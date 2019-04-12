From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 0/4] mm: memcontrol: memory.stat cost & correctness
Date: Fri, 12 Apr 2019 11:15:03 -0400
Message-ID: <20190412151507.2769-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ExcVMXKMLAIGNf5KmSqXrW5PdcB9ts4NWl7/RwgO/jI=;
        b=otZiKvwBqdW+yp5E+sxlXMkmP/ZdX7vWtbD/mtd0dHs4PrW2KX3YuzFsZUDMkuJgc/
         w0UCkKwKdoYReI/dgPptzYV3khKBw7sj2riOqQ8G6vyQd6uSAtjgisNqVmD8di5ZiEqs
         Zw4BXpu40szBooKU5UTvQRGYhF7Gg+ic4rFebiZ5bv3sypeI/TiR625hnOx3fhnSWwzk
         aY9eyFzrLAiiyGiQYzvyO9HFpdX3PZ4wj/lfwRflCHJJUwNEBFWwL7sZvDIJ31Owagc4
         4KHAfGjPzWg9oqhFZ0KqE8gwCnV8C7jmrR+57NKQuzD6XBgU9SRxPlt99lPgk9K2KgXl
         JEUg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

The cgroup memory.stat file holds recursive statistics for the entire
subtree. The current implementation does this tree walk on-demand
whenever the file is read. This is giving us problems in production.

1. The cost of aggregating the statistics on-demand is high. A lot of
system service cgroups are mostly idle and their stats don't change
between reads, yet we always have to check them. There are also always
some lazily-dying cgroups sitting around that are pinned by a handful
of remaining page cache; the same applies to them.

In an application that periodically monitors memory.stat in our fleet,
we have seen the aggregation consume up to 5% CPU time.

2. When cgroups die and disappear from the cgroup tree, so do their
accumulated vm events. The result is that the event counters at
higher-level cgroups can go backwards and confuse some of our
automation, let alone people looking at the graphs over time.

To address both issues, this patch series changes the stat
implementation to spill counts upwards when the counters change.

The upward spilling is batched using the existing per-cpu cache. In a
sparse file stress test with 5 level cgroup nesting, the additional
cost of the flushing was negligible (a little under 1% of CPU at 100%
CPU utilization, compared to the 5% of reading memory.stat during
regular operation).

 include/linux/memcontrol.h |  96 +++++++-------
 mm/memcontrol.c            | 290 +++++++++++++++++++++++++++----------------
 mm/vmscan.c                |   4 +-
 mm/workingset.c            |   7 +-
 4 files changed, 234 insertions(+), 163 deletions(-)


