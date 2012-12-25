From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V3 7/8] memcg: disable memcg page stat accounting code when not in use
Date: Wed, 26 Dec 2012 01:27:57 +0800
Message-ID: <1356456477-14780-1-git-send-email-handai.szj@taobao.com>
References: <1356455919-14445-1-git-send-email-handai.szj@taobao.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=UFDAr12inUh8RLLdy4ZFwUlfd1gw1xMCeUTjqwDeYzU=;
        b=bGImGVLqgeHfhqnQMcD9LkEa0e+P5No5ijKYFaNzP3nC7R3xoskHobEcwBgovQfd3x
         oQ3mjLweP7FnmKBLkWC2fJQ6ui3dwMhqu4F7VWa27r8qH9VNq3FuVi8BVmxmVKhFwkZU
         H578mG73dYWLDKlyzdFyqREOamW8k2gSMNtp3vs+pkJRSTa2BBWDL3YQ5lNEklS3HecP
         Vxx9L/ciwJnnmDfCSA32byytGP6L+iIqUs66IA4Bt5FSxhtkm/Lw8s3P5Qtr1kbaDHEm
         wduQD8gZttnib5U2ii36cN54nLcuVqLc/qRYG74xKDWpKDAkOpTZ+zV98LteJBCN8l3f
         zhwQ==
In-Reply-To: <1356455919-14445-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

It's inspired by a similar optimization from Glauber Costa
(memcg: make it suck faster; https://lkml.org/lkml/2012/9/25/154).
Here we use jump label to patch the memcg page stat accounting code
in or out when not used. when the first non-root memcg comes to
life the code is patching in otherwise it is out.

Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/memcontrol.h |    9 +++++++++
 mm/memcontrol.c            |    8 ++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 1d22b81..3c4430c 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -56,6 +56,9 @@ struct mem_cgroup_reclaim_cookie {
 };
 
 #ifdef CONFIG_MEMCG
+
+extern struct static_key memcg_in_use_key;
+
 /*
  * All "charge" functions with gfp_mask should use GFP_KERNEL or
  * (gfp_mask & GFP_RECLAIM_MASK). In current implementatin, memcg doesn't
@@ -158,6 +161,9 @@ extern atomic_t memcg_moving;
 static inline void mem_cgroup_begin_update_page_stat(struct page *page,
 					bool *locked, unsigned long *flags)
 {
+	if (!static_key_false(&memcg_in_use_key))
+		return;
+
 	if (mem_cgroup_disabled())
 		return;
 	rcu_read_lock();
@@ -171,6 +177,9 @@ void __mem_cgroup_end_update_page_stat(struct page *page,
 static inline void mem_cgroup_end_update_page_stat(struct page *page,
 					bool *locked, unsigned long *flags)
 {
+	if (!static_key_false(&memcg_in_use_key))
+		return;
+
 	if (mem_cgroup_disabled())
 		return;
 	if (*locked)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0cb5187..a2f73d7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -531,6 +531,8 @@ enum res_type {
 #define MEM_CGROUP_RECLAIM_SHRINK_BIT	0x1
 #define MEM_CGROUP_RECLAIM_SHRINK	(1 << MEM_CGROUP_RECLAIM_SHRINK_BIT)
 
+struct static_key memcg_in_use_key;
+
 static void mem_cgroup_get(struct mem_cgroup *memcg);
 static void mem_cgroup_put(struct mem_cgroup *memcg);
 
@@ -2226,6 +2228,9 @@ void mem_cgroup_update_page_stat(struct page *page,
 	struct page_cgroup *pc = lookup_page_cgroup(page);
 	unsigned long uninitialized_var(flags);
 
+	if (!static_key_false(&memcg_in_use_key))
+		return;
+
 	if (mem_cgroup_disabled())
 		return;
 
@@ -6340,6 +6345,8 @@ mem_cgroup_css_alloc(struct cgroup *cont)
 		parent = mem_cgroup_from_cont(cont->parent);
 		memcg->use_hierarchy = parent->use_hierarchy;
 		memcg->oom_kill_disable = parent->oom_kill_disable;
+
+		static_key_slow_inc(&memcg_in_use_key);
 	}
 
 	if (parent && parent->use_hierarchy) {
@@ -6407,6 +6414,7 @@ static void mem_cgroup_css_free(struct cgroup *cont)
 	kmem_cgroup_destroy(memcg);
 
 	memcg_dangling_add(memcg);
+	static_key_slow_dec(&memcg_in_use_key);
 	mem_cgroup_put(memcg);
 }
 
-- 
1.7.9.5
