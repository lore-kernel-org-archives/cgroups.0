From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] memory reserve for userspace oom-killer
Date: Wed, 21 Apr 2021 06:26:37 -0700
Message-ID: <CALvZod7x=QR=p73BAxWPbFm+V8KFwYCcxNp-bOBvGaAttxjm7g@mail.gmail.com>
References: <CALvZod7vtDxJZtNhn81V=oE-EPOf=4KZB2Bv6Giz+u3bFFyOLg@mail.gmail.com>
 <YH8o5iIau85FaeLw@carbon.DHCP.thefacebook.com> <CALvZod7dXuFPeMv5NGu96uCosFpWY_Gy07iDsfSORCA0dT_zsA@mail.gmail.com>
 <YH+U4X8PKWZpOpAA@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZywKeowOaZ5VjiR6Xyl1lA10hFbmQYAWAA2LZ4rnjYw=;
        b=CK1O++Mtfpi16+3yujCdkCfBGjU4sVfzcD13bBfsUdBy4QfY5X0LGDdVSJi7h59uGE
         CAbgTBgagVouDpUaWZMzdF9CN6uKvmqX57EAYp9CPdLIm2iwV3lrOhiMPNnXnS1UAc3U
         VOjJ9diIXc6gRimHPoCeH9Hiqca0KFQ/WE/zg2xuxmv7LyUlzY+T+aZvjN/dULKrWWGN
         AtQZCyKcPiVpNk7gB9XIYbHiTdQe2wVPftF0ZEMKDc8lqANKKd2tbwSEwcHIzZdonz3B
         mcNDmd8/vG/gsoS8jfvtZABzkpzTRy1JgaOM1Emh/D0bKwhc4dtv2LM7QlFYVIRXeY3A
         Ulog==
In-Reply-To: <YH+U4X8PKWZpOpAA-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dragos Sbirlea <dragoss-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Priya Duraisamy <padmapriyad-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Tue, Apr 20, 2021 at 7:58 PM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
>
[...]
> >
> > Michal has suggested ALLOC_OOM which is less risky.
>
> The problem is that even if you'll serve the oom daemon task with pages
> from a reserve/custom pool, it doesn't guarantee anything, because the task
> still can wait for a long time on some mutex, taken by another process,
> throttled somewhere in the reclaim.

I am assuming here by mutex you are referring to locks which
oom-killer might have to take to read metrics or any possible lock
which oom-killer might have to take which some other process can take
too.

Have you observed this situation happening with oomd on production?

> You're basically trying to introduce a
> "higher memory priority" and as always in such cases there will be priority
> inversion problems.
>
> So I doubt that you can simple create a common mechanism which will work
> flawlessly for all kinds of allocations, I anticipate many special cases
> requiring an individual approach.
>
[...]
>
> First, I need to admit that I didn't follow the bpf development too close
> for last couple of years, so my knowledge can be a bit outdated.
>
> But in general bpf is great when there is a fixed amount of data as input
> (e.g. skb) and a fixed output (e.g. drop/pass the packet). There are different
> maps which are handy to store some persistent data between calls.
>
> However traversing complex data structures is way more complicated. It's
> especially tricky if the data structure is not of a fixed size: bpf programs
> have to be deterministic, so there are significant constraints on loops.
>
> Just for example: it's easy to call a bpf program for each task in the system,
> provide some stats/access to some fields of struct task and expect it to return
> an oom score, which then the kernel will look at to select the victim.
> Something like this can be done with cgroups too.
>
> Writing a kthread, which can sleep, poll some data all over the system and
> decide what to do (what oomd/... does),  will be really challenging.
> And going back, it will not provide any guarantees unless we're not taking
> any locks, which is already quite challenging.
>

Thanks for the info and I agree this direction needs much more thought
and time to be materialized.

thanks,
Shakeel
