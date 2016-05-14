From: Aleksa Sarai <asarai@suse.de>
Subject: [PATCH v4 1/2] cgroup: make cgroup.procs permissions userns-aware
Date: Sat, 14 May 2016 13:19:59 +1000
Message-ID: <1463196000-13900-2-git-send-email-asarai@suse.de>
References: <1463196000-13900-1-git-send-email-asarai@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1463196000-13900-1-git-send-email-asarai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Aleksa Sarai <cyphar@cyphar.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, dev@opencontainers.org, Aleksa Sarai <asarai@suse.de>

Instead of comparing the thread's euid to GLOBAL_ROOT_UID, use
capabilities to check the additional privileges required to migrate
processes between cgroups. In addition, add further permissions to
cgroup namespaces where:

* Both tasks are in the same cgroup namespace; and
* The current task has CAP_SYS_ADMIN in the target task's user namespace
  well as in the user namespace the cgroup namespace was created in.
  This essentially requires all of the namespaces to to be the same.

This allows for subtree management of processes in a cgroup namespace,
by a process that is in a user namespace.

Signed-off-by: Aleksa Sarai <asarai@suse.de>
---
 kernel/cgroup.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 86cb5c6e8932..f1c798b69561 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2841,6 +2841,8 @@ static int cgroup_procs_write_permission(struct task_struct *task,
 					 struct cgroup *dst_cgrp,
 					 struct kernfs_open_file *of)
 {
+	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
+	struct cgroup_namespace *tns = task->nsproxy->cgroup_ns;
 	const struct cred *cred = current_cred();
 	const struct cred *tcred = get_task_cred(task);
 	int ret = 0;
@@ -2850,6 +2852,10 @@ static int cgroup_procs_write_permission(struct task_struct *task,
 	 * need to check permissions on one of them.
 	 */
 	if (!uid_eq(cred->euid, GLOBAL_ROOT_UID) &&
+	    !capable(CAP_SYS_ADMIN) &&
+	    !(ns == tns && ns_capable(tcred->user_ns, CAP_SYS_ADMIN) &&
+	      ns_capable(cred->user_ns, CAP_SYS_ADMIN) &&
+	      ns_capable(ns->user_ns, CAP_SYS_ADMIN)) &&
 	    !uid_eq(cred->euid, tcred->uid) &&
 	    !uid_eq(cred->euid, tcred->suid))
 		ret = -EACCES;
-- 
2.8.2

