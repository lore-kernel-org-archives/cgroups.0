From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH bpf-next v3 10/13] mm, memcg: Add new helper get_obj_cgroup_from_cgroup
Date: Fri,  2 Sep 2022 02:30:00 +0000
Message-ID: <20220902023003.47124-11-laoar.shao@gmail.com>
References: <20220902023003.47124-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=oTzSf85iWJHNEVVdQJQawTYzDnCEuMbWuvl4YMwFJHo=;
        b=HpH5nbR7f38apaxWi0KaD3SeNAKzaoXicey2rg/miPioqCgeCWVOK43hCtIftBuo1N
         QbqGHEF6XUCu0BCMIRlFwsthhpD00GqnpDf3e3iIVAx6t7zqW0H7lguDqeHmf9F9kjxZ
         S6VeDMuodddj2nFJ9QdZANE0ynOkPTs8CSWtXQtVPUlS/WeUrrRH8JcbisME3QJuXhjN
         PBriHpMPWSoNwoECmcNJcBgaMUza/8shHez4l6SJ+A6QdqVQeyaccN2u0IE0CWhjJnBn
         +56WGiPw4jZ5f7N+AU/OOQCp50Ok1xUJm48Hr0097jDlSOabNoWqfp7K4Ct7NsN5+B+u
         K5ZQ==
In-Reply-To: <20220902023003.47124-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kafai-b10kYP2dOMg@public.gmane.org, songliubraving-b10kYP2dOMg@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

We want to open a cgroup directory and pass the fd into kernel, and then
in the kernel we can charge the allocated memory into the open cgroup if it
has valid memory subsystem. In the bpf subsystem, the opened cgroup will
be store as a struct obj_cgroup pointer, so a new helper
get_obj_cgroup_from_cgroup() is introduced.

Signed-off-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/linux/memcontrol.h |  1 +
 mm/memcontrol.c            | 48 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 6040b5c..7a7f252 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1734,6 +1734,7 @@ static inline void set_shrinker_bit(struct mem_cgroup *memcg,
 int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order);
 void __memcg_kmem_uncharge_page(struct page *page, int order);
 
+struct obj_cgroup *get_obj_cgroup_from_cgroup(struct cgroup *cgrp);
 struct obj_cgroup *get_obj_cgroup_from_current(void);
 struct obj_cgroup *get_obj_cgroup_from_page(struct page *page);
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b69979c..4e3b51e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2940,6 +2940,7 @@ static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
 {
 	struct obj_cgroup *objcg = NULL;
 
+	WARN_ON_ONCE(!rcu_read_lock_held());
 	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg)) {
 		objcg = rcu_dereference(memcg->objcg);
 		if (objcg && obj_cgroup_tryget(objcg))
@@ -2949,6 +2950,53 @@ static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
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
+/**
+ * get_obj_cgroup_from_cgroup: Obtain a reference on given cgroup's objcg.
+ * @cgrp: cgroup from which objcg should be extracted. It can't be NULL.
+ *        The memory subsystem of this cgroup must be enabled, otherwise
+ *        -EINVAL will be returned.
+ * On success, the objcg will be returned.
+ * On failure, -EINVAL will be returned.
+ */
+struct obj_cgroup *get_obj_cgroup_from_cgroup(struct cgroup *cgrp)
+{
+	struct cgroup_subsys_state *css;
+	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg;
+
+	rcu_read_lock();
+	css = rcu_dereference(cgrp->subsys[memory_cgrp_id]);
+	if (!css || !css_tryget(css)) {
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

