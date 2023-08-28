From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/4] memcg: non-unified flushing for userspace stats
Date: Mon, 28 Aug 2023 23:33:14 +0000
Message-ID: <20230828233319.340712-1-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693265602; x=1693870402;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KQTsLL1n7cCq71JxJGUMYc54rEwbEyB3OuO4iu2aarw=;
        b=UPEryLU2GgdQoGyZh3R8dc8akU7NKnHSY8YQq196qyPn5q7YC7C+9h8N9EB+FtnlHs
         GZNJt9Hw1VKSRbB9r4AqsYFwfY7d/dbJ7z8C6CKrqsjGtNdWtPLvVLEh8T4Ivzysl93l
         qSxDurpdYj2UpjTQUnZw48OSObetl2LyyihLIiPl83eIL29OfNsAXdhOFvI+Vzuqkgl9
         tGLw3ltaCZA7nrlI4vfrJ8x3Bf7bbke3gB/moM8qrDVrz1N2z7p8VThO+vxf8IiIezzq
         repAHOCi/EM9d70gn4esvBCcaVXNySYPtOU1gg/KTODmwhL7fgqK2QcyXNaFrtoP8gsq
         hpQQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
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

v1 -> v2:
- Added patch 3 to help unified stats with non-unified root flushes
  as suggested by Michal Koutn=C3=BD.
- Updated the last patch changelog after discussions with Michal Hocko,
  Shakeel Butt, and Waiman Long.

Yosry Ahmed (4):
  mm: memcg: properly name and document unified stats flushing
  mm: memcg: add a helper for non-unified stats flushing
  mm: memcg: let non-unified root stats flushes help unified flushes
  mm: memcg: use non-unified stats flushing for userspace reads

 include/linux/memcontrol.h |  8 ++--
 mm/memcontrol.c            | 83 ++++++++++++++++++++++++++------------
 mm/vmscan.c                |  2 +-
 mm/workingset.c            |  4 +-
 4 files changed, 65 insertions(+), 32 deletions(-)

--=20
2.42.0.rc2.253.gd59a3bf2b4-goog

