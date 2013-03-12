From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/6] memcg: disable memcg page stat accounting
Date: Tue, 12 Mar 2013 18:11:43 +0800
Message-ID: <1363083103-3907-1-git-send-email-handai.szj@taobao.com>
References: <1363082773-3598-1-git-send-email-handai.szj@taobao.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=1rBe/K+Y48A7NM2U/DC/d/lGzMP2a3Zt1pJoP+gVoMc=;
        b=uxls/M+vcDsgHsx59bxQHds83k2LmfTN+k+lSO5AsMQy/pRn9SXzwltLwqGJERkFuG
         YbQE9IaLTMqDLbeTnqTnhVSdW0bTqGDE06ikSAX7NgwlZnGFoTsiNLQj+FWyTeG/qmZE
         hNC4VvYu3PRFy05x5JnL8Zx5i/fMRBFqJIaNon0HE9QcALZY6QmZC1ZjQUvDmakZaHu1
         6t3CqfRXaw5ylThEmyAXEhqsu+20UbAv+I4LEfKy6oA9jibWkqVtB7M26ax3o/UJPhcY
         gt3S7gjugFzoOlY7xJSNAvpnfDqPUQ3LJhm1qg3tAxJ8MRGfUNDzG72cmGjvuktW0Wv7
         hv3w==
In-Reply-To: <1363082773-3598-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: mhocko-AlSwsSmVLrQ@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Use jump label to patch the memcg page stat accounting code
in or out when not used. when the first non-root memcg comes to
life the code is patching in otherwise it is out.

Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/memcontrol.h |   23 +++++++++++++++++++++++
 mm/memcontrol.c            |   34 +++++++++++++++++++++++++++++++++-
 2 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index d6183f0..99dca91 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -42,6 +42,14 @@ struct mem_cgroup_reclaim_cookie {
 };
 
 #ifdef CONFIG_MEMCG
+
+extern struct static_key memcg_in_use_key;
+
+static inline bool mem_cgroup_in_use(void)
+{
+	return static_key_false(&memcg_in_use_key);
+}
+
 /*
  * All "charge" functions with gfp_mask should use GFP_KERNEL or
  * (gfp_mask & GFP_RECLAIM_MASK). In current implementatin, memcg doesn't
@@ -145,6 +153,10 @@ static inline void mem_cgroup_begin_update_page_stat(struct page *page,
 {
 	if (mem_cgroup_disabled())
 		return;
+
+	if (!mem_cgroup_in_use())
+		return;
+
 	rcu_read_lock();
 	*locked = false;
 	if (atomic_read(&memcg_moving))
@@ -158,6 +170,10 @@ static inline void mem_cgroup_end_update_page_stat(struct page *page,
 {
 	if (mem_cgroup_disabled())
 		return;
+
+	if (!mem_cgroup_in_use())
+		return;
+
 	if (*locked)
 		__mem_cgroup_end_update_page_stat(page, flags);
 	rcu_read_unlock();
@@ -189,6 +205,9 @@ static inline void mem_cgroup_count_vm_event(struct mm_struct *mm,
 {
 	if (mem_cgroup_disabled())
 		return;
+	if (!mem_cgroup_in_use())
+		return;
+
 	__mem_cgroup_count_vm_event(mm, idx);
 }
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -201,6 +220,10 @@ void mem_cgroup_print_bad_page(struct page *page);
 #endif
 #else /* CONFIG_MEMCG */
 struct mem_cgroup;
+static inline bool mem_cgroup_in_use(void)
+{
+	return false;
+}
 
 static inline int mem_cgroup_newpage_charge(struct page *page,
 					struct mm_struct *mm, gfp_t gfp_mask)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cea4b02..4e08347 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -562,6 +562,14 @@ enum res_type {
  */
 static DEFINE_MUTEX(memcg_create_mutex);
 
+/* static_key used for marking memcg in use or not. We use this jump label to
+ * patch memcg page stat accounting code in or out.
+ * The key will be increased when non-root memcg is created, and be decreased
+ * when memcg is destroyed.
+ */
+struct static_key memcg_in_use_key;
+EXPORT_SYMBOL(memcg_in_use_key);
+
 static void mem_cgroup_get(struct mem_cgroup *memcg);
 static void mem_cgroup_put(struct mem_cgroup *memcg);
 
@@ -707,10 +715,21 @@ static void disarm_kmem_keys(struct mem_cgroup *memcg)
 }
 #endif /* CONFIG_MEMCG_KMEM */
 
+static void disarm_inuse_keys(void)
+{
+	static_key_slow_dec(&memcg_in_use_key);
+}
+
+static void arm_inuse_keys(void)
+{
+	static_key_slow_inc(&memcg_in_use_key);
+}
+
 static void disarm_static_keys(struct mem_cgroup *memcg)
 {
 	disarm_sock_keys(memcg);
 	disarm_kmem_keys(memcg);
+	disarm_inuse_keys();
 }
 
 static void drain_all_stock_async(struct mem_cgroup *memcg);
@@ -936,6 +955,9 @@ static void mem_cgroup_swap_statistics(struct mem_cgroup *memcg,
 {
 	int val = (charge) ? 1 : -1;
 
+	if (!mem_cgroup_in_use())
+		return;
+
 	if (!mem_cgroup_is_root(memcg))
 		this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_SWAP], val);
 }
@@ -970,6 +992,11 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
 	__this_cpu_add(memcg->stat->nr_page_events,
 					nr_pages < 0 ? -nr_pages : nr_pages);
 
+	if (!mem_cgroup_in_use()) {
+		preempt_enable();
+		return;
+	}
+
 	if (!mem_cgroup_is_root(memcg)) {
 		/*
 		 * Here, RSS means 'mapped anon' and anon's SwapCache. Shmem/tmpfs is
@@ -2278,11 +2305,13 @@ void mem_cgroup_update_page_stat(struct page *page,
 {
 	struct mem_cgroup *memcg;
 	struct page_cgroup *pc = lookup_page_cgroup(page);
-	unsigned long uninitialized_var(flags);
 
 	if (mem_cgroup_disabled())
 		return;
 
+	if (!mem_cgroup_in_use())
+		return;
+
 	memcg = pc->mem_cgroup;
 
 	if (mem_cgroup_is_root(memcg))
@@ -6414,6 +6443,9 @@ mem_cgroup_css_online(struct cgroup *cont)
 	}
 
 	error = memcg_init_kmem(memcg, &mem_cgroup_subsys);
+	if (!error)
+		arm_inuse_keys();
+
 	mutex_unlock(&memcg_create_mutex);
 	if (error) {
 		/*
-- 
1.7.9.5
