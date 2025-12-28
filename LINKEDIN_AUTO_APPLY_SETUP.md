# LinkedIn Auto-Apply Workflow Setup Guide

## 🎯 Overview

This n8n workflow automates LinkedIn job searching, matching, and application preparation using OpenRouter AI (Claude 3.5 Sonnet). It will:

1. ✅ Search LinkedIn for relevant jobs every 6 hours
2. ✅ Analyze job-candidate fit using AI (70%+ match threshold)
3. ✅ Generate personalized cover letters for each job
4. ✅ Answer application questions automatically
5. ✅ Log applications to Google Sheets
6. ✅ Send email summaries with prepared applications
7. ⚠️ Prepare application data (manual submission required)

## 📋 Prerequisites

### 1. OpenRouter API Key (Required)
- Sign up at: https://openrouter.ai/
- Get your API key from: https://openrouter.ai/keys
- Recommended model: `anthropic/claude-3.5-sonnet` (best quality)
- Alternative models:
  - `anthropic/claude-3-haiku` (faster, cheaper)
  - `openai/gpt-4-turbo` (excellent results)
  - `google/gemini-pro-1.5` (good balance)

### 2. n8n Instance (Running)
- Your Docker setup is ready (check with `docker ps`)
- Access n8n at: http://localhost:5678

### 3. Gmail Account (For notifications)
- Enable Gmail API: https://console.cloud.google.com/apis/library/gmail.googleapis.com
- Create OAuth 2.0 credentials

### 4. Google Sheets (For tracking)
- Create a spreadsheet named "Job Applications Tracker"
- Add columns: Timestamp, Job Title, Company, Location, Match Score, Priority, Job URL, Status, Cover Letter Preview, Questions Answered, Applied Date

## 🚀 Installation Steps

### Step 1: Set Environment Variables

Edit your `.env` file in the n8n directory:

```bash
# Add this to your existing .env file
OPENROUTER_API_KEY=sk-or-v1-YOUR_API_KEY_HERE
```

Restart n8n after adding the API key:

```bash
cd c:\Users\Prateek\Desktop\n8n
docker-compose down
docker-compose up -d
```

### Step 2: Import Workflow

1. Open n8n: http://localhost:5678
2. Click **Workflows** → **Import from File**
3. Select: `linkedin_auto_apply_workflow.json`
4. Click **Import**

### Step 3: Configure Credentials

#### A. Gmail OAuth2 (for email notifications)

1. In n8n, go to **Credentials** → **New**
2. Select **Gmail OAuth2 API**
3. Follow the OAuth flow to connect your Gmail account
4. Save with name: "Gmail account"

#### B. Google Sheets OAuth2 (for tracking)

1. In n8n, go to **Credentials** → **New**
2. Select **Google Sheets OAuth2 API**
3. Follow OAuth flow to authorize
4. Save with name: "Google Sheets account"

#### C. Update Workflow Nodes

Open the workflow and update these nodes:

1. **"Send Email Notification"** node:
   - Select your Gmail credential
   - Update `fromEmail` and `toEmail` with your email

2. **"Log to Google Sheets"** node:
   - Select your Google Sheets credential
   - Choose your spreadsheet
   - Map the columns

### Step 4: Customize Your Profile

Edit the **"Load Profile & API Key"** node and update with your information:

```javascript
{
  "fullName": "Your Full Name",
  "email": "your.email@gmail.com",
  "phone": "+91-XXXXXXXXXX",
  "linkedinUrl": "https://linkedin.com/in/yourprofile",
  "githubUrl": "https://github.com/yourusername",
  "portfolio": "https://yourportfolio.com",
  "currentTitle": "Your Current Title",
  "currentCompany": "Your Company",
  "yearsOfExperience": "X.X",
  "location": "Your City, Country",
  "openToRemote": true,
  "openToRelocate": true,
  "preferredLocations": ["City1", "City2", "Remote"],
  "skills": ["Skill1", "Skill2", "Skill3"],
  "resume": "Your full resume text here...",
  "expectedSalary": "XX-XX LPA",
  "noticePeriod": "30 days",
  "motivation": "Why you're looking for new opportunities..."
}
```

### Step 5: Customize Job Search

Edit the **"Search Easy Apply Jobs"** node:

```javascript
// Query parameters
{
  "keywords": "Backend Engineer Node.js", // Your target job titles
  "location": "India", // Preferred location
  "f_TPR": "r86400", // Time period (r86400 = last 24 hours)
  "f_E": "3,4", // Experience level (3=Mid, 4=Senior)
  "f_AL": "true" // Easy Apply only
}
```

Experience level codes:
- 1 = Internship
- 2 = Entry level
- 3 = Associate
- 4 = Mid-Senior level
- 5 = Director
- 6 = Executive

Time period codes:
- r86400 = Past 24 hours
- r604800 = Past week
- r2592000 = Past month

### Step 6: Test the Workflow

1. **Manual Test:**
   - Click **"Execute Workflow"** button
   - Watch the execution flow
   - Check for errors in each node

2. **Check Output:**
   - Verify email received
   - Check Google Sheets updated
   - Review generated cover letters

3. **Activate for Auto-Run:**
   - Toggle **"Active"** switch in top-right
   - Workflow will run every 6 hours automatically

## ⚙️ Configuration Options

### AI Model Selection

In nodes using OpenRouter, you can change the model:

```javascript
{
  "model": "anthropic/claude-3.5-sonnet" // Current
  // Alternatives:
  // "anthropic/claude-3-haiku" - Faster, cheaper
  // "openai/gpt-4-turbo" - Excellent quality
  // "meta-llama/llama-3.1-70b-instruct" - Open source
  // "google/gemini-pro-1.5" - Good balance
}
```

### Match Score Threshold

Adjust in **"Filter: Score 70+ & Auto-Apply"** node:

```javascript
{
  "matchScore": 70 // Lower = more jobs, Higher = better matches
}
```

Recommended thresholds:
- 80+ = Excellent matches only
- 70+ = Good to excellent (balanced)
- 60+ = More opportunities (may include stretches)

### Schedule Frequency

Edit **"Run Every 6 Hours"** node:

```javascript
{
  "hoursInterval": 6 // Change to 3, 12, or 24
}
```

## 📊 Workflow Features

### 1. Intelligent Job Matching
- Analyzes job descriptions against your resume
- Scores compatibility (0-100%)
- Identifies matching and missing skills
- Assesses experience level fit

### 2. AI-Generated Content
- **Cover Letters:** Personalized, 250-350 words
- **Question Answers:** Context-aware responses
- **Professional tone:** Confident yet authentic

### 3. Application Tracking
- Google Sheets integration
- Timestamp tracking
- Status monitoring
- Cover letter preview

### 4. Email Notifications
- Daily summary emails
- Match scores and priorities
- Generated cover letters
- Direct links to apply

## ⚠️ Important Limitations

### Why Applications Aren't Auto-Submitted

This workflow **does NOT automatically submit** applications to LinkedIn because:

1. **LinkedIn API Restrictions:**
   - No public API for job applications
   - Requires LinkedIn Talent Hub (expensive)
   - Limited Partner Program access only

2. **Terms of Service:**
   - Automated applications may violate LinkedIn ToS
   - Risk of account suspension
   - CAPTCHA challenges

3. **Technical Requirements:**
   - Browser automation (Puppeteer/Selenium) needed
   - OAuth authentication required
   - Session management complexity
   - CAPTCHA solving

### What This Workflow DOES

✅ **Automates:**
- Job searching and discovery
- Match quality analysis
- Cover letter generation
- Application question answers
- Tracking and organization

⚠️ **Requires Manual Action:**
- Final review of generated content
- LinkedIn authentication
- Application submission
- CAPTCHA solving

## 🎯 Usage Workflow

### Daily Process:

1. **Morning (Automated):**
   - Workflow runs every 6 hours
   - Finds new matching jobs
   - Analyzes and scores them
   - Generates cover letters

2. **You Receive Email:**
   - Summary of matched jobs
   - Match scores and priorities
   - Pre-written cover letters
   - Application answers

3. **Manual Review (15-30 min):**
   - Review top matches
   - Customize cover letters if needed
   - Click "Apply on LinkedIn"
   - Copy-paste prepared content
   - Submit applications

4. **Tracking:**
   - Applications logged automatically
   - Status updated in Google Sheets
   - Historical data maintained

## 🔧 Troubleshooting

### Issue: No Jobs Found

**Solutions:**
1. Broaden search keywords
2. Increase time period (r604800 = past week)
3. Remove location filters
4. Lower experience level requirements

### Issue: OpenRouter API Error

**Check:**
1. API key is correct in `.env`
2. n8n container restarted after env change
3. OpenRouter account has credits
4. Model name is correct

**Test API Key:**
```bash
curl https://openrouter.ai/api/v1/models \
  -H "Authorization: Bearer YOUR_API_KEY"
```

### Issue: Gmail Not Sending

**Solutions:**
1. Re-authenticate Gmail OAuth
2. Check Gmail API enabled in Google Cloud
3. Verify email addresses are correct
4. Check Gmail daily sending limits (500/day)

### Issue: Cover Letters Too Generic

**Improve:**
1. Add more detail to your resume in profile
2. Increase `max_tokens` in OpenRouter node (800 → 1200)
3. Adjust temperature for creativity (0.7 → 0.9)
4. Modify the prompt to be more specific

### Issue: Low Match Scores

**Solutions:**
1. Update resume with more keywords
2. Expand skills list
3. Lower match threshold (70 → 60)
4. Improve job search keywords

## 💰 Cost Estimation

### OpenRouter Pricing (Claude 3.5 Sonnet)
- Input: $3 per 1M tokens
- Output: $15 per 1M tokens

**Per Job Application:**
- Job analysis: ~2,000 tokens = $0.03
- Cover letter: ~800 tokens = $0.01
- Question answers: ~1,500 tokens = $0.02
- **Total per job: ~$0.06**

**Monthly Estimate:**
- 10 jobs/day × 30 days = 300 jobs
- 300 × $0.06 = **~$18/month**

**Save Money:**
- Use Claude 3 Haiku: ~$0.01 per job = $3/month
- Use GPT-3.5 Turbo: ~$0.02 per job = $6/month
- Reduce frequency: 2x/day instead of 4x/day

## 🚀 Advanced: Enable Real Auto-Submit (Optional)

### Option 1: Browser Automation (Puppeteer)

**Requirements:**
- n8n with Puppeteer installed
- LinkedIn credentials
- CAPTCHA solving service ($20-50/month)

**Steps:**
1. Add Puppeteer to n8n Docker image
2. Create custom node for LinkedIn automation
3. Implement session management
4. Add 2Captcha or similar service
5. Handle rate limiting (max 5-10 applications/hour)

**Risks:**
- Account suspension
- IP blocking
- Requires constant maintenance

### Option 2: LinkedIn Talent Hub API

**Requirements:**
- LinkedIn Recruiter license ($$$)
- Partner API access
- Business relationship with LinkedIn

**Cost:** $8,000+ per year

**Not recommended for individual use**

## 📚 Additional Resources

### OpenRouter
- Dashboard: https://openrouter.ai/dashboard
- Models: https://openrouter.ai/models
- Pricing: https://openrouter.ai/docs#models

### n8n Documentation
- HTTP Request Node: https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.httprequest/
- Code Node: https://docs.n8n.io/code/builtin/overview/
- Gmail Node: https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.gmail/

### LinkedIn
- Job Search Tips: https://www.linkedin.com/help/linkedin/answer/a507508
- Easy Apply Guide: https://www.linkedin.com/help/linkedin/answer/a550230

## 🤝 Support

### Need Help?

1. **Check n8n Logs:**
   ```bash
   docker logs n8n
   ```

2. **Test Individual Nodes:**
   - Right-click node → "Execute Node"
   - Check output data

3. **Community:**
   - n8n Community: https://community.n8n.io/
   - Reddit: r/n8n

## 📝 License & Disclaimer

**Important:**
- This workflow is for educational and productivity purposes
- Use responsibly and in compliance with LinkedIn Terms of Service
- Automated job applications may violate platform policies
- Always review and customize generated content before use
- The creator is not responsible for account suspensions or ToS violations

**Best Practice:**
- Use this tool to **prepare** applications, not fully automate them
- Always add personal touches to cover letters
- Review all generated content before submission
- Maintain genuine engagement with employers

## 🎉 You're Ready!

Your LinkedIn Auto-Apply workflow is now configured and ready to help you find and apply to jobs more efficiently.

**Next Steps:**
1. ✅ Update your profile information
2. ✅ Test the workflow manually
3. ✅ Review first batch of results
4. ✅ Activate for automatic runs
5. ✅ Check emails daily and apply to top matches

**Good luck with your job search! 🚀**
