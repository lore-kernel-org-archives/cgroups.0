From: Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 1/5] mm: memcg/slab: Fix return child memcg objcg for root memcg
Date: Tue, 27 Oct 2020 16:02:52 +0800
Message-ID: <20201027080256.76497-2-songmuchun@bytedance.com>
References: <20201027080256.76497-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pkKyxTwl8ekG841RoN58bB0vzsrEHZTiUbsxmBIxH0Y=;
        b=J7QFPcYyl+Rudib/U00XRzim7IuwfNQtPAZP0xb+Mv5iSY4+XHq5yo6c5JpkrTzH+x
         zMqLgUYoRMW6RLuijAzEUXPiwdUAv0OlP018X16jtfAE4iCBozAlIGusVJ379BvQF4ex
         euMiQdjzZbooFeBqwPBtKiAAMXvQMYa2laliQtiAMGa7S2aFAmb0VdDszsuq2FBeQIrn
         6sGs6A7g90DTQsM0B1cOt3EBBB544p5q7HmT5QI3C7xvTdM987JLsiQjWQblfV4fCci2
         1R7xoknLsUCfNO9cESLng0m+PikAlEnM8DcLgi/D28YoWPYN5FGqJexP7SZNeepLSpx9
         bcRA==
In-Reply-To: <20201027080256.76497-1-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, shakeelb@google.com, guro@fb.com, iamjoonsoo.kim@lge.com, laoar.shao@gmail.com, chris@chrisdown.name, christian.brauner@ubuntu.com, peterz@infradead.org, mingo@kernel.org, keescook@chromium.org, tglx@linutronix.de, esyr@redhat.com, surenb@google.com, areber@redhat.com, elver@google.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Muchun Song <songmuchun@bytedance.com>

Consider the following memcg hierarchy.

                    root
                   /    \
                  A      B

If we get the objcg of memcg A failed, the get_obj_cgroup_from_current
can return the wrong objcg for the root memcg.

Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/memcontrol.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1337775b04f3..fcbd79c5023e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2945,7 +2945,7 @@ struct mem_cgroup *mem_cgroup_from_obj(void *p)
 
 __always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
 {
-	struct obj_cgroup *objcg = NULL;
+	struct obj_cgroup *objcg;
 	struct mem_cgroup *memcg;
 
 	if (memcg_kmem_bypass())
@@ -2964,6 +2964,9 @@ __always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
 	}
 	rcu_read_unlock();
 
+	if (memcg == root_mem_cgroup)
+		return NULL;
+
 	return objcg;
 }
 
-- 
2.20.1

