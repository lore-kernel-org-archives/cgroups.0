From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [v4 3/4] mm, oom: introduce oom_priority for memory cgroups
Date: Tue, 8 Aug 2017 16:14:50 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1708081607230.54505@chino.kir.corp.google.com>
References: <20170726132718.14806-1-guro@fb.com> <20170726132718.14806-4-guro@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=V4A2srj6+rvjmt6R1DYAsxqLZpeAi9Pmu/2scHXrPgo=;
        b=FtG5md0ZdN6/RSTz8aE9rE10opRWjHl64+Douhms6KwikEa1desGpPP2qESjcb6QRw
         TbsEuUNB3MkW7ByXH3QTwoBz9uPUE1TV09JPreANiplmBVjh0p43v/B0J0yWkdAszTTt
         n0nqsrVycQAwWjCR/k/ZW1Fp1PIKdrJ7HAugwI01sLRNYnpehrXq+OYp/wU7YLynbq5g
         p7XtGLPZFLAoIpacWOghOrtJ9/QCD79HIl/4kBKtvuLyNQAK5BvKfvGrBc9d4Vtz/8ao
         Ub4Rdr/CHPQcbAGxB199S6WkFUa6cDo22LJ/ohrBUF+OW4yy2VSgbqvqfMwCcjyiZ4ab
         FcKw==
In-Reply-To: <20170726132718.14806-4-guro-b10kYP2dOMg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 26 Jul 2017, Roman Gushchin wrote:

> Introduce a per-memory-cgroup oom_priority setting: an integer number
> within the [-10000, 10000] range, which defines the order in which
> the OOM killer selects victim memory cgroups.
> 
> OOM killer prefers memory cgroups with larger priority if they are
> populated with elegible tasks.
> 
> The oom_priority value is compared within sibling cgroups.
> 
> The root cgroup has the oom_priority 0, which cannot be changed.
> 

Awesome!  Very excited to see that you implemented this suggestion and it 
is similar to priority based oom killing that we have done.  I think this 
kind of support is long overdue in the oom killer.

Comment inline.

> Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
> Cc: kernel-team-b10kYP2dOMg@public.gmane.org
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> ---
>  include/linux/memcontrol.h |  3 +++
>  mm/memcontrol.c            | 55 ++++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 56 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index b21bbb0edc72..d31ac58e08ad 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -206,6 +206,9 @@ struct mem_cgroup {
>  	/* cached OOM score */
>  	long oom_score;
>  
> +	/* OOM killer priority */
> +	short oom_priority;
> +
>  	/* handle for "memory.events" */
>  	struct cgroup_file events_file;
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ba72d1cf73d0..2c1566995077 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2710,12 +2710,21 @@ static void select_victim_memcg(struct mem_cgroup *root, struct oom_control *oc)
>  	for (;;) {
>  		struct cgroup_subsys_state *css;
>  		struct mem_cgroup *memcg = NULL;
> +		short prio = SHRT_MIN;
>  		long score = LONG_MIN;
>  
>  		css_for_each_child(css, &root->css) {
>  			struct mem_cgroup *iter = mem_cgroup_from_css(css);
>  
> -			if (iter->oom_score > score) {
> +			if (iter->oom_score == 0)
> +				continue;
> +
> +			if (iter->oom_priority > prio) {
> +				memcg = iter;
> +				prio = iter->oom_priority;
> +				score = iter->oom_score;
> +			} else if (iter->oom_priority == prio &&
> +				   iter->oom_score > score) {
>  				memcg = iter;
>  				score = iter->oom_score;
>  			}

Your tiebreaking is done based on iter->oom_score, which I suppose makes 
sense given that the oom killer traditionally tries to kill from the 
largest memory hogging process.

We actually tiebreak on a timestamp of memcg creation and prefer to kill 
from the newer memcg when iter->oom_priority is the same.  The reasoning 
is that we schedule jobs on a machine that have an inherent priority but 
is unaware of other jobs running at the same priority and so the kill 
decision, if based on iter->oom_score, may differ based on current memory 
usage.

I'm not necessarily arguing against using iter->oom_score, but was 
wondering if you would also find that tiebreaking based on a timestamp 
when priorities are the same is a more clear semantic to describe?  It's 
similar to how the system oom killer tiebreaked based on which task_struct 
appeared later in the tasklist when memory usage was the same.

Your approach makes oom killing less likely in the near term since it 
kills a more memory hogging memcg, but has the potential to lose less 
work.  A timestamp based approach loses the least amount of work by 
preferring to kill newer memcgs but oom killing may be more frequent if 
smaller child memcgs are killed.  I would argue the former is the 
responsibility of the user for using the same priority.

> @@ -2782,7 +2791,15 @@ bool mem_cgroup_select_oom_victim(struct oom_control *oc)
>  	 * For system-wide OOMs we should consider tasks in the root cgroup
>  	 * with oom_score larger than oc->chosen_points.
>  	 */
> -	if (!oc->memcg) {
> +	if (!oc->memcg && !(oc->chosen_memcg &&
> +			    oc->chosen_memcg->oom_priority > 0)) {
> +		/*
> +		 * Root memcg has priority 0, so if chosen memcg has lower
> +		 * priority, any task in root cgroup is preferable.
> +		 */
> +		if (oc->chosen_memcg && oc->chosen_memcg->oom_priority < 0)
> +			oc->chosen_points = 0;
> +
>  		select_victim_root_cgroup_task(oc);
>  
>  		if (oc->chosen && oc->chosen_memcg) {
> @@ -5373,6 +5390,34 @@ static ssize_t memory_oom_kill_all_tasks_write(struct kernfs_open_file *of,
>  	return nbytes;
>  }
>  
> +static int memory_oom_priority_show(struct seq_file *m, void *v)
> +{
> +	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
> +
> +	seq_printf(m, "%d\n", memcg->oom_priority);
> +
> +	return 0;
> +}
> +
> +static ssize_t memory_oom_priority_write(struct kernfs_open_file *of,
> +				char *buf, size_t nbytes, loff_t off)
> +{
> +	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
> +	int oom_priority;
> +	int err;
> +
> +	err = kstrtoint(strstrip(buf), 0, &oom_priority);
> +	if (err)
> +		return err;
> +
> +	if (oom_priority < -10000 || oom_priority > 10000)
> +		return -EINVAL;
> +
> +	memcg->oom_priority = (short)oom_priority;
> +
> +	return nbytes;
> +}
> +
>  static int memory_events_show(struct seq_file *m, void *v)
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
> @@ -5499,6 +5544,12 @@ static struct cftype memory_files[] = {
>  		.write = memory_oom_kill_all_tasks_write,
>  	},
>  	{
> +		.name = "oom_priority",
> +		.flags = CFTYPE_NOT_ON_ROOT,
> +		.seq_show = memory_oom_priority_show,
> +		.write = memory_oom_priority_write,
> +	},
> +	{
>  		.name = "events",
>  		.flags = CFTYPE_NOT_ON_ROOT,
>  		.file_offset = offsetof(struct mem_cgroup, events_file),
