From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH 0/3] memcg: non-unified flushing for userspace stats
Date: Mon, 21 Aug 2023 20:54:55 +0000
Message-ID: <20230821205458.1764662-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692651301; x=1693256101;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kxBzNRuKT3FK2xpnd0zI9fHxTniHJWyags4nIBlfqGo=;
        b=VapQsrLTsIuBdCvmJlnkDnAHLl9uwXYyl4pfelPDhgZfBCaf5UuJw/4Df69B1daF5W
         gCChcu7YIx6NYtBnd3VU2xjT4LtJH6C/uxHDF7ZH/XP0VUHjmQ+px5zJGjW8u6Pyo3Oj
         yj/4S4uWg7n3+4ebepXr/CillPdeCpQ5UBCWFWdu+mHPXoiOzfNDuksE7H66dECQgKT6
         m1AWJKvfJ8wt7vsYfZxBy4KRUdv08ei+xhliPGh0s3uythMQplNFuk0BbdjYyAumUH0L
         lIyQdhxBjiYhgCOEDtvGnrQH3rbPBra4M16LsQzP1POusk9aDfzM4/jaIedXoVa+MnbM
         DV9g==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

Most memcg flushing contexts using "unified" flushing, where only one
flusher is allowed at a time (others skip), and all flushers need to
flush the entire tree. This works well with high concurrency, which
mostly comes from in-kernel flushers (e.g. reclaim, refault, ..).

For userspace reads, unified flushing leads to non-deterministic stats
staleness and reading cost. This series clarifies and documents the
differences between unified and non-unified flushing (patches 1 & 2),
then opts userspace reads out of unified flushing (patch 3).

This patch series is a follow up on the discussion in [1]. That was a
patch that proposed that userspace reads wait for ongoing unified
flushers to complete before returning. There were concerns about the
latency that this introduces to userspace reads, especially with ongoing
reports of expensive stat reads even with unified flushing. Hence, this
series follows a different approach, by opting userspace reads out of
unified flushing completely. The cost of userspace reads are now
determinstic, and depend on the size of the subtree being read. This
should fix both the *sometimes* expensive reads (due to flushing the
entire tree) and occasional staless (due to skipping flushing).

I attempted to remove unified flushing completely, but noticed that
in-kernel flushers with high concurrency (e.g. hundreds of concurrent
reclaimers). This sort of concurrency is not expected from userspace
reads. More details about testing and some numbers in the last patch's
changelog.

[1]https://lore.kernel.org/lkml/20230809045810.1659356-1-yosryahmed@google.com/
[2]https://lore.kernel.org/lkml/CABWYdi0c6__rh-K7dcM_pkf9BJdTRtAU08M43KO9ME4-dsgfoQ@mail.gmail.com/

Yosry Ahmed (3):
  mm: memcg: properly name and document unified stats flushing
  mm: memcg: add a helper for non-unified stats flushing
  mm: memcg: use non-unified stats flushing for userspace reads

 include/linux/memcontrol.h |  8 ++---
 mm/memcontrol.c            | 74 +++++++++++++++++++++++++++-----------
 mm/vmscan.c                |  2 +-
 mm/workingset.c            |  4 +--
 4 files changed, 60 insertions(+), 28 deletions(-)

-- 
2.42.0.rc1.204.g551eb34607-goog

