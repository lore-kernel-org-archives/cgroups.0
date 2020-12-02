From: Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH] mm/memcontrol: make the slab calculation consistent
Date: Wed,  2 Dec 2020 20:14:34 +0800
Message-ID: <20201202121434.75099-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0D0YvfFeRVroyy8DOM8jNI9C4k7vyQ+vFDUfvEXQRIw=;
        b=pZfhUnAfhJIC6/Dv5lxitZ9cKXI7bpi1N7AHDZuXk5iD1odIfF+g8ifMX49reRjF99
         yLEwUP6xyJa0nYkrqHO91vMYQ0XAv/FNqFSpBKoRgkUEIaxAezWlS9w7l1dzjubGclHz
         ThKFQZj7svmOUlI0TdwlQFxJqtLyJL8U5k8/hNqr/2y9OXXb/sFzwZi/Q8k5LSWxGNqG
         qLYgioFTLRmCw5DxE2volAw4/zrCDm+38iAqBgx7OE56INmP/Ga0CGzxUAxMMxQl5750
         sA7qPKmbiVH9tN0Hi/Oa6rm0yp0xRwGe3VrMmaVeLVrF2NOS+g5K8NvQLuwSa7TZc4TS
         d/uA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>

Although the ratio of the slab is one, we also should read the ratio
from the related memory_stats instead of hard-coding. And the local
variable of size is already the value of slab_unreclaimable. So we
do not need to read again. Simplify the code here.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/memcontrol.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9922f1510956..03a9c64560f6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1545,12 +1545,22 @@ static int __init memory_stats_init(void)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
+		switch (memory_stats[i].idx) {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		if (memory_stats[i].idx == NR_ANON_THPS ||
-		    memory_stats[i].idx == NR_FILE_THPS ||
-		    memory_stats[i].idx == NR_SHMEM_THPS)
+		case NR_ANON_THPS:
+		case NR_FILE_THPS:
+		case NR_SHMEM_THPS:
 			memory_stats[i].ratio = HPAGE_PMD_SIZE;
+			break;
 #endif
+		case NR_SLAB_UNRECLAIMABLE_B:
+			VM_BUG_ON(i < 1);
+			VM_BUG_ON(memory_stats[i - 1].idx != NR_SLAB_RECLAIMABLE_B);
+			break;
+		default:
+			break;
+		}
+
 		VM_BUG_ON(!memory_stats[i].ratio);
 		VM_BUG_ON(memory_stats[i].idx >= MEMCG_NR_STAT);
 	}
@@ -1587,8 +1597,10 @@ static char *memory_stat_format(struct mem_cgroup *memcg)
 		seq_buf_printf(&s, "%s %llu\n", memory_stats[i].name, size);
 
 		if (unlikely(memory_stats[i].idx == NR_SLAB_UNRECLAIMABLE_B)) {
-			size = memcg_page_state(memcg, NR_SLAB_RECLAIMABLE_B) +
-			       memcg_page_state(memcg, NR_SLAB_UNRECLAIMABLE_B);
+			int idx = i - 1;
+
+			size += memcg_page_state(memcg, memory_stats[idx].idx) *
+				memory_stats[idx].ratio;
 			seq_buf_printf(&s, "slab %llu\n", size);
 		}
 	}
-- 
2.11.0

