From: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v4 06/21] fs: Treat foreign mounts as nosuid
Date: Tue, 26 Apr 2016 14:36:19 -0500
Message-ID: <1461699396-33000-7-git-send-email-seth.forshee@canonical.com>
References: <1461699396-33000-1-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=canonical-com.20150623.gappssmtp.com; s=20150623;
 h=from:to:cc:subject:date:message-id:in-reply-to:references;
 bh=MPLhsonP/9xhn9KHapaFYigvUMsYtA5c20UuB7nSdQ0=;
 b=kqFS97zlO25mB+SBjzy0lMKcbFA4TX5zrkQH/fDHBSqJajLX9z/fOEkmHSTlzOWajq
 PwrySybLsfoBEtr1Do4Rh+wm5/wTfiGBKdzIidMei6E7+O6yGrPH9lXNhlNMO6J5MLrb
 SF5K0L1aZEIsbXbPAe9wpMkd8CHiLLLSIJR7AIviC823WUkCyL91mbd7i1EKdNFMz4Hr
 9b4LwroJQEOOiijFnQroINJVk981F2hMYCLZdLj1U6GuwC13kqSmx0X9ujOkXFL9P4rX
 Uh7+C+NjLXhjiDFBFI3HF85nIVsVfVyE3LBjmCd6vnL7aT7SS8OW+Ylf7alck9blUKP/
 h6FQ==
In-Reply-To: <1461699396-33000-1-git-send-email-seth.forshee@canonical.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>, Seth Forshee <seth.forshee@canonical.com>, dm-devel@redhat.com, linux-security-module@vger.kernel.org, Richard Weinberger <richard.weinberger@gmail.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, fuse-devel@lists.sourceforge.net, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-mtd@lists.infradead.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

From: Andy Lutomirski <luto@amacapital.net>

If a process gets access to a mount from a different user
namespace, that process should not be able to take advantage of
setuid files or selinux entrypoints from that filesystem.  Prevent
this by treating mounts from other mount namespaces and those not
owned by current_user_ns() or an ancestor as nosuid.

This will make it safer to allow more complex filesystems to be
mounted in non-root user namespaces.

This does not remove the need for MNT_LOCK_NOSUID.  The setuid,
setgid, and file capability bits can no longer be abused if code in
a user namespace were to clear nosuid on an untrusted filesystem,
but this patch, by itself, is insufficient to protect the system
from abuse of files that, when execed, would increase MAC privilege.

As a more concrete explanation, any task that can manipulate a
vfsmount associated with a given user namespace already has
capabilities in that namespace and all of its descendents.  If they
can cause a malicious setuid, setgid, or file-caps executable to
appear in that mount, then that executable will only allow them to
elevate privileges in exactly the set of namespaces in which they
are already privileges.

On the other hand, if they can cause a malicious executable to
appear with a dangerous MAC label, running it could change the
caller's security context in a way that should not have been
possible, even inside the namespace in which the task is confined.

As a hardening measure, this would have made CVE-2014-5207 much
more difficult to exploit.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Acked-by: James Morris <james.l.morris@oracle.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
---
 fs/exec.c                |  2 +-
 fs/namespace.c           | 13 +++++++++++++
 include/linux/mount.h    |  1 +
 security/commoncap.c     |  8 +++++++-
 security/selinux/hooks.c |  2 +-
 5 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index c4010b8207a1..706088dd0cb1 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1391,7 +1391,7 @@ static void bprm_fill_uid(struct linux_binprm *bprm)
 	bprm->cred->euid = current_euid();
 	bprm->cred->egid = current_egid();
 
-	if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
+	if (!mnt_may_suid(bprm->file->f_path.mnt))
 		return;
 
 	if (task_no_new_privs(current))
diff --git a/fs/namespace.c b/fs/namespace.c
index c133318bec35..6e9db4c166b4 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3284,6 +3284,19 @@ found:
 	return visible;
 }
 
+bool mnt_may_suid(struct vfsmount *mnt)
+{
+	/*
+	 * Foreign mounts (accessed via fchdir or through /proc
+	 * symlinks) are always treated as if they are nosuid.  This
+	 * prevents namespaces from trusting potentially unsafe
+	 * suid/sgid bits, file caps, or security labels that originate
+	 * in other namespaces.
+	 */
+	return !(mnt->mnt_flags & MNT_NOSUID) && check_mnt(real_mount(mnt)) &&
+	       in_userns(current_user_ns(), mnt->mnt_sb->s_user_ns);
+}
+
 static struct ns_common *mntns_get(struct task_struct *task)
 {
 	struct ns_common *ns = NULL;
diff --git a/include/linux/mount.h b/include/linux/mount.h
index f822c3c11377..54a594d49733 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -81,6 +81,7 @@ extern void mntput(struct vfsmount *mnt);
 extern struct vfsmount *mntget(struct vfsmount *mnt);
 extern struct vfsmount *mnt_clone_internal(struct path *path);
 extern int __mnt_is_readonly(struct vfsmount *mnt);
+extern bool mnt_may_suid(struct vfsmount *mnt);
 
 struct path;
 extern struct vfsmount *clone_private_mount(struct path *path);
diff --git a/security/commoncap.c b/security/commoncap.c
index 8912ef117faa..a306c5d90709 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -453,8 +453,14 @@ static int get_file_caps(struct linux_binprm *bprm, bool *effective, bool *has_c
 	if (!file_caps_enabled)
 		return 0;
 
-	if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
+	if (!mnt_may_suid(bprm->file->f_path.mnt))
 		return 0;
+
+	/*
+	 * This check is redundant with mnt_may_suid() but is kept to make
+	 * explicit that capability bits are limited to s_user_ns and its
+	 * descendants.
+	 */
 	if (!in_userns(current_user_ns(), bprm->file->f_path.mnt->mnt_sb->s_user_ns))
 		return 0;
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 912deee3f01e..1350167635cb 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2234,7 +2234,7 @@ static int check_nnp_nosuid(const struct linux_binprm *bprm,
 			    const struct task_security_struct *new_tsec)
 {
 	int nnp = (bprm->unsafe & LSM_UNSAFE_NO_NEW_PRIVS);
-	int nosuid = (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID);
+	int nosuid = !mnt_may_suid(bprm->file->f_path.mnt);
 	int rc;
 
 	if (!nnp && !nosuid)
-- 
2.7.4


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
