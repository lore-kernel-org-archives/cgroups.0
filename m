From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2] memcg: refill_stock for kmem uncharging too
Date: Sun, 28 Apr 2019 16:54:24 -0700
Message-ID: <CALvZod5Peau7D-O1oi0jFfiOCJrSOMHDnr6TPrTxawt_jh9izw@mail.gmail.com>
References: <20190423154405.259178-1-shakeelb@google.com> <20190425064858.GL12751@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sJzmJt5dXSr46qHnoNS5EATc+3d/a2ElrqvTmuSBEdg=;
        b=vtb874mzD79EZ4lK/FKahzxhVi0KRxJCPlqZoqswyk+2KOM5zWGrGYQuwyAm+T22Tw
         owM7xGx6+2XBrBj5iKgttpXndlokSkCdXaHqUeHOFf+PlXlCZ2yp0uwBGU9kHmPDBaP3
         NPMqftVpxG32Ym3soeW3UjOB6L1fPjZDBlyMdNqNwt9OVII2tfrlqfl/gnvIPU3bMaZn
         cUVYDFNlR55+wB/mdDdGu/qVqcG7ro7bhCZ4ZElgyYQOn/W0/DI1IikYofKRbuRkkoiy
         mESCGm4KqIGV5Jq0W0rf0Z4UcYiBTtc6ftKlNJ6VQTSglnjByMoBHVI/DsH9MW04d21q
         MSfw==
In-Reply-To: <20190425064858.GL12751@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Wed, Apr 24, 2019 at 11:49 PM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Tue 23-04-19 08:44:05, Shakeel Butt wrote:
> > The commit 475d0487a2ad ("mm: memcontrol: use per-cpu stocks for socket
> > memory uncharging") added refill_stock() for skmem uncharging path to
> > optimize workloads having high network traffic. Do the same for the kmem
> > uncharging as well. Though we can bypass the refill for the offlined
> > memcgs but it may impact the performance of network traffic for the
> > sockets used by other cgroups.
>
> While the change makes sense, I would really like to see what kind of
> effect on performance does it really have. Do you have any specific
> workload that benefits from it?
>

Thanks for the review. I will run some benchmarks and report back later.

Shakeel
