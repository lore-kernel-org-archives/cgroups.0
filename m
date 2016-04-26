From: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v4 09/21] Smack: Handle labels consistently in untrusted mounts
Date: Tue, 26 Apr 2016 14:36:22 -0500
Message-ID: <1461699396-33000-10-git-send-email-seth.forshee@canonical.com>
References: <1461699396-33000-1-git-send-email-seth.forshee@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=canonical-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aeG73OW9Xy1CAYW4s8YPsK1DWTEX4M6k8ROnPiImiQM=;
        b=dJVxu8CvR2IOnLiMj+nVhBBC3n8eJq/E/4Y+nwv8uyMy2EYW4Hs1l1Fw4IqD9NtpV/
         ARLRjLtZ6VjapiRvzdMChXO0glLFF6hR5Z6weArYdRmZSaG18ZKObaCBVKwxSf6RPmIu
         4iH+xXI0RDmJSWFko93KB2GD3dpkCmn0oUKjAPYQKO3BtcsY62/Y0a4rbKSMppqOSRIj
         mabfPjmUdAGnqEkTvIlZ3/yyPBCEgEmrBNE2cknP40OefG9Eu1kuvcw5OrhrxFR+fQK2
         N6b533hcp8qAZDyMDMS8ytioZnfDxvvqhPT5M/xsmiIfW6jO1e58XFNczXqc2f77yD+g
         Im2Q==
In-Reply-To: <1461699396-33000-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Eric W. Biederman" <ebiederm@xmission.com>, Casey Schaufler <casey@schaufler-ca.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, cgroups@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>

The SMACK64, SMACK64EXEC, and SMACK64MMAP labels are all handled
differently in untrusted mounts. This is confusing and
potentically problematic. Change this to handle them all the same
way that SMACK64 is currently handled; that is, read the label
from disk and check it at use time. For SMACK64 and SMACK64MMAP
access is denied if the label does not match smk_root. To be
consistent with suid, a SMACK64EXEC label which does not match
smk_root will still allow execution of the file but will not run
with the label supplied in the xattr.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
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
2.7.4

