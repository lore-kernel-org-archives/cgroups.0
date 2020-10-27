From: Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 2/5] mm: memcg/slab: Fix use after free in obj_cgroup_charge
Date: Tue, 27 Oct 2020 16:02:53 +0800
Message-ID: <20201027080256.76497-3-songmuchun@bytedance.com>
References: <20201027080256.76497-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YWIAYpPs9+svXY8PEtGZ5WZ0CNEgBLTQowd7Fmk6Ks0=;
        b=0mmq9zynkfizT4Ql1IxpOGnGDMmXfmaRO/jTjmX5y5xzgLSWldW1D0OmZmiaqfd3Jj
         uTnV/2ojetEMYoqEy6o95NADBO7FFfWXq+J8lRdeuLuCL+w6GFggpi1WoXcq7Ai0Ouln
         kMd+2CMAl09mrojtd/edMDGXtdwUoq2EPfkdkJl8IJ42pR927Gy1+02gSJnULXNN7/AR
         Tin3noEy1hSSySrqkHSsnkchL+m1SAd/NAdjV9jF1hVqVfziOhHfoalcTD5MZA+F0CcN
         Wsvz53aafL+3Nhw88pYQat+6bd/CjXTZhks3P7F+G145xKZfz8Ji/eNFy8hAV5ap0QgC
         lJjQ==
In-Reply-To: <20201027080256.76497-1-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, shakeelb@google.com, guro@fb.com, iamjoonsoo.kim@lge.com, laoar.shao@gmail.com, chris@chrisdown.name, christian.brauner@ubuntu.com, peterz@infradead.org, mingo@kernel.org, keescook@chromium.org, tglx@linutronix.de, esyr@redhat.com, surenb@google.com, areber@redhat.com, elver@google.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Muchun Song <songmuchun@bytedance.com>

The rcu_read_lock/unlock only can guarantee that the memcg will
not be freed, but it cannot guarantee the success of css_get to
memcg. This can be happened when we reparent the memcg. So using
css_tryget instead of css_get.

Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/memcontrol.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index fcbd79c5023e..c0c27bee23ad 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3223,8 +3223,10 @@ int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
 	 * independently later.
 	 */
 	rcu_read_lock();
+retry:
 	memcg = obj_cgroup_memcg(objcg);
-	css_get(&memcg->css);
+	if (!css_tryget(&memcg->css))
+		goto retry;
 	rcu_read_unlock();
 
 	nr_pages = size >> PAGE_SHIFT;
-- 
2.20.1

