From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [v11 3/6] mm, oom: cgroup-aware OOM killer
Date: Fri, 13 Oct 2017 14:31:28 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1710131419460.44793@chino.kir.corp.google.com>
References: <20171005130454.5590-1-guro@fb.com> <20171005130454.5590-4-guro@fb.com> <alpine.DEB.2.10.1710091414260.59643@chino.kir.corp.google.com> <20171010122306.GA11653@castle.DHCP.thefacebook.com> <alpine.DEB.2.10.1710101345370.28262@chino.kir.corp.google.com>
 <20171010220417.GA8667@castle> <alpine.DEB.2.10.1710111247390.98307@chino.kir.corp.google.com> <20171011214927.GA28741@castle> <alpine.DEB.2.10.1710121415420.76558@chino.kir.corp.google.com> <20171013133219.GA5363@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=8uV1/4YqsFGC9ayVNYkBUqxIZcWdw5K0wYnbLq3yueI=;
        b=FUpvL3Nqnyb/KAupif9REtsbekpWI3niH6aPJBgzqXDDRm/tkyeKa7jzHfO2kREPvJ
         wWw0mLbRG3eW7O6iyaPkKf4FUsE+tLV828Hg0NE2q69ny3WwguQIDR70fq6gatxIfH96
         sV8JtRWT4USE8j9xQTtt7yYY9ZseJRUgJ69KXLnI8QDT2egrtbnUrvRubWabezyJPmIj
         QpIjJgI5G8yVyWX5iBKsGQaHYMzT6ROHIzkLjotFW/9F/vJMc5USpQxY70HazDAspIOi
         3f5bMX8XVVBoIOTgH/XLRNZl+F6XAmOnnovBRBOt+KITy1JRFDWCAR8Uo0ITo9U3p90G
         BbVw==
In-Reply-To: <20171013133219.GA5363-B3w7+ongkCiLfgCeKHXN1g2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 13 Oct 2017, Roman Gushchin wrote:

> > Think about it in a different way: we currently compare per-process usage 
> > and userspace has /proc/pid/oom_score_adj to adjust that usage depending 
> > on priorities of that process and still oom kill if there's a memory leak.  
> > Your heuristic compares per-cgroup usage, it's the cgroup-aware oom killer 
> > after all.  We don't need a strict memory.oom_priority that outranks all 
> > other sibling cgroups regardless of usage.  We need a memory.oom_score_adj 
> > to adjust the per-cgroup usage.  The decisionmaking in your earlier 
> > example would be under the control of C/memory.oom_score_adj and 
> > D/memory.oom_score_adj.  Problem solved.
> > 
> > It also solves the problem of userspace being able to influence oom victim 
> > selection so now they can protect important cgroups just like we can 
> > protect important processes today.
> > 
> > And since this would be hierarchical usage, you can trivially infer root 
> > mem cgroup usage by subtraction of top-level mem cgroup usage.
> > 
> > This is a powerful solution to the problem and gives userspace the control 
> > they need so that it can work in all usecases, not a subset of usecases.
> 
> You're right that per-cgroup oom_score_adj may resolve the issue with
> too strict semantics of oom_priorities. But I believe nobody likes
> the existing per-process oom_score_adj interface, and there are reasons behind.

The previous heuristic before I rewrote the oom killer used 
/proc/pid/oom_adj which acted as a bitshift on mm->total_vm, which was a 
much more difficult interface to use as I'm sure you can imagine.  People 
ended up only using it to polarize selection: either -17 to oom disable a 
process, -16 to bias against it, and 15 to prefer it.  Nobody used 
anything in between and I worked with openssh, udev, kde, and chromium to 
get a consensus on the oom_score_adj semantics.  People do use it to 
protect against memory leaks and to prevent oom killing important 
processes when something else can be sacrificed, unless there's a leak.

> Especially in case of memcg-OOM, getting the idea how exactly oom_score_adj
> will work is not trivial.

I suggest defining it in the terms used for previous iterations of the 
patchset: do hierarchical scoring so that each level of the hierarchy has 
usage information for each subtree.  You can get root mem cgroup usage 
with complete fairness by subtraction with this method.  When comparing 
usage at each level of the hierarchy, you can propagate the eligibility of 
processes in that subtree much like you do today.  I agree with your 
change to make the oom killer a no-op if selection races with the actual 
killing rather than falling back to the old heuristic.  I'm happy to help 
add a Tested-by once we settle the other issues with that change.

At each level, I would state that memory.oom_score_adj has the exact same 
semantics as /proc/pid/oom_score_adj.  In this case, it would simply be 
defined as a proportion of the parent's limit.  If the hierarchy is 
iterated starting at the root mem cgroup for system ooms and at the root 
of the oom memcg for memcg ooms, this should lead to the exact same oom 
killing behavior, which is desired.

This solution would address the three concerns that I had: it allows the 
root mem cgroup to be compared fairly with leaf mem cgroups (with the 
bonus of not requiring root mem cgroup accounting thanks to your heuristic 
using global vmstats), it allows userspace to influence the decisionmaking 
so that users can protect cgroups that use 50% of memory because they are 
important, and it completely avoids users being able to change victim 
selection simply by creating child mem cgroups.

This would be a very powerful patchset.
