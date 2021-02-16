From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [External] Re: [PATCH 4/4] mm: memcontrol: fix swap uncharge on
 cgroup v2
Date: Tue, 16 Feb 2021 09:16:24 -0800
Message-ID: <CALvZod4mjDPfRvs0EZw3nZW8TuZqvye61ExD98Qfpm9JtsbGtg@mail.gmail.com>
References: <20210212170159.32153-1-songmuchun@bytedance.com>
 <20210212170159.32153-4-songmuchun@bytedance.com> <CALvZod6tXn9qrRmzyspp+7usB-Xx4ayu6KrzmKvoU7zWajx85g@mail.gmail.com>
 <CAMZfGtUpsbiVW7AtBtfYjFvppv+7MmAcff_x872gbeMuv8zs3Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E45USrfwyuPTU85r3q5N9FFFgs4PphB6lqH5aUk4Cag=;
        b=uKAmePCYTggNcKv8e6HwrE/wfBPlHBLs09fukIDn1Ad8eGiyXdq6UVoUHACc5UoJCE
         3zvOhCdBL7paJpiTVqgjW/9Ln+PbRjS+i/9EK2u5XKpZQ8iRUEu1fvlDnBpoENJ61vJV
         xamLT1E0WOt/77sNcTXjJxBpkwIl5RrePfmtw0KFg2DKLqob1a4wdYxNfEB6iY+zZQLh
         T73T2gxzFEIfdIthKZ+fVjxhiCYxIDTziJVgXH7GQiAJOCvGXQZK0xyN017joVbw4A0I
         vLlIr+HnHG9caI+/8IiRynC1jQ7pDqyTTR8CIPFBsuFA8z4k9Hp5BTpdMneZU8Fsi1uF
         2WVg==
In-Reply-To: <CAMZfGtUpsbiVW7AtBtfYjFvppv+7MmAcff_x872gbeMuv8zs3Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Feb 12, 2021 at 10:48 PM Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
>
> On Sat, Feb 13, 2021 at 2:57 AM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > CCing more folks.
> >
> > On Fri, Feb 12, 2021 at 9:14 AM Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
> > >
> > > The swap charges the actual number of swap entries on cgroup v2.
> > > If a swap cache page is charged successful, and then we uncharge
> > > the swap counter. It is wrong on cgroup v2. Because the swap
> > > entry is not freed.
> > >
> > > Fixes: 2d1c498072de ("mm: memcontrol: make swap tracking an integral part of memory control")
> > > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> >
> > What's the user visible impact of this change?
>
> IIUC, I think that we cannot limit the swap to memory.swap.max
> on cgroup v2.
>
>   cd /sys/fs/cgroup/
>   mkdir test
>   cd test
>   echo 8192 > memory.max
>   echo 4096 > memory.swap.max
>
> OK. Now we limit swap to 1 page and memory to 2 pages.
> Firstly, we allocate 1 page from this memory cgroup and
> swap this page to swap disk. We can see:
>
>   memory.current: 0
>   memory.swap.current: 1
>
> Then we touch this page, we will swap in and charge
> the swap cache page to the memory counter and uncharge
> the swap counter.
>
>   memory.current: 1
>   memory.swap.current: 0 (but actually we use a swap entry)
>
> Then we allocate another 1 page from this memory cgroup.
>
>   memory.current: 2
>   memory.swap.current: 0 (but actually we use a swap entry)
>
> If we swap those 2 pages to swap disk. We can charge and swap
> those 2 pages successfully. Right? Maybe I am wrong.
>

I was trying to repro this but couldn't and later remembered that swap
on zram skips the swapcache and thus is not impacted by this issue.
This is reproducible on swap on disk and I see Johannes has already
described in good detail.
