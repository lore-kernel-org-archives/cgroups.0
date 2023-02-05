From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH bpf-next 1/5] mm: memcontrol: add new kernel parameter cgroup.memory=nobpf
Date: Sun,  5 Feb 2023 06:58:01 +0000
Message-ID: <20230205065805.19598-2-laoar.shao@gmail.com>
References: <20230205065805.19598-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m9R8PIufUvBWha2/FhSWxLkNgyIkPqx2ukwcdT04Lok=;
        b=VbKKUeOjFCh14UcFioJqXvV7nqLa/vg7qKYxZQoGJttshn6aRrjtM0mbljrXL0sSdo
         eoD9zvL2xe3uInT4uDMDjiP/qOwanJKqBrbwt1d1DwYYMEQZ33HOBD6TmXobYtliaD4y
         jL7qHagWDuT/Cpw7o2NXIPpUlagzQvrXu4hNJXh/5vE4ShSSJfiDwZahWSsv83KJATSd
         F4d2EZbJO3TWewtgx6041qZaYAkpmG9XlDGl3CNBeahJAPv1aHnjnW9jXuHbBSRsLScM
         IxkfodJ2ct1jHAS2KZ38cmjljEGipXaGxiHVk6qRU+Gz+xGTGRPKtSLFVu9vS9T1ECfi
         KzGg==
In-Reply-To: <20230205065805.19598-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kafai-b10kYP2dOMg@public.gmane.org, songliubraving-b10kYP2dOMg@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Add new kernel parameter cgroup.memory=nobpf to allow user disable bpf
memory accounting. This is a preparation for the followup patch.

Signed-off-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/admin-guide/kernel-parameters.txt |  1 +
 include/linux/memcontrol.h                      | 11 +++++++++++
 mm/memcontrol.c                                 | 18 ++++++++++++++++++
 3 files changed, 30 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6cfa6e3..29fb41e 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -557,6 +557,7 @@
 			Format: <string>
 			nosocket -- Disable socket memory accounting.
 			nokmem -- Disable kernel memory accounting.
+			nobpf -- Disable BPF memory accounting.
 
 	checkreqprot=	[SELINUX] Set initial checkreqprot flag value.
 			Format: { "0" | "1" }
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index d3c8203..26d4bf2 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1751,6 +1751,12 @@ static inline void set_shrinker_bit(struct mem_cgroup *memcg,
 int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size);
 void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size);
 
+extern struct static_key_false memcg_bpf_enabled_key;
+static inline bool memcg_bpf_enabled(void)
+{
+	return static_branch_likely(&memcg_bpf_enabled_key);
+}
+
 extern struct static_key_false memcg_kmem_enabled_key;
 
 static inline bool memcg_kmem_enabled(void)
@@ -1829,6 +1835,11 @@ static inline struct obj_cgroup *get_obj_cgroup_from_page(struct page *page)
 	return NULL;
 }
 
+static inline bool memcg_bpf_enabled(void)
+{
+	return false;
+}
+
 static inline bool memcg_kmem_enabled(void)
 {
 	return false;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ab457f0..590526f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -89,6 +89,9 @@
 /* Kernel memory accounting disabled? */
 static bool cgroup_memory_nokmem __ro_after_init;
 
+/* BPF memory accounting disabled? */
+static bool cgroup_memory_nobpf __ro_after_init;
+
 #ifdef CONFIG_CGROUP_WRITEBACK
 static DECLARE_WAIT_QUEUE_HEAD(memcg_cgwb_frn_waitq);
 #endif
@@ -348,6 +351,9 @@ static void memcg_reparent_objcgs(struct mem_cgroup *memcg,
  */
 DEFINE_STATIC_KEY_FALSE(memcg_kmem_enabled_key);
 EXPORT_SYMBOL(memcg_kmem_enabled_key);
+
+DEFINE_STATIC_KEY_FALSE(memcg_bpf_enabled_key);
+EXPORT_SYMBOL(memcg_bpf_enabled_key);
 #endif
 
 /**
@@ -5362,6 +5368,11 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
 		static_branch_inc(&memcg_sockets_enabled_key);
 
+#if defined(CONFIG_MEMCG_KMEM)
+	if (!cgroup_memory_nobpf)
+		static_branch_inc(&memcg_bpf_enabled_key);
+#endif
+
 	return &memcg->css;
 }
 
@@ -5446,6 +5457,11 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_active)
 		static_branch_dec(&memcg_sockets_enabled_key);
 
+#if defined(CONFIG_MEMCG_KMEM)
+	if (!cgroup_memory_nobpf)
+		static_branch_dec(&memcg_bpf_enabled_key);
+#endif
+
 	vmpressure_cleanup(&memcg->vmpressure);
 	cancel_work_sync(&memcg->high_work);
 	mem_cgroup_remove_from_trees(memcg);
@@ -7310,6 +7326,8 @@ static int __init cgroup_memory(char *s)
 			cgroup_memory_nosocket = true;
 		if (!strcmp(token, "nokmem"))
 			cgroup_memory_nokmem = true;
+		if (!strcmp(token, "nobpf"))
+			cgroup_memory_nobpf = true;
 	}
 	return 1;
 }
-- 
1.8.3.1

