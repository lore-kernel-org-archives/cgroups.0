From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 3/5] mm/oom: handle remote ooms
Date: Mon,  8 Nov 2021 13:19:57 -0800
Message-ID: <20211108211959.1750915-4-almasrymina@google.com>
References: <20211108211959.1750915-1-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
        bh=HuOsUesI41VMxHbd9WL9Fs5X3h8wZbAlymoJuWa+M0o=;
        b=mgCbALj0RzI1y7dYKpXbyaiAMLfsKBudFfa7Ub2nVulXL0OgGprL2nvZQ5jgnYWFQk
         FyRwZRuXkDXDZQg/EmG5RPSKJ0THWJP0Gn8tavb7JhK0Lx6F7Dj9+4l1egra+m7YtrPy
         lpmGx4XlaWZ9qtVHp2GizypVKABYErQ15IN9nQhWjo3/L/uwJ8MJb1L7MoiMNoVeyH0V
         iwZn7AfMAJUXEPjwLeaNB9ZvVpm0reoL4Ua4Yl6E+SYJvPNIlcuk4x63koSryTbpjh2C
         Dfoc/LjYIFQeWJUEHu9QP2jJta84c10T9HT3Jpk5hQhWEHbsuURruitDfys71o4MWJGi
         BxHw==
In-Reply-To: <20211108211959.1750915-1-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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
Cc: Roman Gushchin <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
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
 mm/memcontrol.c | 21 +++++++++++++++++++++
 mm/oom_kill.c   | 21 +++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2e4c20d09f959..fc9c6280266b6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2664,6 +2664,27 @@ int mem_cgroup_get_name_from_sb(struct super_block *sb, char *buf, size_t len)
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
+	current_memcg = get_mem_cgroup_from_mm(current->mm);
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
index 0a7e16b16b8c3..556329dee273f 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -1106,6 +1106,27 @@ bool out_of_memory(struct oom_control *oc)
 	}

 	select_bad_process(oc);
+
+	/*
+	 * For remote ooms in userfaults, we have no choice but to kill the
+	 * allocating process.
+	 */
+	if (!oc->chosen && is_remote_oom(oc->memcg) && current->in_user_fault &&
+	    !oom_unkillable_task(current)) {
+		get_task_struct(current);
+		oc->chosen = current;
+		oom_kill_process(
+			oc, "Out of memory (Killing remote allocating task)");
+		return true;
+	}
+
+	/*
+	 * For remote ooms in non-userfaults, simply return ENOMEM to the
+	 * caller.
+	 */
+	if (!oc->chosen && is_remote_oom(oc->memcg))
+		return false;
+
 	/* Found nothing?!?! */
 	if (!oc->chosen) {
 		dump_header(oc, NULL);
