From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Tue, 25 Aug 2015 15:18:42 -0400
Message-ID: <20150825191842.GD26785@mtj.duckdns.org>
References: <20150824170427.GA27262@mtj.duckdns.org>
 <CAPM31RJi07qs42YsH=4JQSbZ+J-zCLv8e7yELb3tF_qAZmLqRA@mail.gmail.com>
 <20150824210223.GH28944@mtj.duckdns.org>
 <CAPM31R+i7BD8x9h_6wZVTa0zCB7XP0SGL5dSA-n6h9PTeAEhug@mail.gmail.com>
 <20150824211707.GJ28944@mtj.duckdns.org>
 <CAPM31R+vt1oAPCB-q6570RqZtJVBu5MH=gcQD2m9mjauStV7MA@mail.gmail.com>
 <20150824214000.GL28944@mtj.duckdns.org>
 <CAPM31R+Mnk=AL6h05eMMQvPEEfnjkB3iGb+oZj28jAQ9-ajOxA@mail.gmail.com>
 <20150824224936.GO28944@mtj.duckdns.org>
 <CAPM31RKr5K0F6b70wJronTcvXRLBYRuOvH+aFeDTVeZiDVZz=Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ehPesBq/+QVPXgnWkQAhGUpT38gIWY+0rJ6Bbq86O/s=;
        b=sOI/TROuMplqTqYoPbywNCWU5jjLgwnL8ZFn5DsD+lxYguvTUQuyhL0AVaZQJ48dEJ
         89vAO5OJAf0GuV2QZf0BsEBSqAFNVPp+2s0Ivc5wPpT7uSfjDrYYJYANq/0WYMOUPK73
         a7jrWVk+7e7j93gvFBXN1QXsDSHelYgOoaJZNN8sqJfDH/ZEiwnorhSCYJ8fFlWPulBB
         bAEuvsKIdf8z0MmIwJybekA7PV8QV/KXtf/A2u3ts/whHXctIIeFPzEJku4Q6VuYWVht
         qkFBTKl20V/Q7Mew1og8+WwkH1q4Nx2seNDHrGFRfEu5jctZ5zlyNooWXVIs2eZpJXv8
         CPKw==
Content-Disposition: inline
In-Reply-To: <CAPM31RKr5K0F6b70wJronTcvXRLBYRuOvH+aFeDTVeZiDVZz=Q@mail.gmail.com>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello, Paul.

On Mon, Aug 24, 2015 at 04:15:59PM -0700, Paul Turner wrote:
> > Hmmm... if that's the case, would limiting iops on those IO devices
> > (or classes of them) work?  qemu already implements IO limit mechanism
> > after all.
> 
> No.
> 
> 1) They should proceed at the maximum rate that they can that's still
> within their provisioning budget.

Ooh, right.

> 2) The cost/IO is both inconsistent and changes over time.  Attempting
> to micro-optimize every backend for this is infeasible, this is
> exactly the type of problem that the scheduler can usefully help
> arbitrate.
> 3) Even pretending (2) is fixable, dynamically dividing these
> right-to-work tokens between different I/O device backends is
> extremely complex.
>
> > Anyways, a point here is that threads of the same process competing
> > isn't a new problem.  There are many ways to make those threads play
> > nice as the application itself often has to be involved anyway,
> > especially for something like qemu which is heavily involved in
> > provisioning resources.
> 
> It's certainly not a new problem, but it's a real one, and it's
> _hard_.  You're proposing removing the best known solution.

Well, I'm trying to figure out whether we actually need it and
implement something sane if so.  We actually can't do hierarchical
resource distribution with existing mechanisms, so if that is
something which is beneficial enough, let's go ahead and figure it
out.

> > cgroups can be a nice brute-force add-on which lets sysadmins do wild
> > things but it's inherently hacky and incomplete for coordinating
> > threads.  For example, what is it gonna do if qemu cloned vcpus and IO
> > helpers dynamically off of the same parent thread?
> 
> We're talking about sub-process usage here.  This is the application
> coordinating itself, NOT the sysadmin.  Processes are becoming larger
> and larger, we need many of the same controls within them that we have
> between them.
>
> >  It requires
> > application's cooperation anyway but at the same time is painful to
> > actually interact from those applications.
> 
> As discussed elsewhere on thread this is really not a problem if you
> define consistent rules with respect to which parts are managed by
> who.  The argument of potential interference is no different to
> messing with an application's on-disk configuration behind its back.
> Alternate strawmen which greatly improve this from where we are today
> have also been proposed.

Let's continue in the other sub-thread but it's not just system
management and applications not stepping on each other's toes although
even just that is extremely painful with the current interface.
cgroup membership is inherently tied to process tree no matter who's
managing it which requires coordination from the application side for
sub-process management and at that point it's really matter of putting
one and one together.

Thanks.

-- 
tejun
