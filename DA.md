# DavinCC and the `da` Interface

#### ChatGPT, but better. _And in Minecraft._

###### Using OpenAI's Davinci model to hold longer conversations, offering greater control than their own ChatGPT

## How Though?

This program generates text in the Minecraft mod [CC:Tweaked](https://tweaked.cc/), or in CC:T-enabled environments like the emulator app, [CraftOS-PC](https://www.craftos-pc.cc/). Such emulators mean this is **_not just a Minecraft thing_** and CraftOS-PC's [mobile support](https://apps.apple.com/us/app/craftos-pc/id1565893014) brings this tech to the phone!

DavinCC provides isolated prompting for generic replies and automated structuring for a conversational experience akin to [ChatGPT](https://chat.openai.com/chat), yet is fully customisable. Powered by their earlier model, Davinci, this program was already pushing more "openness" than OpenAI's latest release... though DavinCC's sizable additions have pushed that envelope even further!

Conversations require a greetName.txt file with a custom personality description and sample replies in plain English. Their power is enhanced with quality and quantity in descriptions and sample replies **_(Greeting files and conversations detailed after setup guide)_**.

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

  - Optional reply scope cap that allows old inputs to expire, releaving the AI from having to process an increasingly bloated chatlog (where context is stored)
  - This ability to "forget" means you can cheat the OpenAI prompting limits with a conversation that evolves over the span of a week... _or a couple millennia_

---

- [x] Access to what I call "personality injection" (which they call prompt structuring) <span>&nbsp;</span> <img width="25px" src="https://github.com/LDexter/fontawesome/blob/main/DavinCC/syringe.svg">

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

- [x] Powerful prompt commands at the ready <span>&nbsp;</span> <img width="25px" src="https://github.com/LDexter/fontawesome/blob/main/DavinCC/terminal.svg">
  - Call commands left and right, anywhere within a prompt
  - **Future feature:** stack multiple calls like a true command slinger!
  - Mix it up with near unix-like flag arguments
  - Quick and simple syntax, that wont ruin your prompts

---

- [x] Conversational image generation <span>&nbsp;</span> <img width="25px" src="https://github.com/LDexter/fontawesome/blob/main/DavinCC/image.svg">
  - Automatic piping of generated text into DALL-CC for effortless image prompting
  - The perfect combination of one word in, extreme detail out, to prompt an image
  - If you are at a complete loss for any ideas, just ask DavinCC to imagine its own!
  - Thanks to seamless integration, images are influenced by all the above features!

---

- [x] Freedom to train on your own data <span>&nbsp;</span> <img width="25px" src="https://github.com/LDexter/fontawesome/blob/main/DavinCC/graduation-cap.svg">

  - Notice knowledge gaps? Train them into Davinci: [OpenAI fine-tuning](https://beta.openai.com/docs/guides/fine-tuning)

---

- [x] Faster and more reliable, with "ChatGPT Pro" now taking priority over free users <span>&nbsp;</span> <img width="25px" src="https://github.com/LDexter/fontawesome/blob/main/DavinCC/rabbit-running.svg">

  - Responses are recieved with speed and consistency

---

- [x] Oh yeah, and it just happens to run in Minecraft through [CC:Tweaked](https://tweaked.cc/) <span>&nbsp;</span> <img width="25px" src="https://github.com/LDexter/fontawesome/blob/main/DavinCC/cube.svg">

  - Because reasons

---

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

## Prompt Commands of `da`

### Calling Prompt Commands With Arguments

The syntax for calling a prompt command is as follows: `[CMDNAME]-kvalue-kvalue`. First comes `[CMDNAME]`, which indicates the command being called, in caps and wrapped by square brackets. Next is an arbitrary number of arguments `-kvalue-kvalue` in key-value pairs, with keys only being single letter IDs, separated by dashes and no spaces.

- An example command that could be pasted as-is would be: `[IMG]-n4-smd`
  - This tells [DALL-CC](https://github.com/LDexter/DALL-CC) to generate an image based on DavinCC's next response (`[IMG]`),
  - that is reproduced to create 4 renders in total (`-n4`),
  - which are all of size medium (`-smd`)

The above example requires [DALL-CC](https://github.com/LDexter/DALL-CC) to be installed on root, alongside DavinCC.

### Current Prompt Commands

All prompt commands, with their placeholder arguments:

`[PMPT]-rrisk-ccutoff-ttokens`, `[PER]-ggreet-rreplay`, `[INS]-ffile`, `[IMG]-nnumber-ssize`, `[SELF]-ggreet`, `[VAR]-nname-vvalue`, `[CLR]`

Explained:

- `[PMPT]`, to adjust standard prompt settings on the fly
  - Risk arg: `-r0.5`, for risk factor (0-1)
  - Cutoff arg: `-c10`, for reply cutoff (1-42 and 0 for infinite)
  - Tokens arg: `-t100`, for token count (1-4000)
- `[PER]`, to switch personalities on-demand
  - Greet arg: `-gstandard`, for the new personality (must already exist in /DavinCC/greetings/ folder)
  - Replay arg: `-rtrue`, to gain personality-accurate context by parsing all prompts within cutoff scope
- `[INS]`, to insert text from a file in `/DavinCC/data/`, at the exact location of the command
  - File arg: `-fitem.txt`, when speciying a file other than the default `in.txt`
- `[IMG]`, to generate an image with [DALL-CC](https://github.com/LDexter/DALL-CC) using DavinCC's reply
  - Number arg: `-n1`, to specify the number of gens on the same reply (1-10)
  - Size arg: `-smd`, for image size (sm: small, md: medium, lg: large)
  - **Note:** all image links will be written to `/DALL-CC/data/out.txt`
- `[SELF]`, to engage the AI in a conversation with itself, using an optional alternative personality
  - Greet arg: `-gstandard`, for the new personality (must already exist in /DavinCC/greetings/ folder)
  - **Note:** not currently supported by the `dalib` library
- `[VAR]`, to reassign variables that the AI is aware of

  - Name arg: `-nfoo`, when identifying the variable name (mandatory as 1st arg)
  - Value arg: `-v42`, when assigning the value (mandatory as 2nd arg)
  - **Note:** can be chained indefinitely:

    `[VAR]-nfoo-v42-nbar-vthing-nx-v70-ny-v88-nstr-wow`

  - **Note:** always blocks prompt from AI processing and modifies the chat log instead
  - **Note:** must already exist in conversation as `var=1`, `item=thing`, etc
  - **Note:** awareness of variables is dependent on the cutoff scope

- `[CLR]`, to clear the terminal without prompting the AI

## DALL-vinci Conversational Image Generation

Producing AI-generated images, that are prompted by AI-generated text requires as little effort as: _"Imagine a photograph/artwork/cartoon of a bird. Describe."_. The value achieved here is immese, as your input consists of two key words: "artwork" + "bird", while DavinCC's output is a verbose breakdown of your bird in great artistic detail... and DALL-CC **_loves detail_**. An example output from this incredible AI tag-team effort is linked below.

### DALL-vinci Output Sample

![DALL-vinci output](https://github.com/LDexter/fontawesome/blob/main/DavinCC/DALLvinci.png)
