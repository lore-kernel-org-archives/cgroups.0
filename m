From: Topi Miettinen <toiwoton@gmail.com>
Subject: Re: [PATCH] capabilities: add capability cgroup controller
Date: Sun, 3 Jul 2016 15:08:07 +0000
Message-ID: <218f2bef-5e5e-89c4-154b-24dc49c82c31@gmail.com>
References: <20160624154830.GX3262@mtj.duckdns.org>
 <20160624155916.GA8759@mail.hallyn.com>
 <20160624163527.GZ3262@mtj.duckdns.org>
 <20160624165910.GA9675@mail.hallyn.com>
 <20160624172447.GA3262@mtj.duckdns.org>
 <47890d79-0891-dd13-4f60-e7e5f1f3fed3@gmail.com>
 <CAOS58YMxz5HfJUayqjw+SPj485M+wquTqQouk367rV2mfvVRHg@mail.gmail.com>
 <20160627145457.GA26980@mail.hallyn.com>
 <58938c8b-aca6-a5b8-9533-58e78d878e85@gmail.com>
 <CAOS58YM+h0w_UciXLbiJcKizPkXV66FL57LT7Mc+RRWspN+Y2Q@mail.gmail.com>
 <20160627194941.GA31843@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------B302B4BAD1EED0B052077B3E"
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=subject:to:references:cc:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=ixjbB3ZRBFYgOGoilXVLd3ANDbJMJgwOUJUAJfKf6QU=;
        b=nOn4HESQHuJf96LWRUkiLfoRPa2415OyZS8Frhcc3QyAitoBXzPM2PsH75T9cR1eaB
         7FMKW+7KbZ0Shckb+1+3qceqRjmVNAyvC7tY+owoaT0xBsTZw0FJ8v41115UK0qBUW8s
         gvS9L/CPf3qhJFEw9c0q0X4PeLCN+zUye68mU3xWmJ2G+imNjxhCIJ1DsrtUFPdy1Ck8
         rW5YvV+YZTa1HZeqbQipXFHTih8AxD03RB5wqjK+FFzwYUtL9tVfvhLTsISrbzkOBAbH
         +Sz0P02Cn17/y6BN0nEgQliEBuCv3AFRR8EhPNWfmRMX8xEdxw2yS2DlEnDXl/7+uhH1
         GMeA==
In-Reply-To: <20160627194941.GA31843@mail.hallyn.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, luto@kernel.org, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Serge Hallyn <serge.hallyn@canonical.com>, James Morris <james.l.morris@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, David Woodhouse <David.Woodhouse@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Petr Mladek <pmladek@suse.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:CAPABILITIES" <linux-security-module@vger.kernel.org>

This is a multi-part message in MIME format.
--------------B302B4BAD1EED0B052077B3E
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 06/27/16 19:49, Serge E. Hallyn wrote:
> Quoting Tejun Heo (tj@kernel.org):
>> Hello,
>>
>> On Mon, Jun 27, 2016 at 3:10 PM, Topi Miettinen <toiwoton@gmail.com> wrote:
>>> I'll have to study these more. But from what I saw so far, it looks to
>>> me that a separate tool would be needed to read taskstats and if that
>>> tool is not taken by distros, the users would not be any wiser, right?
>>> With cgroup (or /proc), no new tools would be needed.
>>
>> That is a factor but shouldn't be a deciding factor in designing our
>> user-facing interfaces. Please also note that kernel source tree
>> already has tools/ subdirectory which contains userland tools which
>> are distributed along with the kernel.
> 
> And, if you take audit+cgroup approach then no tools are needed.  So long
> as you can have audit print out the cgroups for a task as part of the
> capability audit record.
> 

The attached patch would make any uses of capabilities generate audit
messages. It works for simple tests as you can see from the commit
message, but unfortunately the call to audit_cgroup_list() deadlocks the
system when booting a full blown OS. There's no deadlock when the call
is removed.

I guess that in some cases, cgroup_mutex and/or css_set_lock could be
already held earlier before entering audit_cgroup_list(). Holding the
locks is however required by task_cgroup_from_root(). Is there any way
to avoid this? For example, only print some kind of cgroup ID numbers
(are there unique and stable IDs, available without locks?) for those
cgroups where the task is registered in the audit message?

I could remove the cgroup part from the audit message entirely, but then
knowing which capabilities were used in what cgroup gets much more
difficult. The rest of the patch would be useful without it and of
course simpler.

In my earlier versions a per-task cap_used variable summarized all uses
of capabilities, but it was not clear when to reset the variable (fork?
exec? capset?), so it's gone for now. This was also used to rate limit
printing audit messages by only acting when each capability was first
used by the task, but now all uses of capabilities trigger audit
logging. Could that become a problem? I think it only makes sense to
summarize capability use per cgroup (via taskstats).

-Topi


--------------B302B4BAD1EED0B052077B3E
Content-Type: text/x-patch;
 name="0001-capabilities-audit-capability-use.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-capabilities-audit-capability-use.patch"

From 2d5248f91998873174dbcbcafe87e5b30c3858aa Mon Sep 17 00:00:00 2001
From: Topi Miettinen <toiwoton@gmail.com>
Date: Sat, 2 Jul 2016 16:25:20 +0300
Subject: [PATCH] capabilities: audit capability use

There are many basic ways to control processes, including capabilities,
cgroups and resource limits. However, there are far fewer ways to find
out useful values for the limits, except blind trial and error.

Currently, there is no way to know which capabilities are actually used.
Even the source code is only implicit, in-depth knowledge of each
capability must be used when analyzing a program to judge which
capabilities the program will exercise.

Generate an audit message when capabilities are used. This can then be
used to configure capability sets for services by a software developer,
maintainer or system administrator.

Test case demonstrating basic capability monitoring with the new
message type 1330 and how the cgroups are displayed (boot to rdshell):

BusyBox v1.22.1 (Debian 1:1.22.0-19) built-in shell (ash)
Enter 'help' for a list of built-in commands.

(initramfs) cd /sys/fs
(initramfs) mount -t cgroup2 cgroup cgroup
[   16.503902] audit_printk_skb: 4026 callbacks suppressed
[   16.505059] audit: type=1330 audit(1467543885.733:469): cap_used=21 pid=214 auid=4294967295 uid=0 gid=0 ses=4294967295 cgroups=
[   16.506845] audit: type=1330 audit(1467543885.733:469): cap_used=21 pid=214 auid=4294967295 uid=0 gid=0 ses=4294967295 cgroups=
[   16.509234] audit: type=1300 audit(1467543885.733:469): arch=c000003e syscall=165 success=yes exit=0 a0=7ffc2f394e2d a1=7ffc2f394e34 a2=7ffc2f394e25 a3=8000 items=0 ppid=213 pid=214 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=ttyS0 ses=4294967295 comm="mount" exe="/bin/mount" key=(null)
[   16.510134] audit: type=1327 audit(1467543885.733:469): proctitle=6D6F756E74002D74006367726F757032006367726F7570006367726F7570
(initramfs) cd cgroup
(initramfs) mkdir test; cd test
[   16.533829] audit: type=1330 audit(1467543885.765:470): cap_used=1 pid=215 auid=4294967295 uid=0 gid=0 ses=4294967295 cgroups=:/;
[   16.536587] audit: type=1300 audit(1467543885.765:470): arch=c000003e syscall=83 success=yes exit=0 a0=7ffe4f0bfe29 a1=1ff a2=0 a3=1e2 items=0 ppid=213 pid=215 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=ttyS0 ses=4294967295 comm="mkdir" exe="/bin/mkdir" key=(null)
[   16.537263] audit: type=1327 audit(1467543885.765:470): proctitle=6D6B6469720074657374
(initramfs) echo $$ >cgroup.procs
(initramfs) mknod /dev/z_$$ c 1 2
[   16.571516] audit: type=1330 audit(1467543885.801:471): cap_used=27 pid=216 auid=4294967295 uid=0 gid=0 ses=4294967295 cgroups=:/test;
[   16.572812] audit: type=1300 audit(1467543885.801:471): arch=c000003e syscall=133 success=yes exit=0 a0=7ffe04fe3e11 a1=21b6 a2=102 a3=5c9 items=0 ppid=213 pid=216 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=ttyS0 ses=4294967295 comm="mknod" exe="/bin/mknod" key=(null)
[   16.573571] audit: type=1327 audit(1467543885.801:471): proctitle=6D6B6E6F64002F6465762F7A5F323133006300310032

Signed-off-by: Topi Miettinen <toiwoton@gmail.com>
---
 include/linux/audit.h      |  4 +++
 include/linux/cgroup.h     |  2 ++
 include/uapi/linux/audit.h |  1 +
 kernel/audit.c             | 22 ++++++++++++++++
 kernel/capability.c        |  5 ++--
 kernel/cgroup.c            | 62 ++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 94 insertions(+), 2 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index e38e3fc..971cb2e 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -438,6 +438,8 @@ static inline void audit_mmap_fd(int fd, int flags)
 		__audit_mmap_fd(fd, flags);
 }
 
+extern void audit_log_cap_use(int cap);
+
 extern int audit_n_rules;
 extern int audit_signals;
 #else /* CONFIG_AUDITSYSCALL */
@@ -545,6 +547,8 @@ static inline void audit_mmap_fd(int fd, int flags)
 { }
 static inline void audit_ptrace(struct task_struct *t)
 { }
+static inline void audit_log_cap_use(int cap)
+{ }
 #define audit_n_rules 0
 #define audit_signals 0
 #endif /* CONFIG_AUDITSYSCALL */
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index a20320c..b5dc8aa 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -100,6 +100,8 @@ char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen);
 int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry);
 int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 		     struct pid *pid, struct task_struct *tsk);
+struct audit_buffer;
+void audit_cgroup_list(struct audit_buffer *ab);
 
 void cgroup_fork(struct task_struct *p);
 extern int cgroup_can_fork(struct task_struct *p);
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index d820aa9..a5c9a73 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -111,6 +111,7 @@
 #define AUDIT_PROCTITLE		1327	/* Proctitle emit event */
 #define AUDIT_FEATURE_CHANGE	1328	/* audit log listing feature changes */
 #define AUDIT_REPLACE		1329	/* Replace auditd if this packet unanswerd */
+#define AUDIT_CAPABILITY	1330	/* Record showing capability use */
 
 #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
diff --git a/kernel/audit.c b/kernel/audit.c
index 8d528f9..370beb7 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -54,6 +54,7 @@
 #include <linux/kthread.h>
 #include <linux/kernel.h>
 #include <linux/syscalls.h>
+#include <linux/cgroup.h>
 
 #include <linux/audit.h>
 
@@ -1709,6 +1710,27 @@ static void audit_log_fcaps(struct audit_buffer *ab, struct audit_names *name)
 				 name->fcap.fE, name->fcap_ver);
 }
 
+void audit_log_cap_use(int cap)
+{
+	struct audit_context *context = current->audit_context;
+	struct audit_buffer *ab;
+	kuid_t uid;
+	kgid_t gid;
+
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_CAPABILITY);
+	audit_log_format(ab, "cap_used=%d", cap);
+	current_uid_gid(&uid, &gid);
+	audit_log_format(ab, " pid=%d auid=%u uid=%u gid=%u ses=%u",
+			 task_pid_nr(current),
+			 from_kuid(&init_user_ns, audit_get_loginuid(current)),
+			 from_kuid(&init_user_ns, uid),
+			 from_kgid(&init_user_ns, gid),
+			 audit_get_sessionid(current));
+	audit_log_format(ab, " cgroups=");
+	audit_cgroup_list(ab);
+	audit_log_end(ab);
+}
+
 static inline int audit_copy_fcaps(struct audit_names *name,
 				   const struct dentry *dentry)
 {
diff --git a/kernel/capability.c b/kernel/capability.c
index 45432b5..d45d5b1 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -366,8 +366,8 @@ bool has_capability_noaudit(struct task_struct *t, int cap)
  * @ns:  The usernamespace we want the capability in
  * @cap: The capability to be tested for
  *
- * Return true if the current task has the given superior capability currently
- * available for use, false if not.
+ * Return true if the current task has the given superior capability
+ * currently available for use, false if not. Write an audit message.
  *
  * This sets PF_SUPERPRIV on the task if the capability is available on the
  * assumption that it's about to be used.
@@ -380,6 +380,7 @@ bool ns_capable(struct user_namespace *ns, int cap)
 	}
 
 	if (security_capable(current_cred(), ns, cap) == 0) {
+		audit_log_cap_use(cap);
 		current->flags |= PF_SUPERPRIV;
 		return true;
 	}
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 75c0ff0..3b92e85 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -63,6 +63,7 @@
 #include <linux/nsproxy.h>
 #include <linux/proc_ns.h>
 #include <net/sock.h>
+#include <linux/audit.h>
 
 /*
  * pidlists linger the following amount before being destroyed.  The goal
@@ -5789,6 +5790,67 @@ out:
 	return retval;
 }
 
+/*
+ * audit_cgroup_list()
+ *  - Print task's cgroup paths with audit_log_format()
+ *  - Used for capability audit logging
+ *  - Otherwise very similar to proc_cgroup_show().
+ */
+void audit_cgroup_list(struct audit_buffer *ab)
+{
+	char *buf, *path;
+	struct cgroup_root *root;
+
+	buf = kmalloc(PATH_MAX, GFP_KERNEL);
+	if (!buf)
+		return;
+
+	mutex_lock(&cgroup_mutex);
+	spin_lock_irq(&css_set_lock);
+
+	for_each_root(root) {
+		struct cgroup_subsys *ss;
+		struct cgroup *cgrp;
+		int ssid, count = 0;
+
+		if (root == &cgrp_dfl_root && !cgrp_dfl_visible)
+			continue;
+
+		if (root != &cgrp_dfl_root)
+			for_each_subsys(ss, ssid)
+				if (root->subsys_mask & (1 << ssid))
+					audit_log_format(ab, "%s%s",
+							 count++ ? "," : "",
+							 ss->legacy_name);
+		if (strlen(root->name))
+			audit_log_format(ab, "%sname=%s", count ? "," : "",
+					 root->name);
+		audit_log_format(ab, ":");
+
+		cgrp = task_cgroup_from_root(current, root);
+
+		if (cgroup_on_dfl(cgrp) || !(current->flags & PF_EXITING)) {
+			path = cgroup_path_ns_locked(cgrp, buf, PATH_MAX,
+						current->nsproxy->cgroup_ns);
+			if (!path)
+				goto out_unlock;
+		} else
+			path = "/";
+
+		audit_log_format(ab, "%s", path);
+
+		if (cgroup_on_dfl(cgrp) && cgroup_is_dead(cgrp))
+			audit_log_format(ab, " (deleted);");
+		else
+			audit_log_format(ab, ";");
+	}
+
+out_unlock:
+	spin_unlock_irq(&css_set_lock);
+	mutex_unlock(&cgroup_mutex);
+	kfree(buf);
+}
+
 /* Display information about each subsystem and each hierarchy */
 static int proc_cgroupstats_show(struct seq_file *m, void *v)
 {
-- 
2.8.1


--------------B302B4BAD1EED0B052077B3E--
