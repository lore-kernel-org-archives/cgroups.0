From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Tue, 25 Aug 2015 12:00:54 +0200
Message-ID: <20150825100054.GN16853@twins.programming.kicks-ass.net>
References: <CAPM31RJi07qs42YsH=4JQSbZ+J-zCLv8e7yELb3tF_qAZmLqRA@mail.gmail.com>
 <20150824210223.GH28944@mtj.duckdns.org>
 <CAPM31R+i7BD8x9h_6wZVTa0zCB7XP0SGL5dSA-n6h9PTeAEhug@mail.gmail.com>
 <20150824211707.GJ28944@mtj.duckdns.org>
 <CAPM31R+vt1oAPCB-q6570RqZtJVBu5MH=gcQD2m9mjauStV7MA@mail.gmail.com>
 <20150824214000.GL28944@mtj.duckdns.org>
 <CAPM31R+Mnk=AL6h05eMMQvPEEfnjkB3iGb+oZj28jAQ9-ajOxA@mail.gmail.com>
 <20150824224936.GO28944@mtj.duckdns.org>
 <CAPM31RKr5K0F6b70wJronTcvXRLBYRuOvH+aFeDTVeZiDVZz=Q@mail.gmail.com>
 <20150825092441.GA24131@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150825092441.GA24131-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Tue, Aug 25, 2015 at 11:24:42AM +0200, Ingo Molnar wrote:
> 
> * Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > > Anyways, a point here is that threads of the same process competing
> > > isn't a new problem.  There are many ways to make those threads play
> > > nice as the application itself often has to be involved anyway,
> > > especially for something like qemu which is heavily involved in
> > > provisioning resources.
> > 
> > It's certainly not a new problem, but it's a real one, and it's
> > _hard_.  You're proposing removing the best known solution.
> 
> Also, just to make sure this is resolved properly, I'm NAK-ing the current 
> scheduler bits in this series:
> 
>   NAKed-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 
> until all of pjt's API design concerns are resolved. This is conceptual, it is not 
> a 'we can fix it later' detail.
> 
> Tejun, please keep me Cc:-ed to future versions of this series so that I can lift 
> the NAK if things get resolved.

You can add:

NAKed-by: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

to that.

There have been at least 3 different groups of people:

 - Mike, representing Suse customers
 - Kamezawa-san, representing Fujitsu customers
 - Paul, representing Google

that claim per-thread control groups are in use and important.

Any replacement _must_ provide for this use case up front; its not
something that can be cobbled on later.
