From: Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v2 10/12] mm, memcg: Add new helper get_obj_cgroup_from_cgroup
Date: Thu, 18 Aug 2022 14:31:16 +0000
Message-ID: <20220818143118.17733-11-laoar.shao@gmail.com>
References: <20220818143118.17733-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=SdEsGdLtUTnGTQlmpkcqbLnnsMN1enZs7HVXG4Feokc=;
        b=iM7+xYE3ZpaZKh2j/9NZNfU6WfXX1qnhHz90ontLLo/0kh1EMI2GgT3hsaLXjYuqB+
         Bc+3EgV3QlYwmbQSgP6DF4xyLZM3XeV8u8WuYlvq9gCHoYixiOEju6GCoB9t8bIaV/h0
         8FIPglxdIU0iKsIttK5lqBYDQPvSCT6m7EJ3UB3fKymtdyT2oCkbs3nW8AuR5HmU6c4U
         plqqyHQwuiSWQJN/q+zwHtXRUvp4HuPyDXIB+i0qM1xVXS6Uwz7nDD7ePd9S4T3uG5Lr
         XMmyq9x38HyRsbixPhyelgKdWfrTLNyNj+YPuYZOVsEtiDUSthZTWGolXni2ZmEiLLAD
         tSiQ==
In-Reply-To: <20220818143118.17733-1-laoar.shao@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, songmuchun@bytedance.com, akpm@linux-foundation.org, tj@kernel.org, lizefan.x@bytedance.com
Cc: cgroups@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org, Yafang Shao <laoar.shao@gmail.com>

We want to open a cgroup directory and pass the fd into kernel, and then
in the kernel we can charge the allocated memory into the open cgroup if it
has valid memory subsystem. In the bpf subsystem, the opened cgroup will
be store as a struct obj_cgroup pointer, so a new helper
get_obj_cgroup_from_cgroup() is introduced.

It also add a comment on why the helper  __get_obj_cgroup_from_memcg()
must be protected by rcu read lock.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/memcontrol.h |  1 +
 mm/memcontrol.c            | 47 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 2f0a611..901a921 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1713,6 +1713,7 @@ static inline void set_shrinker_bit(struct mem_cgroup *memcg,
 int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order);
 void __memcg_kmem_uncharge_page(struct page *page, int order);
 
+struct obj_cgroup *get_obj_cgroup_from_cgroup(struct cgroup *cgrp);
 struct obj_cgroup *get_obj_cgroup_from_current(void);
 struct obj_cgroup *get_obj_cgroup_from_page(struct page *page);
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 618c366..0409cc4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2895,6 +2895,14 @@ struct mem_cgroup *mem_cgroup_from_obj(void *p)
 	return page_memcg_check(folio_page(folio, 0));
 }
 
+/*
+ * Pls. note that the memg->objcg can be freed after it is deferenced,
+ * that can happen when the memcg is changed from online to offline.
+ * So this helper must be protected by read rcu lock.
+ *
+ * After obj_cgroup_tryget(), it is safe to use the objcg outside of the rcu
+ * read-side critical section.
+ */
 static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
 {
 	struct obj_cgroup *objcg = NULL;
@@ -2908,6 +2916,45 @@ static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
 	return objcg;
 }
 
+static struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
+{
+	struct obj_cgroup *objcg;
+
+	if (memcg_kmem_bypass())
+		return NULL;
+
+	rcu_read_lock();
+	objcg = __get_obj_cgroup_from_memcg(memcg);
+	rcu_read_unlock();
+	return objcg;
+}
+
+struct obj_cgroup *get_obj_cgroup_from_cgroup(struct cgroup *cgrp)
+{
+	struct cgroup_subsys_state *css;
+	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg;
+
+	rcu_read_lock();
+	css = rcu_dereference(cgrp->subsys[memory_cgrp_id]);
+	if (!css || !css_tryget_online(css)) {
+		rcu_read_unlock();
+		return ERR_PTR(-EINVAL);
+	}
+	rcu_read_unlock();
+
+	memcg = mem_cgroup_from_css(css);
+	if (!memcg) {
+		css_put(css);
+		return ERR_PTR(-EINVAL);
+	}
+
+	objcg = get_obj_cgroup_from_memcg(memcg);
+	css_put(css);
+
+	return objcg;
+}
+
 __always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
 {
 	struct obj_cgroup *objcg = NULL;
-- 
1.8.3.1

