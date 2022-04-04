From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: introduce dynamic protection for memcg
Date: Mon, 4 Apr 2022 10:51:48 +0200
Message-ID: <YkqxpEW4m6iU3zMq@dhcp22.suse.cz>
References: <1648713656-24254-1-git-send-email-zhaoyang.huang@unisoc.com>
 <YkVt0m+VxnXgnulq@dhcp22.suse.cz>
 <CAGWkznF4qb2EP3=xVamKO8qk08vaFg9JeHD7g80xvBfxm39Hkg@mail.gmail.com>
 <YkWR8t8yEe6xyzCM@dhcp22.suse.cz>
 <CAGWkznHxAD0757m1i1Csw1CVRDtQddfCL08dYf12fa47=-uYYQ@mail.gmail.com>
 <YkbjNYMY8VjHoSHR@dhcp22.suse.cz>
 <CAGWkznF7cSyPU0ceYwH6zweJzf-X1bQnS6AJ2-J+WEL0u8jzng@mail.gmail.com>
 <CAJuCfpHneDZMXO_MmQDPA+igAOdAPRUChiq+zftFXGfDzPHNhQ@mail.gmail.com>
 <CAGWkznFTQCm0cusVxA_55fu2WfT-w2coVHrT=JA1D_9_2728mQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649062309; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8dVesPMKaUut+TR+yGDooheAhutrkDr3IKERwS5AoSk=;
        b=llLqVXQVAuNVhRTxpopykvgOo5UDxL0+UVttQORgi7aeqOzxr0beKggQRRtiym8WzDZ4Qt
        GbJRJ10wLx240JOdmPbpx+/0eROIKFzQSN+bI6CSp2pTBrhNp1eNW3sGqfCOjn9fiS01bc
        30ovvrP+E6SgyIM6U5zj5D9JlKi04HM=
Content-Disposition: inline
In-Reply-To: <CAGWkznFTQCm0cusVxA_55fu2WfT-w2coVHrT=JA1D_9_2728mQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:MEMORY MANAGEMENT" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ke Wang <ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>

On Mon 04-04-22 10:33:58, Zhaoyang Huang wrote:
[...]
> > One thing that I don't understand in this approach is: why memory.low
> > should depend on the system's memory pressure. It seems you want to
> > allow a process to allocate more when memory pressure is high. That is
> > very counter-intuitive to me. Could you please explain the underlying
> > logic of why this is the right thing to do, without going into
> > technical details?
> What I want to achieve is make memory.low be positive correlation with
> timing and negative to memory pressure, which means the protected
> memcg should lower its protection(via lower memcg.low) for helping
> system's memory pressure when it's high.

I have to say this is still very confusing to me. The low limit is a
protection against external (e.g. global) memory pressure. Decreasing
the protection based on the external pressure sounds like it goes right
against the purpose of the knob. I can see reasons to update protection
based on refaults or other metrics from the userspace but I still do not
see how this is a good auto-magic tuning done by the kernel.

> The concept behind is memcg's
> fault back of dropped memory is less important than system's latency
> on high memory pressure.

Can you give some specific examples?

> Please refer to my new version's test data
> for more detail.

Please note that sending new RFCs will just make the discussion spread
over several email threads which will get increasingly hard to follow.
So do not post another version until it is really clear what is the
actual semantic you are proposing.

-- 
Michal Hocko
SUSE Labs
