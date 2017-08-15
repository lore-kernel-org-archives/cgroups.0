From: Roman Gushchin <guro@fb.com>
Subject: Re: [v5 2/4] mm, oom: cgroup-aware OOM killer
Date: Tue, 15 Aug 2017 13:15:58 +0100
Message-ID: <20170815121558.GA15892@castle.dhcp.TheFacebook.com>
References: <20170814183213.12319-1-guro@fb.com>
 <20170814183213.12319-3-guro@fb.com>
 <alpine.DEB.2.10.1708141532300.63207@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=SSk492Mjd47wtNqGIhwEpXxVDS8ul8NU3mkWFzvkB/c=;
 b=oTB8SGsIIcmJ1rRI+kFqVsvNGA+a3kX8uboasamY/LGXXvHh0HjLpz0Kk6IjZvXgfytR
 Q+kbOnkF0OxukXf3+zeEqaz3OM/ixq4LZEVV4DhXJ6W36gw38Imtwk6X0/A1+B/qK1BO
 Abq2D8g6M6Jyxn2Okd9TkhXTK8OjxdqFTq4= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=SSk492Mjd47wtNqGIhwEpXxVDS8ul8NU3mkWFzvkB/c=;
 b=MDcAs/IzB448r+qi3pqv4VzriJ8NWk+fqWM8hPjEqyravHZsCZp2xtBjsExVqtzVV6YFcaesrd9T8J/b+KkpFJ2kGdxbwiH96eWk4A2o6ELlySc8Fii5FZ5W0UBNeZx9uv5w4oYYaScl6vImSFBpxrWCuvZekZEtxVa35i0xNTk=
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1708141532300.63207@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Aug 14, 2017 at 03:42:54PM -0700, David Rientjes wrote:
> On Mon, 14 Aug 2017, Roman Gushchin wrote:
> > +
> > +static long oom_evaluate_memcg(struct mem_cgroup *memcg,
> > +			       const nodemask_t *nodemask)
> > +{
> > +	struct css_task_iter it;
> > +	struct task_struct *task;
> > +	int elegible = 0;
> > +
> > +	css_task_iter_start(&memcg->css, 0, &it);
> > +	while ((task = css_task_iter_next(&it))) {
> > +		/*
> > +		 * If there are no tasks, or all tasks have oom_score_adj set
> > +		 * to OOM_SCORE_ADJ_MIN and oom_kill_all_tasks is not set,
> > +		 * don't select this memory cgroup.
> > +		 */
> > +		if (!elegible &&
> > +		    (memcg->oom_kill_all_tasks ||
> > +		     task->signal->oom_score_adj != OOM_SCORE_ADJ_MIN))
> > +			elegible = 1;
> 
> I'm curious about the decision made in this conditional and how 
> oom_kill_memcg_member() ignores task->signal->oom_score_adj.  It means 
> that memory.oom_kill_all_tasks overrides /proc/pid/oom_score_adj if it 
> should otherwise be disabled.
> 
> It's undocumented in the changelog, but I'm questioning whether it's the 
> right decision.  Doesn't it make sense to kill all tasks that are not oom 
> disabled, and allow the user to still protect certain processes by their 
> /proc/pid/oom_score_adj setting?  Otherwise, there's no way to do that 
> protection without a sibling memcg and its own reservation of memory.  I'm 
> thinking about a process that governs jobs inside the memcg and if there 
> is an oom kill, it wants to do logging and any cleanup necessary before 
> exiting itself.  It seems like a powerful combination if coupled with oom 
> notification.

Good question!
I think, that an ability to override any oom_score_adj value and get all tasks
killed is more important, than an ability to kill all processes with some
exceptions.

In your example someone still needs to look after the remaining process,
and kill it after some timeout, if it will not quit by itself, right?

The special treatment of the -1000 value (without oom_kill_all_tasks)
is required only to not to break the existing setups.

Generally, oom_score_adj should have a meaning only on a cgroup level,
so extending it to the system level doesn't sound as a good idea.

> 
> Also, s/elegible/eligible/

Shame on me :)
Will fix, thanks!

> 
> Otherwise, looks good!

Great!
Thank you for the reviewing and testing.

Roman

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
