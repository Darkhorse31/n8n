# 🚀 Quick Reference Card - LinkedIn Auto-Apply

## ⚡ Setup in 5 Minutes

```powershell
# 1. Start n8n
cd c:\Users\Prateek\Desktop\n8n
.\setup.ps1

# 2. Open browser
http://localhost:5678

# 3. Import workflow
linkedin_auto_apply_workflow.json

# 4. Done!
```

## 🔑 Must-Have Credentials

| Credential | Where to Get | Used For |
|------------|--------------|----------|
| OpenRouter API | [openrouter.ai/keys](https://openrouter.ai/keys) | AI matching & writing |
| Gmail OAuth2 | n8n Credentials → Gmail | Email notifications |
| Google Sheets OAuth2 | n8n Credentials → Sheets | Application tracking |

## 📝 Quick Edits

### Update Your Profile
**Node:** "Load Profile & API Key"
```javascript
{
  "fullName": "Your Name",
  "email": "your@email.com",
  "resume": "Your detailed resume...",
  "skills": ["Skill1", "Skill2"]
}
```

### Change Job Search
**Node:** "Search Easy Apply Jobs"
```javascript
{
  "keywords": "Your Job Title",
  "location": "Your City",
  "f_E": "3,4"  // Experience level
}
```

### Adjust Match Score
**Node:** "Filter: Score 70+ & Auto-Apply"
```javascript
{
  "matchScore": 70  // Change to 60, 75, or 80
}
```

## 💰 Cost Quick View

| Jobs/Day | AI Model | Monthly Cost |
|----------|----------|--------------|
| 10 | Claude 3.5 Sonnet | $18 |
| 10 | Claude 3 Haiku | $3 |
| 10 | GPT-3.5 Turbo | $6 |
| 20 | Claude 3.5 Sonnet | $36 |

## 🔧 Common Commands

```powershell
# Start/Stop
docker-compose up -d          # Start
docker-compose down           # Stop
docker-compose restart n8n    # Restart

# Logs
docker logs n8n -f           # Follow logs
docker logs n8n --tail 50    # Last 50 lines

# Status
docker ps                    # Check containers
docker-compose ps            # n8n status
```

## ⚠️ Quick Troubleshooting

| Problem | Solution |
|---------|----------|
| No jobs found | Broaden search keywords, increase time period |
| API error | Check OPENROUTER_API_KEY in .env, restart n8n |
| Gmail not sending | Re-authenticate OAuth in n8n credentials |
| Low match scores | Add more details to resume, lower threshold |
| Workflow not running | Check "Active" toggle is ON |

## 📊 Daily Routine (10 min)

1. ✅ Check email summary (5 min)
2. ✅ Review top 3-5 matches (2 min)
3. ✅ Customize if needed (2 min)
4. ✅ Submit on LinkedIn (1 min)

## 🎯 Success Metrics

Track in Google Sheets:
- Applications sent per day
- Response rate (%)
- Interview requests
- Time saved vs manual

**Target:** 10 quality applications/day = 300/month

## 📚 Documentation

- **Full Setup:** [LINKEDIN_AUTO_APPLY_SETUP.md](LINKEDIN_AUTO_APPLY_SETUP.md)
- **Detailed README:** [README_AUTO_APPLY.md](README_AUTO_APPLY.md)
- **n8n Docs:** [docs.n8n.io](https://docs.n8n.io)

## 🚨 Remember

✅ **This tool PREPARES applications**
❌ **Does NOT auto-submit to LinkedIn**
✨ **Always review AI content before use**
🎯 **Personalization = Better success rate**

---

**Need Help?**
- Check [Troubleshooting](README_AUTO_APPLY.md#-troubleshooting)
- Visit [n8n Community](https://community.n8n.io)
- Review [Setup Guide](LINKEDIN_AUTO_APPLY_SETUP.md)

---

*Good luck! 🚀*
