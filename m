From: Tejun Heo <tj@kernel.org>
Subject: [PATCH cgroup/for-4.11] cgroup: drop the matching uid requirement on
 migration for cgroup v2
Date: Fri, 20 Jan 2017 11:29:54 -0500
Message-ID: <20170120162954.GA30978@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=B0t/H9q29FfuA6RvuN3c2C3chmC4DBuXE2MdDJ7Njs0=;
        b=Sx4Xxl8uUhO8NITOdt9U9JVRvNwiQDpdQ52TyammmL8/G/7bswRpBsD/w0nvH2EPMr
         fVGwQjA2HMLqqBdKU6FlsDSE4ExJmzPfR7DkmV+ncj+v+lYixq8u9AMDCrhBO0N/2/dw
         n0Tu3x4fhOlhOMtrvBsBdL7nh3R5eMQEJyLzQqzJZ1xylyINtcvRHJe3hOcIYa6BjL2Q
         nuNL33yLD8BC/DQnjm0WprgE/lhYXMD8dsMcs9NkZWWaZRfuEBpqkTDcr5CAE4/Kgc63
         zUXlfTfHFWWXz1woNTFbPER84LAQv1LglZjHM+sASP5/lsZ21yqyGzTMXs3UK4hpR3mV
         KRpA==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Along with the write access to the cgroup.procs or tasks file, cgroup
has required the writer's euid, unless root, to match [s]uid of the
target process or task.  On cgroup v1, this is necessary because
there's nothing preventing a delegatee from pulling in tasks or
processes from all over the system.

If a user has a cgroup subdirectory delegated to it, the user would
have write access to the cgroup.procs or tasks file.  If there are no
further checks than file write access check, the user would be able to
pull processes from all over the system into its subhierarchy which is
clearly not the intended behavior.  The matching [s]uid requirement
partially prevents this problem by allowing a delegatee to pull in the
processes that belongs to it.  This isn't a sufficient protection
however, because a user would still be able to jump processes across
two disjoint sub-hierarchies that has been delegated to them.

cgroup v2 resolves the issue by requiring the writer to have access to
the common ancestor of the cgroup.procs file of the source and target
cgroups.  This confines each delegatee to their own sub-hierarchy
proper and bases all permission decisions on the cgroup filesystem
rather than having to pull in explicit uid matching.

cgroup v2 has still been applying the matching [s]uid requirement just
for historical reasons.  On cgroup2, the requirement doesn't serve any
purpose while unnecessarily complicating the permission model.  Let's
drop it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 Documentation/cgroup-v2.txt |   12 +++++-------
 kernel/cgroup/cgroup.c      |   27 ++++++++++++++-------------
 2 files changed, 19 insertions(+), 20 deletions(-)

--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -330,14 +330,12 @@ a process with a non-root euid to migrat
 cgroup by writing its PID to the "cgroup.procs" file, the following
 conditions must be met.
 
-- The writer's euid must match either uid or suid of the target process.
-
 - The writer must have write access to the "cgroup.procs" file.
 
 - The writer must have write access to the "cgroup.procs" file of the
   common ancestor of the source and destination cgroups.
 
-The above three constraints ensure that while a delegatee may migrate
+The above two constraints ensure that while a delegatee may migrate
 processes around freely in the delegated sub-hierarchy it can't pull
 in from or push out to outside the sub-hierarchy.
 
@@ -352,10 +350,10 @@ all processes under C0 and C1 belong to
 
 Let's also say U0 wants to write the PID of a process which is
 currently in C10 into "C00/cgroup.procs".  U0 has write access to the
-file and uid match on the process; however, the common ancestor of the
-source cgroup C10 and the destination cgroup C00 is above the points
-of delegation and U0 would not have write access to its "cgroup.procs"
-files and thus the write will be denied with -EACCES.
+file; however, the common ancestor of the source cgroup C10 and the
+destination cgroup C00 is above the points of delegation and U0 would
+not have write access to its "cgroup.procs" files and thus the write
+will be denied with -EACCES.
 
 
 2-6. Guidelines
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2352,20 +2352,9 @@ static int cgroup_procs_write_permission
 					 struct cgroup *dst_cgrp,
 					 struct kernfs_open_file *of)
 {
-	const struct cred *cred = current_cred();
-	const struct cred *tcred = get_task_cred(task);
 	int ret = 0;
 
-	/*
-	 * even if we're attaching all tasks in the thread group, we only
-	 * need to check permissions on one of them.
-	 */
-	if (!uid_eq(cred->euid, GLOBAL_ROOT_UID) &&
-	    !uid_eq(cred->euid, tcred->uid) &&
-	    !uid_eq(cred->euid, tcred->suid))
-		ret = -EACCES;
-
-	if (!ret && cgroup_on_dfl(dst_cgrp)) {
+	if (cgroup_on_dfl(dst_cgrp)) {
 		struct super_block *sb = of->file->f_path.dentry->d_sb;
 		struct cgroup *cgrp;
 		struct inode *inode;
@@ -2383,9 +2372,21 @@ static int cgroup_procs_write_permission
 			ret = inode_permission(inode, MAY_WRITE);
 			iput(inode);
 		}
+	} else {
+		const struct cred *cred = current_cred();
+		const struct cred *tcred = get_task_cred(task);
+
+		/*
+		 * even if we're attaching all tasks in the thread group,
+		 * we only need to check permissions on one of them.
+		 */
+		if (!uid_eq(cred->euid, GLOBAL_ROOT_UID) &&
+		    !uid_eq(cred->euid, tcred->uid) &&
+		    !uid_eq(cred->euid, tcred->suid))
+			ret = -EACCES;
+		put_cred(tcred);
 	}
 
-	put_cred(tcred);
 	return ret;
 }
 
