From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCHSET for-4.11] cgroup: implement cgroup v2 thread mode
Date: Mon, 6 Feb 2017 13:49:43 +0100
Message-ID: <20170206124943.GJ6515@twins.programming.kicks-ass.net>
References: <20170202200632.13992-1-tj@kernel.org>
 <20170203202048.GD6515@twins.programming.kicks-ass.net>
 <20170203205955.GA9886@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170203205955.GA9886-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, lvenanci-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Fri, Feb 03, 2017 at 03:59:55PM -0500, Tejun Heo wrote:
> Hello, Peter.
> 
> On Fri, Feb 03, 2017 at 09:20:48PM +0100, Peter Zijlstra wrote:
> > So my proposal was to do the inverse of what you propose here. Instead
> > of marking special 'thread' subtrees, explicitly mark resource domains
> > in the tree.
> > 
> > So always allow arbitrary hierarchies and allow threads to be assigned
> > to cgroups, as long as they're all in the same resource domain.
> > 
> > Controllers that do not support things, fallback to mapping everything
> > to the nearest resource domain.
> 
> That sounds counter-intuitive as all controllers can do resource
> domains and only a subset of them can do thread mode.

But to me the resource domain is your primary new construct; so it makes
more sense to explicitly mark that.

(FWIW note that your whole initial cgroup-v2 thing is counter intuitive
to me, as someone who has only ever dealt with thread capable
controllers.)

> Also, thread subtrees are necessarily a sub-hierarchy of a resource domain.

Sure, don't see how that is relevant though. Or rather, I don't see it
being an argument one way or the other.

> Also,
> expanding resource domains from the root after the trees are populated
> would make the behaviors surprising as the resource domains that these
> subtrees belong to would change dynamically.

Uh what? I cannot parse that.

My question was, if you have root.threads=1, can you then still create
(sub) resource domains? Can I create a child cgroup and clear "threads"
again?

(I'm assuming "threads" is inherited when creating new groups).

Now, _if_ we can do the above, then "threads" is not sufficient to
uniquely identify resource domains, which I think was your point in the
other email. Which argues against the interface. Because a group can be
a resource domain _and_ have threads sub-trees.

OTOH, if you can _not_ do this, then this proposal is
insufficient/inadequate.

> In practice, how would this work?  To enable memcg, the user has to
> first create the subtree and then explicitly have to make that a
> domain and then enable memcg?  If so, that would be a completely
> unnecessary deviation from the current behavior while not achieving
> any more functionalities, right?  It's just flipping the default value
> the other way around and the default wouldn't be supported by many of
> the controllers.  I can't see how that is a better option.

OK, so I'm entirely unaware of this enabling of controllers. What's that
about? I thought the whole point of cgroup-v2 was to have all
controllers enabled over the entire tree, this is not so?

In any case, yes, more or less like that, except of course, not at all
:-) If we make this flag inherited (which I think it should be), you
don't need to do anything different from today, because the root group
must be a resource domain, any new sub-group will automagically also be.

Only once you clear the flag somewhere do you get 'new' behaviour. Note
that the only extra constraint is that all threads of a process must
stay within the same resource domain, anything else goes.

Task based controllers operate on the actual cgroup, resource domain
controllers always map it back to the resource group. Finding a random
task's resource domain is trivial; simply walk up the hierarchy until
you find a group with the flag set. 



So, just to recap, my proposal is as follows:

 1) each cgroup will have a new flag, indicating if this is a resource
    domain.

    a) this flag will be inherited; when creating a new cgroup, the
       state of the flag will be set to the value of the parent cgroup.

    b) the root cgroup is a resource domain per definition, will
       have it set (cannot be cleared).

 2) all tasks of a process shall be part of the same resource domain

 3) controllers come in two types:

    a) task based controllers; these use the direct cgroup the task
       is assigned to.

    b) resource controllers; these use the effective resource group
       of the task, which is the first parent group with our new
       flag set.


With an optional:

 1c) this flag can only be changed on empty groups

to ease implementation.



From these rules it follows that:

- 1a and 1b together ensure no change in behaviour per default
  for cgroup-v2.

- 2 and 3a together ensure resource groups automagically work for task
  based controllers (under the assumption that the controller is
  strictly hierarchical).


For example, cpuacct does the accounting strictly hierarchical, it adds
the cpu usage to each parent group. Therefore the total cpu usage
accounted to the resource group is the same as if all tasks were part of
that group.
