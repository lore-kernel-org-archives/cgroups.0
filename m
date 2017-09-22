From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Fri, 22 Sep 2017 13:39:55 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1709221316290.68140@chino.kir.corp.google.com>
References: <20170911131742.16482-1-guro@fb.com> <alpine.DEB.2.10.1709111334210.102819@chino.kir.corp.google.com> <20170921142107.GA20109@cmpxchg.org> <alpine.DEB.2.10.1709211357520.60945@chino.kir.corp.google.com>
 <20170922154426.GF828415@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=YG150i2Ng27SWXDCW+jDJ3yfp6uAYMxJXFuUdifc9w4=;
        b=hepHluwFGuDvor8tofj2h/ONRVEziw+6FXmtN8/7cmC8Hu2x9SOyjknFdrBcmCjM60
         bKJzXe8QCzSg9s7ilTVYBKD9VS4zLp/Z1oqb5GnkfZvXR7xXaiCwmCF8AlV+jD9GnePn
         osgxPgsn8Ek/u+Rt0vgUf1uDbchR1nK79HssUWEoGs7tqbaAu/3it6y/ZRSs8iHe7OkH
         m4I9gY/w2f+LeI7eJcFp7wKcvSO245TOpJz0rPdR51kHpCehzR8EOIveaDOYIElRKmrY
         SFEeVE7mqjqTRemKj1a0RyXDelwNudUPQAwp+0GCTNzW9tKp5bkXKav8cqmDxtZksvMB
         3ZJA==
In-Reply-To: <20170922154426.GF828415-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 22 Sep 2017, Tejun Heo wrote:

> > It doesn't have anything to do with my particular usecase, but rather the 
> > ability of userspace to influence the decisions of the kernel.  Previous 
> > to this patchset, when selection is done based on process size, userspace 
> > has full control over selection.  After this patchset, userspace has no 
> > control other than setting all processes to be oom disabled if the largest 
> > memory consumer is to be protected.  Roman's memory.oom_priority provides 
> > a perfect solution for userspace to be able to influence this decision 
> > making and causes no change in behavior for users who choose not to tune 
> > memory.oom_priority.  The nack originates from the general need for 
> > userspace influence over oom victim selection and to avoid userspace 
> > needing to take the rather drastic measure of setting all processes to be 
> > oom disabled to prevent oom kill in kernels before oom priorities are 
> > introduced.
> 
> Overall, I think that OOM killing is the wrong place to implement
> sophisticated intelligence in.  It's too late to be smart - the
> workload already has suffered significantly and there's only very
> limited amount of computing which can be performed.  That said, if
> there's a useful and general enough mechanism to configure OOM killer
> behavior from userland, that can definitely be useful.
> 

What is under discussion is a new way to compare sibling cgroups when 
selecting a victim for oom kill.  It's a new heuristic based on a 
characteristic of the memory cgroup rather than the individual process.  
We want this behavior that the patchset implements.  The only desire is a 
way for userspace to influence that decision making in the same way that 
/proc/pid/oom_score_adj allows userspace to influence the current 
heuristic.

Current heuristic based on processes is coupled with per-process
/proc/pid/oom_score_adj.  The proposed 
heuristic has no ability to be influenced by userspace, and it needs one.  
The proposed heuristic based on memory cgroups coupled with Roman's 
per-memcg memory.oom_priority is appropriate and needed.  It is not 
"sophisticated intelligence," it merely allows userspace to protect vital 
memory cgroups when opting into the new features (cgroups compared based 
on size and memory.oom_group) that we very much want.

> We even change the whole scheduling behaviors and try really hard to
> not get locked into specific implementation details which exclude
> future improvements.  Guaranteeing OOM killing selection would be
> crazy.  Why would we prevent ourselves from doing things better in the
> future?  We aren't talking about the semantics of read(2) here.  This
> is a kernel emergency mechanism to avoid deadlock at the last moment.
> 

We merely want to prefer other memory cgroups are oom killed on system oom 
conditions before important ones, regardless if the important one is using 
more memory than the others because of the new heuristic this patchset 
introduces.  This is exactly the same as /proc/pid/oom_score_adj for the 
current heuristic.

> Here's a really simple use case.  Imagine a system which hosts two
> containers of services and one is somewhat favored over the other and
> wants to set up cgroup hierarchy so that resources are split at the
> top level between the two containers.  oom_priority is set accordingly
> too.  Let's say a low priority maintenance job in higher priority
> container goes berserk, as they oftne do, and pushing the system into
> OOM.
> 
> With the proposed static oom_priority mechanism, the only
> configuration which can be expressed is "kill all of the lower top
> level subtree before any of the higher one", which is a silly
> restriction leading to silly behavior and a direct result of
> conflating resource distribution network with level-by-level OOM
> killing decsion.
> 

The problem you're describing is an issue with the top-level limits after 
this patchset is merged, not memory.oom_priority at all.

If they are truly split evenly, this patchset kills the largest process 
from the hierarchy with the most charged memory.  That's unchanged if the 
two priorities are equal.  By changing the priority to be more preferred 
for a hierarchy, you indeed prefer oom kills from the lower priority 
hierarchy.  You've opted in.  One hierarchy is more important than the 
other, regardless of any hypothetical low priority maintenance job going 
berserk.

If you have this low priority maintenance job charging memory to the high 
priority hierarchy, you're already misconfigured unless you adjust 
/proc/pid/oom_score_adj because it will oom kill any larger process than 
itself in today's kernels anyway.

A better configuration would be attach this hypothetical low priority 
maintenance job to its own sibling cgroup with its own memory limit to 
avoid exactly that problem: it going berserk and charging too much memory 
to the high priority container that results in one of its processes 
getting oom killed.
