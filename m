From: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 4/4] security: binder: Add binder object flags to selinux_binder_transfer_file
Date: Mon, 23 Jan 2023 19:17:26 +0000
Message-ID: <20230123191728.2928839-5-tjmercier@google.com>
References: <20230123191728.2928839-1-tjmercier@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z2WhRnZzQgS7vry+Z+wffN8GNT/+GwBkd2a3cKemc3A=;
        b=qIoHkzSJgScPAOmXRPybmkkxLYzr2DadvdaoU+21L1WVU3YW/Hmjf98YSxQck6Cojl
         hSJIB90Oc/J5PhcPthu37nMpMkmKvUecOx+8XcN0o61N3c9FSHsypWEcnKqeCpO8oZn5
         5t2GLdXEZE6+Kn1L/RgqPV6+knFah8Sty5ttQeslTrfM6XTfbVGpIJuSS4JTguGrEf+K
         02GyI8CR+Za0guqiCqlg7dAfcw68H5UFF1O5CbDXUC7fdVcQj+I00pYkk/UsWsyDil4n
         wMUZxRBLOsVMt7lEWJwwaO1NERbypePie8xI/PldXEjxtDPpICffELsttwq1JrA5YUun
         L0Tw==
In-Reply-To: <20230123191728.2928839-1-tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Carlos Llamas <cmllamas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Stephen Smalley <stephen.smalley.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, daniel.vetter-/w4YWyX8dFk@public.gmane.org, android-mm-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jstultz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jeffv-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, selinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Any process can cause a memory charge transfer to occur to any other
process when transmitting a file descriptor through binder. This should
only be possible for central allocator processes, so the binder object
flags are added to the security_binder_transfer_file hook so that LSMs
can enforce restrictions on charge transfers.

Signed-off-by: T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 drivers/android/binder.c            |  2 +-
 include/linux/lsm_hook_defs.h       |  2 +-
 include/linux/lsm_hooks.h           |  5 ++++-
 include/linux/security.h            |  6 ++++--
 security/security.c                 |  4 ++--
 security/selinux/hooks.c            | 13 ++++++++++++-
 security/selinux/include/classmap.h |  2 +-
 7 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 5e707974793f..7b1bb23b6b79 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2270,7 +2270,7 @@ static int binder_translate_fd(u32 fd, binder_size_t fd_offset, __u32 flags,
 		ret = -EBADF;
 		goto err_fget;
 	}
-	ret = security_binder_transfer_file(proc->cred, target_proc->cred, file);
+	ret = security_binder_transfer_file(proc->cred, target_proc->cred, file, flags);
 	if (ret < 0) {
 		ret = -EPERM;
 		goto err_security;
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index ed6cb2ac55fa..84ee61089f7b 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -32,7 +32,7 @@ LSM_HOOK(int, 0, binder_transaction, const struct cred *from,
 LSM_HOOK(int, 0, binder_transfer_binder, const struct cred *from,
 	 const struct cred *to)
 LSM_HOOK(int, 0, binder_transfer_file, const struct cred *from,
-	 const struct cred *to, struct file *file)
+	 const struct cred *to, struct file *file, u32 binder_object_flags)
 LSM_HOOK(int, 0, ptrace_access_check, struct task_struct *child,
 	 unsigned int mode)
 LSM_HOOK(int, 0, ptrace_traceme, struct task_struct *parent)
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 0a5ba81f7367..d57977336ae8 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1381,9 +1381,12 @@
  *	Return 0 if permission is granted.
  * @binder_transfer_file:
  *	Check whether @from is allowed to transfer @file to @to.
+ *	If @binder_object_flags indicates a memory charge transfer for @file, then
+ *	permission for the charge transfer can be checked as well.
  *	@from contains the struct cred for the sending process.
- *	@file contains the struct file being transferred.
  *	@to contains the struct cred for the receiving process.
+ *	@file contains the struct file being transferred.
+ *	@binder_object_flags contains the flags associated with the binder object.
  *	Return 0 if permission is granted.
  *
  * @ptrace_access_check:
diff --git a/include/linux/security.h b/include/linux/security.h
index 5b67f208f7de..c4b80fc8d104 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -269,7 +269,8 @@ int security_binder_transaction(const struct cred *from,
 int security_binder_transfer_binder(const struct cred *from,
 				    const struct cred *to);
 int security_binder_transfer_file(const struct cred *from,
-				  const struct cred *to, struct file *file);
+				  const struct cred *to, struct file *file,
+				  u32 binder_object_flags);
 int security_ptrace_access_check(struct task_struct *child, unsigned int mode);
 int security_ptrace_traceme(struct task_struct *parent);
 int security_capget(struct task_struct *target,
@@ -542,7 +543,8 @@ static inline int security_binder_transfer_binder(const struct cred *from,
 
 static inline int security_binder_transfer_file(const struct cred *from,
 						const struct cred *to,
-						struct file *file)
+						struct file *file,
+						u32 binder_object_flags)
 {
 	return 0;
 }
diff --git a/security/security.c b/security/security.c
index d1571900a8c7..12ccaca744c0 100644
--- a/security/security.c
+++ b/security/security.c
@@ -796,9 +796,9 @@ int security_binder_transfer_binder(const struct cred *from,
 }
 
 int security_binder_transfer_file(const struct cred *from,
-				  const struct cred *to, struct file *file)
+				  const struct cred *to, struct file *file, u32 binder_object_flags)
 {
-	return call_int_hook(binder_transfer_file, 0, from, to, file);
+	return call_int_hook(binder_transfer_file, 0, from, to, file, binder_object_flags);
 }
 
 int security_ptrace_access_check(struct task_struct *child, unsigned int mode)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 3c5be76a9199..d4cfca3c9a3b 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -88,6 +88,7 @@
 #include <linux/bpf.h>
 #include <linux/kernfs.h>
 #include <linux/stringhash.h>	/* for hashlen_string() */
+#include <uapi/linux/android/binder.h>
 #include <uapi/linux/mount.h>
 #include <linux/fsnotify.h>
 #include <linux/fanotify.h>
@@ -2029,7 +2030,8 @@ static int selinux_binder_transfer_binder(const struct cred *from,
 
 static int selinux_binder_transfer_file(const struct cred *from,
 					const struct cred *to,
-					struct file *file)
+					struct file *file,
+					u32 binder_object_flags)
 {
 	u32 sid = cred_sid(to);
 	struct file_security_struct *fsec = selinux_file(file);
@@ -2038,6 +2040,15 @@ static int selinux_binder_transfer_file(const struct cred *from,
 	struct common_audit_data ad;
 	int rc;
 
+	if (binder_object_flags & BINDER_FD_FLAG_XFER_CHARGE) {
+		rc = avc_has_perm(&selinux_state,
+			    cred_sid(from), sid,
+			    SECCLASS_BINDER, BINDER__TRANSFER_CHARGE,
+			    NULL);
+		if (rc)
+			return rc;
+	}
+
 	ad.type = LSM_AUDIT_DATA_PATH;
 	ad.u.path = file->f_path;
 
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index a3c380775d41..2eef180d10d7 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -172,7 +172,7 @@ const struct security_class_mapping secclass_map[] = {
 	{ "tun_socket",
 	  { COMMON_SOCK_PERMS, "attach_queue", NULL } },
 	{ "binder", { "impersonate", "call", "set_context_mgr", "transfer",
-		      NULL } },
+		      "transfer_charge", NULL } },
 	{ "cap_userns",
 	  { COMMON_CAP_PERMS, NULL } },
 	{ "cap2_userns",
-- 
2.39.0.246.g2a6d74b583-goog

