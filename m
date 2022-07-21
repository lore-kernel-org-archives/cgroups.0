From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4] mm: vmpressure: don't count proactive reclaim in vmpressure
Date: Thu, 21 Jul 2022 08:58:06 -0700
Message-ID: <CAJD7tkZVcQ6xzdnGPS0kQAP=+Q=yZwVT_ZrLaEsAgkLi_DAMtQ@mail.gmail.com>
References: <20220714064918.2576464-1-yosryahmed@google.com>
 <YtfJug77XJ9BPA8L@dhcp22.suse.cz> <CALvZod7X3PsM2+ZrWXwb75FNBBjaBGJpjd+WVmzr5hStROvW+g@mail.gmail.com>
 <CAJD7tkYBm+L_-GTLDux0ZsJ6=kw-zzHjs6vgKUtmeZhcxLwqiw@mail.gmail.com> <Ytk8EBBEi4EubvPn@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=swGACW5Jh2L0fPaTYT636BPQVQeKVon43dJ9BYyWHwk=;
        b=r+w+mxLV3pDF7H2PvRP1rSgfVNzPHjXRHDyW0bx0FSpYp1xxdfqRoM2olAqDztXFE2
         PrymskSXxb/ztAY1MquHjtG0OPZHvYVoOyAxVVJizv2kBU3Q4X1K7qkH/BbNu30JXFtU
         jhWBX1Jy7Ww9lAN0MpXsAQhFSo5xgPmW7AAMUve3/2zmUkNLIZbDLkbOVMwQ42/Zvgxm
         Ti1H7+z6K/40JPEy9H0KmJ3GQHMbwo2S5TK+RhZh2SpFcwkIZHoA/HDnKg2724iqIleF
         GGmYpUbMNf8YGpByjFYxAiFmsiC7KoY1DCuYjnD3rpRD2ICk4RJIeYEkxerGu8ODGLx2
         Oc0Q==
In-Reply-To: <Ytk8EBBEi4EubvPn-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Xu <peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Thu, Jul 21, 2022 at 4:44 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Wed 20-07-22 11:02:56, Yosry Ahmed wrote:
> > On Wed, Jul 20, 2022 at 10:50 AM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > >
> > > On Wed, Jul 20, 2022 at 2:24 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > > >
> > > [...]
> > > >
> > > > I think what we are missing here is
> > > > - explain that this doesn't have any effect on existing users of
> > > >   vmpressure user interface because that is cgroup v1 and memory.reclaim
> > > >   is v2 feature. This is a trivial statement but quite useful for future
> > > >   readers of this commit
> > > > - explain the effect on the networking layer and typical usecases
> > > >   memory.reclaim is used for currently and ideally document that.
> > >
> > > I agree with the above two points (Yosry, please address those) but
> > > the following third point is orthogonal and we don't really need to
> > > have an answer for this patch to be accepted.
> > >
> >
> > That's great feedback, thanks Michal and Shakeel!
> >
> > How do you feel about the following commit message instead? Does it
> > address your concerns?:
> >
> > memory.reclaim is a cgroup v2 interface that allows users to
> > proactively reclaim memory from a memcg, without real memory pressure.
> > Reclaim operations invoke vmpressure, which is used in cgroup v1 to
> > notify userspace of reclaim efficiency, and used in both v1 and v2 as
> > a signal for a memcg being under memory pressure for networking (see
> > mem_cgroup_under_socket_pressure()). For the former, vmpressure
> > notifications in v1 are not affected by this change since
> > memory.reclaim is a v2 feature.
> >
> > For the latter, the effects of the vmpressure signal (according to
> > Shakeel [1]) are as follows:
> > 1. Reducing send and receive buffers of the current socket.
> > 2. May drop packets on the rx path.
> > 3. May throttle current thread on the tx path.
> >
> > Since proactive reclaim is invoked directly by userspace, not by
> > memory pressure, it makes sense not to throttle networking. Hence,
> > this change makes sure that proactive reclaim caused by memory.reclaim
> > does not trigger vmpressure.
>
> OK, looks much better. Please also add a note to the documentation about
> this side effect.

I don't want to add something to the documentation about throttling
networking because it seems like these are implementation details that
we may change in the future. I don't know if we can document this
behavior today and then change it later.

How about we document a more generic statement in memory.reclaim
documentation, like:

"With reactive reclaim operations triggered by the kernel, the kernel
may take further actions to alleviate memory pressure (such as
throttling networking memory consumption). For proactive reclaim
operations triggered by this interface, the kernel may choose to skip
such actions as reclaim is not an indication of memory pressure."

Does this make sense to you?

>
> Thanks!
> --
> Michal Hocko
> SUSE Labs
