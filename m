From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 0/6] mm: memcontrol: clean up the LRU counts tracking
Date: Thu, 28 Feb 2019 11:30:14 -0500
Message-ID: <20190228163020.24100-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r8ZvTCXRT2zhzdpNdKlPpMAbuU1N2QujZ8hztSmYHqE=;
        b=XuAtCfvAHvwTNFMx0qa1F9819pfkkTzHRKOpVaq3vLzhJJZC5lnmioCoV1xfLmgkpJ
         dUDLdfUT4PSmGDHSEcRyAbTij36xsmu5kZSwyjfKZJaAemf6Nbsl6VsdV2r7ap0+WDaQ
         YeOgPqmKIuQpdHTdijMZXbriMUePvgXWfVccv3ivtj43bnZYtbkhClWW1EPrqHeSPisz
         eT80DHEtMFihomuG7eX6Ia1aWE2lXirpvQlmhq3SKiQyN+IljLh2hhi3TEkTJ+u7+Fqg
         v67gmTMwN7XQbZDsN65N671ZQ9Ej1pqoyH1IfvfoZ8BGby5L3JOkc952FiSNY9U8dvb+
         Ut1w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

[ Resend #2: Sorry about the spam, I mixed up the header fields in
  git-send-email and I don't know who did and didn't receive the
  garbled previous attempt.

  Resend #1: Rebased on top of the latest mmots. ]

The memcg LRU stats usage is currently a bit messy. Memcg has private
per-zone counters because reclaim needs zone granularity sometimes,
but we also have plenty of users that need to awkwardly sum them up to
node or memcg granularity. Meanwhile the canonical per-memcg vmstats
do not track the LRU counts (NR_INACTIVE_ANON etc.) as you'd expect.

This series enables LRU count tracking in the per-memcg vmstats array
such that lruvec_page_state() and memcg_page_state() work on the enum
node_stat_item items for the LRU counters. Then it converts all the
callers that don't specifically need per-zone numbers over to that.

 include/linux/memcontrol.h | 28 ---------------
 include/linux/mm_inline.h  |  2 +-
 include/linux/mmzone.h     |  5 ---
 mm/memcontrol.c            | 85 +++++++++++++++++++++++++-------------------
 mm/vmscan.c                |  2 +-
 mm/workingset.c            |  5 +--
 6 files changed, 54 insertions(+), 73 deletions(-)


