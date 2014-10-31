From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv2 6/7] cgroup: cgroup namespace setns support
Date: Fri, 31 Oct 2014 12:19:00 -0700
Message-ID: <1414783141-6947-7-git-send-email-adityakali@google.com>
References: <adityakali-cgroupns>
 <1414783141-6947-1-git-send-email-adityakali@google.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kNHKQLsFzwjtqcZbOU/UqyQC93f/7iGCBH9NI2ANHow=;
        b=B28zAcHtzUqFotKB9xk2N96kap1EQP4fTQycyFlCrYka2tTzzdDc1xxB8KQCoVNc2X
         mrsv08jain4s8Rj1MuMXk09Hi0qLyNRldjCBm0iw5sNDEirzQmrQO4iMZqFy2PN2TOq4
         TAsogYBVmQ6k3UNH/VXgSCj4T/xYo+Avu1zS+POYZawL+P58LFAvcQW6njvL62XJqiE6
         nwojs+7FYUh3DokT+B2msWhfOUBa6axrWkoRfxoZBTqrjfA6yzNQtnfI0gcgb7pBbkn/
         XACIOyak6y6AdNAbqUVUXKWrg0TMJOy7KL/Yafj+5KDZw2ZDD3ypMIJKtit5mLqWRSd/
         E0Xw==
In-Reply-To: <1414783141-6947-1-git-send-email-adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

setns on a cgroup namespace is allowed only if
task has CAP_SYS_ADMIN in its current user-namespace and
over the user-namespace associated with target cgroupns.
No implicit cgroup changes happen with attaching to another
cgroupns. It is expected that the somone moves the attaching
process under the target cgroupns-root.

Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup_namespace.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup_namespace.c b/kernel/cgroup_namespace.c
index 7e9bda0..0803575 100644
--- a/kernel/cgroup_namespace.c
+++ b/kernel/cgroup_namespace.c
@@ -86,8 +86,22 @@ err_out:
 
 static int cgroupns_install(struct nsproxy *nsproxy, void *ns)
 {
-	pr_info("setns not supported for cgroup namespace");
-	return -EINVAL;
+	struct cgroup_namespace *cgroup_ns = ns;
+
+	if (!ns_capable(current_user_ns(), CAP_SYS_ADMIN) ||
+	    !ns_capable(cgroup_ns->user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* Prevent cgroup changes for this task. */
+	threadgroup_lock(current);
+
+	get_cgroup_ns(cgroup_ns);
+	put_cgroup_ns(nsproxy->cgroup_ns);
+	nsproxy->cgroup_ns = cgroup_ns;
+
+	threadgroup_unlock(current);
+
+	return 0;
 }
 
 static void *cgroupns_get(struct task_struct *task)
-- 
2.1.0.rc2.206.gedb03e5
