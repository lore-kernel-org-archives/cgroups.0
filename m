From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET for-4.11] cgroup: implement cgroup v2 thread mode
Date: Fri, 10 Feb 2017 10:45:08 -0500
Message-ID: <20170210154508.GA16097@mtj.duckdns.org>
References: <20170202200632.13992-1-tj@kernel.org>
 <20170203202048.GD6515@twins.programming.kicks-ass.net>
 <20170203205955.GA9886@mtj.duckdns.org>
 <20170206124943.GJ6515@twins.programming.kicks-ass.net>
 <20170208230819.GD25826@htj.duckdns.org>
 <20170209102909.GC6515@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UFJBjdGxwZ1fKVBuEmU8r1OdjfhCg9op/jGaM+utSDo=;
        b=V5MLQxyKsAycEjcdmzRp80IqBim/R9skPK387eBHTBBfaEANspVIBS3Ct9ReA1KmXi
         00GzjQga46Am0uYW7/dqy4VKaYb7w9NbBX+qrUaEOgEgOPWSlpNZQKNqSX9pqubxH1aI
         vmQAC0x4IQdvauXuOacb/YWZAd7EoHvBVCxq9TS+mudLPZOyyIR6Z7eLdagB12aYMLY0
         weKND3MQ6+Or3ydfyvzb2iOF/6YulURObaenC/630JMv2cFktBDK+PW9AvypVFzQ6TWL
         70VUOGm0aZiU3msq7A4rKPCjFWPLIxs04oYKGp18kncZRtiuOQiml0pehYQnr8WTQ8+t
         QHeA==
Content-Disposition: inline
In-Reply-To: <20170209102909.GC6515-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, lvenanci-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello,

On Thu, Feb 09, 2017 at 11:29:09AM +0100, Peter Zijlstra wrote:
> Uhm, no. They would see the exact same hierarchy, seeing how there is
> only one tree. They would have different view of it maybe, but I don't
> see how that matters, nor do you explain.

Sure, the base hierarchy is the same but different controllers would
need to see different subsets (or views) of the hierarchy.  As I wrote
before, cgroup v2 alredy does this to certain extent by controllers
ignoring the hierarchy beyond certain points.  You're proposing to add
a new "view" of the hierarchy.  I'll explain why it matters below.

> > which brings in something completely new to the basic hierarchy.
> 
> I'm failing to see what.
> 
> > Different controllers seeing differing levels of the same hierarchy is
> > part of the basic behaviors
> 
> I have no idea what you mean there.

It's explained in Documentation/cgroup-v2.txt but for example, if the
whole hierarchy is,

	A - B -C
	  \ D

One controller might only see

	A - B
	  \ D

while another sees the whole thing.

> > and making subtrees threaded is a
> > straight-forward extension of that - threaded controllers just see
> > further into the hierarchy.  Adding threaded sub-sections in the
> > middle is more complex and frankly confusing.
> 
> I disagree, as I completely fail to see any confusion. The rules are
> simple and straight forward.
> 
> I also don't see why you would want to impose this artificial
> restriction. It doesn't get you anything. Why are you so keen on designs
> with these artificial limits on?

Because I actually understand and use this thing day in and day out?

Let's go back to the no-internal-process constraint.  The main reason
behind that is avoiding resource competition between child cgroups and
processes.  The reason why we need this is because for some resources
the terminal consumer (be that a process or task or anonymous) and the
resource domain that it belongs to (be that the system itself or a
cgroup) aren't equivalent.

If you make a memcg, put some processes in it and then create some
child cgroups, how resource should be distributed between those
processes and child cgroups is not clearly defined and can't be
controlled from userspace.  The resource control knobs in a child
cgroup governs how the resource is distributed from the parent.  For
child processes, we don't have those knobs.

There are multiple ways to deal with the problem.  We can add a
separate set of control knobs to govern control resource consumption
from internal processes.  This effectively adds an implicit leaf node
to each cgroup so that internal processes or tasks always are in its
own leaf resource domain.  This however adds a lot of cruft to the
interface, the implementation gets nasty and the presented resource
hierarchy can be misleading to users.

Another option would be just letting each controller do whatever,
which is pretty much what we did in v1.  This got really bad because
the behaviors were widely inconsistent across controllers and often
implementation dependent without any way for the user to configure or
monitor what's going on.  Who gets how much becomes a matter of
accidents and people optimize for whatever arbitrary behaviors that
the kernel they're using is showing.

No-internal-process rule establishes that resource domains are always
terminal in the resource graph for a given controller, such that every
competition along the resource hiearchy always is clearly defined and
configurable.  Only the terminal resource domains actually host
resource consumptions and they can behave analogous to a system which
doesn't have any cgroups at all.  Estalishing resource domains this
way isn't the only approach to solve the problem; however, it is a
valid, simple and effective one.

Now, back to not allowing switching back and forth between resource
domains and thread subtrees.  Let's say we allow that and compose a
hierarchy as follows.  Let's say A and B are resource domains and T's
are subtrees of threads.

	A - T1 - B - T2

The resource domain controllers would see the following hierarchy.

	A - B

A will contain processes from T1 and B T2.  Both A and B would have
internal consumptions from the processes and the no-internal-process
constraint and thus resource domain abstraction are broken.  If we
want to support a hierarchy like that, we'll internally have to
something like

	A - B
	 \
	  A'

Where cgroup A' contains processes from T1 and B T2.  Now, this is
exactly the same problem as having internal processes and can be
solved in the same ways.  The only realistic way to handle this in a
generic and consistent manner is creating a leaf cgroup to contain the
processes.  We sure can try to hide this from userspace and convolute
the interface but it can be solved *far* more elegantly by simply
requiring thread subtrees to be leaf subtrees.

And here's another point, currently, all controllers are enabled
consecutively from root.  If we have leaf thread subtrees, this still
works fine.  Resource domain controllers won't be enabled into thread
subtrees.  If we allow switching back and forth, what do we do in the
middle while we're in the thread part?  No matter what we do, it's
gonna be more confusing and we lose basic invariants like "parent
always has superset of control knobs that its child has".

If we're gonna override the above points, we gotta gain something
really substantial.

> > Let's say we can make that work but what are the use cases which would
> > require such setup where we have to alternate between thread and
> > domain modes through out the resource hierarchy?
> 
> I would very much like to run my main workload in the root resource
> group. This means I need to have threaded subtrees at the root level.

But this is just a whim.  It isn't even a functional requirement.

> Your design would then mean I then cannot run a VM (which uses all these
> cgroups muck and needs its own resource domain) for some less
> critical/isolated workload.
> 
> Now, you'll argue I should set up a subtree for the main workload; but
> why would I do that? Why would you force me into making this choice;
> which has performance penalties associated (because the root resource
> domain is special cased in a bunch of places; and because the shallower
> the cgroup tree the less overhead etc.).

Because what you want costs a lot of complexity and significantly
worsens the interface.  "I just want to do it in the root" isn't a
valid justification.  As for the runtime overhead, if you get affected
by adding a top-level cgroup in any measureable way, we need to fix
that.  That's not a valid argument for messing up the interface.

> > This will be a
> > considerable departure and added complexity from the existing
> > behaviors and code.  We gotta be achieving something significant if
> > we're doing that.  Why would we want this?
> 
> How is this a departure? I do not understand.
> 
> Why would we not want to do this? Why would we want to impose artificial
> limitations. What specifically is hard about what I propose?
> 
> You have no actual arguments on why what I propose would be hard to
> implement. As far as I can tell it should be fairly similar in
> complexity to what you already proposed.

I hope it's explained now.

> > And here's another aspect.  The currently proposed interface doesn't
> > preclude adding the behavior you're describing in the future.  Once
> > thread mode is enabled on a subtree, it isn't allowed to be disabled
> > in its proper subtree; however, if there actually are use cases which
> > require flipping it back, we can later implemnt the behavior and lift
> > that restriction.  I think it makes sense to start with a simple
> > model.
> 
> Your choice of flag makes it impossible to tell what is a resource
> domain and what is not in that situation.
> 
> Suppose I set the root group threaded and I create subgroups (which will
> also all have threaded set). Suppose I clear the threaded bit somewhere
> in the subtree to create a new resource group, but then immediately set
> the threaded bit again to allow that resource group to have thread
> subgroups as well. Now the entire hierarchy will have the threaded flag
> set and it becomes impossible to find the resource domains.
> 
> This is all a direct consequence of your flag not denoting the primary
> construct; eg. resource domains.

Even if we allow switching back and forth, we can't make the same
cgroup both resource domain && thread root.  Not in a sane way at
least.

> IOW; you've completely failed to convince me and my NAK stands.

You have a narrow view from a single component and has been openly
claiming and demonstrating to be not using, disinterested and
uninformed on cgroup.  It's unfortunate and bullshit that the whole
thing is blocked on your NAK, especially when the part you're holding
hostage is something a lot of users want and won't change no matter
what we do about threads.

-- 
tejun
