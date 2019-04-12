From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 0/4] mm: memcontrol: memory.stat cost & correctness
Date: Fri, 12 Apr 2019 13:07:17 -0700
Message-ID: <CALvZod4-7a1aCELqWb+6xJ=-cPtfntNipAG634PA6UEQcN3Lag@mail.gmail.com>
References: <20190412151507.2769-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cWy39L110bpl90KlTOYN36nnj0m9Og8hXJw1+zoZDKk=;
        b=LP65T9uo0dVn2Y5omvF5mxvXGRfAgu6NngtzQkPAnlMx95MzRaoxUddWsZp48rD13D
         DVYmLNGVWFeqmVnvvMAV+nlf+frio4tA488tODN1HVqEvHfhTW5BOunil70RJ/PsIhYE
         AVgukhQXhJcaGfW/bxdzEpdpiwIo/iM6ZGTv3XE8Y3RuPKBM4A8WyrvK4tDNZUmeWYl9
         wLKIa898nv5rY6FJxM+Z2Bz1Tk8gGszZttNaJ7iQfD4v9jr1wIsYMwMZhHPbEWz/2gJT
         zl199wVxdgncig7ajSNj8hQEX/RicdcdKS2ywd0YJfPSMTtbNXfvLGLH43wX3vF0nHyC
         CWiA==
In-Reply-To: <20190412151507.2769-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team@fb.com

On Fri, Apr 12, 2019 at 8:15 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> The cgroup memory.stat file holds recursive statistics for the entire
> subtree. The current implementation does this tree walk on-demand
> whenever the file is read. This is giving us problems in production.
>
> 1. The cost of aggregating the statistics on-demand is high. A lot of
> system service cgroups are mostly idle and their stats don't change
> between reads, yet we always have to check them. There are also always
> some lazily-dying cgroups sitting around that are pinned by a handful
> of remaining page cache; the same applies to them.
>
> In an application that periodically monitors memory.stat in our fleet,
> we have seen the aggregation consume up to 5% CPU time.
>
> 2. When cgroups die and disappear from the cgroup tree, so do their
> accumulated vm events. The result is that the event counters at
> higher-level cgroups can go backwards and confuse some of our
> automation, let alone people looking at the graphs over time.
>
> To address both issues, this patch series changes the stat
> implementation to spill counts upwards when the counters change.
>
> The upward spilling is batched using the existing per-cpu cache. In a
> sparse file stress test with 5 level cgroup nesting, the additional
> cost of the flushing was negligible (a little under 1% of CPU at 100%
> CPU utilization, compared to the 5% of reading memory.stat during
> regular operation).

For whole series:

Reviewed-by: Shakeel Butt <shakeelb@google.com>

>
>  include/linux/memcontrol.h |  96 +++++++-------
>  mm/memcontrol.c            | 290 +++++++++++++++++++++++++++----------------
>  mm/vmscan.c                |   4 +-
>  mm/workingset.c            |   7 +-
>  4 files changed, 234 insertions(+), 163 deletions(-)
>
>
