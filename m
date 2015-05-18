From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/7] cpuset: migrate memory only for threadgroup leaders
Date: Mon, 18 May 2015 15:49:49 -0400
Message-ID: <1431978595-12176-2-git-send-email-tj@kernel.org>
References: <1431978595-12176-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=umzrmk9idk7sTqDxo5GCYlbi5SLjiJM4/7KF9kfGY6Q=;
        b=u0QKsx98Zevbo7KgV6GyP5zSCVrUhpG5VusD/jaXgnCCkap6y6UWPmk0fAJ2mtN9Jn
         pu+BHfjimQunSNwsc1l9raIE0WfBxPwe3ZlswQaiDx/e+998vcqcV1A48MUUFIy+BLaL
         rgj0AYYTg+/puRjkozTOkb/hODFEZ3ViioWM3OeY+lOsgKySrwabpS3FfStmd5Nl2XZK
         wzTZQLtftGg5ejC2zkH9CTClAon14pZNeSHkVL0vjiiX/+VixkjkTLUQi6rfp367OQWh
         tMIzPZLlZVQGwFE9NNiEzTWVSRTtSI/EeAtVNVRhJ4ORoZdeSIr3EMFZkMVH20l0YWyj
         Pqvg==
In-Reply-To: <1431978595-12176-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

If memory_migrate flag is set, cpuset migrates memory according to the
destnation css's nodemask.  The current implementation migrates memory
whenever any thread of a process is migrated making the behavior
somewhat arbitrary.  Let's tie memory operations to the threadgroup
leader so that memory is migrated only when the leader is migrated.

While this is a behavior change, given the inherent fuziness, this
change is not too likely to be noticed and allows us to clearly define
who owns the memory (always the leader) and helps the planned atomic
multi-process migration.

Note that we're currently migrating memory in migration path proper
while holding all the locks.  In the long term, this should be moved
out to an async work item.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cpuset.c | 40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index ee14e3a..43db5b7 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1484,7 +1484,6 @@ static void cpuset_attach(struct cgroup_subsys_state *css,
 {
 	/* static buf protected by cpuset_mutex */
 	static nodemask_t cpuset_attach_nodemask_to;
-	struct mm_struct *mm;
 	struct task_struct *task;
 	struct task_struct *leader = cgroup_taskset_first(tset);
 	struct cpuset *cs = css_cs(css);
@@ -1512,26 +1511,31 @@ static void cpuset_attach(struct cgroup_subsys_state *css,
 	}
 
 	/*
-	 * Change mm, possibly for multiple threads in a threadgroup. This is
-	 * expensive and may sleep.
+	 * Change mm, possibly for multiple threads in a threadgroup. This
+	 * is expensive and may sleep and should be moved outside migration
+	 * path proper.
 	 */
 	cpuset_attach_nodemask_to = cs->effective_mems;
-	mm = get_task_mm(leader);
-	if (mm) {
-		mpol_rebind_mm(mm, &cpuset_attach_nodemask_to);
-
-		/*
-		 * old_mems_allowed is the same with mems_allowed here, except
-		 * if this task is being moved automatically due to hotplug.
-		 * In that case @mems_allowed has been updated and is empty,
-		 * so @old_mems_allowed is the right nodesets that we migrate
-		 * mm from.
-		 */
-		if (is_memory_migrate(cs)) {
-			cpuset_migrate_mm(mm, &oldcs->old_mems_allowed,
-					  &cpuset_attach_nodemask_to);
+	if (thread_group_leader(leader)) {
+		struct mm_struct *mm = get_task_mm(leader);
+
+		if (mm) {
+			mpol_rebind_mm(mm, &cpuset_attach_nodemask_to);
+
+			/*
+			 * old_mems_allowed is the same with mems_allowed
+			 * here, except if this task is being moved
+			 * automatically due to hotplug.  In that case
+			 * @mems_allowed has been updated and is empty, so
+			 * @old_mems_allowed is the right nodesets that we
+			 * migrate mm from.
+			 */
+			if (is_memory_migrate(cs)) {
+				cpuset_migrate_mm(mm, &oldcs->old_mems_allowed,
+						  &cpuset_attach_nodemask_to);
+			}
+			mmput(mm);
 		}
-		mmput(mm);
 	}
 
 	cs->old_mems_allowed = cpuset_attach_nodemask_to;
-- 
2.4.0
