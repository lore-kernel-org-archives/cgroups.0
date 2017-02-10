From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCHSET for-4.11] cgroup: implement cgroup v2 thread mode
Date: Fri, 10 Feb 2017 18:51:45 +0100
Message-ID: <20170210175145.GJ6515@twins.programming.kicks-ass.net>
References: <20170202200632.13992-1-tj@kernel.org>
 <20170203202048.GD6515@twins.programming.kicks-ass.net>
 <20170203205955.GA9886@mtj.duckdns.org>
 <20170206124943.GJ6515@twins.programming.kicks-ass.net>
 <20170208230819.GD25826@htj.duckdns.org>
 <20170209102909.GC6515@twins.programming.kicks-ass.net>
 <20170210154508.GA16097@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bG96YuLJPWn+Yv4POuhywm+RycGWWa3Bx0sckBNjE70=; b=oHHdxLR/CDCRZS9CNhrCkwWxy
        KXSQwPLws9cjzqwPksGhW8gPBQU3Sjzw6tqjJnHdgdX9DWgXaxXBdHzIFIKu26O/ot2zAawWvXzMA
        /kJLHwmM3mupevKaX1cbkVfZ6VLPvFhx65xAiMPt9B2HJYXYmlkow3HpnBRtgdBaT5KOMR/xZmrLS
        69bwT0+mCSpAXaCrAP1jXk9psWLpu1EG4QYVpJoUkWYJWlRvoa8fjm6IIWcGpyFKZ7S7mxkd5jIdy
        wa120PoF40iv6wEBjBmMg9Zd1kzHqneXDR/X+uOx3mZ7xYaSWc+RKNepgvC9bt+54wy6DyqvAcyYu
      
Content-Disposition: inline
In-Reply-To: <20170210154508.GA16097-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, lvenanci-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Fri, Feb 10, 2017 at 10:45:08AM -0500, Tejun Heo wrote:

> > > and making subtrees threaded is a
> > > straight-forward extension of that - threaded controllers just see
> > > further into the hierarchy.  Adding threaded sub-sections in the
> > > middle is more complex and frankly confusing.
> > 
> > I disagree, as I completely fail to see any confusion. The rules are
> > simple and straight forward.
> > 
> > I also don't see why you would want to impose this artificial
> > restriction. It doesn't get you anything. Why are you so keen on designs
> > with these artificial limits on?
> 
> Because I actually understand and use this thing day in and day out?

Just because you don't have the use-cases doesn't mean they're invalid.

Also, the above is effectively: "because I say so", which isn't much of
an argument.

> Let's go back to the no-internal-process constraint.  The main reason
> behind that is avoiding resource competition between child cgroups and
> processes.  The reason why we need this is because for some resources
> the terminal consumer (be that a process or task or anonymous) and the
> resource domain that it belongs to (be that the system itself or a
> cgroup) aren't equivalent.

Sure, we're past that. This isn't about what memcg can or cannot do.
Previous discussions established that controllers come in two shapes:

 - task based controllers; these are build on per task properties and
   groups are aggregates over sets of tasks. Since per definition inter
   task competition is already defined on individual tasks, its fairly
   trivial to extend the same rules to sets of tasks etc..

   Examples: cpu, cpuset, cpuacct, perf, pid, (freezer)

 - system controllers; instead of building from tasks upwards, they
   split what previously would be machine wide / global state. For these
   there is no natural competition rule vs tasks, and hence your
   no-internal-task rule.

   Examples: memcg, io, hugetlb

(I have no idea where: devices, net_cls, net_prio, debug fall in this
classification, nor is that really relevant)

Now, cgroup-v2 is entirely build around the use-case of
containerization, where you want a single hierarchy describing the
containers and their resources. Now, because of that single hierarchy
and single use-case, you let the system controllers dominate and dictate
the rules.

By doing that you've completely killed off a whole bunch of use-cases
that were possible with pure task controllers. And you seen to have a
very hard time accepting that this is a problem.

Furthermore, the argument that people who need that can continue to use
v1 doesn't work. Because v2 and v1 are mutually exclusive and do not
respect the namespace/container invariant. That is, if a controller is
used in v2, a sub-container is forced to also use v2.

Therefore it is important to fix v2 if possible or do v3 if not, such
that all use-cases can be met in a single setup that respects the
container invariant.

> Now, back to not allowing switching back and forth between resource
> domains and thread subtrees.  Let's say we allow that and compose a
> hierarchy as follows.  Let's say A and B are resource domains and T's
> are subtrees of threads.
> 
> 	A - T1 - B - T2
> 
> The resource domain controllers would see the following hierarchy.
> 
> 	A - B
> 
> A will contain processes from T1 and B T2.  Both A and B would have
> internal consumptions from the processes and the no-internal-process
> constraint and thus resource domain abstraction are broken.

> If we want to support a hierarchy like that, we'll internally have to
> something like
> 
> 	A - B
> 	 \
> 	  A'

Because, and it took me a little while to get here, this:

		A
              /   \
	     T1	  t1
	    / \
	   t2  B
	      / \
	     t3  T2
	         /\
		t4 t5


Ends up being this from a resource domain pov. (because the task
controllers are hierarchical their effective contribution collapses onto
the resource domain):

		A
	      /   \
	     B	   t1, t2
	     |
	     t3,t4,t5


> Now, this is exactly the same problem as having internal processes

Indeed, bugger.

> And here's another point, currently, all controllers are enabled
> consecutively from root.  If we have leaf thread subtrees, this still
> works fine.  Resource domain controllers won't be enabled into thread
> subtrees.  If we allow switching back and forth, what do we do in the
> middle while we're in the thread part?

From what I understand you cannot re-enable a controller once its been
disabled, right? If you disable it, its dead for the entire subtree.

I think it would work naturally if you only allow disabling system
controllers at the resource domain levels (thread controllers can be
disabled at any point).

That means that thread nodes will have the exact same system controllers
enabled as their resource domain, which makes perfect sense, since all
tasks in the thread nodes are effectively mapped into the resource
domain for system controllers.

That is:

	A (cpu, memory)
        |
	T (memory)

is a perfectly valid setup, since all tasks under T will still use the
memory setup of A.

> No matter what we do, it's
> gonna be more confusing and we lose basic invariants like "parent
> always has superset of control knobs that its child has".

No, exactly that. I don't think I ever proposed something different.

The "resource domain" flag I proposed violates the no-internal-processes
thing, but it doesn't violate that rule afaict.

> > > Let's say we can make that work but what are the use cases which would
> > > require such setup where we have to alternate between thread and
> > > domain modes through out the resource hierarchy?
> > 
> > I would very much like to run my main workload in the root resource
> > group. This means I need to have threaded subtrees at the root level.
> 
> But this is just a whim.  It isn't even a functional requirement.

You're always so very quick to dismiss use-cases :/ Or do I read this
that performance is not a functional requirement?

(don't bite, I know you don't mean that)

Sure, I had not seen that I violated the no internal processes rule in
the resource domain view; equally you had not made it very clear either.

> As for the runtime overhead, if you get affected by adding a top-level
> cgroup in any measureable way, we need to fix that.  That's not a
> valid argument for messing up the interface.

I think cgroup tree depth is a more significant issue; because of
hierarchy we often do tree walks (uo-to-root or down-to-task).

So creating elaborate trees is something I try not to do.

> > You have no actual arguments on why what I propose would be hard to
> > implement. As far as I can tell it should be fairly similar in
> > complexity to what you already proposed.
> 
> I hope it's explained now.

I think I got there..

> > > And here's another aspect.  The currently proposed interface doesn't
> > > preclude adding the behavior you're describing in the future.  Once
> > > thread mode is enabled on a subtree, it isn't allowed to be disabled
> > > in its proper subtree; however, if there actually are use cases which
> > > require flipping it back, we can later implemnt the behavior and lift
> > > that restriction.  I think it makes sense to start with a simple
> > > model.
> > 
> > Your choice of flag makes it impossible to tell what is a resource
> > domain and what is not in that situation.
> > 
> > Suppose I set the root group threaded and I create subgroups (which will
> > also all have threaded set). Suppose I clear the threaded bit somewhere
> > in the subtree to create a new resource group, but then immediately set
> > the threaded bit again to allow that resource group to have thread
> > subgroups as well. Now the entire hierarchy will have the threaded flag
> > set and it becomes impossible to find the resource domains.
> > 
> > This is all a direct consequence of your flag not denoting the primary
> > construct; eg. resource domains.
> 
> Even if we allow switching back and forth, we can't make the same
> cgroup both resource domain && thread root.  Not in a sane way at
> least.

The back and forth thing yes, but even with a single level, the one
resource domain you tag will be both resource domain and thread root.

> > IOW; you've completely failed to convince me and my NAK stands.
> 
> You have a narrow view from a single component and has been openly
> claiming and demonstrating to be not using, disinterested and
> uninformed on cgroup.

I use a narrow set of cgroup-v1 capabilities not present in v2. You've
been very aggressively dismissing and ignoring those for a long time.
Given that, why should I be interested in v2?

> It's unfortunate and bullshit that the whole thing is blocked on your
> NAK, especially when the part you're holding hostage is something a
> lot of users want and won't change no matter what we do about threads.

I understand your frustration, I have plenty of my own, see the
paragraph above. Then again, I'm glad you're now more open discuss these
things.

I don't see it as a given that things will not change until the threads
situation is solved. Call me a pessimist if you will, but I want to see
a full picture first.

In any case, let me ponder these new insights for a bit.
