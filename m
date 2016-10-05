From: John Stultz <john.stultz@linaro.org>
Subject: [RFC][PATCH] cgroup: Add new capability to allow a process to migrate other tasks between cgroups
Date: Tue,  4 Oct 2016 17:21:14 -0700
Message-ID: <1475626874-22949-1-git-send-email-john.stultz@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=fUQ0GjMEQVYvJMvhpRm4pLlrvJk9OmLwMIkbO0C341E=;
        b=T4QXomIVNfc+UTQ3SNEwHJt5AmSbbLDI3ipxufD3tJEB46qwiAI13ZF6uxbCFrEVtL
         cbbcJjY5yDoBoeyO5s7DLaCFefDPgL3Jgqu38sz8l8hYMzR93lD0SISFxI9G9zYDwHbg
         zL9rNkJhKLR2hRN5jmpOEfWfaIXFamB4hFYdo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, Android Kernel Team <kernel-team@android.com>, Rom Lemarchand <romlem@android.com>, Colin Cross <ccross@android.com>, Dmitry Shmidt <dimitrysh@google.com>, Todd Kjos <tkjos@google.com>, Christian Poetzsch <christian.potzsch@imgtec.com>, Amit Pundir <amit.pundir@linaro.org>, "Serge E. Hallyn" <serge@hallyn.com>

This patch adds CAP_GROUP_MIGRATE_TASK and logic to allows a process
to migrate other tasks between cgroups.

In Android (where this feature originated), the ActivityManager tracks
various application states (TOP_APP, FOREGROUND, BACKGROUND, SYSTEM,
etc), and then as applications change states, the SchedPolicy logic
will migrate the application tasks between different cgroups used
to control the different application states (for example, there is a
background cpuset cgroup which can limit background tasks to stay
on one low-power cpu, and the bg_non_interactive cpuctrl cgroup can
then further limit those background tasks to a small percentage of
that one cpu's cpu time).

However, for security reasons, Android doesn't want to make the
system_server (the process that runs the ActivityManager and
SchedPolicy logic), run as root. So in the Android common.git
kernel, they have some logic to allow cgroups to loosen their
permissions so CAP_SYS_NICE tasks can migrate other tasks between
cgroups.

The approach taken there overloads CAP_SYS_NICE a bit much, and
is maybe more complicated then needed.

So this patch, as suggested by Tejun,  simply adds a new process
capability flag (CAP_CGROUP_MIGRATE_TASK), and uses it when checking
if a task can migrate other tasks between cgroups.

I've tested this with AOSP master (though its a bit hacked in as I
still need to properly get the selinux bits aware of the new
capability bit) with selinux set to permissive and it seems to be
working well.

Thouhts and feedback would be appreciated!

Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: cgroups@vger.kernel.org
Cc: Android Kernel Team <kernel-team@android.com>
Cc: Rom Lemarchand <romlem@android.com>
Cc: Colin Cross <ccross@android.com>
Cc: Dmitry Shmidt <dimitrysh@google.com>
Cc: Todd Kjos <tkjos@google.com>
Cc: Christian Poetzsch <christian.potzsch@imgtec.com>
Cc: Amit Pundir <amit.pundir@linaro.org>
Cc: Serge E. Hallyn <serge@hallyn.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/uapi/linux/capability.h | 5 ++++-
 kernel/cgroup.c                 | 3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
index 49bc062..e199ea0 100644
--- a/include/uapi/linux/capability.h
+++ b/include/uapi/linux/capability.h
@@ -349,8 +349,11 @@ struct vfs_cap_data {
 
 #define CAP_AUDIT_READ		37
 
+/* Allow migrating tasks between cgroups */
 
-#define CAP_LAST_CAP         CAP_AUDIT_READ
+#define CAP_CGROUP_MIGRATE_TASK	38
+
+#define CAP_LAST_CAP         CAP_CGROUP_MIGRATE_TASK
 
 #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 9ba28310..a318956 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2847,7 +2847,8 @@ static int cgroup_procs_write_permission(struct task_struct *task,
 	 */
 	if (!uid_eq(cred->euid, GLOBAL_ROOT_UID) &&
 	    !uid_eq(cred->euid, tcred->uid) &&
-	    !uid_eq(cred->euid, tcred->suid))
+	    !uid_eq(cred->euid, tcred->suid) &&
+	    !ns_capable(tcred->user_ns, CAP_CGROUP_MIGRATE_TASK))
 		ret = -EACCES;
 
 	if (!ret && cgroup_on_dfl(dst_cgrp)) {
-- 
1.9.1

