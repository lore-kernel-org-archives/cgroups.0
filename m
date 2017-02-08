From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET for-4.11] cgroup: implement cgroup v2 thread mode
Date: Wed, 8 Feb 2017 18:08:19 -0500
Message-ID: <20170208230819.GD25826@htj.duckdns.org>
References: <20170202200632.13992-1-tj@kernel.org>
 <20170203202048.GD6515@twins.programming.kicks-ass.net>
 <20170203205955.GA9886@mtj.duckdns.org>
 <20170206124943.GJ6515@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=G5PJeJxqlStZoQFdy2xVLBQWxX7PR9uuMS1oW3dlGyI=;
        b=ZK91Ne6WkS/s87Ypv2zZn7OX9wECrpWVumgAXLIbdD/HxeCtV2ANI/GTq9uy5TxpTD
         2zSu2c0msbeg67AruaYEEognWBsVU0DMjTEiFYn9zpl/3FBVk83h7Yaln7OzEUkUEyT3
         fcZ59oibHs8QYSgaoiiE4IRM7wWpDTerkst+t2lo17DIEx+joGxlnilreIHbIGb4oOa0
         8sEJvX+qcBvP2fGyHfGFGUK4JHg02kE54V4c+XUVC8QGt5u3itbC6ojX+kgp0TJgzEno
         Od9Pf87LKnLDYM8gxAyFpl0CQoD4GMPjypNBGe2RDZZh6+ADcwOQsHCZ+8bJeJJbBEyK
         EIyA==
Content-Disposition: inline
In-Reply-To: <20170206124943.GJ6515-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, lvenanci-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

(cc'ing Linus and Andrew for visibility)

Hello, Peter.

On Mon, Feb 06, 2017 at 01:49:43PM +0100, Peter Zijlstra wrote:
> But to me the resource domain is your primary new construct; so it makes
> more sense to explicitly mark that.

Whether it's new or not isn't the point.  Resource domains weren't
added arbitrarily.  We were missing critical resource accounting and
control capabilities because cgroup v1's abstraction wasn't strong
enough to cover some of the major resource consumers and how different
resources can interact with each other.

Resource domains were added to address that.  Given that cgroup's
primary goal is providing resource accounting and control, it doesn't
make sense to make this optional.

> (FWIW note that your whole initial cgroup-v2 thing is counter intuitive
> to me, as someone who has only ever dealt with thread capable
> controllers.)

That is completely fine but you can't direct the overall design while
claiming to be not using, disinterested and unfamiliar with the
subject at hand.  I do understand that you have certain use cases that
you think should be covered.  Let's focus on that.

> My question was, if you have root.threads=1, can you then still create
> (sub) resource domains? Can I create a child cgroup and clear "threads"
> again?
>
> (I'm assuming "threads" is inherited when creating new groups).
> 
> Now, _if_ we can do the above, then "threads" is not sufficient to
> uniquely identify resource domains, which I think was your point in the
> other email. Which argues against the interface. Because a group can be
> a resource domain _and_ have threads sub-trees.
>
> OTOH, if you can _not_ do this, then this proposal is
> insufficient/inadequate.

No, you can't flip it back and I'm not convinced this matters.  More
on this below.

> > In practice, how would this work?  To enable memcg, the user has to
> > first create the subtree and then explicitly have to make that a
> > domain and then enable memcg?  If so, that would be a completely
> > unnecessary deviation from the current behavior while not achieving
> > any more functionalities, right?  It's just flipping the default value
> > the other way around and the default wouldn't be supported by many of
> > the controllers.  I can't see how that is a better option.
> 
> OK, so I'm entirely unaware of this enabling of controllers. What's that
> about? I thought the whole point of cgroup-v2 was to have all
> controllers enabled over the entire tree, this is not so?

This is one of the most basic aspects of cgroup v2.  In short, while
the controllers share the hierarchy, each doesn't have to be enabled
all the way down to the leaf.  Different controllers can see upto
different subsets of the hierarchy spreading out from the root.

> In any case, yes, more or less like that, except of course, not at all
> :-) If we make this flag inherited (which I think it should be), you
> don't need to do anything different from today, because the root group
> must be a resource domain, any new sub-group will automagically also be.
> 
> Only once you clear the flag somewhere do you get 'new' behaviour. Note
> that the only extra constraint is that all threads of a process must
> stay within the same resource domain, anything else goes.
> 
> Task based controllers operate on the actual cgroup, resource domain
> controllers always map it back to the resource group. Finding a random
> task's resource domain is trivial; simply walk up the hierarchy until
> you find a group with the flag set. 
> 
> So, just to recap, my proposal is as follows:
> 
>  1) each cgroup will have a new flag, indicating if this is a resource
>     domain.
> 
>     a) this flag will be inherited; when creating a new cgroup, the
>        state of the flag will be set to the value of the parent cgroup.
> 
>     b) the root cgroup is a resource domain per definition, will
>        have it set (cannot be cleared).
> 
>  2) all tasks of a process shall be part of the same resource domain
> 
>  3) controllers come in two types:
> 
>     a) task based controllers; these use the direct cgroup the task
>        is assigned to.
> 
>     b) resource controllers; these use the effective resource group
>        of the task, which is the first parent group with our new
>        flag set.
> 
> 
> With an optional:
> 
>  1c) this flag can only be changed on empty groups
> 
> to ease implementation.
> 
> From these rules it follows that:
> 
> - 1a and 1b together ensure no change in behaviour per default
>   for cgroup-v2.
> 
> - 2 and 3a together ensure resource groups automagically work for task
>   based controllers (under the assumption that the controller is
>   strictly hierarchical).
> 
> For example, cpuacct does the accounting strictly hierarchical, it adds
> the cpu usage to each parent group. Therefore the total cpu usage
> accounted to the resource group is the same as if all tasks were part of
> that group.

So, what you're proposing isn't that different from what the posted
patches implement except that what's implemented doesn't allow
flipping a part of a threaded subtree back to domain mode.

Your proposal is more complicated while seemingly not adding much to
what can be achieved.  The orignal proposal is very simple.  It allows
declaring a subtree to be threaded (or task based) and that's it.  A
threaded subtree can't have resource domains under it.

The only addition that your proposal has is the ability to mark
portions of such subtree to be domains again.  This would require
making domain controllers and thread controllers to see different
hierarchies, which brings in something completely new to the basic
hierarchy.

Different controllers seeing differing levels of the same hierarchy is
part of the basic behaviors and making subtrees threaded is a
straight-forward extension of that - threaded controllers just see
further into the hierarchy.  Adding threaded sub-sections in the
middle is more complex and frankly confusing.

Let's say we can make that work but what are the use cases which would
require such setup where we have to alternate between thread and
domain modes through out the resource hierarchy?  This will be a
considerable departure and added complexity from the existing
behaviors and code.  We gotta be achieving something significant if
we're doing that.  Why would we want this?

And here's another aspect.  The currently proposed interface doesn't
preclude adding the behavior you're describing in the future.  Once
thread mode is enabled on a subtree, it isn't allowed to be disabled
in its proper subtree; however, if there actually are use cases which
require flipping it back, we can later implemnt the behavior and lift
that restriction.  I think it makes sense to start with a simple
model.

Thanks.

-- 
tejun
