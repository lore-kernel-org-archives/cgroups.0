From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH 0/3] memcg: more sophisticated stats flushing
Date: Wed, 13 Sep 2023 07:38:43 +0000
Message-ID: <20230913073846.1528938-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694591104; x=1695195904; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TER8l9tb6XZzOMFgeFSUUqc1AW9x7/45uI22fSAHiTA=;
        b=zqX1u6T24v63FwM5oiXBqKUxfT7wA7eHpHfU3nqWaUBaPEuc2qm6mwC7mxjVF9hMXb
         Hr46PFYQqw1YJCy1DL1Wa0LV5dj9Q+KCvYyvIgEUDS8+rZgwUSVBa34NoZmV+OC5ktJc
         au2R4K2s7O0PDVLAuADHma8mI/BRZdOljfnm11dOXSDopoJx09ZeYur04GvQ+ILrpxdJ
         nKtGJOvjOZuq/DioVM4l3GdnIZ3xUEk4yM2CJKOseOnP0Bnb5NttKtGEnCC96YJ57t7J
         vZaKrfZi5sIKsz+wotFF8wcAaHMOgGYJE9WtcpEdJ9snaz22YN6AYQ9gelIC0N56lweM
         qauQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Tejun Heo <tj@kernel.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, kernel-team@cloudflare.com, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

The current stats flushing approach is very simple. Everyone tries to
flush the entire tree, and only a single flusher is allowed. Concurrent
flushers just skip the flush completely. This approach has problems that
manifest in both flushing latency and stats accuracy (or freshness).
This series introduces a more sophisticated approach that aims to find a
better trade-off between accuracy and performance. Essentially we try to
get the best accuracy with the minimal amount of work done when possible
(fast path), and we fallback to more expensive or less accurate flushes
only when necessary. Details are in the commit message of patch 3, which
is really the core of this series.

Patches 1 & 2 are just cleanups with no functional change intended.

This series replaces v4 of "memcg: non-unified flushing for userspace
stats" series [1]. I did not send this as v5 as it completely deviates
from what that patchset is doing (but still trying to solve the same
problem). The approach followed in this series attempts to provide a
more generic framework for flushing for both userspace readers and
in-kernel flushers, to avoid having a lot of different flushing flavors.
It also benefits in-kernel flushers as well as userspace readers.

This series is a result of the discussions held in [1], and various
suggestions by Wei Xu <weixugc@google.com>.

[1] https://lore.kernel.org/lkml/20230831165611.2610118-1-yosryahmed@google.com/

Yosry Ahmed (3):
  mm: memcg: change flush_next_time to flush_last_time
  mm: memcg: rename stats_flush_threshold to stats_updates_order
  mm: memcg: optimize stats flushing for latency and accuracy

 include/linux/memcontrol.h |   4 +-
 mm/memcontrol.c            | 125 ++++++++++++++++++++++++++-----------
 mm/vmscan.c                |   2 +-
 mm/workingset.c            |   8 ++-
 4 files changed, 98 insertions(+), 41 deletions(-)

-- 
2.42.0.283.g2d96d420d3-goog

