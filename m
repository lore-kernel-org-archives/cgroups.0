From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET for-4.11] cgroup: implement cgroup v2 thread mode
Date: Mon, 13 Mar 2017 16:05:44 -0400
Message-ID: <20170313200544.GE15709@htj.duckdns.org>
References: <20170202200632.13992-1-tj@kernel.org>
 <20170203202048.GD6515@twins.programming.kicks-ass.net>
 <20170203205955.GA9886@mtj.duckdns.org>
 <20170206124943.GJ6515@twins.programming.kicks-ass.net>
 <20170208230819.GD25826@htj.duckdns.org>
 <20170209102909.GC6515@twins.programming.kicks-ass.net>
 <20170210154508.GA16097@mtj.duckdns.org>
 <20170210175145.GJ6515@twins.programming.kicks-ass.net>
 <20170212050544.GJ29323@mtj.duckdns.org>
 <20170214103541.GS6515@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZXTusKjnYIU4y9nm/DbtbkC64yuuHtgbbqjlY0p6fms=;
        b=DXOPfJjjw2nMx6krWLPqaroKwM2XvuC6VDrGMCMJX64B6U3MYrDZywoM5dusvTXWMc
         SbGlx9gjZyHK0uyi9Hw5rnz2WYcGPVvy5M29pzRiD1aoNDArxq9Q7gOxklOo5y3Fhrbi
         +3qk2HdorpHvUYDJYOWvp41XZD/MiXb2+fTkyAYt5fL97bXpDLxFzq14hHWBMUnrlS7R
         krCpTWzdyED5lZuZii9jji+duDYAdUEDwDrAMbpRE28fPZKuieR4V6shsG4Lr0XHGLRj
         T5Pp4O7x5BRHkFSKbV+FHjUSZhMhdWOX4V1yBkxVEUBpg6lk/DQsr60cla0IgLKQOeTJ
         tvFA==
Content-Disposition: inline
In-Reply-To: <20170214103541.GS6515-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, lvenanci-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hey, Peter.  Sorry about the long delay.

On Tue, Feb 14, 2017 at 11:35:41AM +0100, Peter Zijlstra wrote:
> > This is a bit of delta but as I wrote before, at least cpu (and
> > accordingly cpuacct) won't stay purely task-based as we should account
> > for resource consumptions which aren't tied to specific tasks to the
> > matching domain (e.g. CPU consumption during writeback, disk
> > encryption or CPU cycles spent to receive packets).
> 
> We should probably do that in another thread, but I'd probably insist on
> separate controllers that co-operate to get that done.

Let's shelve this for now.

> > cgroups on creation don't enable controllers by default and users can
> > enable and disable controllers dynamically as long as the conditions
> > are met.  So, they can be disable and re-enabled.
> 
> I was talking in a hierarchical sense, your section 2-4-2. Top-Down
> constraint seems to state similar things to what I meant.
> 
> Once you disable a controller it cannot be re-enabled in a subtree.

Ah, yeah, you can't jump across parts of the tree.

> > If we go to thread mode and back to domain mode, the control knobs for
> > domain controllers don't make sense on the thread part of the tree and
> > they won't have cgroup_subsys_state to correspond to either.  For
> > example,
> > 
> >  A - T - B
> > 
> > B's memcg knobs would control memory distribution from A and cgroups
> > in T can't have memcg knobs.  It'd be weird to indicate that memcg is
> > enabled in those cgroups too.
> 
> But memcg _is_ enabled for T. All the tasks are mapped onto A for
> purpose of the system controller (memcg) and are subject to its
> constraints.

Sure, T is contained in A but think about the interface.  For memcg, T
belongs to A.  B is the first descendant when viewed from memcg, which
brings about two problems - memcg doesn't have control knobs to assign
throughout T which is just weird and there's no way to configure how T
competes against B.

> > We can make it work somehow.  It's just weird-ass interface.
> 
> You could make these control files (read-only?) symlinks back to A's
> actual control files. To more explicitly show this.

But the knobs are supposed to control how much resource a child gets
from its parent.  Flipping that over while walking down the same tree
sounds horribly ugly and confusing to me.  Besides, that doesn't solve
the problem with lacking the ability configure T's consumptions
against B.

> > So, as long as the depth stays reasonable (single digit or lower),
> > what we try to do is keeping tree traversal operations aggregated or
> > located on slow paths. 
> 
> While at the same time you allowed that BPF cgroup thing to not be
> hierarchical because iterating the tree was too expensive; or did I
> misunderstand?

That was more because that was supposed to be part of bpf (network or
whatever) and just followed the model of table matching "is the target
under this hierarchy?".  That's where it came from after all.
Hierarchical walking can be added but it's more work (defining the
iteration direction and rules) and doesn't bring benefits without
working delegation.

If it were a cgroup controller, it should have been fully hierarchical
no matter what but that involves solving bpf delegation first.

> Also, I think Mike showed you the pain and hurt are quite visible for
> even a few levels.
> 
> Batching is tricky, you need to somehow bound the error function in
> order to not become too big a factor on behaviour. Esp. for cpu, cpuacct
> obviously doesn't care much as it doesn't enforce anything.

Yeah, I thought about this for quite a while but I couldn't think of
any easy way of circumventing overhead without introducing a lot of
scheduling artifacts (e.g. multiplying down the weights to practically
collapse multi levels of the hierarchy), at least for the weight based
control which what most people use.  It looks like the only way to
lower the overhead there is making generic scheduling cheaper but that
still means that multi-level will always be noticeably more expensive
in terms of raw schceduling performance.

Scheduling hackbench is an extreme case tho and in practice at least
we're not seeing noticeable issues with a few levels of nesting when
the workload actually spends cpu cycles doing things other than
scheduling.  However, we're seeing significant increase in scheduling
latency coming from how cgroups are handled from the rebalance path.
I'm still looking into it and will write about that in a separate
thread.

> > In general, I think it's important to ensure that this in general is
> > the case so that users can use the logical layouts matching the actual
> > resource hierarchy rather than having to twist the layout for
> > optimization.
> 
> One does what one can.. But it is important to understand the
> constraints, nothing comes for free.

Yeah, for sure.

> Also, there is the one giant wart in v2 wrt no-internal-processes;
> namely the root group is allowed to have them.
> 
> Now I understand why this is so; so don't feel compelled to explain that
> again, but it does make the model very ugly and has a real problem, see
> below. OTOH, since it is there, I would very much like to make use of
> this 'feature' and allow a thread-group on the root group.
> 
> And since you then _can_ have nested thread groups, it again becomes
> very important to be able to find the resource domains, which brings me
> back to my proposal; albeit with an addition constraint.

I've thought quite a bit about ways to allow thread granularity from
the top while still presenting a consistent picture to resource domain
controllers.  That's what's missing from the CPU controller side given
Mike's claim that there's unavoidable overhead in nesting CPU
controller and requiring at least one level of nesting on cgroup v2
for thread granularity might not be acceptable.

Going back to why thread support on cgroup v2 was needed in the first
place, it was to allow thread level control while cooperating with
other controllers on v2.  IOW, allowing thread level control for CPU
while cooperating with resource domain type controllers.

Now, going back to allowing thread hierarchies from the root, given
that their resource domain can only be root, which is exactly what you
get when CPU is mounted on a separate hierarchy, it seems kinda moot.
The practical constraint with the current scheme is that in cases
where other resource domain controllers need to be used, the thread
hierarchies would have to be nested at least one level, but if you
don't want any resource domain things, that's the same as mounting the
controller separately.

> Now on to the problem of the no-internal-processes wart; how does
> cgroup-v2 currently implement the whole container invariant? Because by
> that invariant, a container's 'root' group must also allow
> internal-processes.

I'm not sure I follow the question here.  What's the "whole container
invariant"?

Thanks.

-- 
tejun
