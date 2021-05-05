From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] memory reserve for userspace oom-killer
Date: Tue, 4 May 2021 17:37:32 -0700
Message-ID: <CALvZod4_L7GSHnivQTSdDzo=fb4i3z=katjzVCHfLz9WWGK8uQ@mail.gmail.com>
References: <CALvZod7vtDxJZtNhn81V=oE-EPOf=4KZB2Bv6Giz+u3bFFyOLg@mail.gmail.com>
 <YH54pyRWSi1zLMw4@dhcp22.suse.cz> <CALvZod4kjdgMU=8T_bx6zFufA1cGtt2p1Jg8jOgi=+g=bs-Evw@mail.gmail.com>
 <YH/RPydqhwXdyG80@dhcp22.suse.cz> <CALvZod4kRWDQuZZQ5F+z6WMcUWLwgYd-Kb0mY8UAEK4MbSOZaA@mail.gmail.com>
 <YIA2rB0wgqKzfUfi@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rE+67pf/2itGCrXRDqOt78tityf8/56CzXmtqalTs7Y=;
        b=oPjqJycdh906u/NKD96OF/32I8GkIKXWJvImxBVe8Uoi5eQH0eCxEmU1C14OFp77Bh
         7Q0cLGd/hOMzojqrDn4N+h/krRVmuvkI/846O1BZJG6acacCSK6qRvH8kWCAw0IgRM2o
         tW70LTDJPlXiFxn+Onp+XUen2V3IVkqMFUZ7B20neSLbTJyPlWuIJLgM+YpmiPQ3zIUA
         kc8idKtZ5R86Yp4837IQvSnAO/r8OkY3shl3v0ueAglTxveiZ600ewUj216ssOQDZoWi
         COcs6/4gvKgeap02wOQj5e0w7c0XRY4BL7JWx7btEdKvqUOorT11BgEN8oY2OwmENhV1
         yMtA==
In-Reply-To: <YIA2rB0wgqKzfUfi-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dragos Sbirlea <dragoss-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Priya Duraisamy <padmapriyad-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed, Apr 21, 2021 at 7:29 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
[...]
> > > What if the pool is depleted?
> >
> > This would mean that either the estimate of mempool size is bad or
> > oom-killer is buggy and leaking memory.
> >
> > I am open to any design directions for mempool or some other way where
> > we can provide a notion of memory guarantee to oom-killer.
>
> OK, thanks for clarification. There will certainly be hard problems to
> sort out[1] but the overall idea makes sense to me and it sounds like a
> much better approach than a OOM specific solution.
>
>
> [1] - how the pool is going to be replenished without hitting all
> potential reclaim problems (thus dependencies on other all tasks
> directly/indirectly) yet to not rely on any background workers to do
> that on the task behalf without a proper accounting etc...
> --

I am currently contemplating between two paths here:

First, the mempool, exposed through either prctl or a new syscall.
Users would need to trace their userspace oom-killer (or whatever
their use case is) to find an appropriate mempool size they would need
and periodically refill the mempools if allowed by the state of the
machine. The challenge here is to find a good value for the mempool
size and coordinating the refilling of mempools.

Second is a mix of Roman and Peter's suggestions but much more
simplified. A very simple watchdog with a kill-list of processes and
if userspace didn't pet the watchdog within a specified time, it will
kill all the processes in the kill-list. The challenge here is to
maintain/update the kill-list.

I would prefer the direction which oomd and lmkd are open to adopt.

Any suggestions?
