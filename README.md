# DavinCC

#### ChatGPT, but better. _And in Minecraft._

###### Using OpenAI's Davinci model to hold longer conversations, offering greater control than their own ChatGPT

## How Though?

This program generates text in the Minecraft mod [CC:Tweaked](https://tweaked.cc/), or in CC:T-enabled environments like the emulator app, [CraftOS-PC](https://www.craftos-pc.cc/). Such emulators mean this is **_not just a Minecraft thing_** and CraftOS-PC's [mobile support](https://apps.apple.com/us/app/craftos-pc/id1565893014) brings this tech to the phone!

DavinCC provides isolated prompting for generic replies and automated structuring for a conversational experience akin to [ChatGPT](https://chat.openai.com/chat), yet is fully customisable.

Conversations require a greetName.txt file with a custom personality description and sample replies in plain English. Their power is enhanced with quality and quantity in descriptions and sample replies. **_(Greeting files and conversations detailed at end)_**

## Greater Control Than ChatGPT?

###### Reasons why I feel this offers improvements over OpenAI's latest product

---

- [x] Risk-taking factor
  - ChatGPT is famously certain on every single reply, with zero risk
  - Davinci however, has a temperature floating point (0-1) for taking risks
  - Risk-taking produces the most unique and interesting replies
  - Produces results such as denying its AI state, valiantly defending itself as a human and randomly deciding to reply in code (results _will_ vary)

---

- [x] Conversations that carry into **infinity -** **_and beyond_**

  - Optional reply capping that allows old inputs to expire, releaving the AI from having to process an increasingly bloated chatlog (where context is stored)
  - This ability to "forget" means you can cheat the OpenAI prompting limits with a conversation that evolves over the span of a week... _or a couple millennia_

---

- [x] Access to what I call "personality injection" (which they simply call prompt structuring)

  - Quick and easy behavioural customisation without data training
  - Fully embraces whatever personality you describe
  - Targeted handling of replies for pinpointing specific scenarios

---

- [x] Far less filtering **and way more emotional** _(results depend on your greeting file)_

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
  - Also at a **_zero-cost price point_**, as this relies upon tokens that are provided in ample supply by OpenAI for free - no card required

---

- [x] Oh yeah, and it just happens to run in Minecraft through [CC:Tweaked](https://tweaked.cc/)
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

<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 512"><!--! Font Awesome Pro 6.2.1 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2022 Fonticons, Inc. --><path d="M130 480c40.6 0 80.4-11 115.2-31.9L352 384l-224 0 0 96h2zM352 128L245.2 63.9C210.4 43 170.6 32 130 32h-2v96l224 0zM96 128l0-96H80C53.5 32 32 53.5 32 80v48h8c-22.1 0-40 17.9-40 40v16V328v16c0 22.1 17.9 40 40 40H32v48c0 26.5 21.5 48 48 48H96l0-96h8c26.2 0 49.4-12.6 64-32H456c69.3 0 135-22.7 179.2-81.6c6.4-8.5 6.4-20.3 0-28.8C591 182.7 525.3 160 456 160H168c-14.6-19.4-37.8-32-64-32l-8 0zM512 243.6v24.9c0 19.6-15.9 35.6-35.6 35.6c-2.5 0-4.4-2-4.4-4.4V212.4c0-2.5 2-4.4 4.4-4.4c19.6 0 35.6 15.9 35.6 35.6z"/></svg>
