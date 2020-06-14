From: Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH] mm: memcontrol: Fix do not put the css reference
Date: Sun, 14 Jun 2020 20:26:53 +0800
Message-ID: <20200614122653.98829-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O3wDQLkjLZhz8HlGMqP3m6FBvc0T90YmqvSvkQbSHmY=;
        b=UZdFv0Xir9MEd893nm2NsmxcmIkqD+9uJfe/NWiB6X4ESmnvYuGlbYeBwqpFlqO9RE
         GEBYJJZFKnYz3RhjfSojLRVr5YVm5AGj/u7OUlKiuBC9pTCpa/UTUp4W0JS62X3RZVlN
         yUkG04sIKOg+sRsa+nZB76FklBpGfLDF2tULWeLOIx3xRMLvhRlyusQ8swY5N6V6FueI
         OgCRl6obnJBQmMr4UfhxeO0voZrS3sJhbQYyQanMRjl6HbdtGdAg8MKQCLIovef0xhA0
         hY8ljJPDg1iToDvZczOb8CPHo34wtShhA11Rm7JQiD3cdRyhygvgKhIxkBp0UuA/gl99
         oQpg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org
Cc: guro@fb.com, cai@lca.pw, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>

We should put the css reference when memory allocation failed.

Fixes: f0a3a24b532d ("mm: memcg/slab: rework non-root kmem_cache lifecycle management")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/memcontrol.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0b38b6ad547d..2323d811ee8e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2772,8 +2772,10 @@ static void memcg_schedule_kmem_cache_create(struct mem_cgroup *memcg,
 		return;
 
 	cw = kmalloc(sizeof(*cw), GFP_NOWAIT | __GFP_NOWARN);
-	if (!cw)
+	if (!cw) {
+		css_put(&memcg->css);
 		return;
+	}
 
 	cw->memcg = memcg;
 	cw->cachep = cachep;
-- 
2.11.0

