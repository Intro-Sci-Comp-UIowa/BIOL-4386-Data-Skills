WEEK3: WORKSHOP
Ethan Bahl, edited by Bin He 2021-02-09 9:30pm

1. Edit the README file in the directory you created last week (should be called `My_Project`)
	a. recall where you created the directory (eh, where did I create it? I thought it was here? but there is nothing ... - 1hr later - omg... first lesson in reproducible research!)
	b. use `cd` to enter that directory (or recreate one if you can't find the old one, and do remember its location this time!)
	c. use nano to open the README.md file you created last week (hint: `nano READMD.md`)
	d. add a brief description of your project in markdown. include headings like "Introduction", "Figure to Reproduce", "Materials and Methods", "Results", "Discussion", "Conclusion". Try to use bulleted lists and insert an image if you can. (if you haven't settled on which paper to reproduce, just randomly choose one)
	e. turn that markdown file into a pdf by typing `pandoc -o README.pdf README.md`. 
	    - if you see an error like ~README.md doesn't exist~, you are likely in the wrong directory. check using `pwd`
	    - if you see an error like ~Command not found: pandoc~, it means the system you are working on doesn't have pandoc installed (fastx did have pandoc). in that case, use the online site you used last week and just download the preview as a pdf.
	f. you will be asked to upload your output as part of this week's feedback on Thursday.

2. Write a shell script to automate what you have just done in #1. When this shell script is executed inside of an empty project directory, it should...
	a. create appropriate/general project subdirectories (eg, data/, code/, figures/).
	b. create a README for the main project directory.
	c. copies the main project README into the subdirectories.
	d. (optional) can you think of a way to have the script print to the screen something like "Done!" at the end (Hint: use `echo`)

3. (Challenge/Game) If the above are a piece of cake for your level, try this fun game. It's worth no extra credit, just the joy at the bottom of your heart. Feel free to share a screenshot of your final award!
    a. Go to <https://gitlab.com/slackermedia/bashcrawl> and click the "download" icon next to "Find file" (you can use any of the format. if you don't know, just choose zip)
    b. Follow the instructions on the frontpage of the repository (the link above).
    c. Share a screenshot of your result!