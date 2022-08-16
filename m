From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH] mm: memcg: export workingset refault stats for cgroup v1
Date: Tue, 16 Aug 2022 15:45:33 -0700
Message-ID: <CAJD7tkZrQZ8CR0E0vKnXGWFLPChxFmNaSQUkFAm1icnGnE6Tew@mail.gmail.com>
References: <20220816185801.651091-1-shy828301@gmail.com> <CALvZod5t7Qo1NQ040pRyWco+nJGn3hSrxZyuFQ0UBi31Ni6=_g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=s8pSl43fKh9JnCgmD3zX1WMUhwtcyLQMOInMOIHCWPM=;
        b=thGApBqcLsCEmh3pIRfPPTjA3/bLHUE0lVp6KZuhpZ8/XaxKjSsw2BgdMdYpP7ymnM
         ESvhyZMAMxvD3tRAEHWhsBP4GBQ7bWNSFVOiHm8hVtj7TtWfbSO7esaMlrJdPbZVLxNL
         CYhy1R0vjrjAWOGyIkBU1oDpc7QJ07rRnQEI96teV0fQ7kB206wfqAtWu/n5JTBwin+Y
         gfYvRzKW0pP5oI6tx+cfkf8sbbDsqbDcDAmH/p3uB1UdWO0XuhgPb1atJCwrJPXkl4ZR
         z7vyDT8KVdEDBNzSqmC9WOKYvYldB8VcollbxJa2iys4s4DTw12zi5MwFE7uJjE7PIWS
         1jNQ==
In-Reply-To: <CALvZod5t7Qo1NQ040pRyWco+nJGn3hSrxZyuFQ0UBi31Ni6=_g@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Yang Shi <shy828301@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Tue, Aug 16, 2022 at 3:06 PM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Tue, Aug 16, 2022 at 11:58 AM Yang Shi <shy828301@gmail.com> wrote:
> >
> > Workingset refault stats are important and usefule metrics to measure
> > how well reclaimer and swapping work and how healthy the services are,
> > but they are just available for cgroup v2.  There are still plenty users
> > with cgroup v1, export the stats for cgroup v1.
> >
> > Signed-off-by: Yang Shi <shy828301@gmail.com>
> > ---
> > I do understand the development of cgroup v1 is actually stalled and
> > the community is reluctant to accept new features for v1.  However
> > the workingset refault stats are really quite useful and exporting
> > two new stats, which have been supported by v2, seems ok IMHO.  So
> > hopefully this patch could be considered.  Thanks.
> >
>
> Is just workingset refault good enough for your use-case? What about
> the other workingset stats? I don't have a strong opinion against
> adding these to v1 and I think these specific stats should be fine.
> (There is subtlety in exposing objcg based stats (i.e. reparenting) in
> v1 due to non-hierarchical stats in v1. I remember Yosry and Muchun
> were looking into that.)

I think only kernel memory stats and zswap stats are objcg-based at
this point, right? The workingset refault stats seem to be memcg-based
and should not face the reparenting problem.
