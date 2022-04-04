From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: introduce dynamic protection for memcg
Date: Mon, 4 Apr 2022 11:32:25 +0200
Message-ID: <Ykq7KUleuAg5QnNU@dhcp22.suse.cz>
References: <CAGWkznF4qb2EP3=xVamKO8qk08vaFg9JeHD7g80xvBfxm39Hkg@mail.gmail.com>
 <YkWR8t8yEe6xyzCM@dhcp22.suse.cz>
 <CAGWkznHxAD0757m1i1Csw1CVRDtQddfCL08dYf12fa47=-uYYQ@mail.gmail.com>
 <YkbjNYMY8VjHoSHR@dhcp22.suse.cz>
 <CAGWkznF7cSyPU0ceYwH6zweJzf-X1bQnS6AJ2-J+WEL0u8jzng@mail.gmail.com>
 <CAJuCfpHneDZMXO_MmQDPA+igAOdAPRUChiq+zftFXGfDzPHNhQ@mail.gmail.com>
 <CAGWkznFTQCm0cusVxA_55fu2WfT-w2coVHrT=JA1D_9_2728mQ@mail.gmail.com>
 <YkqxpEW4m6iU3zMq@dhcp22.suse.cz>
 <CAGWkznG4L3w=9bpZp8TjyWHmqFyZQk-3m4xCZ96zhHCLPawBgQ@mail.gmail.com>
 <CAGWkznGMRohE2_at4Qh8KbwSqNmNqOAG2N1EM+7uE9wKqzRm0A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649064748; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/QhehSjHhOKNL81Gz/OIvOna/doU9hehd+fzE0LoRRM=;
        b=k7X7bZkdrsHkgHqwy36YGKGpfYF8iNGllvdNgCT0X1H4MVFTN6Hf/Np97vtwNdrNWixGdN
        Jo8z8f9KVKVHfRi1Ltdg5Av39TBpFgCoBM+w4KqvGIU904rpFl7RzMu04Q5IaQTV1g6Gfw
        3iJkuTIhCsu/YgKUHy8L1oGSgcd/6HA=
Content-Disposition: inline
In-Reply-To: <CAGWkznGMRohE2_at4Qh8KbwSqNmNqOAG2N1EM+7uE9wKqzRm0A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:MEMORY MANAGEMENT" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ke Wang <ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>

On Mon 04-04-22 17:23:43, Zhaoyang Huang wrote:
> On Mon, Apr 4, 2022 at 5:07 PM Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > On Mon, Apr 4, 2022 at 4:51 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > >
> > > On Mon 04-04-22 10:33:58, Zhaoyang Huang wrote:
> > > [...]
> > > > > One thing that I don't understand in this approach is: why memory.low
> > > > > should depend on the system's memory pressure. It seems you want to
> > > > > allow a process to allocate more when memory pressure is high. That is
> > > > > very counter-intuitive to me. Could you please explain the underlying
> > > > > logic of why this is the right thing to do, without going into
> > > > > technical details?
> > > > What I want to achieve is make memory.low be positive correlation with
> > > > timing and negative to memory pressure, which means the protected
> > > > memcg should lower its protection(via lower memcg.low) for helping
> > > > system's memory pressure when it's high.
> > >
> > > I have to say this is still very confusing to me. The low limit is a
> > > protection against external (e.g. global) memory pressure. Decreasing
> > > the protection based on the external pressure sounds like it goes right
> > > against the purpose of the knob. I can see reasons to update protection
> > > based on refaults or other metrics from the userspace but I still do not
> > > see how this is a good auto-magic tuning done by the kernel.
> > >
> > > > The concept behind is memcg's
> > > > fault back of dropped memory is less important than system's latency
> > > > on high memory pressure.
> > >
> > > Can you give some specific examples?
> > For both of the above two comments, please refer to the latest test
> > result in Patchv2 I have sent. I prefer to name my change as focus
> > transfer under pressure as protected memcg is the focus when system's
> > memory pressure is low which will reclaim from root, this is not
> > against current design. However, when global memory pressure is high,
> > then the focus has to be changed to the whole system, because it
> > doesn't make sense to let the protected memcg out of everybody, it
> > can't
> > do anything when the system is trapped in the kernel with reclaiming work.
> Does it make more sense if I describe the change as memcg will be
> protect long as system pressure is under the threshold(partially
> coherent with current design) and will sacrifice the memcg if pressure
> is over the threshold(added change)

No, not really. For one it is still really unclear why there should be any
difference in the semantic between global and external memory pressure
in general. The low limit is always a protection from the external
pressure. And what should be the actual threshold? Amount of the reclaim
performed, effectivness of the reclaim or what?
-- 
Michal Hocko
SUSE Labs
