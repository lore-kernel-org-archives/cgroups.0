From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET for-4.13] cgroup: implement cgroup2 thread mode, v2
Date: Mon, 12 Jun 2017 17:27:53 -0400
Message-ID: <20170612212753.GN19206@htj.duckdns.org>
References: <20170610140351.10703-1-tj@kernel.org>
 <20170612123150.scopfxela7v26dct@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xDhCEOW75hhuy+cdnLympO+lhg47/jUZC0+GUQiL4zE=;
        b=tYHvIS/eSmSxMt3DgROMKbXZtd65TLeewrR61BbJnefYCRMgGQdMVlmm9DSD6/npMx
         x+ynoDYRUVk6adSzAQGXhbovJPJ0MckqxoryyEq97W3gx3zRSVo16z0s6y5n2C36OJbp
         N462YA5xTe14ryYOfKfxx1XI7+wDF4Bbb9yf35ujYQ6cG7FuN1gzAIvXvppZvCxUwJYD
         gRXxMyV00zRgmmvQB73EqMpHEtzTU6kS0aonPpZLnr32XMJkwmSzFFYsFjkHXcl9VMdV
         SUF7AbLUZ9q83kXIibe624CQKLRg5WTv9li+oSSdEOQ9LhIbIfJs84mciR7RdU0J2ViS
         QyJA==
Content-Disposition: inline
In-Reply-To: <20170612123150.scopfxela7v26dct-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

Hello, Peter.

On Mon, Jun 12, 2017 at 02:31:50PM +0200, Peter Zijlstra wrote:
> Please don't rush this; also, I might not be around much the coming
> weeks due to taking some leave 'soon' (kid #3 is imminent).

Congrats.  As for this going forward, how can we possibly be slower?

> And I really need more time to look at this (and re-read the old
> discussions, because I've forgot most everything again).

Can we at least unblock the cpu controller part?  We can hash the
details of thread support as long as necessary but I'm not sure it's
reasonable to keep blocking the whole cpu controller at this point.

> > * Root cgroup can enable thread mode anytime and a first level child
> >   can opt-in to that thread subtree anchored at root by writing "join"
> >   to "cgroup.threads" files, start its own thread subtree or just be a
> >   normal cgroup.
> 
> Yuck... this again is a consequence of tagging the 'wrong' thing. Again,
> the primary construct is the resource domain.
> 
> If you use that as a tag, you don't need this weird join crap. Because
> as soon as you clear the 'resource domain' flag on a group, it instantly
> becomes a thread group and 'obviously' connects to the first parent that
> is a resource domain.

It has nothing to do with whether we mark domain or threaded subtrees.
It is solely from whether you wanna express cases where a thread root
is right below another thread root.  Tn's are member cgroup of thread
subtrees where the same number means the same threaded subtree, D's
are of domain cgroups.

The following is straight forward.

	T0
       /  \
      T0   D

The following is too.

	T0
       /  \
      T0   D
            \
	     T1

The question is whether to allow something like the following.

	T0
       /  \
      T0  T1

That's where the "join" thing comes from because we wanna be able to
tell apart whether a cgroup is gonna be a part of the existing thread
subtree or starting its own thread subtree.  There sure are multiple
ways to express that but one way or the other, if you wanna support
topologies like the last one, you have to distinguish the two.

The previous iteration actually was that way, so the only thread mode
operation was setting whether to enable thread or not as before and if
the parent is already thread mode, it'd always join the existing
threaded subtree.  If you like that better, I can post that version
right away.

> And, as per the last time, this threaded marker isn't uniquely
> identifying things, so it hard prohibits from ever extending the model
> to allow resource domains nested in a thread subtree. Now I understand
> why you don't implement that now -- you were struggling with the views
> API, but that is no excuse to create an API that permanently disables
> that feature.

Hmmm?  We can just allow disabling thread mode if we ever get to that.
We can't make arbitrary graphs out of these nodes.  Whatever mode we
put them in, they have to fall in with the overall tree structure, so
I don't think the interface is unnecessarily restricting in that
direction.

> I cannot at this time remember if there was a strong use-case for that
> scenario -- like said, I really need to re-read the email threads, but I
> might not have enough time to do so now.
> 
> Again, please don't rush this.

Well, I don't have a way to do that.

> So I really regret the 'shares' interface; we really should have done a
> nice thing.
> 
>   https://lkml.kernel.org/r/20170410073622.2y6tnpcd2ssuoztz-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org
> 
> So I would like to change to that instead of the weird 100 thing.

Is it?  Relative weights are pretty fundamental and clearly defined in
expressing work-conserving resource distribution.  Do you have more
details on what you have on mind?

> As for the RT thing, the runtime/period thing is not a MAX but a MIN
> limit (conceptually -- in practise its both).

Yeah, it's a hard allocation.

> Also, we need cpuset to be a thread controller.

Yeah, absolutely.

Thanks.

-- 
tejun
