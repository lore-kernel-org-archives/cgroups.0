From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] memory reserve for userspace oom-killer
Date: Wed, 21 Apr 2021 07:13:45 -0700
Message-ID: <CALvZod6oCBB6tDh5wABSwdHfcDzLX7S7cOTLp_4Qk4DCi50X_A@mail.gmail.com>
References: <CALvZod7vtDxJZtNhn81V=oE-EPOf=4KZB2Bv6Giz+u3bFFyOLg@mail.gmail.com>
 <YH8o5iIau85FaeLw@carbon.DHCP.thefacebook.com> <CALvZod7dXuFPeMv5NGu96uCosFpWY_Gy07iDsfSORCA0dT_zsA@mail.gmail.com>
 <YH/S2dVxk2le8SMw@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KT5Z/sPJXf0qDYy55bMraiO4nEL20VpFAQ+FPYD2/dw=;
        b=WFAWOqMmzOQnQNVjpAKoR6YqWuxUDxMFdKgszw7Kn8uz7r8hz4pWSNkrWd5wNrvPGp
         q39wDsrIdJmGWqrYNH8EUO6pO+DVhIsP8AaaNicOjCkRz1CNsoCn+ETNeFl3Q8hL00Ct
         CI1EzrSnzpp4EWE1LXyyb2yFXfBfV/RmqRZCM6pQdzS7WbVf46BwNckO0u6hNrXyZKcf
         0nxRN8JIvGm8b0shRuwYStgnyt9mEE0rBE+HLxDOYWOElrfF7Tk4/ZSmZiS4411A4+bU
         38t+fVT8D6CfEj3lIXI40eG7FQCx5Bzpg1adr0Ij4D6cG3oMI17mt+20w8Tl4tniDdvW
         Xiag==
In-Reply-To: <YH/S2dVxk2le8SMw-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dragos Sbirlea <dragoss-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Priya Duraisamy <padmapriyad-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed, Apr 21, 2021 at 12:23 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
[...]
> > In our observation the global reclaim is very non-deterministic at the
> > tail and dramatically impacts the reliability of the system. We are
> > looking for a solution which is independent of the global reclaim.
>
> I believe it is worth purusing a solution that would make the memory
> reclaim more predictable. I have seen direct reclaim memory throttling
> in the past. For some reason which I haven't tried to examine this has
> become less of a problem with newer kernels. Maybe the memory access
> patterns have changed or those problems got replaced by other issues but
> an excessive throttling is definitely something that we want to address
> rather than work around by some user visible APIs.
>

I agree we want to address the excessive throttling but for everyone
on the machine and most importantly it is a moving target. The reclaim
code continues to evolve and in addition it has callbacks to diverse
sets of subsystems.

The user visible APIs is for one specific use-case i.e. oom-killer
which will indirectly help in reducing the excessive throttling.

[...]
> > So, the suggestion is to have a per-task flag to (1) indicate to not
> > throttle and (2) fail allocations easily on significant memory
> > pressure.
> >
> > For (1), the challenge I see is that there are a lot of places in the
> > reclaim code paths where a task can get throttled. There are
> > filesystems that block/throttle in slab shrinking. Any process can get
> > blocked on an unrelated page or inode writeback within reclaim.
> >
> > For (2), I am not sure how to deterministically define "significant
> > memory pressure". One idea is to follow the __GFP_NORETRY semantics
> > and along with (1) the userspace oom-killer will see ENOMEM more
> > reliably than stucking in the reclaim.
>
> Some of the interfaces (e.g. seq_file uses GFP_KERNEL reclaim strength)
> could be more relaxed and rather fail than OOM kill but wouldn't your
> OOM handler be effectivelly dysfunctional when not able to collect data
> to make a decision?
>

Yes it would be. Roman is suggesting to have a precomputed kill-list
(pidfds ready to send SIGKILL) and whenever oom-killer gets ENOMEM, it
would go with the kill-list. Though we are still contemplating the
ways and side-effects of preferably returning ENOMEM in slowpath for
oom-killer and in addition the complexity to maintain the kill-list
and keeping it up to date.

thanks,
Shakeel
