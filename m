From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [v3 2/6] mm, oom: cgroup-aware OOM killer
Date: Wed, 12 Jul 2017 13:11:10 +0100
Message-ID: <20170712121110.GA9017@castle>
References: <1498079956-24467-1-git-send-email-guro@fb.com>
 <1498079956-24467-3-git-send-email-guro@fb.com>
 <alpine.DEB.2.10.1707101547010.116811@chino.kir.corp.google.com>
 <20170711125124.GA12406@castle>
 <alpine.DEB.2.10.1707111342190.60183@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=qTNxet8plFjK8RaqnykWIJx/vuEsMz6TNTn0VCD7U/I=;
 b=GacPWNPNOZ6XqbjcvOZEfp1oOC5Tf1fBjh5trPqZWx85hr8M18RlsZGbpEyzUBESgTwf
 W7q6Qp9cMmyuW6uO40JanmqDZxAffQkHjjlDu/EUhtIVzYdbLTbpUbxNtEFcODEBezVM
 R65duZ8o5bznshjBJeWEOEtDxr6WybknjkI= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=qTNxet8plFjK8RaqnykWIJx/vuEsMz6TNTn0VCD7U/I=;
 b=kJmrxJmgEVvtAgduiIniCafz+F7nAzbsdU8G/T51BEJLJDVrMQmpaS1kO6RYOho1yCM/zlNHkJZyTZUXJGan9zmyA70zKW91n/1o9drK8NN4eHyYtLeD0u7zJ1HdxZTT/JNMW7eSCi2RZKpUN6LViqeKfAh3Bc1cR6sEUarengY=
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1707111342190.60183-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jul 11, 2017 at 01:56:30PM -0700, David Rientjes wrote:
> On Tue, 11 Jul 2017, Roman Gushchin wrote:
> 
> > > Yes, the original motivation was to limit killing to a single process, if 
> > > possible.  To do that, we kill the process with the largest rss to free 
> > > the most memory and rely on the user to configure /proc/pid/oom_score_adj 
> > > if something else should be prioritized.
> > > 
> > > With containerization and overcommit of system memory, we concur that 
> > > killing the single largest process isn't always preferable and neglects 
> > > the priority of its memcg.  Your motivation seems to be to provide 
> > > fairness between one memcg with a large process and one memcg with a large 
> > > number of small processes; I'm curious if you are concerned about the 
> > > priority of a memcg hierarchy (how important that "job" is) or whether you 
> > > are strictly concerned with "largeness" of memcgs relative to each other.
> > 
> > I'm pretty sure we should provide some way to prioritize some cgroups
> > over other (in terms of oom killer preferences), but I'm not 100% sure yet,
> > what's the best way to do it. I've suggested something similar to the existing
> > oom_score_adj for tasks, mostly to folow the existing design.
> > 
> > One of the questions to answer in priority-based model is
> > how to compare tasks in the root cgroup with cgroups?
> > 
> 
> We do this with an alternate scoring mechanism, that is purely priority 
> based and tiebreaks based on largest rss.  An additional tunable is added 
> for each process, under /proc/pid, and also to the memcg hierarchy, and is 
> enabled via a system-wide sysctl.  I way to mesh the two scoring 
> mechanisms together would be helpful, but for our purposes we don't use 
> oom_score_adj at all, other than converting OOM_SCORE_ADJ_MIN to still be 
> oom disabled when written by third party apps.
> 
> For memcg oom conditions, iteration of the hierarchy begins at the oom 
> memcg.  For system oom conditions, this is the root memcg.
> 
> All processes attached to the oom memcg have their priority based value 
> and this is compared to all child memcg's priority value at that level.  
> If a process has the lowest priority, it is killed and we're done; we 
> could implement a "kill all" mechanism for this memcg that is checked 
> before the process is killed.
> 
> If a memcg has the lowest priority compared to attached processes, it is 
> iterated as well, and so on throughout the memcg hierarchy until we find 
> the lowest priority process in the lowest priority leaf memcg.  This way, 
> we can fully control which process is killed for both system and memcg oom 
> conditions.  I can easily post patches for this, we have used it for 
> years.
> 
> > > These are two different things, right?  We can adjust how the system oom 
> > > killer chooses victims when memcg hierarchies overcommit the system to not 
> > > strictly prefer the single process with the largest rss without killing 
> > > everything attached to the memcg.
> > 
> > They are different, and I thought about providing two independent knobs.
> > But after all I haven't found enough real life examples, where it can be useful.
> > Can you provide something here?
> > 
> 
> Yes, we have users who we chown their memcg hierarchy to and have full 
> control over setting up their hierarchy however we want.  Our "Activity 
> Manager", using Documentation/cgroup-v1/memory.txt terminology, only is 
> aware of the top level memcg that was chown'd to the user.  That user runs 
> a series of batch jobs that are submitted to it and each job is 
> represented as a subcontainer to enforce strict limits on the amount of 
> memory that job can use.  When it becomes oom, we have found that it is 
> preferable to oom kill the entire batch job rather than leave it in an 
> inconsistent state, so enabling such a knob here would be helpful.
> 
> Other top-level jobs are fine with individual processes being oom killed.  
> It can be a low priority process for which they have full control over 
> defining the priority through the new per-process and per-memcg value 
> described above.  Easy example is scraping logs periodically or other 
> best-effort tasks like cleanup.  They can happily be oom killed and 
> rescheduled without taking down the entire first-class job.
> 
> > Also, they are different only for non-leaf cgroups; leaf cgroups
> > are always treated as indivisible memory consumers during victim selection.
> > 
> > I assume, that containerized systems will always set oom_kill_all_tasks for
> > top-level container memory cgroups. By default it's turned off
> > to provide backward compatibility with current behavior and avoid
> > excessive kills and support oom_score_adj==-1000 (I've added this to v4,
> > will post soon).
> > 
> 
> We certainly would not be enabling it for top-level memcgs, there would be 
> no way that we could because we have best-effort processes, but we would 
> like to enable it for small batch jobs that are run on behalf of a user in 
> their own subcontainer.  We have had this usecase for ~3 years and solely 
> because of the problem that you pointed out earlier: it is often much more 
> reliable for the kernel to do oom killing of multiple processes rather 
> than userspace.
> 
> > > In our methodology, each memcg is assigned a priority value and the 
> > > iteration of the hierarchy simply compares and visits the memcg with the 
> > > lowest priority at each level and then selects the largest process to 
> > > kill.  This could also support a "kill-all" knob.
> > > 
> > > 	struct mem_cgroup *memcg = root_mem_cgroup;
> > > 	struct mem_cgroup *low_memcg;
> > > 	unsigned long low_priority;
> > > 
> > > next:
> > > 	low_memcg = NULL;
> > > 	low_priority = ULONG_MAX;
> > > 	for_each_child_of_memcg(memcg) {
> > > 		unsigned long prio = memcg_oom_priority(memcg);
> > > 
> > > 		if (prio < low_priority) {
> > > 			low_memcg = memcg;
> > > 			low_priority = prio;
> > > 		}		
> > > 	}
> > > 	if (low_memcg)
> > > 		goto next;
> > > 	oom_kill_process_from_memcg(memcg);
> > > 
> > > So this is a priority based model that is different than your aggregate 
> > > usage model but I think it allows userspace to define a more powerful 
> > > policy.  We certainly may want to kill from a memcg with a single large 
> > > process, or we may want to kill from a memcg with several small processes, 
> > > it depends on the importance of that job.
> > 
> > I believe, that both models have some advantages.
> > Priority-based model is more powerful, but requires support from the userspace
> > to set up these priorities (and, probably, adjust them dynamically).
> 
> It's a no-op if nobody sets up priorities or the system-wide sysctl is 
> disabled.  Presumably, as in our model, the Activity Manager sets the 
> sysctl and is responsible for configuring the priorities if present.  All 
> memcgs at the sibling level or subcontainer level remain the default if 
> not defined by the chown'd user, so this falls back to an rss model for 
> backwards compatibility.

Hm, this is interesting...

What I'm thinking about, is that we can introduce the following model:
each memory cgroup has an integer oom priority value, 0 be default.
Root cgroup priority is always 0, other cgroups can have both positive
or negative priorities.

During OOM victim selection we compare cgroups on each hierarchy level
based on priority and size, if there are several cgroups with equal priority.
Per-task oom_score_adj will affect task selection inside a cgroup if
oom_kill_all_tasks is not set. -1000 special value will also completely
protect a task from being killed, if only oom_kill_all_tasks is not set.

I wonder, if it will work for you?

Thanks!

Roman
