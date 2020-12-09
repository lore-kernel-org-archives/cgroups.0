From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [External] Re: [PATCH v2] mm: memcontrol: optimize per-lruvec
 stats counter memory usage
Date: Tue, 8 Dec 2020 19:52:35 -0800
Message-ID: <20201209031115.GA2390587@carbon.lan>
References: <20201208095132.79383-1-songmuchun@bytedance.com>
 <20201209022118.GB2385286@carbon.DHCP.thefacebook.com>
 <CAMZfGtUMP6mz3DE7DHS55fyto=LZuQpcitt59WuwhZw8m2LqBg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=j84ueRbd5U3HePmJX5oQjdX2Bf/TWLQOa+LPbgAb1Ko=;
 b=Krnsx0yvhpkI4pPM9qxyOcv/0F765WRZTDCUG5lDowoCDin6aagiFAQ7eVDgE0pr7EFE
 JhpkP1GJwItPFVyhZvuhtowa0Mtx/Z34FNRTM+VYpPysea1LbNO9TV/JI08fMmDc5yZb
 kmTdGlIVVcav0/tN6qv7AnJrHUx0lYirf5U= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j84ueRbd5U3HePmJX5oQjdX2Bf/TWLQOa+LPbgAb1Ko=;
 b=E3QxU9N/E805zJ30GyhAnQUjnTiv1FAgwSAnsJN4GyUp5BDOL2FQx9THo5jTfmsKAdZbXWaKcIMLCBQ4F5AVjEBDvqc4hBk0EPJqBPtfYbE1tEt6+FkG1Jqd7DmPHS05JM40WSJwXitydqK0buZFLvgyeVj5Moh0Fj+6OXDCSkE=
Content-Disposition: inline
In-Reply-To: <CAMZfGtUMP6mz3DE7DHS55fyto=LZuQpcitt59WuwhZw8m2LqBg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Wed, Dec 09, 2020 at 10:31:55AM +0800, Muchun Song wrote:
> On Wed, Dec 9, 2020 at 10:21 AM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> >
> > On Tue, Dec 08, 2020 at 05:51:32PM +0800, Muchun Song wrote:
> > > The vmstat threshold is 32 (MEMCG_CHARGE_BATCH), so the type of s32
> > > of lruvec_stat_cpu is enough.

Actually the threshold can be as big as MEMCG_CHARGE_BATCH * PAGE_SIZE.
It still fits into s32, but without explicitly saying it it's hard to
understand why not choosing s8, as in vmstat.c.

> > >
> > > The size of struct lruvec_stat is 304 bytes on 64 bits system. As it
> > > is a per-cpu structure. So with this patch, we can save 304 / 2 * ncpu
> > > bytes per-memcg per-node where ncpu is the number of the possible CPU.
> > > If there are c memory cgroup (include dying cgroup) and n NUMA node in
> > > the system. Finally, we can save (152 * ncpu * c * n) bytes.
> >
> > Honestly, I'm not convinced.
> > Say, ncpu = 32, n = 2, c = 500. We're saving <5Mb of memory.
> > If the machine has 128Gb of RAM, it's .000000003%.
> 
> Hi Roman,
> 
> When the cpu hotplug is enabled, the ncpu can be 256 on
> some configurations. Also, the c can be more large when
> there are many dying cgroup in the system.
> 
> So the savings depends on the environment and
> configurations. Right?

Of course, but machines with more CPUs tend to have more RAM as well.

Thanks!
