From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH 2/3] mm: page_counter: rearrange struct page_counter fields
Date: Mon, 22 Aug 2022 00:17:36 +0000
Message-ID: <20220822001737.4120417-3-shakeelb@google.com>
References: <20220822001737.4120417-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=V/ZZIFSPKFcCAZIO5J88CNRgR4nImf4CDqSEwHgZtc8=;
        b=VRt8PiD5az0Dl+WRznAYAHoEFU2MambiOUqw9hJIF1ucU60TS0sVFR1bUuaJD8nPng
         xGG21VhjqfptsMV9A8m6NtDIcNUxnu3moTzE7NDuS0132TTFDbZUQdoq7PUgYhDiEc88
         VWXGevOtBTC071FhOwLWbdC2RbpbtXjJBP30qVmnMrkSyaRORF9MkIgIOE44YT8fPxhx
         MXMroQq5cbkgX/PlRdMgvF1WbQYDo+Czb0BC6hLgVyoEUZLM+nIZRg1Iz+BkUSiS19+u
         NDrsfq1Tm8UcqdVd/B6tTxgxOaUMNvPwSrhSYvXv0b64wiY5pKs+NN5viMa0qiHMezJn
         gzSQ==
In-Reply-To: <20220822001737.4120417-1-shakeelb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <songmuchun@bytedance.com>
Cc: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Eric Dumazet <edumazet@google.com>, Soheil Hassas Yeganeh <soheil@google.com>, Feng Tang <feng.tang@intel.com>, Oliver Sang <oliver.sang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, lkp@lists.01.org, cgroups@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>

With memcg v2 enabled, memcg->memory.usage is a very hot member for
the workloads doing memcg charging on multiple CPUs concurrently.
Particularly the network intensive workloads. In addition, there is a
false cache sharing between memory.usage and memory.high on the charge
path. This patch moves the usage into a separate cacheline and move all
the read most fields into separate cacheline.

To evaluate the impact of this optimization, on a 72 CPUs machine, we
ran the following workload in a three level of cgroup hierarchy with top
level having min and low setup appropriately. More specifically
memory.min equal to size of netperf binary and memory.low double of
that.

 $ netserver -6
 # 36 instances of netperf with following params
 $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K

Results (average throughput of netperf):
Without (6.0-rc1)	10482.7 Mbps
With patch		12413.7 Mbps (18.4% improvement)

With the patch, the throughput improved by 18.4%.

One side-effect of this patch is the increase in the size of struct
mem_cgroup. However for the performance improvement, this additional
size is worth it. In addition there are opportunities to reduce the size
of struct mem_cgroup like deprecation of kmem and tcpmem page counters
and better packing.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
---
 include/linux/page_counter.h | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index 679591301994..8ce99bde645f 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -3,15 +3,27 @@
 #define _LINUX_PAGE_COUNTER_H
 
 #include <linux/atomic.h>
+#include <linux/cache.h>
 #include <linux/kernel.h>
 #include <asm/page.h>
 
+#if defined(CONFIG_SMP)
+struct pc_padding {
+	char x[0];
+} ____cacheline_internodealigned_in_smp;
+#define PC_PADDING(name)	struct pc_padding name
+#else
+#define PC_PADDING(name)
+#endif
+
 struct page_counter {
+	/*
+	 * Make sure 'usage' does not share cacheline with any other field. The
+	 * memcg->memory.usage is a hot member of struct mem_cgroup.
+	 */
+	PC_PADDING(_pad1_);
 	atomic_long_t usage;
-	unsigned long min;
-	unsigned long low;
-	unsigned long high;
-	unsigned long max;
+	PC_PADDING(_pad2_);
 
 	/* effective memory.min and memory.min usage tracking */
 	unsigned long emin;
@@ -23,16 +35,16 @@ struct page_counter {
 	atomic_long_t low_usage;
 	atomic_long_t children_low_usage;
 
-	/* legacy */
 	unsigned long watermark;
 	unsigned long failcnt;
 
-	/*
-	 * 'parent' is placed here to be far from 'usage' to reduce
-	 * cache false sharing, as 'usage' is written mostly while
-	 * parent is frequently read for cgroup's hierarchical
-	 * counting nature.
-	 */
+	/* Keep all the read most fields in a separete cacheline. */
+	PC_PADDING(_pad3_);
+
+	unsigned long min;
+	unsigned long low;
+	unsigned long high;
+	unsigned long max;
 	struct page_counter *parent;
 };
 
-- 
2.37.1.595.g718a3a8f04-goog

