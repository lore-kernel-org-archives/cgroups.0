From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCHSET for-4.13] cgroup: implement cgroup2 thread mode, v2
Date: Tue, 27 Jun 2017 09:01:43 +0200
Message-ID: <20170627070143.GB4114@worktop>
References: <20170610140351.10703-1-tj@kernel.org>
 <20170612123150.scopfxela7v26dct@hirez.programming.kicks-ass.net>
 <20170612212753.GN19206@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4zXQMgTEuCIOfUFAqGn3joP98RSpCgdBvT7ci9KTZ1k=; b=dDClyX6MGvTvccMwxlMkIB6B4
        C+2BhVS/LaL3nF73kBptoMsaJmnd5wMbBcnID35TTlx/V4AZ8pOHN7JA2spjCcQtgBtFfLi+PYSO1
        CSpuq5IwY8FVF03L3NpANWDuuo43P+E7qDy4bJoJravOl9Ja0NuibO0hyqfCXbSf2ePlaqGI1iP90
        cxtU1oxoqIUSDX0JppH1QS/B3rjcW0ullofvLkHhlNBUL3wO2Pk9YJVt7RNur11/uzludBGBrBvaf
        qQN6tbvgjLfLgxGCVhZb86A9+VQi94Gg0bdxzoKIWA3g5knE0c103JEb+GyBsSxGAzFQIYVLLyrZq
    
Content-Disposition: inline
In-Reply-To: <20170612212753.GN19206-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org


I'm slowly getting back to things...

On Mon, Jun 12, 2017 at 05:27:53PM -0400, Tejun Heo wrote:

> > > * Root cgroup can enable thread mode anytime and a first level child
> > >   can opt-in to that thread subtree anchored at root by writing "join"
> > >   to "cgroup.threads" files, start its own thread subtree or just be a
> > >   normal cgroup.
> > 
> > Yuck... this again is a consequence of tagging the 'wrong' thing. Again,
> > the primary construct is the resource domain.
> > 
> > If you use that as a tag, you don't need this weird join crap. Because
> > as soon as you clear the 'resource domain' flag on a group, it instantly
> > becomes a thread group and 'obviously' connects to the first parent that
> > is a resource domain.
> 
> It has nothing to do with whether we mark domain or threaded subtrees.
> It is solely from whether you wanna express cases where a thread root
> is right below another thread root.  Tn's are member cgroup of thread
> subtrees where the same number means the same threaded subtree, D's
> are of domain cgroups.
> 
> The following is straight forward.
> 
> 	  T0
>        /  \
>       T0   D
> 
> The following is too.
> 
> 	  T0
>        /  \
>       T0   D
>             \
> 	       T1
> 
> The question is whether to allow something like the following.
> 
> 	  T0
>        /  \
>       T0  T1
> 
> That's where the "join" thing comes from because we wanna be able to
> tell apart whether a cgroup is gonna be a part of the existing thread
> subtree or starting its own thread subtree.  There sure are multiple
> ways to express that but one way or the other, if you wanna support
> topologies like the last one, you have to distinguish the two.

Hmm,.. I had not considered that. I was strictly considering the root to
always be a resource domain. What use-case or scenario did you have
to want to do this?

That is, what is the meaning of having T1 be a separate 'root' if its
not also a resource domain?

> > And, as per the last time, this threaded marker isn't uniquely
> > identifying things, so it hard prohibits from ever extending the model
> > to allow resource domains nested in a thread subtree. Now I understand
> > why you don't implement that now -- you were struggling with the views
> > API, but that is no excuse to create an API that permanently disables
> > that feature.
> 
> Hmmm?  We can just allow disabling thread mode if we ever get to that.
> We can't make arbitrary graphs out of these nodes.  Whatever mode we
> put them in, they have to fall in with the overall tree structure, so
> I don't think the interface is unnecessarily restricting in that
> direction.

IIRC the problem with the 'threaded' marker is that it doesn't clearly
capture what a resource domain is.

That is, assuming that a thread root is always a resource domain, we get
the following problem:

If we set 'threaded' on the root group in order to create a thread
(sub)group. If we then want to create another domain group, we'd have to
clear 'threaded' on that.

	R (t=1)
       / \
(t=1) T   D (t=0)

So far so good. However, now we want to create another thread group
under our domain group D, so we have to set its 'threaded' marker again:

	R (t=1)
       / \
(t=1) T   D (t=1)
         /
	T (t=1)

And we can no longer identify D as a resource domain. If OTOH we mark
'domain' we get:

	R (d=1)
       / \
(d=0) T   D (d=1)
         /
	T (d=0)

Which clearly identifies the domains and the thread only groups.


Your objections to doing this were representing the resource controllers
in the intermediate thread-only groups like:

   R
    \
     T  -- what to do with eg. memcg here?
      \
       D
        \
	 T

I suggested having all resource controllers represented with a soft-link
back into the (thread-root) resource domain. But you were not convinced
and worried people were going to be confused.


Your current proposal treats the resource controllers as disabled in
thread subgroups -- which is perfectly fine given the constraint that we
cannot have new domains in a thread sub-tree. My worry is that we don't
paint ourselves in a corner and create an interface where we can never
extend to allow this.

The immediate use-case for wanting this would be allowing tasks in a
thread-group to start a VM or container (which would then want a
(sub) resource domain).


> > So I really regret the 'shares' interface; we really should have done a
> > nice thing.
> > 
> >   https://lkml.kernel.org/r/20170410073622.2y6tnpcd2ssuoztz-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org
> > 
> > So I would like to change to that instead of the weird 100 thing.
> 
> Is it?  Relative weights are pretty fundamental and clearly defined in
> expressing work-conserving resource distribution.  Do you have more
> details on what you have on mind?

I'm not wanting to change the relative weight thing. I merely wish to
change the interface for setting the group weight to match that of the
task weight, since both directly compete against one another.

That is, a group weight is the same kind of weight as a task weight.
Therefore it would make much more sense to set then in equal units too.
Not having done that from the beginning was rather silly.

By having a 100 based weight it becomes very hard to match the weight of
nice()'ed tasks (something that was already tricky with the current
shares interface because we'd need to share the nice weight table with
userspace).

By having both in nice units, its both conceptually clear that they're
the same kind of weight and easier to match weights.
