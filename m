From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v4.11-rc2
Date: Tue, 14 Mar 2017 17:01:47 -0400
Message-ID: <20170314210147.GD15132@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=CZyzzcAMaAhrGhBCYh2ADJorn/iFryxRJ0JiyVs0qE0=;
        b=gLmqHdK0bHfEmHyI9AKzWluHTz2Edm/OhWQSDJuspEiMrgicjxhhX7suKY6mvkXlTN
         3/QMCkgo/3dKmwP1vA6GW7+Sqwkw7Pma1LLXzShCjyT+KvMPZUiUxTz1VIESB7MXMTik
         Tq1zEeQJwgJWuJQogJ0V/qVuVi4TQ1szQ/BfyV0t0BVDwfwBACxjghhmLKNzvc6w7rbe
         Slv76VlC8/hZ3E8uIWrjFZFqWMcr5RaV4yPGxlI0rE+tsJQYjJEEGgmYJsyaYrDEqpcv
         tsHxoljJmSp0UAch3eg5u5VaiB8CLGHAwaPVwivy//VKTNYFFCBKdQ7QajPs7Q7hdm9a
         tE9Q==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

Three cgroup fixes.  Nothing critical.

* The pids controller could trigger suspicious RCU warning spuriously.
  Fixed.

* In the debug controller, %p -> %pK to protect kernel pointer from
  getting exposed.

* Documentation formatting fix.

Thanks.

The following changes since commit c1ae3cfa0e89fa1a7ecc4c99031f5e9ae99d9201:

  Linux 4.11-rc1 (2017-03-05 12:59:56 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.11-fixes

for you to fetch changes up to b6a6759daf55dade2b65089957832759d502acfb:

  cgroups: censor kernel pointer in debug files (2017-03-06 15:16:03 -0500)

----------------------------------------------------------------
Kees Cook (1):
      cgroups: censor kernel pointer in debug files

Tejun Heo (1):
      cgroup/pids: remove spurious suspicious RCU usage warning

Tobias Klauser (1):
      cgroup: Fix indenting in PID controller documentation

 Documentation/cgroup-v2.txt | 11 ++++++-----
 kernel/cgroup/cgroup-v1.c   |  2 +-
 kernel/cgroup/pids.c        |  2 +-
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index 3b8449f..49d7c99 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -1142,16 +1142,17 @@ used by the kernel.
 
   pids.max
 
- A read-write single value file which exists on non-root cgroups.  The
- default is "max".
+	A read-write single value file which exists on non-root
+	cgroups.  The default is "max".
 
- Hard limit of number of processes.
+	Hard limit of number of processes.
 
   pids.current
 
- A read-only single value file which exists on all cgroups.
+	A read-only single value file which exists on all cgroups.
 
- The number of processes currently in the cgroup and its descendants.
+	The number of processes currently in the cgroup and its
+	descendants.
 
 Organisational operations are not blocked by cgroup policies, so it is
 possible to have pids.current > pids.max.  This can be done by either
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 56eba9c..1dc22f6 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -1329,7 +1329,7 @@ static int cgroup_css_links_read(struct seq_file *seq, void *v)
 		struct task_struct *task;
 		int count = 0;
 
-		seq_printf(seq, "css_set %p\n", cset);
+		seq_printf(seq, "css_set %pK\n", cset);
 
 		list_for_each_entry(task, &cset->tasks, cg_list) {
 			if (count++ > MAX_TASKS_SHOWN_PER_CSS)
diff --git a/kernel/cgroup/pids.c b/kernel/cgroup/pids.c
index e756dae..2237201 100644
--- a/kernel/cgroup/pids.c
+++ b/kernel/cgroup/pids.c
@@ -229,7 +229,7 @@ static int pids_can_fork(struct task_struct *task)
 		/* Only log the first time events_limit is incremented. */
 		if (atomic64_inc_return(&pids->events_limit) == 1) {
 			pr_info("cgroup: fork rejected by pids controller in ");
-			pr_cont_cgroup_path(task_cgroup(current, pids_cgrp_id));
+			pr_cont_cgroup_path(css->cgroup);
 			pr_cont("\n");
 		}
 		cgroup_file_notify(&pids->events_file);

-- 
tejun
