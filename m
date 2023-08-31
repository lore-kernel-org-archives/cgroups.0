From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 0/4] memcg: non-unified flushing for userspace stats
Date: Thu, 31 Aug 2023 16:56:07 +0000
Message-ID: <20230831165611.2610118-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693500973; x=1694105773; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gOQaXSmI19T3CmRXHqALPzLoBcwM1iddQy4gNQ1FwHI=;
        b=3Mk6IsV5i8zXUYIam0xe89FspudrAHmbi76z1/AanIj7zaz/8mf19LVT95ZWrINPCt
         tVTgT6Cp102pT6jPl9hG0OLr8kkiLjBOLEAxB2fhaXVxfPKMBx+3nOidqUbxG0pxf0O8
         h+kLxR0bvZQ3OHizNZbxM8FAW2896SZIvhizip2lcHbTSugx0UlfamoiPOCr69PDrRUB
         vyMkIx1fYNvFXBIafiDNwUBDlOaOQUskoTd2fjpsHRQ46GCk6FVbLRjRvLYXb2/Fc2wn
         3YuX7VPQlsNjYXdqNTOzTL053ujzxwzWa4rKLV/+h6oXpSypwRrbbBZBfFQkZjhW7a/2
         r73Q==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

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

v4 -> v5:
- Fixed build error in the last patch with W=1 because of a missed
  'static'.

v4: https://lore.kernel.org/lkml/20230830175335.1536008-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/

Yosry Ahmed (4):
  mm: memcg: properly name and document unified stats flushing
  mm: memcg: add a helper for non-unified stats flushing
  mm: memcg: let non-unified root stats flushes help unified flushes
  mm: memcg: use non-unified stats flushing for userspace reads

 include/linux/memcontrol.h |   8 +--
 mm/memcontrol.c            | 106 +++++++++++++++++++++++++++----------
 mm/vmscan.c                |   2 +-
 mm/workingset.c            |   4 +-
 4 files changed, 85 insertions(+), 35 deletions(-)

-- 
2.42.0.rc2.253.gd59a3bf2b4-goog

