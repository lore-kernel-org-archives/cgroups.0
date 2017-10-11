From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [v11 3/6] mm, oom: cgroup-aware OOM killer
Date: Wed, 11 Oct 2017 22:49:27 +0100
Message-ID: <20171011214927.GA28741@castle>
References: <20171005130454.5590-1-guro@fb.com>
 <20171005130454.5590-4-guro@fb.com>
 <alpine.DEB.2.10.1710091414260.59643@chino.kir.corp.google.com>
 <20171010122306.GA11653@castle.DHCP.thefacebook.com>
 <alpine.DEB.2.10.1710101345370.28262@chino.kir.corp.google.com>
 <20171010220417.GA8667@castle>
 <alpine.DEB.2.10.1710111247390.98307@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=D3Be+ANk5WgWy8kK/i0mu1oCnhx5vASBfalybm47lrk=;
 b=SB4liIBPAChFBSuRLR+MldaqqRZcxTH40w1IQBC6ktbiQqXEOk9hcHKvXlFeiyig9D6v
 wq2T/iw8bKdVkeZPL4Hhm7d6Cbh7DM93fD8VrCkw72/Qkl+D3cbThfdAU8sIjvEcEIDz
 znAKnKMjnCe0YLmoI/jBMVZUbqq3n0n5N3I= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=D3Be+ANk5WgWy8kK/i0mu1oCnhx5vASBfalybm47lrk=;
 b=MI4p+7S3u3PAVcHxhVjrQH2nQIf+3g2nId/dkuMp1tId7U0n6xK6zKJS7wQyvUKKppengQIj1JAdcU/5zyp9NNBFHZOO6Tww3KBz9s+RL7U882EyTKgjIglfXtN0g6z9Jxo57kebJ6jrpkBepulUs2UfuhNvzLSYX8GQXKYOvGA=
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1710111247390.98307-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Oct 11, 2017 at 01:21:47PM -0700, David Rientjes wrote:
> On Tue, 10 Oct 2017, Roman Gushchin wrote:
> 
> > > We don't need a better approximation, we need a fair comparison.  The 
> > > heuristic that this patchset is implementing is based on the usage of 
> > > individual mem cgroups.  For the root mem cgroup to be considered 
> > > eligible, we need to understand its usage.  That usage is _not_ what is 
> > > implemented by this patchset, which is the largest rss of a single 
> > > attached process.  This, in fact, is not an "approximation" at all.  In 
> > > the example of 10000 processes attached with 80MB rss each, the usage of 
> > > the root mem cgroup is _not_ 80MB.
> > 
> > It's hard to imagine a "healthy" setup with 10000 process in the root
> > memory cgroup, and even if we kill 1 process we will still have 9999
> > remaining process. I agree with you at some point, but it's not
> > a real world example.
> > 
> 
> It's an example that illustrates the problem with the unfair comparison 
> between the root mem cgroup and leaf mem cgroups.  It's unfair to compare 
> [largest rss of a single process attached to a cgroup] to
> [anon + unevictable + unreclaimable slab usage of a cgroup].  It's not an 
> approximation, as previously stated: the usage of the root mem cgroup is 
> not 100MB if there are 10 such processes attached to the root mem cgroup, 
> it's off by orders of magnitude.
> 
> For the root mem cgroup to be treated equally as a leaf mem cgroup as this 
> patchset proposes, it must have a fair comparison.  That can be done by 
> accounting memory to the root mem cgroup in the same way it is to leaf mem 
> cgroups.
> 
> But let's move the discussion forward to fix it.  To avoid necessarily 
> accounting memory to the root mem cgroup, have we considered if it is even 
> necessary to address the root mem cgroup?  For the users who opt-in to 
> this heuristic, would it be possible to discount the root mem cgroup from 
> the heuristic entirely so that oom kills originate from leaf mem cgroups?  
> Or, perhaps better, oom kill from non-memory.oom_group cgroups only if 
> the victim rss is greater than an eligible victim rss attached to the root 
> mem cgroup?

David, I'm not pretending for implementing the best possible accounting
for the root memory cgroup, and I'm sure there is a place for further
enhancement. But if it's not leading to some obviously stupid victim
selection (like ignoring leaking task, which consumes most of the memory),
I don't see why it should be treated as a blocker for the whole patchset.
I also doubt that any of us has these examples, and the best way to get
them is to get some real usage feedback.

Ignoring oom_score_adj, subtracting leaf usage sum from system usage etc,
these all are perfect ideas which can be implemented on top of this patchset.

> 
> > > For these reasons: unfair comparison of root mem cgroup usage to bias 
> > > against that mem cgroup from oom kill in system oom conditions, the 
> > > ability of users to completely evade the oom killer by attaching all 
> > > processes to child cgroups either purposefully or unpurposefully, and the 
> > > inability of userspace to effectively control oom victim selection:
> > > 
> > > Nacked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > 
> > So, if we'll sum the oom_score of tasks belonging to the root memory cgroup,
> > will it fix the problem?
> > 
> > It might have some drawbacks as well (especially around oom_score_adj),
> > but it's doable, if we'll ignore tasks which are not owners of their's mm struct.
> > 
> 
> You would be required to discount oom_score_adj because the heuristic 
> doesn't account for oom_score_adj when comparing the anon + unevictable + 
> unreclaimable slab of leaf mem cgroups.  This wouldn't result in the 
> correct victim selection in real-world scenarios where processes attached 
> to the root mem cgroup are vital to the system and not part of any user 
> job, i.e. they are important system daemons and the "activity manager" 
> responsible for orchestrating the cgroup hierarchy.
> 
> It's also still unfair because it now compares
> [sum of rss of processes attached to a cgroup] to
> [anon + unevictable + unreclaimable slab usage of a cgroup].  RSS isn't 
> going to be a solution, regardless if its one process or all processes, if 
> it's being compared to more types of memory in leaf cgroups.
> 
> If we really don't want root mem cgroup accounting so this is a fair 
> comparison, I think the heuristic needs to special case the root mem 
> cgroup either by discounting root oom kills if there are eligible oom 
> kills from leaf cgroups (the user would be opting-in to this behavior) or 
> comparing the badness of a victim from a leaf cgroup to the badness of a 
> victim from the root cgroup when deciding which to kill and allow the user 
> to protect root mem cgroup processes with oom_score_adj.
> 
> That aside, all of this has only addressed one of the three concerns with 
> the patchset.
> 
> I believe the solution to avoid allowing users to circumvent oom kill is 
> to account usage up the hierarchy as you have done in the past.  Cgroup 
> hierarchies can be managed by the user so they can create their own 
> subcontainers, this is nothing new, and I would hope that you wouldn't 
> limit your feature to only a very specific set of usecases.  That may be 
> your solution for the root mem cgroup itself: if the hierarchical usage of 
> all top-level mem cgroups is known, it's possible to find the root mem 
> cgroup usage by subtraction, you are using stats that are global vmstats 
> in your heuristic.
> 
> Accounting usage up the hierarchy avoids the first two concerns with the 
> patchset.  It allows you to implicitly understand the usage of the root 
> mem cgroup itself, and does not allow users to circumvent oom kill by 
> creating subcontainers, either purposefully or not.  The third concern, 
> userspace influence, can allow users to attack leaf mem cgroups deeper in 
> the tree if it is using more memory than expected, but the hierarchical 
> usage is lower at the top-level.  That is the only objection that I have 
> seen to using hierarchical usage: there may be a single cgroup deeper in 
> the tree that avoids oom kill because another hierarchy has a higher 
> usage.  This can trivially be addressed either by oom priorities or an 
> adjustment, just like oom_score_adj, on cgroup usage.

As I've said, I barely understand how the exact implementation of root memory
cgroup accounting is considered a blocker for the whole feature.
The same is true for oom priorities: it's something that can and should
be implemented on top of the basic semantics, introduced by this patchset.

So, the only real question is the way how we find a victim memcg in the
subtree: by performing independent election on each level or by searching
tree-wide. We all had many discussion around, and as you remember, initially
I was supporting the first option.
But then Michal provided a very strong argument:
if you have 3 similar workloads in A, B and C, but for non-memory-related
reasons (e.g. cpu time sharing) you have to join A and B into a group D:
  /\
 D  C
/ \
A B
it's strange to penalize A and B for it. It looks to me that you're
talking about the similar case, but you consider this hierarchy
useful. So, overall, it seems to be depending on exact configuration.

I have to add, that if you can enable memory.oom_group, your problem
doesn't exist.

The selected approach is easy extendable into hierarchical direction:
as I've said before, we can introduce a new value of memory.oom_group,
which will enable cumulative accounting without mass killing.

And, tbh, I don't see how oom_priorities will resolve an opposite
problem if we'd take the hierarchical approach.

Thanks!
