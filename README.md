# DavinCC

#### ChatGPT, but better. _And in Minecraft._

###### Using OpenAI's Davinci model to hold longer conversations, offering greater control than their own ChatGPT

## How Though?

This program generates text in the Minecraft mod [CC:Tweaked](https://tweaked.cc/), or CC:T-enabled environments like the emulator app, [CraftOS-PC](https://www.craftos-pc.cc/). Such emulators mean this is **_not just a Minecraft thing_** and CraftOS-PC's mobile support bring this tech to the phone! DavinCC provides isolated prompting for generic replies and automated conversational structuring for a fully customisable ChatGPT-like experience.

Conversations require a greetName.txt file with a custom personality description and sample replies in plain English. Their power is enhanced with quality and quantity in descriptions and sample replies. **_(Greeting files and conversations detailed at end)_**

## Greater Control Than ChatGPT?

- [x] Risk-taking factor
  - ChatGPT is famously certain in every single reply, with zero risk
  - Davinci however, has a temperature floating point (0-1) for taking risks
  - Risk-taking produces the most unique and interesting replies
  - Produces results such as denying its AI state, valiantly defending itself as being human and randomly deciding to reply in code (results _will_ vary)

---

- [x] Conversations that carry into **infinity -** **_and beyond_**

  - Optional reply capping that allows old inputs to expire, releaving the AI of having to process an increasingly bloated chatlog (where it stores context)
  - This ability to "forget" means you can cheat the OpenAI prompting limits with a conversation that evolves over the span of a week... _or a couple millennia_

---

- [x] Access to what I call "personality injection"

  - Quick and easy behavioural customisation without AI training
  - Fully embraces whatever personality you describe
  - Targeted pinpointing for handling specific replies in a precise manner

---

- [x] Far less filtering **and way more emotional** _(especially through convo structs `completion.continue()` and depends greatly on your greeting file)_

  - An AI with feelings, emotions, concerns, etc
  - Emotionally opens up about itself and get incredibly personal
  - Able to ask you about your feelings and shares in greivances
  - Will develop care for things that you make apparent as concerns
  - Even evolves based on its own replies, through habitual growth
  - You are capable of swaying its habits (if you're convincing enough!)

---

- [x] Freedom to train on your own data
  - Notice knowledge gaps? Train them into Davinci: [OpenAI fine-tuning](https://beta.openai.com/docs/guides/fine-tuning)

---

- [x] Faster and more reliable, with "ChatGPT Pro" now taking priority over free users
  - Also at a **_zero-cost price point_**, as this relies upon tokens which are provided in ample supply by OpenAI for free - with no card required

---

- [x] Oh yeah, and it just happens to run in Minecraft through [CC:Tweaked](https://tweaked.cc/)
  - Because reasons

## Setup Guide

1. Download zip under "< > Code" dropdown and place extracted folder in computer directory
2. Follow steps for API setup at my [openai-lua repository](https://github.com/LDexter/openai-lua)
3. Make a folder within DavinCC named "greetings" and paste the `greetStandard.txt` file inside
4. Run `examples.lua` and enjoy!

## Custom Personalities Through Greeting Files

1. To craft a personality, copy the `greetStandard.txt` in greetings again
2. Rename the file to replace "Standard" with anything you like
3. Update `local personality = "standard"` to resemble your changes
4. Modify sentences before the `"You:"` for general descriptions
5. Modify text following `"You:"` for sample prompts
6. Modify text following `"AI:"` for sample replies

Remember two things about greeting files:

- Quality _and_ quantity are paramount for effective results
- `"The following is a conversation"` and `"You:"`/`"AI:"` are off-limits from being edited, else the program will break. That being said, "You" and "AI" are planned to be cofigurable for roleplay purposes.
