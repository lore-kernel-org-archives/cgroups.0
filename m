From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/4] mm/oom: handle remote ooms
Date: Wed, 10 Nov 2021 13:19:48 -0800
Message-ID: <20211110211951.3730787-3-almasrymina@google.com>
References: <20211110211951.3730787-1-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
        bh=VaRLTVJVm8bc5oD03oVAGrqeOn+Oq3c9ZULJFx/+Xrg=;
        b=ZRt8IcmyzTVn4UbNUqU42UgqUs8gj+sBg7Q2DWoy2p/NXaPWqgCIbES5OSatgTBOpQ
         ZsbTzfPvlARVBLkmi6Xg/raHqeKIlpKRd86dCQlXLorUydu9M+SdMZvMjDroflzf8hPk
         47KT6GjuZezkT5mQ4/F8NI2VJcYKiMz9Koih0cg792tqeKSi6WEbmJf8CxAiTu5/pDoZ
         gbG7a2ROhqitQXIbe+8A9uMYD1vkr1Bb9jeYXQGClhsgnTQsV0K7PA0l912tYXiQsGDr
         xrr3FJ82UN6xOK8T8XZatXvlk9TXZ9lgYsP+T9PCYxa0swZdC7WjKtxn9VKbevA02w8r
         t+EQ==
In-Reply-To: <20211110211951.3730787-1-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On remote ooms (OOMs due to remote charging), the oom-killer will attempt
to find a task to kill in the memcg under oom, if the oom-killer
is unable to find one, the oom-killer should simply return ENOMEM to the
allocating process.

If we're in pagefault path and we're unable to return ENOMEM to the
allocating process, we instead kill the allocating process.

Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Cc: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

---

Changes in v2:
- Moved the remote oom handling as Roman requested.
- Used mem_cgroup_from_task(current) instead of grabbing the memcg from
current->mm

---
 include/linux/memcontrol.h |  6 ++++++
 mm/memcontrol.c            | 29 +++++++++++++++++++++++++++++
 mm/oom_kill.c              | 22 ++++++++++++++++++++++
 3 files changed, 57 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 866904afd3563..ae4686abd4d32 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -937,6 +937,7 @@ struct mem_cgroup *mem_cgroup_get_from_path(const char *path);
  * it.
  */
 int mem_cgroup_get_name_from_sb(struct super_block *sb, char *buf, size_t len);
+bool is_remote_oom(struct mem_cgroup *memcg_under_oom);

 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 		int zid, int nr_pages);
@@ -1270,6 +1271,11 @@ static inline int mem_cgroup_get_name_from_sb(struct super_block *sb, char *buf,
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
index 0a7e16b16b8c3..0e0097a0aed45 100644
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
+			if (current->in_user_fault &&
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
