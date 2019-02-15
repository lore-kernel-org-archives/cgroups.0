From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 3/6] mm: memcontrol: replace node summing with memcg_page_state()
Date: Fri, 15 Feb 2019 13:14:22 -0500
Message-ID: <20190215181425.32624-4-hannes@cmpxchg.org>
References: <20190215181425.32624-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m8WChnDGiJjl3dG7Qy7BcuERcz0zJgVAywmHmi4mw/w=;
        b=UdfnkLw0LmmTMvDdh9ElM17TqIoS3oWEjsSyoG4o6RGsaPK+fs4daWXmy0W/V7D+78
         Ob2Pc5U21jjOaaMkxoMxu9tYDRhLSY2CL/sI5SGMTfBDcQdRvqtWJ1c9dngW43CxCbTv
         9p4H2xQVSXhBxNYvad1mhG4sR3iDigfmHjGeDfRaTU+7XjGsyeFxL22FLqvWeI/UsRbR
         PTdCQwKwdVXH+yJAh1ngZAjeqZ2nUBqtDoA+jtJ5gStQMocaU9AuCbQLZYLint5d9dxj
         S9J7e7kCePwD2WfXXOsu+GBqZ9GNU0PIVhs0jDdsSLfjoGX15iGR18dpmrWWhqj3O5UO
         DL0Q==
In-Reply-To: <20190215181425.32624-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Instead of adding up the node counters, use memcg_page_state() to get
the memcg state directly. This is a bit cheaper and more stream-lined.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a04177f25758..4d573f4e1759 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -739,10 +739,13 @@ static unsigned long mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg,
 			unsigned int lru_mask)
 {
 	unsigned long nr = 0;
-	int nid;
+	enum lru_list lru;
 
-	for_each_node_state(nid, N_MEMORY)
-		nr += mem_cgroup_node_nr_lru_pages(memcg, nid, lru_mask);
+	for_each_lru(lru) {
+		if (!(BIT(lru) & lru_mask))
+			continue;
+		nr += memcg_page_state(memcg, NR_LRU_BASE + lru);
+	}
 	return nr;
 }
 
-- 
2.20.1

