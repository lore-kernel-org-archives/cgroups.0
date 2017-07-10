From: David Rientjes <rientjes@google.com>
Subject: Re: [v3 2/6] mm, oom: cgroup-aware OOM killer
Date: Mon, 10 Jul 2017 16:05:49 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1707101547010.116811@chino.kir.corp.google.com>
References: <1498079956-24467-1-git-send-email-guro@fb.com> <1498079956-24467-3-git-send-email-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=AuWb+0GXRrmk/xqByzfJabYe7BWdZmX6rYP6W+hZnlc=;
        b=jfmoujEBvtvx+p4pI/WmayDpMXTmMvbbAahoviY/H5P0mYChBOgwcLmxqIM89AzzV/
         6K0+8s4ew3ypBbePvKuXnW4KSyo+33TgXPsaSqQE0PPQWPky4noFvvdKfRbF8a5sPU4S
         YPUlj1ogBaFuIUJy567XakTfkVUtcHnjAzelmB04cpamsDLuI/E9m+Q1ifkNDSOCdVuA
         3IldsknG7+SxKyLUemBuqiM23nL5jghHOc0PUweJmjm1WgKWyKNi0FokTSqBaf8jYc1K
         792guPN6gLwrZlPDniRHqRQEmtyEuBGXELHFWH+IoueqqlY+LpSJcINp4vW8ft1191iK
         CP+w==
In-Reply-To: <1498079956-24467-3-git-send-email-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 21 Jun 2017, Roman Gushchin wrote:

> Traditionally, the OOM killer is operating on a process level.
> Under oom conditions, it finds a process with the highest oom score
> and kills it.
> 
> This behavior doesn't suit well the system with many running
> containers. There are two main issues:
> 
> 1) There is no fairness between containers. A small container with
> few large processes will be chosen over a large one with huge
> number of small processes.
> 

Yes, the original motivation was to limit killing to a single process, if 
possible.  To do that, we kill the process with the largest rss to free 
the most memory and rely on the user to configure /proc/pid/oom_score_adj 
if something else should be prioritized.

With containerization and overcommit of system memory, we concur that 
killing the single largest process isn't always preferable and neglects 
the priority of its memcg.  Your motivation seems to be to provide 
fairness between one memcg with a large process and one memcg with a large 
number of small processes; I'm curious if you are concerned about the 
priority of a memcg hierarchy (how important that "job" is) or whether you 
are strictly concerned with "largeness" of memcgs relative to each other.

> 2) Containers often do not expect that some random process inside
> will be killed. In many cases much more safer behavior is to kill
> all tasks in the container. Traditionally, this was implemented
> in userspace, but doing it in the kernel has some advantages,
> especially in a case of a system-wide OOM.
> 

We agree.

> 3) Per-process oom_score_adj affects global OOM, so it's a breache
> in the isolation.
> 

This should only be a consequence of overcommiting memcgs at the top level 
so the system oom killer is actually ever invoked, otherwise per-process 
oom_score_adj works well for memcg oom killing.

> To address these issues, cgroup-aware OOM killer is introduced.
> 
> Under OOM conditions, it tries to find the biggest memory consumer,
> and free memory by killing corresponding task(s). The difference
> the "traditional" OOM killer is that it can treat memory cgroups
> as memory consumers as well as single processes.
> 
> By default, it will look for the biggest leaf cgroup, and kill
> the largest task inside.
> 
> But a user can change this behavior by enabling the per-cgroup
> oom_kill_all_tasks option. If set, it causes the OOM killer treat
> the whole cgroup as an indivisible memory consumer. In case if it's
> selected as on OOM victim, all belonging tasks will be killed.
> 

These are two different things, right?  We can adjust how the system oom 
killer chooses victims when memcg hierarchies overcommit the system to not 
strictly prefer the single process with the largest rss without killing 
everything attached to the memcg.

Separately: do you not intend to support memcg priorities at all, but 
rather strictly consider the "largeness" of a memcg versus other memcgs?

In our methodology, each memcg is assigned a priority value and the 
iteration of the hierarchy simply compares and visits the memcg with the 
lowest priority at each level and then selects the largest process to 
kill.  This could also support a "kill-all" knob.

	struct mem_cgroup *memcg = root_mem_cgroup;
	struct mem_cgroup *low_memcg;
	unsigned long low_priority;

next:
	low_memcg = NULL;
	low_priority = ULONG_MAX;
	for_each_child_of_memcg(memcg) {
		unsigned long prio = memcg_oom_priority(memcg);

		if (prio < low_priority) {
			low_memcg = memcg;
			low_priority = prio;
		}		
	}
	if (low_memcg)
		goto next;
	oom_kill_process_from_memcg(memcg);

So this is a priority based model that is different than your aggregate 
usage model but I think it allows userspace to define a more powerful 
policy.  We certainly may want to kill from a memcg with a single large 
process, or we may want to kill from a memcg with several small processes, 
it depends on the importance of that job.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
