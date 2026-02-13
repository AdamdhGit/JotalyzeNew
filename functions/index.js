const { onCall, HttpsError } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");

// 1. INITIALIZATION
if (admin.apps.length === 0) admin.initializeApp();
const db = admin.firestore();

const ADMIN_UID = "OaoTc51sGdQVfGOdMXMHXfTihRn2";

/// --- 2. RATE LIMIT HELPERS ---

// A. STRICT DAILY LIMIT (For Instant Feedback: 5 per 24h)
async function checkStrictLimit(uid, feature, max) {
    if (uid === ADMIN_UID) return; // Debug Backdoor

    const docRef = db.collection("rate_limits").doc(`${uid}_${feature}`);
    const now = Date.now();
    await db.runTransaction(async (t) => {
        const doc = await t.get(docRef);
        let calls = doc.exists ? doc.data().calls || [] : [];
        calls = calls.filter(ts => ts > now - 86400000); 
        if (calls.length >= max) throw new Error("LIMIT_REACHED");
        calls.push(now);
        t.set(docRef, { calls });
    });
}

// B. CREDIT SYSTEM (Infinite Rollover for Weekly features)
async function checkCreditLimit(uid, feature, msPerRefill) {
    if (uid === ADMIN_UID) return; // Debug Backdoor

    const docRef = db.collection("rate_limits").doc(`${uid}_${feature}`);
    const now = Date.now();
    await db.runTransaction(async (t) => {
        const doc = await t.get(docRef);
        // New users start with 1 credit
        let data = doc.exists ? doc.data() : { credits: 1, lastRefill: now };
        
        const earned = Math.floor((now - data.lastRefill) / msPerRefill);
        if (earned > 0) {
            data.credits += earned; // Infinite banking
            data.lastRefill = now;
        }
        
        if (data.credits < 1) throw new Error("LIMIT_REACHED");
        
        data.credits -= 1;
        t.set(docRef, data);
    });
}

// Helper function updated to wrap response in a "data" object
async function getAI(prompt) {
    const response = await fetch("https://api.openai.com/v1/chat/completions", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ${process.env.JOTALYZE_AI_KEY}`
        },
        body: JSON.stringify({
            model: "gpt-5-mini",
            messages: [{ role: "user", content: prompt }],
            reasoning_effort: "medium"
        })
    });
    
    const result = await response.json();
    
    // THIS IS THE FIX: 
    // We wrap the OpenAI result in a 'data' key so your Swift 
    // CloudFunctionResponse struct finds exactly what it's looking for.
    return { data: result }; 
}

const ONE_WEEK_MS = 604800000;

// 1. Instant Feedback
exports.runInstantAIFeedback = onCall({ secrets: ["JOTALYZE_AI_KEY"], enforceAppCheck: false }, async (request) => {

    // MANDATORY: This is the "Auth" lock. 
    // It must be here to stop the code if the user isn't logged in.
    if (!request.auth) {
        throw new HttpsError("unauthenticated", "Auth required");
    }

    try {
        await checkStrictLimit(request.auth.uid, "instant", 5);
    } catch (e) {
        throw new HttpsError("resource-exhausted", "Daily limit reached.");
    }

const prompt = `
    This is a prompt for my app. I am going to provide you a mood and my journal entry. 
    With this information you will provide me 6 to 8 sentences of feedback. 
    Acknowledging my journal entry, being supportive, providing recommendations and advice if and where applicable, and giving feedback. 
    
    Don't say anything about how I can reach out to you for additional help or anything, 
    because this isn't an ongoing dialogue, this is a one time supportive feedback prompt only 
    for the mood and journal entry I provide you. 
    
    I will provide a maximum of 1,000 text characters so if anything gets cut off just ignore it. 
    
    ${request.data.inputText}`;
  return await getAI(prompt);
});

// 2. Reflect & Optimize
exports.runReflectAndOptimizeAnalysis = onCall({ secrets: ["JOTALYZE_AI_KEY"], enforceAppCheck: false }, async (request) => {

    // MANDATORY: This is the "Auth" lock. 
    // It must be here to stop the code if the user isn't logged in.
    if (!request.auth) {
        throw new HttpsError("unauthenticated", "Auth required");
    }

    try {
        await checkCreditLimit(request.auth.uid, "reflect", ONE_WEEK_MS); 
    } catch (e) {
        throw new HttpsError("resource-exhausted", "No analysis credits left.");
    }

const prompt = `
    I am going to provide you some data. The only thing I want you to pay attention to is the 'entry' value and the 'mood' value. 
    Your reply MUST consist of three paragraphs, between 3 to 4 sentences each. 

    The first paragraph MUST start with "Your Good Days:" followed by a new line. Then in the paragraph, provide an analysis of what my good days consisted of based off entries associated with matching 'mood' values of any of the following types of mood: Average, Calm, Indifferent, Meh, Okay, Content, Balanced, Ambivalent, Uncertain, Bored, Uninspired, Good, Happy, Optimistic, Confident, Motivated, Cheerful, Excited, Proud, Thankful, Energized, Relaxed, Great, Ecstatic, Grateful, Joyful, Euphoric, Elated, Radiant, Inspired, Hopeful, Uplifted, Pleased. 

    If not a single one of these exact 'mood' values are found, all you will say for this paragraph is: "No neutral or positive mood check-in entries found.". 

    The second paragraph MUST start with "Your Bad Days:" followed by a new line. This paragraph will include an analysis summary of what my bad days consisted of based off entries associated with matching 'mood' values of any of the following types of mood: Terrible, Depressed, Hopeless, Anxious, Overwhelmed, Despairing, Stressed, Terrified, Lonely, Unhappy, Guilty, Bad, Sad, Disappointed, Frustrated, Angry, Irritated, Unmotivated, Down, Bitter, Dismal, Tired. 

    If not a single exact one of these 'mood' values are found, all you will say for this paragraph is: "No negative mood check-in entries found.". 

    The final paragraph MUST start with "For More Great Days:" followed by a new line. This paragraph will include insights and feedback, providing some type of feedback and plan for direction, making it clear what I should potentially spend more time doing based on my positive mood associated entries with additional recommendations on how to get even more out of those things that contributed to those positive mood days with specific recommendations, while emphasizing what might contribute to my negative moods and giving some type of feedback on how to navigate those things.

    Lastly, don't actually include the mood words themself. Instead, simply refer to the concepts as 'good days', 'bad days', and 'great days'. 
    If those entries don't make sense or lack context, ignore them. Don't use the term 'value' in any way. 
    Ignore any data after 5000 characters. 
    If zero entries were made in total, return "No Data Found." and NOTHING ELSE. 

    Here is the data: ${request.data.inputText}`;
  return await getAI(prompt);
});

// 3. Affirmations
exports.runAffirmationsAnalysis = onCall({ secrets: ["JOTALYZE_AI_KEY"], enforceAppCheck: false }, async (request) => {

    // MANDATORY: This is the "Auth" lock. 
    // It must be here to stop the code if the user isn't logged in.
    if (!request.auth) {
        throw new HttpsError("unauthenticated", "Auth required");
    }

    try {
        await checkCreditLimit(request.auth.uid, "affirmations", ONE_WEEK_MS); 
    } catch (e) {
        throw new HttpsError("resource-exhausted", "No analysis credits left.");
    }

    const prompt = `
    I am going to provide you some data. The only thing I want you to pay attention to is the 'entry' values and the 'mood' values. 
    Only provide the following response I'm asking you to give IF the 'mood' value DOES include \(allPositiveMoods) and the associated 'entry' value DOES have an affirmation in it. 
    
    Make SURE that an affirmation curated based on their 'entry' value is found and REALLY analyze the associated 'entry' value, not every 'entry' value will have an applicable affirmation to be created from it so you must identify carefully. 
    Ensure journal entries contain substantive content to facilitate meaningful affirmations and do not create affirmations from context that doesn't correlate substantially.
    
    If the 'mood' value does NOT include one of the moods and/or the entry does NOT include an 'entry' that can be made into an affirmation, only provide a brief response that says: "No affirmations were found." 
    
    Never refer back to me the words 'entry values', I only want a polished response. 
    What I need you to do is curate affirmations based on positive affirmation psychology throughout the entries. 
    For each affirmation you find, on a new line start with 'Context:' and then only write the specific piece of text they included in their entry that contained the text that the affirmation could be curated from. 
    Then on a new line after that start with 'Affirmation:' and then write what the affirmation is. Then put a new line and then finish this part with the word 'DONE'. 
    
    The response MUST be a MAXIMUM of 150 text letter characters. 
    Do not include asterisks or any other text symbols. 
    Ignore any data after 5000 characters that gets cut off.
    
    Here is the data: ${request.data.inputText}`;
    return await getAI(prompt);
});

// 4. Cognitive Errors
exports.runCognitiveErrorAnalysis = onCall({ secrets: ["JOTALYZE_AI_KEY"], enforceAppCheck: false }, async (request) => {

    // MANDATORY: This is the "Auth" lock. 
    // It must be here to stop the code if the user isn't logged in.
    if (!request.auth) {
        throw new HttpsError("unauthenticated", "Auth required");
    }

    try {
        await checkCreditLimit(request.auth.uid, "cognitive", ONE_WEEK_MS); 
    } catch (e) {
        throw new HttpsError("resource-exhausted", "No analysis credits left.");
    }

    const prompt = `
    I am going to provide you some data. The only thing I want you to pay attention to is the 'entry' values and the 'mood' values. 
    Only provide the following response I'm asking you to give IF the 'mood' value DOES include \(allNegativeMoods) and the associated 'entry' value DOES have a cognitive error.
    
    Make SURE that a cognitive error is found and REALLY analyze the associated 'entry' value, not every 'entry' value will have a cognitive error so you must identify carefully. 
    Ensure journal entries contain substantive content to facilitate accurate cognitive errors and do attempt to create cognitive errors from unapplicable context - really make sure it is truly a cognitive error before choosing it as a cognitive error. 
    
    If the 'mood' value does NOT include one of the moods and/or the entry does NOT include a cognitive error, only provide a brief response that says: "No cognitive errors were found." 
    
    Never refer back to me the words 'entry values', I only want a polished response. 
    What I need you to do is identify any 'cognitive errors' based in psychology throughout the entries. 
    For each cognitive error you find, on a new line start with 'Context:' and then only write the specific piece of text they included in their entry that contained the cognitive error. 
    Then on a new line after that start with 'Cognitive Error:' and then write what the cognitive error is. 
    Then on a new line after that, write 'Restructured Thought:' and then write a restructured thought that would replace the original thought in a healthy way mentally. 
    Then put a new line and then finish this part with the word 'DONE'. 
    
    The response MUST be a MAXIMUM of 150 text letter characters. 
    Remember, if there IS cognitive errors, you are ONLY writing the titles and colon with the associated responses I told you to provide, do not include asterisks or any other text symbols, and do not write anything additional such as telling me there are not additional cognitive errors found. 
    
    The data might get cut off because i am going to provide you only 5000 characters maximum, so just ignore any data after 5000 characters that gets cut off.
    
    Here is the data: ${request.data.inputText}`;
    return await getAI(prompt);
});

// 5. Goal Analysis
exports.runGoalAnalysis = onCall({ secrets: ["JOTALYZE_AI_KEY"], enforceAppCheck: false }, async (request) => {

    // MANDATORY: This is the "Auth" lock. 
    // It must be here to stop the code if the user isn't logged in.
    if (!request.auth) {
        throw new HttpsError("unauthenticated", "Auth required");
    }

    try {
        await checkCreditLimit(request.auth.uid, "goals", ONE_WEEK_MS); 
    } catch (e) {
        throw new HttpsError("resource-exhausted", "No analysis credits left.");
    }

    const prompt = `
    I am going to provide you goal tracking entries that users have created in my journaling app. 
    You will be focusing on the ‘goalName’ and ‘entry’ values. For each different 'goalName' value, you will analyze the associated entries. 
    
    Based on the entries, you will provide personalized recommendations and tips to improve their success in their goal while also giving credit where due for any progress they have mentioned in their entries. 
    Your response will be 4-5 sentences for EVERY different goal found and you must REALLY help them continue their growth in their specific goals. 
    
    Start every different goal response on a new line if there are more than one different ‘goalName’ values. 
    Do not reference the term ‘goal values’ in your response. 
    For each new paragraph associated with a different 'goalName' value, start with "Goal:" and state their 'goalName' value exactly how it is. 
    Then on the VERY NEXT line, give the analysis response without labeling it as a 'response' in any way. 
    
    ONLY provide a response I'm asking you to give IF the 'goalName' value AND the associated 'entry' value DO have string values. 
    ONLY put an empty new line between different goal paragraphs, if there are more than one. 
    
    If they do not have values presented after I say 'Here is the Data:', return "No Goal Tracking Entries Found." and NOTHING ELSE. 
    
    Here is the data: ${request.data.inputText}`;
    return await getAI(prompt);
});
