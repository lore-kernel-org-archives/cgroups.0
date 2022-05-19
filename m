From: Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] Add swappiness argument to memory.reclaim
Date: Thu, 19 May 2022 08:29:32 -0700
Message-ID: <CAAPL-u-e=yZT7_N2oVNhpPnM=1Fg=JhCF-0xoMoFZfq8Kgw3zQ@mail.gmail.com>
References: <CAJD7tkbDpyoODveCsnaqBBMZEkDvshXJmNdbk51yKSNgD7aGdg@mail.gmail.com>
 <YoNHJwyjR7NJ5kG7@dhcp22.suse.cz> <CAJD7tkYnBjuwQDzdeo6irHY=so-E8z=Kc_kZe52anMOmRL+8yA@mail.gmail.com>
 <YoQAVeGj19YpSMDb@cmpxchg.org> <CAAPL-u8pZ_p+SQZnr=8UV37yiQpWRZny7g9p6YES0wa+g_kMJw@mail.gmail.com>
 <YoYFKdqayKRw2npp@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TTppzXqGXGzezJ0VNR/10YUamTL+Jpn/a+OS4nEwUs0=;
        b=aJRufbeVPWWTg6xesgVQ92jTkUBXkj4204NtsTRRuXhSDjPb8Xkpo0bNaK4046hFnv
         mLKgwhvsh9GAmI2LFDkeF6HnSFJOYseaJ+p8tes7OyljSbloK0G+33o31Bpt84fkfCb4
         J38wGhcIGfbVqDVaOHU/qKlZO1PRo09oJVwe8Kq8Gjr8j7VY4qHpf1GeZdyugHi00mzw
         aPj5qp0lnQNuRwPUHk0H544OPn69tIDaGuwVRtFJw5cVWxmIclVYYJ1OVG+xA+X0wkh6
         EFpAbJrZNyvmy90Vgh11onsTrIn9w5C0EYbSgXGfpC4kZqk73crIwyt6vZPv3EiDdghA
         AwgQ==
In-Reply-To: <YoYFKdqayKRw2npp-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chen Wandun <chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Thu, May 19, 2022 at 1:51 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Wed 18-05-22 22:44:13, Wei Xu wrote:
> > On Tue, May 17, 2022 at 1:06 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> [...]
> > > But I don't think an anon/file bias will capture this coefficient?
> >
> > It essentially provides the userspace proactive reclaimer an ability
> > to define its own reclaim policy by adding an argument to specify
> > which type of pages to reclaim via memory.reclaim.
>
> I am not sure the swappiness is really a proper interface for that.
> Historically this tunable has changed behavior several times and the
> reclaim algorithm is free to ignore it completely in many cases. If you
> want to build a userspace reclaim policy, then it really has to have a
> predictable and stable behavior. That would mean that the semantic would
> have to be much stronger than the global vm_swappiness.

I agree. As what I replied to Roman's comments earlier, it is cleaner
to just specify the type of pages to reclaim.

> --
> Michal Hocko
> SUSE Labs
