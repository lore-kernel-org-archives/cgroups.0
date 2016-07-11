From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] capabilities: audit capability use
Date: Mon, 11 Jul 2016 10:25:43 -0500
Message-ID: <20160711152543.GA17459@mail.hallyn.com>
References: <1468235672-3745-1-git-send-email-toiwoton@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468235672-3745-1-git-send-email-toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, mladek-IBi9RG/b67k@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "moderated list:AUDIT SUBSYSTEM" <linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CAPABILITIES" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Quoting Topi Miettinen (toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org):
> There are many basic ways to control processes, including capabilities,
> cgroups and resource limits. However, there are far fewer ways to find
> out useful values for the limits, except blind trial and error.
> 
> Currently, there is no way to know which capabilities are actually used.
> Even the source code is only implicit, in-depth knowledge of each
> capability must be used when analyzing a program to judge which
> capabilities the program will exercise.
> 
> Generate an audit message at system call exit, when capabilities are used.
> This can then be used to configure capability sets for services by a
> software developer, maintainer or system administrator.
> 
> Test case demonstrating basic capability monitoring with the new
> message types 1330 and 1331 and how the cgroups are displayed (boot to
> rdshell):

Thanks, Topi, I'll find time this week to look this over in detail.

How much chattier does this make the syslog/journald during a regular
boot?  I was thinking "this is audit, we can choose what messages
will show up", but I guess that' sonly what auditd actually listens to,
not what kernel emits?  (sorry i've not looked at audit in a long
time).  Drat, that makes it seem like tracepoints would be better
after all.  But let's see how much it addes to the noise.

> BusyBox v1.22.1 (Debian 1:1.22.0-19) built-in shell (ash)
> Enter 'help' for a list of built-in commands.
> 
> (initramfs) cd /sys/fs
> (initramfs) mount -t cgroup2 cgroup cgroup
> [   12.343152] audit_printk_skb: 5886 callbacks suppressed
> [   12.355214] audit: type=1300 audit(1468234317.100:518): arch=c000003e syscall=165 success=yes exit=0 a0=7fffe1e9ae2d a1=7fffe1e9ae34 a2=7fffe1e9ae25 a3=8000 items=0 ppid=469 pid=470 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=ttyS0 ses=4294967295 comm="mount" exe="/bin/mount" key=(null)
> [   12.414853] audit: type=1327 audit(1468234317.100:518): proctitle=6D6F756E74002D74006367726F757032006367726F7570006367726F7570
> [   12.438338] audit: type=1330 audit(1468234317.100:518): cap_used=0000000000200000
> [   12.453893] audit: type=1331 audit(1468234317.100:518): cgroups=:/;
> (initramfs) cd cgroup
> (initramfs) mkdir test; cd test
> [   17.335625] audit: type=1300 audit(1468234322.092:519): arch=c000003e syscall=83 success=yes exit=0 a0=7ffddfd75e29 a1=1ff a2=0 a3=1e2 items=0 ppid=469 pid=471 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=ttyS0 ses=4294967295 comm="mkdir" exe="/bin/mkdir" key=(null)
> [   17.392686] audit: type=1327 audit(1468234322.092:519): proctitle=6D6B6469720074657374
> [   17.409404] audit: type=1330 audit(1468234322.092:519): cap_used=0000000000000002
> [   17.425404] audit: type=1331 audit(1468234322.092:519): cgroups=:/;
> (initramfs) echo $$ >cgroup.procs
> (initramfs) mknod /dev/z_$$ c 1 2
> [   28.385681] audit: type=1300 audit(1468234333.144:520): arch=c000003e syscall=133 success=yes exit=0 a0=7ffe16324e11 a1=21b6 a2=102 a3=5c9 items=0 ppid=469 pid=472 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=ttyS0 ses=4294967295 comm="mknod" exe="/bin/mknod" key=(null)
> [   28.443674] audit: type=1327 audit(1468234333.144:520): proctitle=6D6B6E6F64002F6465762F7A5F343639006300310032
> [   28.465888] audit: type=1330 audit(1468234333.144:520): cap_used=0000000008000000
> [   28.482080] audit: type=1331 audit(1468234333.144:520): cgroups=:/test;
> (initramfs) chown 1234 /dev/z_*
> [   34.772992] audit: type=1300 audit(1468234339.532:521): arch=c000003e syscall=92 success=yes exit=0 a0=7ffd0b563e17 a1=4d2 a2=0 a3=60a items=0 ppid=469 pid=473 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=ttyS0 ses=4294967295 comm="chown" exe="/bin/chown" key=(null)
> [   34.828569] audit: type=1327 audit(1468234339.532:521): proctitle=63686F776E0031323334002F6465762F7A5F343639
> [   34.848747] audit: type=1330 audit(1468234339.532:521): cap_used=0000000000000001
> [   34.864404] audit: type=1331 audit(1468234339.532:521): cgroups=:/test;
> 
> Signed-off-by: Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  include/linux/audit.h      |  4 +++
>  include/linux/cgroup.h     |  2 ++
>  include/uapi/linux/audit.h |  2 ++
>  kernel/audit.c             |  7 +++---
>  kernel/audit.h             |  1 +
>  kernel/auditsc.c           | 28 ++++++++++++++++++++-
>  kernel/capability.c        |  5 ++--
>  kernel/cgroup.c            | 62 ++++++++++++++++++++++++++++++++++++++++++++++
>  8 files changed, 105 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index e38e3fc..971cb2e 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -438,6 +438,8 @@ static inline void audit_mmap_fd(int fd, int flags)
>  		__audit_mmap_fd(fd, flags);
>  }
>  
> +extern void audit_log_cap_use(int cap);
> +
>  extern int audit_n_rules;
>  extern int audit_signals;
>  #else /* CONFIG_AUDITSYSCALL */
> @@ -545,6 +547,8 @@ static inline void audit_mmap_fd(int fd, int flags)
>  { }
>  static inline void audit_ptrace(struct task_struct *t)
>  { }
> +static inline void audit_log_cap_use(int cap)
> +{ }
>  #define audit_n_rules 0
>  #define audit_signals 0
>  #endif /* CONFIG_AUDITSYSCALL */
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index a20320c..b5dc8aa 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -100,6 +100,8 @@ char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen);
>  int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry);
>  int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
>  		     struct pid *pid, struct task_struct *tsk);
> +struct audit_buffer;
> +void audit_cgroup_list(struct audit_buffer *ab);
>  
>  void cgroup_fork(struct task_struct *p);
>  extern int cgroup_can_fork(struct task_struct *p);
> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index d820aa9..c1ae016 100644
> --- a/include/uapi/linux/audit.h
> +++ b/include/uapi/linux/audit.h
> @@ -111,6 +111,8 @@
>  #define AUDIT_PROCTITLE		1327	/* Proctitle emit event */
>  #define AUDIT_FEATURE_CHANGE	1328	/* audit log listing feature changes */
>  #define AUDIT_REPLACE		1329	/* Replace auditd if this packet unanswerd */
> +#define AUDIT_CAPABILITY	1330	/* Record showing capability use */
> +#define AUDIT_CGROUP		1331	/* Record showing cgroups */
>  
>  #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
>  #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 8d528f9..98dd920 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -54,6 +54,7 @@
>  #include <linux/kthread.h>
>  #include <linux/kernel.h>
>  #include <linux/syscalls.h>
> +#include <linux/cgroup.h>
>  
>  #include <linux/audit.h>
>  
> @@ -1682,7 +1683,7 @@ void audit_log_cap(struct audit_buffer *ab, char *prefix, kernel_cap_t *cap)
>  {
>  	int i;
>  
> -	audit_log_format(ab, " %s=", prefix);
> +	audit_log_format(ab, "%s=", prefix);
>  	CAP_FOR_EACH_U32(i) {
>  		audit_log_format(ab, "%08x",
>  				 cap->cap[CAP_LAST_U32 - i]);
> @@ -1696,11 +1697,11 @@ static void audit_log_fcaps(struct audit_buffer *ab, struct audit_names *name)
>  	int log = 0;
>  
>  	if (!cap_isclear(*perm)) {
> -		audit_log_cap(ab, "cap_fp", perm);
> +		audit_log_cap(ab, " cap_fp", perm);
>  		log = 1;
>  	}
>  	if (!cap_isclear(*inh)) {
> -		audit_log_cap(ab, "cap_fi", inh);
> +		audit_log_cap(ab, " cap_fi", inh);
>  		log = 1;
>  	}
>  
> diff --git a/kernel/audit.h b/kernel/audit.h
> index a492f4c..680e8b5 100644
> --- a/kernel/audit.h
> +++ b/kernel/audit.h
> @@ -202,6 +202,7 @@ struct audit_context {
>  	};
>  	int fds[2];
>  	struct audit_proctitle proctitle;
> +	kernel_cap_t cap_used;
>  };
>  
>  extern u32 audit_ever_enabled;
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 2672d10..32c3813 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -197,7 +197,6 @@ static int audit_match_filetype(struct audit_context *ctx, int val)
>   * References in it _are_ dropped - at the same time we free/drop aux stuff.
>   */
>  
> -#ifdef CONFIG_AUDIT_TREE
>  static void audit_set_auditable(struct audit_context *ctx)
>  {
>  	if (!ctx->prio) {
> @@ -206,6 +205,7 @@ static void audit_set_auditable(struct audit_context *ctx)
>  	}
>  }
>  
> +#ifdef CONFIG_AUDIT_TREE
>  static int put_tree_ref(struct audit_context *ctx, struct audit_chunk *chunk)
>  {
>  	struct audit_tree_refs *p = ctx->trees;
> @@ -1439,6 +1439,18 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
>  
>  	audit_log_proctitle(tsk, context);
>  
> +	ab = audit_log_start(context, GFP_KERNEL, AUDIT_CAPABILITY);
> +	if (ab) {
> +		audit_log_cap(ab, "cap_used", &context->cap_used);
> +		audit_log_end(ab);
> +	}
> +	ab = audit_log_start(context, GFP_KERNEL, AUDIT_CGROUP);
> +	if (ab) {
> +		audit_log_format(ab, "cgroups=");
> +		audit_cgroup_list(ab);
> +		audit_log_end(ab);
> +	}
> +
>  	/* Send end of event record to help user space know we are finished */
>  	ab = audit_log_start(context, GFP_KERNEL, AUDIT_EOE);
>  	if (ab)
> @@ -2428,3 +2440,17 @@ struct list_head *audit_killed_trees(void)
>  		return NULL;
>  	return &ctx->killed_trees;
>  }
> +
> +void audit_log_cap_use(int cap)
> +{
> +	struct audit_context *context = current->audit_context;
> +
> +	if (context) {
> +		cap_raise(context->cap_used, cap);
> +		audit_set_auditable(context);
> +	} else {
> +		audit_log(NULL, GFP_NOFS, AUDIT_CAPABILITY,
> +			  "cap_used=%d pid=%d no audit_context",
> +			  cap, task_pid_nr(current));
> +	}
> +}
> diff --git a/kernel/capability.c b/kernel/capability.c
> index 45432b5..d45d5b1 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -366,8 +366,8 @@ bool has_capability_noaudit(struct task_struct *t, int cap)
>   * @ns:  The usernamespace we want the capability in
>   * @cap: The capability to be tested for
>   *
> - * Return true if the current task has the given superior capability currently
> - * available for use, false if not.
> + * Return true if the current task has the given superior capability
> + * currently available for use, false if not. Write an audit message.
>   *
>   * This sets PF_SUPERPRIV on the task if the capability is available on the
>   * assumption that it's about to be used.
> @@ -380,6 +380,7 @@ bool ns_capable(struct user_namespace *ns, int cap)
>  	}
>  
>  	if (security_capable(current_cred(), ns, cap) == 0) {
> +		audit_log_cap_use(cap);
>  		current->flags |= PF_SUPERPRIV;
>  		return true;
>  	}
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 75c0ff0..1931679 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -63,6 +63,7 @@
>  #include <linux/nsproxy.h>
>  #include <linux/proc_ns.h>
>  #include <net/sock.h>
> +#include <linux/audit.h>
>  
>  /*
>   * pidlists linger the following amount before being destroyed.  The goal
> @@ -5789,6 +5790,67 @@ out:
>  	return retval;
>  }
>  
> +/*
> + * audit_cgroup_list()
> + *  - Print task's cgroup paths with audit_log_format()
> + *  - Used for capability audit logging
> + *  - Otherwise very similar to proc_cgroup_show().
> + */
> +void audit_cgroup_list(struct audit_buffer *ab)
> +{
> +	char *buf, *path;
> +	struct cgroup_root *root;
> +
> +	buf = kmalloc(PATH_MAX, GFP_NOFS);
> +	if (!buf)
> +		return;
> +
> +	mutex_lock(&cgroup_mutex);
> +	spin_lock_irq(&css_set_lock);
> +
> +	for_each_root(root) {
> +		struct cgroup_subsys *ss;
> +		struct cgroup *cgrp;
> +		int ssid, count = 0;
> +
> +		if (root == &cgrp_dfl_root && !cgrp_dfl_visible)
> +			continue;
> +
> +		if (root != &cgrp_dfl_root)
> +			for_each_subsys(ss, ssid)
> +				if (root->subsys_mask & (1 << ssid))
> +					audit_log_format(ab, "%s%s",
> +							 count++ ? "," : "",
> +							 ss->legacy_name);
> +		if (strlen(root->name))
> +			audit_log_format(ab, "%sname=%s", count ? "," : "",
> +					 root->name);
> +		audit_log_format(ab, ":");
> +
> +		cgrp = task_cgroup_from_root(current, root);
> +
> +		if (cgroup_on_dfl(cgrp) || !(current->flags & PF_EXITING)) {
> +			path = cgroup_path_ns_locked(cgrp, buf, PATH_MAX,
> +						current->nsproxy->cgroup_ns);
> +			if (!path)
> +				goto out_unlock;
> +		} else
> +			path = "/";
> +
> +		audit_log_format(ab, "%s", path);
> +
> +		if (cgroup_on_dfl(cgrp) && cgroup_is_dead(cgrp))
> +			audit_log_format(ab, " (deleted);");
> +		else
> +			audit_log_format(ab, ";");
> +	}
> +
> +out_unlock:
> +	spin_unlock_irq(&css_set_lock);
> +	mutex_unlock(&cgroup_mutex);
> +	kfree(buf);
> +}
> +
>  /* Display information about each subsystem and each hierarchy */
>  static int proc_cgroupstats_show(struct seq_file *m, void *v)
>  {
> -- 
> 2.8.1
