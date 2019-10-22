From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 2/2] mm: memcontrol: try harder to set a new memory.high
Date: Tue, 22 Oct 2019 16:15:18 -0400
Message-ID: <20191022201518.341216-2-hannes@cmpxchg.org>
References: <20191022201518.341216-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SKH3PcY5YzXD6Qge68ymWg6Ins6ocLR9l5DfPryEBgk=;
        b=KaaLg/bw88z77buICYAJEe5iw5ThIZJCDvLL4q2RSdmGOXSdlsryIy4UAPdKiR3U1i
         TnF8jNwIgRKrMzBMH2cBT8Qyy9tg/M9wTtR3Wrx6e/JrVGOp77QhbBjRArE2l/meQdby
         SOdO/mGWcTubS8kR90ln5IenSVxDk0WPTvDqpdaDO4iRAPQXIssKgsKkCTzxFI7D99tI
         K/w9BneoewwmdaDHDt5q8QWenhYLUUAhYRi0GJm58lfdROEHZrbuhSNsUmJ7vhrTLZoB
         TlgRns9OFeILnr1C45VJ/hBfpRmLpXl6WY6/23dwwSlktV02dZHRpDlk39xE/9wyzzJf
         OKPw==
In-Reply-To: <20191022201518.341216-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Setting a memory.high limit below the usage makes almost no effort to
shrink the cgroup to the new target size.

While memory.high is a "soft" limit that isn't supposed to cause OOM
situations, we should still try harder to meet a user request through
persistent reclaim.

For example, after setting a 10M memory.high on an 800M cgroup full of
file cache, the usage shrinks to about 350M:

+ cat /cgroup/workingset/memory.current
841568256
+ echo 10M
+ cat /cgroup/workingset/memory.current
355729408

This isn't exactly what the user would expect to happen. Setting the
value a few more times eventually whittles the usage down to what we
are asking for:

+ echo 10M
+ cat /cgroup/workingset/memory.current
104181760
+ echo 10M
+ cat /cgroup/workingset/memory.current
31801344
+ echo 10M
+ cat /cgroup/workingset/memory.current
10440704

To improve this, add reclaim retry loops to the memory.high write()
callback, similar to what we do for memory.max, to make a reasonable
effort that the usage meets the requested size after the call returns.

Afterwards, a single write() to memory.high is enough in all but
extreme cases:

+ cat /cgroup/workingset/memory.current
841609216
+ echo 10M
+ cat /cgroup/workingset/memory.current
10182656

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ff90d4e7df37..8090b4c99ac7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6074,7 +6074,8 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 				 char *buf, size_t nbytes, loff_t off)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
-	unsigned long nr_pages;
+	unsigned int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
+	bool drained = false;
 	unsigned long high;
 	int err;
 
@@ -6085,12 +6086,29 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 
 	memcg->high = high;
 
-	nr_pages = page_counter_read(&memcg->memory);
-	if (nr_pages > high)
-		try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
-					     GFP_KERNEL, true);
+	for (;;) {
+		unsigned long nr_pages = page_counter_read(&memcg->memory);
+		unsigned long reclaimed;
+
+		if (nr_pages <= high)
+			break;
+
+		if (signal_pending(current))
+			break;
+
+		if (!drained) {
+			drain_all_stock(memcg);
+			drained = true;
+			continue;
+		}
+
+		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
+							 GFP_KERNEL, true);
+
+		if (!reclaimed && !nr_retries--)
+			break;
+	}
 
-	memcg_wb_domain_size_changed(memcg);
 	return nbytes;
 }
 
-- 
2.23.0

