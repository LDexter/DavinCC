# DavinCC

#### ChatGPT, but better. _And in Minecraft._

###### Using OpenAI's Davinci model to hold longer conversations, offering greater control than their own ChatGPT

## How Though?

This program generates text in the Minecraft mod [CC:Tweaked](https://tweaked.cc/), or in CC:T-enabled environments like the emulator app, [CraftOS-PC](https://www.craftos-pc.cc/). Such emulators mean this is **_not just a Minecraft thing_** and CraftOS-PC's [mobile support](https://apps.apple.com/us/app/craftos-pc/id1565893014) brings this tech to the phone!

DavinCC provides isolated prompting for generic replies and automated structuring for a conversational experience akin to [ChatGPT](https://chat.openai.com/chat), yet is fully customisable.

Conversations require a greetName.txt file with a custom personality description and sample replies in plain English. Their power is enhanced with quality and quantity in descriptions and sample replies **_(Greeting files and conversations detailed at end)_**.

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
  - Is capable of remorse, regret, and apologising

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

1. Download zip under "< > Code" dropdown and place extracted folder in CC **_root directory_**
2. Follow these steps for API setup from my [openai-lua repository](https://github.com/LDexter/openai-lua#api-setup)
   1. Sign-in and access your [private API key](https://beta.openai.com/account/api-keys)
   2. Paste the API key into `template.env`, replacing the sample key
   3. Rename template.env to just .env
3. Ensure the openai-lua library is located at `/DavinCC/lib/openai-lua`
4. Make a "greetings" folder within DavinCC and paste `greetStandard.txt` inside
5. Run `da [personality] [risk] [cutoff] [img]` for a conversation interface and enjoy!

## The Programs

`da.lua` enables you to run `da [personality] [risk] [cutoff] [img]`, with all arguments being optional. Arguments default to "standard" personality, 0 risk, and 5 cutoff. **_Personality_** can be the corresponding suffix to your custom greeting file. Personality can also be `"none"` for a dedicated quick-and-easy flavourless mode where the Davinci model is simply queried once, using your input following the program call. **_Risk_** range is a 0-1 floating point number (0.1, 0.2, 0.3, etc) and enables the AI to take more risks and become more inventive or random. **_Cutoff_** sets the maximum number of replies the AI keeps track of, to help reduce token costs and stay within OpenAI's preset token limits per prompt. There is a maximum cutoff of 42 replies, simply because each reply can generate a varying number of tokens. **_Img_**, if true, tells DavinCC to generate images using [DALL-CC](https://github.com/LDexter/DALL-CC) throughout a conversation, provided the [DALL-CC](https://github.com/LDexter/DALL-CC) library is located at root. All image links will be written to `/DALL-CC/out.txt`.

Producing AI-generated images, that are prompted by AI-generated text requires as little effort as: _"Imagine a photograph/artwork/cartoon of a girraffe. Describe."_ The value achieved here is immese, as your input consists of one word: "girrafe", while DavinCC's output is a verbose breakdown of your girraffe in great detail... and DALL-CC **_loves detail_**. An example output from this incredible AI tag-team effort is below.

### DALL-vinci Output Sample

![DALL-vinci output](https://github.com/LDexter/fontawesome/blob/main/DavinCC/DALLvinci.png)
`co.lua` (usage: `co [personality] [risk]`) is capable of reading, completing, and writing .txt files as isolated requests. Is almost like `da none` but for large text blocks.

`examples.lua` is also available as a less UX-focused demo.

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
