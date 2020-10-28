From: Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2] mm: memcg/slab: Fix use after free in obj_cgroup_charge
Date: Wed, 28 Oct 2020 11:50:11 +0800
Message-ID: <20201028035013.99711-2-songmuchun@bytedance.com>
References: <20201028035013.99711-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f42zNGuydbxsMprn7/o4rTiW5Mh/YrWQVTbGkrcpGAU=;
        b=JRG9qhqWVdv+qAPGEyd6hAeN94upYYLiFE/8ziCyK2IfmG0KH0vcgx4BU3gjZFhSCf
         OEaj1GD1WXVm1jmeXl1DAWeAzX9Lob3XEKoPsdIGbnDQ1EZlxhf90ONNi7wNxTQIRxa9
         JYfxxPzpE73/OCT2b00zuaCJtatE4mhFQZTM1zuzRudG7zsEUnH4gtecsO/0Msaf4j7w
         CHNZUDlEGkeM+dWh/h54KR874ZVAd/8idZH6gFDdGIdh0J1HKh15Z6JSbBjt3nBo17Ag
         izJQJtcjN0Ho2qCL3Miw31aUHdSVubCbCTwrcvEvzj7CbUF9eK85qoW+4YUKLq/JBNAg
         8XsA==
In-Reply-To: <20201028035013.99711-1-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, shakeelb@google.com, guro@fb.com, iamjoonsoo.kim@lge.com, laoar.shao@gmail.com, chris@chrisdown.name, christian.brauner@ubuntu.com, peterz@infradead.org, mingo@kernel.org, keescook@chromium.org, tglx@linutronix.de, esyr@redhat.com, surenb@google.com, areber@redhat.com, elver@google.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Muchun Song <songmuchun@bytedance.com>

The rcu_read_lock/unlock only can guarantee that the memcg will
not be freed, but it cannot guarantee the success of css_get to
memcg.

If the whole process of a cgroup offlining is completed between
reading a objcg->memcg pointer and bumping the css reference on
another CPU, and there are exactly 0 external references to this
memory cgroup (how we get to the obj_cgroup_charge() then?),
css_get() can change the ref counter from 0 back to 1.

Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <guro@fb.com>
---
 changelog in v2:
 1. Add unlikely and update the commit log suggested by Roman.

 mm/memcontrol.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8c8b4c3ed5a0..d9cdf899c6fc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3221,8 +3221,10 @@ int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
 	 * independently later.
 	 */
 	rcu_read_lock();
+retry:
 	memcg = obj_cgroup_memcg(objcg);
-	css_get(&memcg->css);
+	if (unlikely(!css_tryget(&memcg->css)))
+		goto retry;
 	rcu_read_unlock();
 
 	nr_pages = size >> PAGE_SHIFT;
-- 
2.20.1

