From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH v3 09/21] Smack: Handle labels consistently in
	untrusted mounts
Date: Fri, 22 Apr 2016 10:38:26 -0500
Message-ID: <1461339521-123191-10-git-send-email-seth.forshee@canonical.com>
References: <1461339521-123191-1-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1461339521-123191-1-git-send-email-seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=fuse-devel>
List-Post: <mailto:fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>

The SMACK64, SMACK64EXEC, and SMACK64MMAP labels are all handled
differently in untrusted mounts. This is confusing and
potentically problematic. Change this to handle them all the same
way that SMACK64 is currently handled; that is, read the label
from disk and check it at use time. For SMACK64 and SMACK64MMAP
access is denied if the label does not match smk_root. To be
consistent with suid, a SMACK64EXEC label which does not match
smk_root will still allow execution of the file but will not run
with the label supplied in the xattr.

Signed-off-by: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Acked-by: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
---
 security/smack/smack_lsm.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index aa17198cd5f2..ca564590cc1b 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -919,6 +919,7 @@ static int smack_bprm_set_creds(struct linux_binprm *bprm)
 	struct inode *inode = file_inode(bprm->file);
 	struct task_smack *bsp = bprm->cred->security;
 	struct inode_smack *isp;
+	struct superblock_smack *sbsp;
 	int rc;
 
 	if (bprm->cred_prepared)
@@ -928,6 +929,11 @@ static int smack_bprm_set_creds(struct linux_binprm *bprm)
 	if (isp->smk_task == NULL || isp->smk_task == bsp->smk_task)
 		return 0;
 
+	sbsp = inode->i_sb->s_security;
+	if ((sbsp->smk_flags & SMK_SB_UNTRUSTED) &&
+	    isp->smk_task != sbsp->smk_root)
+		return 0;
+
 	if (bprm->unsafe & (LSM_UNSAFE_PTRACE | LSM_UNSAFE_PTRACE_CAP)) {
 		struct task_struct *tracer;
 		rc = 0;
@@ -1725,6 +1731,7 @@ static int smack_mmap_file(struct file *file,
 	struct task_smack *tsp;
 	struct smack_known *okp;
 	struct inode_smack *isp;
+	struct superblock_smack *sbsp;
 	int may;
 	int mmay;
 	int tmay;
@@ -1736,6 +1743,10 @@ static int smack_mmap_file(struct file *file,
 	isp = file_inode(file)->i_security;
 	if (isp->smk_mmap == NULL)
 		return 0;
+	sbsp = file_inode(file)->i_sb->s_security;
+	if (sbsp->smk_flags & SMK_SB_UNTRUSTED &&
+	    isp->smk_mmap != sbsp->smk_root)
+		return -EACCES;
 	mkp = isp->smk_mmap;
 
 	tsp = current_security();
@@ -3546,16 +3557,14 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 			if (rc >= 0)
 				transflag = SMK_INODE_TRANSMUTE;
 		}
-		if (!(sbsp->smk_flags & SMK_SB_UNTRUSTED)) {
-			/*
-			 * Don't let the exec or mmap label be "*" or "@".
-			 */
-			skp = smk_fetch(XATTR_NAME_SMACKEXEC, inode, dp);
-			if (IS_ERR(skp) || skp == &smack_known_star ||
-			    skp == &smack_known_web)
-				skp = NULL;
-			isp->smk_task = skp;
-		}
+		/*
+		 * Don't let the exec or mmap label be "*" or "@".
+		 */
+		skp = smk_fetch(XATTR_NAME_SMACKEXEC, inode, dp);
+		if (IS_ERR(skp) || skp == &smack_known_star ||
+		    skp == &smack_known_web)
+			skp = NULL;
+		isp->smk_task = skp;
 
 		skp = smk_fetch(XATTR_NAME_SMACKMMAP, inode, dp);
 		if (IS_ERR(skp) || skp == &smack_known_star ||
-- 
1.9.1


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
-- 
fuse-devel mailing list
To unsubscribe or subscribe, visit https://lists.sourceforge.net/lists/listinfo/fuse-devel
