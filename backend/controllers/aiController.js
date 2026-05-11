const asyncHandler = require('express-async-handler');
const Groq = require('groq-sdk');

// Initialize Groq client lazily
let groq = null;
function getGroq() {
  if (!groq) groq = new Groq({ apiKey: process.env.GROQ_API_KEY });
  return groq;
}

const GROQ_MODEL = 'llama-3.3-70b-versatile';

const SYSTEM_PROMPT = `You are an expert AI marketing assistant for "Digital_Marketing" — a marketplace platform that connects:
- Businesses (who post campaigns and look for influencers)
- Influencers (who apply to campaigns and promote brands)
- Franchise seekers (who explore franchise opportunities)
- Startups (who need marketing help)

Your role is to provide:
1. AI marketing suggestions and campaign improvement ideas
2. Influencer recommendations and matching advice
3. Franchise investment guidance
4. Content creation tips and caption ideas
5. Brand growth strategies

Always respond helpfully, professionally, and concisely. Use bullet points when listing items.`;

// @desc    AI marketing chatbot (Groq / Llama 3.3-70b)
// @route   POST /api/ai/chat
// @access  Private
const aiChat = asyncHandler(async (req, res) => {
  const { message, history = [] } = req.body;

  if (!message || message.trim().length === 0) {
    res.status(400); throw new Error('Message is required');
  }
  if (!process.env.GROQ_API_KEY) {
    res.status(503); throw new Error('AI service not configured. Add GROQ_API_KEY to .env');
  }

  const messages = [{ role: 'system', content: SYSTEM_PROMPT }];
  for (const h of history) messages.push({ role: h.role, content: h.text });
  messages.push({ role: 'user', content: message });

  const completion = await getGroq().chat.completions.create({
    model: GROQ_MODEL, messages, max_tokens: 1024, temperature: 0.7,
  });

  const reply = completion.choices[0]?.message?.content ?? 'No response generated.';
  res.json({ reply, timestamp: new Date() });
});

// @desc    AI influencer recommendations
// @route   POST /api/ai/recommend-influencers
// @access  Private
const recommendInfluencers = asyncHandler(async (req, res) => {
  const { campaignTitle, category, budget, targetAudience } = req.body;
  if (!process.env.GROQ_API_KEY) { res.status(503); throw new Error('AI service not configured.'); }

  const prompt = `Recommend the ideal influencer profile for this campaign:
Campaign Title: ${campaignTitle}, Category: ${category}, Budget: ₹${budget}, Target Audience: ${targetAudience}

Provide: 1) Ideal niche & platform 2) Follower range 3) Content types 4) Red flags 5) Negotiation tips`;

  const completion = await getGroq().chat.completions.create({
    model: GROQ_MODEL,
    messages: [{ role: 'system', content: SYSTEM_PROMPT }, { role: 'user', content: prompt }],
    max_tokens: 800,
  });

  res.json({ recommendations: completion.choices[0]?.message?.content, timestamp: new Date() });
});

// @desc    AI campaign improvement analysis
// @route   POST /api/ai/improve-campaign
// @access  Private
const improveCampaign = asyncHandler(async (req, res) => {
  const { title, description, budget, targetAudience, campaignType } = req.body;
  if (!process.env.GROQ_API_KEY) { res.status(503); throw new Error('AI service not configured.'); }

  const prompt = `Analyze this campaign and give improvements:
Title: ${title}, Type: ${campaignType}, Budget: ₹${budget}, Audience: ${targetAudience}
Description: ${description}

Provide: 1) Strengths 2) Weaknesses 3) 3 improvements 4) Recommended platforms 5) Estimated ROI`;

  const completion = await getGroq().chat.completions.create({
    model: GROQ_MODEL,
    messages: [{ role: 'system', content: SYSTEM_PROMPT }, { role: 'user', content: prompt }],
    max_tokens: 800,
  });

  res.json({ analysis: completion.choices[0]?.message?.content, timestamp: new Date() });
});

module.exports = { aiChat, recommendInfluencers, improveCampaign };
