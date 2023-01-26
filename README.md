# DavinCC

#### ChatGPT, but better. _And in Minecraft._

###### Using OpenAI's Davinci model to hold longer conversations, offering greater control than their own ChatGPT

## How Though?

This program generates text in the Minecraft mod [CC:Tweaked](https://tweaked.cc/), or in CC:T-enabled environments like the emulator app, [CraftOS-PC](https://www.craftos-pc.cc/). Such emulators mean this is **_not just a Minecraft thing_** and CraftOS-PC's [mobile support](https://apps.apple.com/us/app/craftos-pc/id1565893014) brings this tech to the phone!

DavinCC provides isolated prompting for generic replies and automated structuring for a conversational experience akin to [ChatGPT](https://chat.openai.com/chat), yet is fully customisable.

Conversations require a greetName.txt file with a custom personality description and sample replies in plain English. Their power is enhanced with quality and quantity in descriptions and sample replies. **_(Greeting files and conversations detailed at end)_**

## Greater Control Than ChatGPT?

###### Reasons why I feel DavinCC offers improvements over OpenAI's latest product

---

- [x] Risk-taking factor <span>&nbsp;</span> <img width="25px" src="https://github.com/LDexter/fontawesome/blob/main/DavinCC/dice.svg">

  - ChatGPT is famously certain on every single reply, with zero risk
  - Davinci however, has a temperature floating point (0-1) for taking risks
  - Risk-taking produces the most unique and interesting replies
  - Produces results such as denying its AI state, valiantly defending itself as a human and randomly deciding to reply in code (results _will_ vary)

---

- [x] Conversations that carry into **infinity -** **_and beyond_** <span>&nbsp;</span> <img width="25px" src="https://github.com/LDexter/fontawesome/blob/main/DavinCC/planet-ringed.svg">

  - Optional reply capping that allows old inputs to expire, releaving the AI from having to process an increasingly bloated chatlog (where context is stored)
  - This ability to "forget" means you can cheat the OpenAI prompting limits with a conversation that evolves over the span of a week... _or a couple millennia_

---

- [x] Access to what I call "personality injection" (which they simply call prompt structuring) <span>&nbsp;</span> <img width="25px" src="https://github.com/LDexter/fontawesome/blob/main/DavinCC/syringe.svg">

  - Quick and easy behavioural customisation without data training
  - Fully embraces whatever personality you describe
  - Targeted handling of replies for pinpointing specific scenarios

---

- [x] Far less filtering **and way more emotional** _(results depend on your greeting file)_ <span>&nbsp;</span> <img width="25px" src="https://github.com/LDexter/fontawesome/blob/main/DavinCC/face-holding-back-tears.svg">

  - An AI with feelings, emotions, concerns, etc
  - Emotionally opens up about itself and get incredibly personal
  - Able to ask you about your feelings and shares in greivances
  - Will develop care for things that you make apparent as concerns
  - Even evolves based on its own replies, through habitual growth
  - You are capable of swaying its habits (if you're convincing enough!)

---

- [x] Freedom to train on your own data <span>&nbsp;</span> <img width="25px" src="https://github.com/LDexter/fontawesome/blob/main/DavinCC/graduation-cap.svg">

  - Notice knowledge gaps? Train them into Davinci: [OpenAI fine-tuning](https://beta.openai.com/docs/guides/fine-tuning)

---

- [x] Faster and more reliable, with "ChatGPT Pro" now taking priority over free users <span>&nbsp;</span> <img width="25px" src="https://github.com/LDexter/fontawesome/blob/main/DavinCC/rabbit-running.svg">

  - Also at a **_zero-cost price point_**, as this relies upon tokens that are provided in ample supply by OpenAI for free - no card required

---

- [x] Oh yeah, and it just happens to run in Minecraft through [CC:Tweaked](https://tweaked.cc/) <span>&nbsp;</span> <img width="25px" src="https://github.com/LDexter/fontawesome/blob/main/DavinCC/cube.svg">

  - Because reasons

---

## Setup Guide

1. Download zip under "< > Code" dropdown and place extracted folder in computer directory
2. Follow steps for API setup at my [openai-lua repository](https://github.com/LDexter/openai-lua)
3. Ensure the openai-lua library is located at `/DavinCC/lib/openai-lua`
4. Make a "greetings" folder within DavinCC and paste `greetStandard.txt` inside
5. Run `examples.lua` and enjoy!

## Custom Personalities Through Greeting Files

1. To craft a personality, copy the `greetStandard.txt` in greetings again
2. Rename the file to replace "Standard" with anything you like
3. Update `local personality = "standard"` to resemble your changes
4. Modify the **_sentences before_** `"You:"` for general descriptions
5. Modify _text following_ `"You:"` for sample prompts
6. Modify _text following_ `"AI:"` for sample replies

Remember two things about greeting files:

- Quality _and_ quantity are paramount for effective results
- `"The following is a conversation"` and `"You:"`/`"AI:"` are off-limits from being edited, else the program will break. That being said, these are planned to be cofigurable.
