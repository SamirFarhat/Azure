# Install Terraform Step

If you have steps and tasks that use Terraform, you can add a Task on each "Stage" that will install Terraform
for you and set the "Path" environnment variable so that subsequent tasks can run 'terraform' command.

## Requirmeents
- Tested on the **VS 2017 agent** pool
- You need to add a variable to your Stage or to all the Release that contains the version: Terraformversion
- The terraform installation wide/scope in the Stage. Add an Install Step to each Stage.

## Add a Step

The following example shows a step added to a relase pipeline, but you can use it in a Build or a MultiStage pipeline.


