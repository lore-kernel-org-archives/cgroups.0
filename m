From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Fri, 22 Sep 2017 08:44:27 -0700
Message-ID: <20170922154426.GF828415@devbig577.frc2.facebook.com>
References: <20170911131742.16482-1-guro@fb.com>
 <alpine.DEB.2.10.1709111334210.102819@chino.kir.corp.google.com>
 <20170921142107.GA20109@cmpxchg.org>
 <alpine.DEB.2.10.1709211357520.60945@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=weOcwXlouFzezN9Ar0xFJCh5dt3SaOWm9q9LUmdKays=;
        b=XsIbbKJ+7H6PVhm0nFpghJF97xFVLs6hax814+T9BXJbf47ZiEktxxeOHV3QQELokv
         pv+0pRyugyh7YAcgaCkIig9tnq8xbRdqnIQgvviEWULpAHvRLm4tF0RaaKr0ZI41axhJ
         BMiZiycIIBTZK9OQ1AQYJgwhZUQglX+hNanWtVttehV3ZvGZytnbKMwJuicOxXMQDeol
         v8K5l7QxjgthmbU0xAOaR8KqgG+Yi2xdoA2JCeBCmi5T9rjYzI2lZclcULXY4nyVPdG3
         vJCRzQvee/3zPjXO5aeOxuEdG+J+8OSFpeItQwYzhSqoxojqxMvlgtSsyUg0rXU7zge9
         uFBg==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1709211357520.60945-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, David.

On Thu, Sep 21, 2017 at 02:17:25PM -0700, David Rientjes wrote:
> It doesn't have anything to do with my particular usecase, but rather the 
> ability of userspace to influence the decisions of the kernel.  Previous 
> to this patchset, when selection is done based on process size, userspace 
> has full control over selection.  After this patchset, userspace has no 
> control other than setting all processes to be oom disabled if the largest 
> memory consumer is to be protected.  Roman's memory.oom_priority provides 
> a perfect solution for userspace to be able to influence this decision 
> making and causes no change in behavior for users who choose not to tune 
> memory.oom_priority.  The nack originates from the general need for 
> userspace influence over oom victim selection and to avoid userspace 
> needing to take the rather drastic measure of setting all processes to be 
> oom disabled to prevent oom kill in kernels before oom priorities are 
> introduced.

Overall, I think that OOM killing is the wrong place to implement
sophisticated intelligence in.  It's too late to be smart - the
workload already has suffered significantly and there's only very
limited amount of computing which can be performed.  That said, if
there's a useful and general enough mechanism to configure OOM killer
behavior from userland, that can definitely be useful.

> The patchset compares memory cgroup size relative to sibling cgroups only, 
> the same comparison for memory.oom_priority.  There is a guarantee 
> provided on how cgroup size is compared in select_victim_memcg(), it 
> hierarchically accumulates the "size" from leaf nodes up to the root memcg 
> and then iterates the tree comparing sizes between sibling cgroups to 
> choose a victim memcg.  That algorithm could be more elaborately described 
> in the documentation, but we simply cannot change the implementation of 
> select_victim_memcg() later even without oom priorities since users cannot 
> get inconsistent results after opting into a feature between kernel 
> versions.  I believe the selection criteria should be implemented to be 
> deterministic, as select_victim_memcg() does, and the documentation should 
> fully describe what the selection criteria is, and then allow the user to 
> decide.

We even change the whole scheduling behaviors and try really hard to
not get locked into specific implementation details which exclude
future improvements.  Guaranteeing OOM killing selection would be
crazy.  Why would we prevent ourselves from doing things better in the
future?  We aren't talking about the semantics of read(2) here.  This
is a kernel emergency mechanism to avoid deadlock at the last moment.

> Roman is planning on introducing memory.oom_priority back into the 
> patchset per https://marc.info/?l=linux-kernel&m=150574701126877 and I 
> agree with the very clear semantic that it introduces: to have the 
> size-based comparison use the same rules as the userspace priority 
> comparison.  It's very powerful and I'm happy to ack the final version 
> that he plans on posting.

To me, the proposed oom_priority mechanism seems too limited and makes
the error of tightly coupling the hierarchical behavior of resource
distribution with OOM victim selection.  They can be related but are
not the same and coupling them together in the kernel interface is
likely a mistake which will lead to long term pains that we can't
easily get out of.

Here's a really simple use case.  Imagine a system which hosts two
containers of services and one is somewhat favored over the other and
wants to set up cgroup hierarchy so that resources are split at the
top level between the two containers.  oom_priority is set accordingly
too.  Let's say a low priority maintenance job in higher priority
container goes berserk, as they oftne do, and pushing the system into
OOM.

With the proposed static oom_priority mechanism, the only
configuration which can be expressed is "kill all of the lower top
level subtree before any of the higher one", which is a silly
restriction leading to silly behavior and a direct result of
conflating resource distribution network with level-by-level OOM
killing decsion.

If we want to allow users to steer OOM killing, I suspect that it
should be aligned at delegation boundaries rather than on cgroup
hierarchy itself.  We can discuss that but it is a separate
discussion.

The mechanism being proposed is fundamentally flawed.  You can't push
that in by nacking other improvements.

Thanks.

-- 
tejun
