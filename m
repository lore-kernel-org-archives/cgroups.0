From: Mina Almasry <almasrymina@google.com>
Subject: [PATCH v3 2/4] mm/oom: handle remote ooms
Date: Thu, 11 Nov 2021 15:42:01 -0800
Message-ID: <20211111234203.1824138-3-almasrymina@google.com>
References: <20211111234203.1824138-1-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
        bh=uSYMrm67Vam+Dj2xrSbIEx2XERRWcvK22Y5/aS6BHtY=;
        b=CiDhBgQvahrK+6hVk+HcAOFmXy97c2vf/1ydDDBH1xL0pfjijygM31NRMWm8S5whE6
         VwFoIHYU7JCsu11Ie0nFUvS1kTau69fdABOM/7qmi9XqIpPvM4gnyKU03S0rxudHIdd4
         xydVAMFmUPhqpxIziGaf67c/sT3dJ8w3NLXFbMF4+RCnD6/f/RxSiqpFh7254Gktxk1h
         r7WL7PoRl1aVj1lmIY5o/3Xb5FU/kFA5qsSuO+/VYs3A/t8jN9I0cEL6QIgzUeGslgbT
         +XNoI/2B0fbn4NtjwWsasZUm+4Kz3h1pnnI8dfhKkyAlZdQ+JxFPA6b47EQKFllu+LFD
         8F0g==
In-Reply-To: <20211111234203.1824138-1-almasrymina@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Mina Almasry <almasrymina@google.com>, Michal Hocko <mhocko@suse.com>, Theodore Ts'o <tytso@mit.edu>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Muchun Song <songmuchun@bytedance.com>, riel@surriel.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org

On remote ooms (OOMs due to remote charging), the oom-killer will attempt
to find a task to kill in the memcg under oom, if the oom-killer
is unable to find one, the oom-killer should simply return ENOMEM to the
allocating process.

If we're in pagefault path and we're unable to return ENOMEM to the
allocating process, we instead kill the allocating process.

Signed-off-by: Mina Almasry <almasrymina@google.com>

Cc: Michal Hocko <mhocko@suse.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Greg Thelen <gthelen@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
CC: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: riel@surriel.com
Cc: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org
Cc: cgroups@vger.kernel.org

---

Changes in v3:
- Fixed build failures/warnings Reported-by: kernel test robot <lkp@intel.com>

Changes in v2:
- Moved the remote oom handling as Roman requested.
- Used mem_cgroup_from_task(current) instead of grabbing the memcg from
current->mm

---
 include/linux/memcontrol.h | 16 ++++++++++++++++
 mm/memcontrol.c            | 29 +++++++++++++++++++++++++++++
 mm/oom_kill.c              | 22 ++++++++++++++++++++++
 3 files changed, 67 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 8583d37c05d9b..b7a045ace7b2c 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -944,6 +944,7 @@ struct mem_cgroup *mem_cgroup_get_from_path(const char *path);
  * it.
  */
 int mem_cgroup_get_name_from_sb(struct super_block *sb, char *buf, size_t len);
+bool is_remote_oom(struct mem_cgroup *memcg_under_oom);

 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 		int zid, int nr_pages);
@@ -981,6 +982,11 @@ static inline void mem_cgroup_exit_user_fault(void)
 	current->in_user_fault = 0;
 }

+static inline bool is_in_user_fault(void)
+{
+	return current->in_user_fault;
+}
+
 static inline bool task_in_memcg_oom(struct task_struct *p)
 {
 	return p->memcg_in_oom;
@@ -1281,6 +1287,11 @@ static inline int mem_cgroup_get_name_from_sb(struct super_block *sb, char *buf,
 	return 0;
 }

+static inline bool is_remote_oom(struct mem_cgroup *memcg_under_oom)
+{
+	return false;
+}
+
 static inline int mem_cgroup_swapin_charge_page(struct page *page,
 			struct mm_struct *mm, gfp_t gfp, swp_entry_t entry)
 {
@@ -1472,6 +1483,11 @@ static inline void mem_cgroup_exit_user_fault(void)
 {
 }

+static inline bool is_in_user_fault(void)
+{
+	return false;
+}
+
 static inline bool task_in_memcg_oom(struct task_struct *p)
 {
 	return false;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b3d8f52a63d17..8019c396bfdd9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2664,6 +2664,35 @@ int mem_cgroup_get_name_from_sb(struct super_block *sb, char *buf, size_t len)
 	return ret < 0 ? ret : 0;
 }

+/*
+ * Returns true if current's mm is a descendant of the memcg_under_oom (or
+ * equal to it). False otherwise. This is used by the oom-killer to detect
+ * ooms due to remote charging.
+ */
+bool is_remote_oom(struct mem_cgroup *memcg_under_oom)
+{
+	struct mem_cgroup *current_memcg;
+	bool is_remote_oom;
+
+	if (!memcg_under_oom)
+		return false;
+
+	rcu_read_lock();
+	current_memcg = mem_cgroup_from_task(current);
+	if (current_memcg && !css_tryget_online(&current_memcg->css))
+		current_memcg = NULL;
+	rcu_read_unlock();
+
+	if (!current_memcg)
+		return false;
+
+	is_remote_oom =
+		!mem_cgroup_is_descendant(current_memcg, memcg_under_oom);
+	css_put(&current_memcg->css);
+
+	return is_remote_oom;
+}
+
 /*
  * Set or clear (if @memcg is NULL) charge association from file system to
  * memcg.  If @memcg != NULL, then a css reference must be held by the caller to
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 0a7e16b16b8c3..499924efab370 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -1108,6 +1108,28 @@ bool out_of_memory(struct oom_control *oc)
 	select_bad_process(oc);
 	/* Found nothing?!?! */
 	if (!oc->chosen) {
+		if (is_remote_oom(oc->memcg)) {
+			/*
+			 * For remote ooms in userfaults, we have no choice but
+			 * to kill the allocating process.
+			 */
+			if (is_in_user_fault() &&
+			    !oom_unkillable_task(current)) {
+				get_task_struct(current);
+				oc->chosen = current;
+				oom_kill_process(
+					oc,
+					"Out of memory (Killing remote allocating task)");
+				return true;
+			}
+
+			/*
+			 * For remote ooms in non-userfaults, simply return
+			 * ENOMEM to the caller.
+			 */
+			return false;
+		}
+
 		dump_header(oc, NULL);
 		pr_warn("Out of memory and no killable processes...\n");
 		/*
--
2.34.0.rc1.387.gb447b232ab-goog
