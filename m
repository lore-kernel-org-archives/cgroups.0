From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 7/7] psi: cgroup support
Date: Thu, 10 May 2018 10:49:43 -0400
Message-ID: <20180510144943.GH19348@cmpxchg.org>
References: <20180507210135.1823-1-hannes@cmpxchg.org>
 <20180507210135.1823-8-hannes@cmpxchg.org>
 <20180509110736.GR12217@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VvhdY2Icrvortic3LDJgG6o4jdtiMx2l0jXQ2jnb1TU=; b=TspPyEo4YH3A8Z4dDoTbu5SEHV
        jJr//qieGvFKS1j525guo+Re7tqYVV5PfB/BWKRVaz1rYgZzYEycVj7X1Kb6j/Fb4NLoA8e9JSU3j
        nT6vI0QFto8+1LSwSTZG0rdCzFSjFrU3yRMilMPKl/sl+Dbxttf/gqMSyjXYQZ5VPKPo=;
Content-Disposition: inline
In-Reply-To: <20180509110736.GR12217@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Mike Galbraith <efault@gmx.de>, Oliver Yang <yangoliver@me.com>, Shakeel Butt <shakeelb@google.com>, xxx xxx <x.qendo@gmail.com>, Taras Kondratiuk <takondra@cisco.com>, Daniel Walker <danielwa@cisco.com>, Vinayak Menon <vinmenon@codeaurora.org>, Ruslan Ruslichenko <rruslich@cisco.com>, kernel-team@fb.com

On Wed, May 09, 2018 at 01:07:36PM +0200, Peter Zijlstra wrote:
> On Mon, May 07, 2018 at 05:01:35PM -0400, Johannes Weiner wrote:
> > --- a/kernel/sched/psi.c
> > +++ b/kernel/sched/psi.c
> > @@ -260,6 +260,18 @@ void psi_task_change(struct task_struct *task, u64 now, int clear, int set)
> >  	task->psi_flags |= set;
> >  
> >  	psi_group_update(&psi_system, cpu, now, clear, set);
> > +
> > +#ifdef CONFIG_CGROUPS
> > +       cgroup = task->cgroups->dfl_cgrp;
> > +       while (cgroup && (parent = cgroup_parent(cgroup))) {
> > +               struct psi_group *group;
> > +
> > +               group = cgroup_psi(cgroup);
> > +               psi_group_update(group, cpu, now, clear, set);
> > +
> > +               cgroup = parent;
> > +       }
> > +#endif
> >  }
> 
> TJ fixed needing that for stats at some point, why can't you do the
> same?

The stats deltas are all additive, so it's okay to delay flushing them
up the tree right before somebody is trying to look at them.

With this, though, we are tracking time of an aggregate state composed
of child tasks, and that state might not be identical for you and all
your ancestor, so everytime a task state changes we have to evaluate
and start/stop clocks on every level, because we cannot derive our
state from the state history of our child groups.

For example, say you have the following tree:

              root
             /
            A
          /   \
         A1   A2
  running=1   running=1

I.e. There is a a running task in A1 and one in A2.

root, A, A1, and A2 are all PSI_NONE as nothing is stalled.

Now the task in A2 enters a memstall.

              root
             /
            A
          /   \
         A1   A2
  running=1   memstall=1

From the perspective of A2, the group is now fully blocked and starts
recording time in PSI_FULL.

From the perspective of A, it has a working group below it and a
stalled one, which would make it PSI_SOME, so it starts recording time
in PSI_SOME.

The root/sytem level likewise has to start the timer on PSI_SOME.

Now the task in A1 enters a memstall, and we have to propagate the
PSI_FULL state up A1 -> A -> root.

I'm not quite sure how we could make this lazy. Say we hadn't
propagated the state from A1 and A2 right away, and somebody is asking
about the averages for A. We could tell that A1 and A2 had been in
PSI_FULL recently, but we wouldn't know exactly if them being in these
states fully overlapped (all PSI_FULL), overlapped partially (some
PSI_FULL and some PSI_SOME), or didn't overlap at all (PSI_SOME).
