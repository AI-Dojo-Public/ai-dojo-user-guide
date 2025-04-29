AI-Dojo and its underlying technologies provide a number of ways to analyze the behavior and performance of agents. 

At the most rudimentary level, when a file logging is enabled, the system produces the information in the form of CSV
entries that track sent messages, run statistics, configuration, and custom information. These CSV files have to be 
extracted from the AI-Dojo container and the analysis is completely up to users.

Provided the users have an Elasticsearch stack running and the elasticsearch options is selected when creating an 
environment, runtime data is stored in the database and can be analyzed through provided analytics.

First, there is an option to analyze particular runs with a Vega-powered Kibana extension that is in detail documented 
here: [https://is.muni.cz/auth/th/jl0cs/](https://is.muni.cz/auth/th/jl0cs/). This visualization gives an overview of a
network topology, enables to inspect traversing messages, and do a time-seek and replay of runs. 

Here are some examples of how the visualization looks like:

<figure>
  <img src="images/analysis_vis_1.png" alt="Visualization of network topology">
  <figcaption>Visualization of network topology</figcaption>
</figure>

<figure>
  <img src="images/analysis_vis_2.png" alt="Inspection of traversing messages">
  <figcaption>Inspection of traversing messages</figcaption>
</figure>

<figure>
  <img src="images/analysis_vis_3.png" alt="The general UI with time controls">
  <figcaption>The general UI with time controls</figcaption>
</figure>

Second, for runs that are executed on the emulation platform, which does not enable such a deep insight into the 
internal details, users can utilize the visualization provided by the Cryton framework, which is included in the
frontend.

<figure>
  <img src="images/analysis_vis_4.png" alt="Cryton UI">
  <figcaption>Cryton UI</figcaption>
</figure>

<figure>
  <img src="images/analysis_vis_5.png" alt="Visualization of action sequence">
  <figcaption>Visualization of action sequence</figcaption>
</figure>

And finally, when using agents through the NetSecGame coordinator (i.e., not fully custom agents), many a data is 
collected and can provide an important insights into agents' working.

<figure>
  <img src="images/analysis_vis_6.png" alt="Histogram of action utilization">
  <figcaption>Histogram of action utilization</figcaption>
</figure>

<figure>
  <img src="images/analysis_vis_7.png" alt="Trajectory step comparison">
  <figcaption>Trajectory step comparison</figcaption>
</figure>

<figure>
  <img src="images/analysis_vis_8.png" alt="Action sequences">
  <figcaption>Action sequences</figcaption>
</figure>

Despite our efforts, these analytic tools are still in the prototype mode, so they may be sometime hard to use or to
even launch correctly. Depending on the time you are reading this, you may need to contact us if you want to utilize 
these visualizations.
