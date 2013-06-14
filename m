From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-3.11] cgroup: disallow rename(2) if sane_behavior
Date: Thu, 13 Jun 2013 20:47:17 -0700
Message-ID: <20130614034717.GA31533@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
	:content-disposition:user-agent;
	bh=MOBDL8jn0iTblmwS2sf8i2xLz3f5kKngdkf9NKXf5D0=;
	b=N0IijnJVvN56zsZTNHy3qTqQ5eX/U5rd5dIwyedw9tebZwzxWEWBhXJ88aOp6VZ1Iy
	8WUNSPqwzhi5BRepua1Dd3x1lBvY2xESThEMM/qJG/co31tZzlO+eXfQCgvwdDEo96gV
	Brp2GmaR42URnk+27YZyYuRKIhm+6s/EeI4ikNRyRImygCiodYMTyYJMAOxjpnb3sE2A
	D3k+VZyXuga67MkpnXwv0SS6i8ZeIA2A94q5a/k2oi/1k/O+zdScTOhqxurSsBxsMZq6
	5bHJPtfVWQsQZI324iIKBPHPAWyIDEmnAnzHnRlmkRaTg2TmsbZjQszOrFf9YZGWBKt/
	426g==
Content-Disposition: inline
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>

cgroup's rename(2) isn't a proper migration implementation - it can't
move the cgroup to a different parent in the hierarchy.  All it can do
is swapping the name string for that cgroup.  This isn't useful and
can mislead users to think that cgroup supports proper cgroup-level
migration.  Disallow rename(2) if sane_behavior.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/linux/cgroup.h |    2 ++
 kernel/cgroup.c        |    7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 1760476..f975227 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -270,6 +270,8 @@ enum {
 	 * - "release_agent" and "notify_on_release" are removed.
 	 *   Replacement notification mechanism will be implemented.
 	 *
+	 * - rename(2) is disallowed.
+	 *
 	 * - memcg: use_hierarchy is on by default and the cgroup file for
 	 *   the flag is not created.
 	 */
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2e9da7b..7d78902 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2508,6 +2508,13 @@ static int cgroup_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	cgrp = __d_cgrp(old_dentry);
 
+	/*
+	 * This isn't a proper migration and its usefulness is very
+	 * limited.  Disallow if sane_behavior.
+	 */
+	if (cgroup_sane_behavior(cgrp))
+		return -EINVAL;
+
 	name = cgroup_alloc_name(new_dentry);
 	if (!name)
 		return -ENOMEM;
