From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET for-4.13] cgroup: implement cgroup2 thread mode, v2
Date: Fri, 30 Jun 2017 09:23:24 -0400
Message-ID: <20170630132324.GA18669@htj.duckdns.org>
References: <20170610140351.10703-1-tj@kernel.org>
 <20170612123150.scopfxela7v26dct@hirez.programming.kicks-ass.net>
 <20170612212753.GN19206@htj.duckdns.org>
 <20170627070143.GB4114@worktop>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XhW3L+Z2kFpxhWmPQ8SIiF+oK9/JUk9NsigyiAqBQuM=;
        b=N/JGq+DuniQEWbTdEQXWYG9ye/3dHr01ZVbNae4P+z2jGbvpblARRZ85chxXUJA5if
         MX+HfZznAJMgw+idH6kFxT9+SwX7NszC3A7wlH8H8krDUke0exG/8WlZqgqWNLEfqkLs
         AnBs7A45UL3efXJ3Ps491+roxBHDJVu6z8DP7ddh5yCMCM7e28L7rYFNYMlCDWbULyIC
         ZrCedOkkEUDzXMyCpI2Ie/4CsbvkbEgEBNlrVJ+HCyKcvYMzSf+z6MxcDCGc9X6tpDT9
         oE414hdrjFbNM6gWlSe+C8CEydyHw5p1MC8GaENjTw1v+N0scYoVLDnWbAOey/MfVgJw
         Sy9A==
Content-Disposition: inline
In-Reply-To: <20170627070143.GB4114@worktop>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

Hello, Peter.

On Tue, Jun 27, 2017 at 09:01:43AM +0200, Peter Zijlstra wrote:
> 
> I'm slowly getting back to things...

Welcome back.

> On Mon, Jun 12, 2017 at 05:27:53PM -0400, Tejun Heo wrote:
> > That's where the "join" thing comes from because we wanna be able to
> > tell apart whether a cgroup is gonna be a part of the existing thread
> > subtree or starting its own thread subtree.  There sure are multiple
> > ways to express that but one way or the other, if you wanna support
> > topologies like the last one, you have to distinguish the two.
> 
> Hmm,.. I had not considered that. I was strictly considering the root to
> always be a resource domain. What use-case or scenario did you have
> to want to do this?

I don't have any really.  It's mostly just from interface
completeness.

> That is, what is the meaning of having T1 be a separate 'root' if its
> not also a resource domain?

T1 is a resource domain.  Hmm... I think I see what you mean.  Let's
continue below.

> IIRC the problem with the 'threaded' marker is that it doesn't clearly
> capture what a resource domain is.
> 
> That is, assuming that a thread root is always a resource domain, we get
> the following problem:
> 
> If we set 'threaded' on the root group in order to create a thread
> (sub)group. If we then want to create another domain group, we'd have to
> clear 'threaded' on that.
> 
> 	R (t=1)
>        / \
> (t=1) T   D (t=0)
> 
> So far so good. However, now we want to create another thread group
> under our domain group D, so we have to set its 'threaded' marker again:
> 
> 	R (t=1)
>        / \
> (t=1) T   D (t=1)
>          /
> 	T (t=1)
> 
> And we can no longer identify D as a resource domain. If OTOH we mark
> 'domain' we get:
> 
> 	R (d=1)
>        / \
> (d=0) T   D (d=1)
>          /
> 	T (d=0)
> 
> Which clearly identifies the domains and the thread only groups.

So, the difference between the two interfaces is that the one I
proposed is marking the thread root which makes all its descendants
threaded while the above is marking each individual cgroup as being
whether a resource domain or threaded.

> Your objections to doing this were representing the resource controllers
> in the intermediate thread-only groups like:
> 
>    R
>     \
>      T  -- what to do with eg. memcg here?
>       \
>        D
>         \
> 	 T

And that's a perfectly valid point and as you pointed out the downside
of marking each node separately is that the interface would allow
configurations which aren't supported (at least for now) and that
there's just more to configure - the user has to set the mode on each
node after creation which is just the natural cost of being able to
express more.

> I suggested having all resource controllers represented with a soft-link
> back into the (thread-root) resource domain. But you were not convinced
> and worried people were going to be confused.

There's more to it than just confusion because resource interface
files belong to the parent cgroup rather than the cgroup which hosts
the files.  This becomes clear when thinking about which files a
container should be granted write access to when delegating a cgroup
subtree to it.  I'm sure we can get around it some way but we need to
be careful here.

> Your current proposal treats the resource controllers as disabled in
> thread subgroups -- which is perfectly fine given the constraint that we
> cannot have new domains in a thread sub-tree. My worry is that we don't
> paint ourselves in a corner and create an interface where we can never
> extend to allow this.

Understood.  We can err out on unsupported configurations and expand
in the future as necessary.

> I'm not wanting to change the relative weight thing. I merely wish to
> change the interface for setting the group weight to match that of the
> task weight, since both directly compete against one another.
> 
> That is, a group weight is the same kind of weight as a task weight.
> Therefore it would make much more sense to set then in equal units too.
> Not having done that from the beginning was rather silly.
> 
> By having a 100 based weight it becomes very hard to match the weight of
> nice()'ed tasks (something that was already tricky with the current
> shares interface because we'd need to share the nice weight table with
> userspace).
> 
> By having both in nice units, its both conceptually clear that they're
> the same kind of weight and easier to match weights.

I think there is another side to it.  If you just think about threads,
nice levels is the only thing we have.  It's a relative interface
which isn't defined rigidly and that can be a plus in that it allows
the kernel the room to maneuver with evolving implentations,
heuristics and so on.

Unfortunaltey, viewed from containerized resource control side, this
is very difficult to deal with.  The scale isn't strictly defined,
rather coarse and in generally difficult to work with - e.g. what do
you do when the system is split 20%, 80% and then you wanna add
another workload so that it becomes 20%, 50%, 30%?  And then there is
the problem with consistency with other resource types which may also
use proportional distribution.

But, it doesn't have to be this or that.  We can easily support both
units by simply allowing, say, "-5n" to be written to cpu.weight file
and interpret that as the nice value and exposing the closest nice
value in the cpu.stat file.

Does that sound workable?

Thanks.

-- 
tejun
