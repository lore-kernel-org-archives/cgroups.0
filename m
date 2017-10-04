From: Roman Gushchin <guro@fb.com>
Subject: Re: [v10 3/6] mm, oom: cgroup-aware OOM killer
Date: Wed, 4 Oct 2017 20:51:10 +0100
Message-ID: <20171004195110.GA18900@castle>
References: <20171004154638.710-1-guro@fb.com>
 <20171004154638.710-4-guro@fb.com>
 <20171004192720.GC1501@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=XfeQXVT86PBnW6yk/E6UyxRrTCsdEEz4HaS5CVmQRps=;
 b=l6W3ETBM1Gx42rjErDXdVUcnpeCzqkDLjB7iZbN97CWa7kEMagrTCPTXNpYWbP2Stl9Z
 sJ/P7R+ZCTo5+7i06YEjle48txKfwQ1Q6k85TEf2JgH4IASWwq9awIcSsOVU286I8z+h
 V88ThMMekqznLg+JqcDUFGDQF6pxTmFKmD4= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=XfeQXVT86PBnW6yk/E6UyxRrTCsdEEz4HaS5CVmQRps=;
 b=ROxPumzl1U0PsOcVsp4W4o7PQSG2px5hh7Q06XUn7ONzJWhtch8QUCJQG2K8D3Lenp2XQfQqmDWm0NTmGqTIEwyAZ/dFah1Y/WArOqPg+vUQuVSUuohDwbMnjvu+cCmiG9rqH6t08qiiF+Y1AqCEG+e0yWrtUmoflqlNvVGgEH4=
Content-Disposition: inline
In-Reply-To: <20171004192720.GC1501@cmpxchg.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Oct 04, 2017 at 03:27:20PM -0400, Johannes Weiner wrote:
> On Wed, Oct 04, 2017 at 04:46:35PM +0100, Roman Gushchin wrote:
> > Traditionally, the OOM killer is operating on a process level.
> > Under oom conditions, it finds a process with the highest oom score
> > and kills it.
> > 
> > This behavior doesn't suit well the system with many running
> > containers:
> > 
> > 1) There is no fairness between containers. A small container with
> > few large processes will be chosen over a large one with huge
> > number of small processes.
> > 
> > 2) Containers often do not expect that some random process inside
> > will be killed. In many cases much safer behavior is to kill
> > all tasks in the container. Traditionally, this was implemented
> > in userspace, but doing it in the kernel has some advantages,
> > especially in a case of a system-wide OOM.
> > 
> > To address these issues, the cgroup-aware OOM killer is introduced.
> > 
> > Under OOM conditions, it looks for the biggest leaf memory cgroup
> > and kills the biggest task belonging to it. The following patches
> > will extend this functionality to consider non-leaf memory cgroups
> > as well, and also provide an ability to kill all tasks belonging
> > to the victim cgroup.
> > 
> > The root cgroup is treated as a leaf memory cgroup, so it's score
> > is compared with leaf memory cgroups.
> > Due to memcg statistics implementation a special algorithm
> > is used for estimating it's oom_score: we define it as maximum
> > oom_score of the belonging tasks.
> > 
> > Signed-off-by: Roman Gushchin <guro@fb.com>
> > Cc: Michal Hocko <mhocko@kernel.org>
> > Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > Cc: David Rientjes <rientjes@google.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: kernel-team@fb.com
> > Cc: cgroups@vger.kernel.org
> > Cc: linux-doc@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: linux-mm@kvack.org
> 
> This looks good to me.
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> I just have one question:
> 
> > @@ -828,6 +828,12 @@ static void __oom_kill_process(struct task_struct *victim)
> >  	struct mm_struct *mm;
> >  	bool can_oom_reap = true;
> >  
> > +	if (is_global_init(victim) || (victim->flags & PF_KTHREAD) ||
> > +	    victim->signal->oom_score_adj == OOM_SCORE_ADJ_MIN) {
> > +		put_task_struct(victim);
> > +		return;
> > +	}
> > +
> >  	p = find_lock_task_mm(victim);
> >  	if (!p) {
> >  		put_task_struct(victim);
> 
> Is this necessary? The callers of this function use oom_badness() to
> find a victim, and that filters init, kthread, OOM_SCORE_ADJ_MIN.

It is. __oom_kill_process() is used to kill all processes belonging
to the selected memory cgroup, so we should perform these checks
to avoid killing unkillable processes.

Thanks!
