From: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v4 08/21] userns: Replace in_userns with current_in_userns
Date: Tue, 26 Apr 2016 14:36:21 -0500
Message-ID: <1461699396-33000-9-git-send-email-seth.forshee@canonical.com>
References: <1461699396-33000-1-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=canonical-com.20150623.gappssmtp.com; s=20150623;
 h=from:to:cc:subject:date:message-id:in-reply-to:references;
 bh=XN0VEjNp7CAxfuE3oWm8eRX9UvQ5a9jIhWtwswECLLw=;
 b=SZ7tex4/WLx7C78g5S4kw6Mzw2aSk9W2wv+V5DAGxy6ttPwo1Dhw9/YHBw+20OdL3n
 mrreeNw58JQbjyQmjUTqFStKpa3CkOf7/3vRjAqxpN/6sO5pdaSdBPRZQm02DAKoRr3V
 EVBkP5VQoo43CnquHsT0VYZ4qXzkXb1K/aUxG7819BQf/z8mN+v0nmACGzO7UrkoCf9s
 qsK7X9MExsTWIYZlH4h40GPd1ceiLrPN5+kvQTclLmLfwOB74CCexHWqjC6ZhsJ6jng1
 aio+eeMp8900yooD75di9VQ0EWIQXpe8SZ2npnEa456CC6MOhQuCDyw7xXfb1Dk5vS48
 sPZw==
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
To: "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, Seth Forshee <seth.forshee@canonical.com>, dm-devel@redhat.com, linux-security-module@vger.kernel.org, Richard Weinberger <richard.weinberger@gmail.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, fuse-devel@lists.sourceforge.net, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-mtd@lists.infradead.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

All current callers of in_userns pass current_user_ns as the
first argument. Simplify by replacing in_userns with
current_in_userns which checks whether current_user_ns is in the
namespace supplied as an argument.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Acked-by: James Morris <james.l.morris@oracle.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
---
 fs/namespace.c                 | 2 +-
 include/linux/user_namespace.h | 6 ++----
 kernel/user_namespace.c        | 6 +++---
 security/commoncap.c           | 2 +-
 4 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 6e9db4c166b4..0ad8e4a4f50b 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3294,7 +3294,7 @@ bool mnt_may_suid(struct vfsmount *mnt)
 	 * in other namespaces.
 	 */
 	return !(mnt->mnt_flags & MNT_NOSUID) && check_mnt(real_mount(mnt)) &&
-	       in_userns(current_user_ns(), mnt->mnt_sb->s_user_ns);
+	       current_in_userns(mnt->mnt_sb->s_user_ns);
 }
 
 static struct ns_common *mntns_get(struct task_struct *task)
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index a43faa727124..9217169c64cb 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -72,8 +72,7 @@ extern ssize_t proc_projid_map_write(struct file *, const char __user *, size_t,
 extern ssize_t proc_setgroups_write(struct file *, const char __user *, size_t, loff_t *);
 extern int proc_setgroups_show(struct seq_file *m, void *v);
 extern bool userns_may_setgroups(const struct user_namespace *ns);
-extern bool in_userns(const struct user_namespace *ns,
-		      const struct user_namespace *target_ns);
+extern bool current_in_userns(const struct user_namespace *target_ns);
 #else
 
 static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
@@ -103,8 +102,7 @@ static inline bool userns_may_setgroups(const struct user_namespace *ns)
 	return true;
 }
 
-static inline bool in_userns(const struct user_namespace *ns,
-			     const struct user_namespace *target_ns)
+static inline bool current_in_userns(const struct user_namespace *target_ns)
 {
 	return true;
 }
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index dee3be5445da..68f594212759 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -942,10 +942,10 @@ bool userns_may_setgroups(const struct user_namespace *ns)
  * Returns true if @ns is the same namespace as or a descendant of
  * @target_ns.
  */
-bool in_userns(const struct user_namespace *ns,
-	       const struct user_namespace *target_ns)
+bool current_in_userns(const struct user_namespace *target_ns)
 {
-	for (; ns; ns = ns->parent) {
+	struct user_namespace *ns;
+	for (ns = current_user_ns(); ns; ns = ns->parent) {
 		if (ns == target_ns)
 			return true;
 	}
diff --git a/security/commoncap.c b/security/commoncap.c
index a306c5d90709..e657227d221e 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -461,7 +461,7 @@ static int get_file_caps(struct linux_binprm *bprm, bool *effective, bool *has_c
 	 * explicit that capability bits are limited to s_user_ns and its
 	 * descendants.
 	 */
-	if (!in_userns(current_user_ns(), bprm->file->f_path.mnt->mnt_sb->s_user_ns))
+	if (!current_in_userns(bprm->file->f_path.mnt->mnt_sb->s_user_ns))
 		return 0;
 
 	rc = get_vfs_caps_from_disk(bprm->file->f_path.dentry, &vcaps);
-- 
2.7.4


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
