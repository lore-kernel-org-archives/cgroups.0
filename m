From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH v2] mm/memcontrol: make the slab calculation consistent
Date: Thu,  3 Dec 2020 11:11:11 +0800
Message-ID: <20201203031111.3187-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rwVqmku+KuF7CBDwCXmp7GQf251F6L0Ar739gqzf9cU=;
        b=tITewJgNthn6PxKyqtA6y7Hsga8qG37N3FDSi29gWHRtvQG+yNxwFH68T9T2/XjU2d
         McUpVdjLgYPQlC7j8HhQPXZO+rMwHmoB1qk4zk1HY/jZ92ViyXbppXXZsVTD8iN8M8Av
         TPbPm1yTQzGCsDMl7nhuEzLoA0QSHzG+aqEYuvfqcJ/7hAouPj31QXTnaVm4ZVCEB1hy
         WGBtEaiDvKXSp9rE0YOCwfzz5B4NsC8gRkvzGjKJZx9QyHNyuspmL6hPsDRI1+P5oYzd
         kEC1TPjDhslQHfF862x4i6EA/EofAGpWNJlm9oyLEjfSng0F8LXkHEddvJadX359XlfS
         20Aw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Although the ratio of the slab is one, we also should read the ratio
from the related memory_stats instead of hard-coding. And the local
variable of size is already the value of slab_unreclaimable. So we
do not need to read again. Simplify the code here.

Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
---
Changes in v2:
 - Add a comment in the memory_stat_format() suggested by Roman.

 mm/memcontrol.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9922f1510956..75df129b7a52 100644
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
@@ -1586,9 +1596,15 @@ static char *memory_stat_format(struct mem_cgroup *memcg)
 		size *= memory_stats[i].ratio;
 		seq_buf_printf(&s, "%s %llu\n", memory_stats[i].name, size);
 
+		/*
+		 * We are printing reclaimable, unreclaimable of the slab
+		 * and the sum of both.
+		 */
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

