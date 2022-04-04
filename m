From: Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: introduce dynamic protection for memcg
Date: Mon, 4 Apr 2022 17:07:30 +0800
Message-ID: <CAGWkznG4L3w=9bpZp8TjyWHmqFyZQk-3m4xCZ96zhHCLPawBgQ@mail.gmail.com>
References: <1648713656-24254-1-git-send-email-zhaoyang.huang@unisoc.com>
 <YkVt0m+VxnXgnulq@dhcp22.suse.cz> <CAGWkznF4qb2EP3=xVamKO8qk08vaFg9JeHD7g80xvBfxm39Hkg@mail.gmail.com>
 <YkWR8t8yEe6xyzCM@dhcp22.suse.cz> <CAGWkznHxAD0757m1i1Csw1CVRDtQddfCL08dYf12fa47=-uYYQ@mail.gmail.com>
 <YkbjNYMY8VjHoSHR@dhcp22.suse.cz> <CAGWkznF7cSyPU0ceYwH6zweJzf-X1bQnS6AJ2-J+WEL0u8jzng@mail.gmail.com>
 <CAJuCfpHneDZMXO_MmQDPA+igAOdAPRUChiq+zftFXGfDzPHNhQ@mail.gmail.com>
 <CAGWkznFTQCm0cusVxA_55fu2WfT-w2coVHrT=JA1D_9_2728mQ@mail.gmail.com> <YkqxpEW4m6iU3zMq@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4bEukbCR9Nhs/phBw9CHkxQ3EgSEHMJ/cxKPyV/U1Lc=;
        b=J5KW87ePrm1kVWM8zimS7BHw2Mzubr83uLPX1ZBEuTOjvvs+UkzK/GsTYtS+rkeeh6
         Ge2jgAndu7+Zy91oVbelB/tQnEdNrikZagGfuskZmImTjrfeZFKVfsqjT4l6uBHJSGVZ
         VY7S7PBo+y7RdG666XUW2bx1aEo7G3ouf2K51+rUsGOhwYYyquxLNq9RdgI6zt+EI6Oq
         QogUEwbMxBtv/3Hc+6E7ikZQLShJTywcEZtzSZ40mqOmq5LwKkAGxigcH/x8JoioykXi
         D2BAEjI17KvY0X1MbUap3yVxXSGf+QKh6gAAsi1h7CMfZADAjRdbrxbuASmFKV+ZXIG/
         gb5Q==
In-Reply-To: <YkqxpEW4m6iU3zMq-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:MEMORY MANAGEMENT" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ke Wang <ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>

On Mon, Apr 4, 2022 at 4:51 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Mon 04-04-22 10:33:58, Zhaoyang Huang wrote:
> [...]
> > > One thing that I don't understand in this approach is: why memory.low
> > > should depend on the system's memory pressure. It seems you want to
> > > allow a process to allocate more when memory pressure is high. That is
> > > very counter-intuitive to me. Could you please explain the underlying
> > > logic of why this is the right thing to do, without going into
> > > technical details?
> > What I want to achieve is make memory.low be positive correlation with
> > timing and negative to memory pressure, which means the protected
> > memcg should lower its protection(via lower memcg.low) for helping
> > system's memory pressure when it's high.
>
> I have to say this is still very confusing to me. The low limit is a
> protection against external (e.g. global) memory pressure. Decreasing
> the protection based on the external pressure sounds like it goes right
> against the purpose of the knob. I can see reasons to update protection
> based on refaults or other metrics from the userspace but I still do not
> see how this is a good auto-magic tuning done by the kernel.
>
> > The concept behind is memcg's
> > fault back of dropped memory is less important than system's latency
> > on high memory pressure.
>
> Can you give some specific examples?
For both of the above two comments, please refer to the latest test
result in Patchv2 I have sent. I prefer to name my change as focus
transfer under pressure as protected memcg is the focus when system's
memory pressure is low which will reclaim from root, this is not
against current design. However, when global memory pressure is high,
then the focus has to be changed to the whole system, because it
doesn't make sense to let the protected memcg out of everybody, it
can't
do anything when the system is trapped in the kernel with reclaiming work.
>
> > Please refer to my new version's test data
> > for more detail.
>
> Please note that sending new RFCs will just make the discussion spread
> over several email threads which will get increasingly hard to follow.
> So do not post another version until it is really clear what is the
> actual semantic you are proposing.
ok, I will hold until all question done.
>
> --
> Michal Hocko
> SUSE Labs
