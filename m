From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v3 0/7] mm: reparent slab memory on cgroup removal
Date: Tue, 14 May 2019 12:22:08 -0700
Message-ID: <CALvZod4GscZjob8bfCcfhsMh0sco16r4yfOaRU69WnNO7MRrpw@mail.gmail.com>
References: <20190508202458.550808-1-guro@fb.com> <CALvZod4WGVVq+UY_TZdKP_PHdifDrkYqPGgKYTeUB6DsxGAdVw@mail.gmail.com>
 <20190513202146.GA18451@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YfOaL1oTnK5xA4uooC11ryURNw9L/10wivCSX2gcjCo=;
        b=GAaDgk7n/tpFRiZ3MVfd/nTZvVS8gOy9QgwY0WSf+e6tOSWEVi0YrWAMv5RFGbDprW
         AjTBdJhyEJCjt5jOANifS7VPXwOs1izpQ8BJUlZI9YWzJXVBYvd/JcdbIcJBIH0/qsJ1
         c4PWmrJK0W5UxolQRTIAsskkAi4l2CLZZFPhxLpq7OePR8qRs4NhOZbAzQJfY5LoJXdd
         7wWIKB/86sHuEiWNzyWBGD2BwCh+MX18mViRjbaLzDupK9+NmsOZ2YhjXGjy5CQV3Ivw
         HwxFWXerI5hfYo9iqcWrLsrzxwQdbaVmFuOVKt1BHFvq7LErJFjomK170O3fUcF8HlJf
         C6kw==
In-Reply-To: <20190513202146.GA18451@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Christoph Lameter <cl@linux.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Cgroups <cgroups@vger.kernel.org>

From: Roman Gushchin <guro@fb.com>
Date: Mon, May 13, 2019 at 1:22 PM
To: Shakeel Butt
Cc: Andrew Morton, Linux MM, LKML, Kernel Team, Johannes Weiner,
Michal Hocko, Rik van Riel, Christoph Lameter, Vladimir Davydov,
Cgroups

> On Fri, May 10, 2019 at 05:32:15PM -0700, Shakeel Butt wrote:
> > From: Roman Gushchin <guro@fb.com>
> > Date: Wed, May 8, 2019 at 1:30 PM
> > To: Andrew Morton, Shakeel Butt
> > Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
> > <kernel-team@fb.com>, Johannes Weiner, Michal Hocko, Rik van Riel,
> > Christoph Lameter, Vladimir Davydov, <cgroups@vger.kernel.org>, Roman
> > Gushchin
> >
> > > # Why do we need this?
> > >
> > > We've noticed that the number of dying cgroups is steadily growing on most
> > > of our hosts in production. The following investigation revealed an issue
> > > in userspace memory reclaim code [1], accounting of kernel stacks [2],
> > > and also the mainreason: slab objects.
> > >
> > > The underlying problem is quite simple: any page charged
> > > to a cgroup holds a reference to it, so the cgroup can't be reclaimed unless
> > > all charged pages are gone. If a slab object is actively used by other cgroups,
> > > it won't be reclaimed, and will prevent the origin cgroup from being reclaimed.
> > >
> > > Slab objects, and first of all vfs cache, is shared between cgroups, which are
> > > using the same underlying fs, and what's even more important, it's shared
> > > between multiple generations of the same workload. So if something is running
> > > periodically every time in a new cgroup (like how systemd works), we do
> > > accumulate multiple dying cgroups.
> > >
> > > Strictly speaking pagecache isn't different here, but there is a key difference:
> > > we disable protection and apply some extra pressure on LRUs of dying cgroups,
> >
> > How do you apply extra pressure on dying cgroups? cgroup-v2 does not
> > have memory.force_empty.
>
> I mean the following part of get_scan_count():
>         /*
>          * If the cgroup's already been deleted, make sure to
>          * scrape out the remaining cache.
>          */
>         if (!scan && !mem_cgroup_online(memcg))
>                 scan = min(lruvec_size, SWAP_CLUSTER_MAX);
>
> It seems to work well, so that pagecache alone doesn't pin too many
> dying cgroups. The price we're paying is some excessive IO here,

Thanks for the explanation. However for this to work, something still
needs to trigger the memory pressure until then we will keep the
zombies around. BTW the get_scan_count() is getting really creepy. It
needs a refactor soon.

> which can be avoided had we be able to recharge the pagecache.
>

Are you looking into this? Do you envision a mount option which will
tell the filesystem is shared and do recharging on the offlining of
the origin memcg?

> Btw, thank you very much for looking into the patchset. I'll address
> all comments and send v4 soon.
>

You are most welcome.

thanks,
Shakeel
