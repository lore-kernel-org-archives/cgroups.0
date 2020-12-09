From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH v2] mm: memcontrol: optimize per-lruvec
 stats counter memory usage
Date: Wed, 9 Dec 2020 10:31:55 +0800
Message-ID: <CAMZfGtUMP6mz3DE7DHS55fyto=LZuQpcitt59WuwhZw8m2LqBg@mail.gmail.com>
References: <20201208095132.79383-1-songmuchun@bytedance.com> <20201209022118.GB2385286@carbon.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lpLy5o85Uv8KFkEXX1qh8QHfnClzTv7IW4GkyuNRa/I=;
        b=iol7HVumr2vVfjJpGSYJsjp2//+4swLMulHc2gpp0zagvSLlssLPP9K3PRtq2X6zMy
         Po5hMnqSAA28ZIbmek9aOm0SSGmzdrpc5dZLVJ4bMUVEj0uC3X3jZ9G6A+z8LrQIi033
         +PK6fgSurp1M2od/4Td4FLHZZo1TXLt3GWL1FhWnJIJNmZWuAwNC/TPlLHYR96nthc9V
         Qj4+z5EjXrBaKWai2A4XYuBgu0phbWuur699cOnNUw7tYen7UJX3dm0rXvKlgUGn6asC
         wN0X9e+wv9i6vOlueoBI/4+SXBLMYWtrQrWQMYleF0cx+FYfqbfCsfmdDd4SkWvNPLIN
         I3jg==
In-Reply-To: <20201209022118.GB2385286-lLJQVQxiE4uLfgCeKHXN1g2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Wed, Dec 9, 2020 at 10:21 AM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
>
> On Tue, Dec 08, 2020 at 05:51:32PM +0800, Muchun Song wrote:
> > The vmstat threshold is 32 (MEMCG_CHARGE_BATCH), so the type of s32
> > of lruvec_stat_cpu is enough. And introduce struct per_cpu_lruvec_stat
> > to optimize memory usage.
> >
> > The size of struct lruvec_stat is 304 bytes on 64 bits system. As it
> > is a per-cpu structure. So with this patch, we can save 304 / 2 * ncpu
> > bytes per-memcg per-node where ncpu is the number of the possible CPU.
> > If there are c memory cgroup (include dying cgroup) and n NUMA node in
> > the system. Finally, we can save (152 * ncpu * c * n) bytes.
>
> Honestly, I'm not convinced.
> Say, ncpu = 32, n = 2, c = 500. We're saving <5Mb of memory.
> If the machine has 128Gb of RAM, it's .000000003%.

Hi Roman,

When the cpu hotplug is enabled, the ncpu can be 256 on
some configurations. Also, the c can be more large when
there are many dying cgroup in the system.

So the savings depends on the environment and
configurations. Right?


>
> Using longs (s64) allows not to think too much about overflows
> and can also be slightly faster on 64-bit machines.
>
> Thanks!


