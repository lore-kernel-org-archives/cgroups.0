From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH] capabilities: audit capability use
Date: Tue, 12 Jul 2016 17:56:28 -0400
Message-ID: <CAHC9VhQGBDzVY73=KW1o-u2WTMTe2nWbaBkszCbD94ssAQBpAg@mail.gmail.com>
References: <1468235672-3745-1-git-send-email-toiwoton@gmail.com>
Mime-Version: 1.0
Return-path: <linux-security-module-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=v0zjcZmPGx0FBfKzvUfJ3NZJ5HnbBJHHIo8O/C4ehpg=;
        b=kcqYYb3XpnDwJU3HCa4i0sPGcPVEDLg+0q/BRHSHgkAmU+ge17QmA+LLy+5ZAVY5Qj
         lCG1EP+VQ2ubF0nPCI8y7mOYMM8rBJeQsVkmo/aiKzDiMIcsaTrMva63ry8MboMzol4A
         YV2vs5T96vjgTqcYftZVhij8aWfPoQsL8cfKurnLFkZGXNeifnKzK9Yszz7vsOu9vzj+
         P183i2n/R+vnzssKAR8XltUFQWloda6zIYB5HyS2Kj7MT4gi1rvZWuoNY06jv9RlR3QT
         16q6umRqs/1SOQ7pcABVkvX0GWSoOIvtYd892yGXrQ44EJxcKRhbIZCl8y3T6ntiWcsC
         Cypw==
In-Reply-To: <1468235672-3745-1-git-send-email-toiwoton@gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Topi Miettinen <toiwoton@gmail.com>, "moderated list:AUDIT SUBSYSTEM" <linux-audit@redhat.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, mladek@suse.com, luto@kernel.org, serge@hallyn.com, keescook@chromium.org, Eric Paris <eparis@redhat.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Serge Hallyn <serge.hallyn@canonical.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:CAPABILITIES" <linux-security-module@vger.kernel.org>

On Mon, Jul 11, 2016 at 7:14 AM, Topi Miettinen <toiwoton@gmail.com> wrote:
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

NOTE: additional comments inline with the patch.

I can understand the desire to audit the capabilities, but I'm a
little uncertain about the value of auditing cgroups at this point in
time.  The audit subsystem focuses primarily on security relevant
information, and while you could make an argument for cgroups here, I
think it is a relatively weak argument at the moment.

Also, please continue to work on reducing the impact of this on the
audit logs (your discussion with Serge).

> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index e38e3fc..971cb2e 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -438,6 +438,8 @@ static inline void audit_mmap_fd(int fd, int flags)
>                 __audit_mmap_fd(fd, flags);
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
>                      struct pid *pid, struct task_struct *tsk);
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
>  #define AUDIT_PROCTITLE                1327    /* Proctitle emit event */
>  #define AUDIT_FEATURE_CHANGE   1328    /* audit log listing feature changes */
>  #define AUDIT_REPLACE          1329    /* Replace auditd if this packet unanswerd */
> +#define AUDIT_CAPABILITY       1330    /* Record showing capability use */
> +#define AUDIT_CGROUP           1331    /* Record showing cgroups */

As Tejun Heo already stated, please put the capability changes and the
cgroup changes into two separate patches in one patchset.

>  #define AUDIT_AVC              1400    /* SE Linux avc denial or grant */
>  #define AUDIT_SELINUX_ERR      1401    /* Internal SE Linux Errors */
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
>         int i;
>
> -       audit_log_format(ab, " %s=", prefix);
> +       audit_log_format(ab, "%s=", prefix);

Why?

>         CAP_FOR_EACH_U32(i) {
>                 audit_log_format(ab, "%08x",
>                                  cap->cap[CAP_LAST_U32 - i]);
> @@ -1696,11 +1697,11 @@ static void audit_log_fcaps(struct audit_buffer *ab, struct audit_names *name)
>         int log = 0;
>
>         if (!cap_isclear(*perm)) {
> -               audit_log_cap(ab, "cap_fp", perm);
> +               audit_log_cap(ab, " cap_fp", perm);

This is not an improvement, please stick with the leading space in
audit_log_cap() so callers do not have to worry about formatting
issues like this.

> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 2672d10..32c3813 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -1439,6 +1439,18 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
>
>         audit_log_proctitle(tsk, context);
>
> +       ab = audit_log_start(context, GFP_KERNEL, AUDIT_CAPABILITY);
> +       if (ab) {
> +               audit_log_cap(ab, "cap_used", &context->cap_used);
> +               audit_log_end(ab);
> +       }
> +       ab = audit_log_start(context, GFP_KERNEL, AUDIT_CGROUP);
> +       if (ab) {
> +               audit_log_format(ab, "cgroups=");
> +               audit_cgroup_list(ab);

Why not just move the "cgroups=" into audit_cgroup_list()?  Can you
ever think of a reason why you would need to record the cgroups
without the "cgroup=" field prefix?

> +               audit_log_end(ab);
> +       }
> +
>         /* Send end of event record to help user space know we are finished */
>         ab = audit_log_start(context, GFP_KERNEL, AUDIT_EOE);
>         if (ab)
> @@ -2428,3 +2440,17 @@ struct list_head *audit_killed_trees(void)
>                 return NULL;
>         return &ctx->killed_trees;
>  }
> +
> +void audit_log_cap_use(int cap)
> +{
> +       struct audit_context *context = current->audit_context;
> +
> +       if (context) {
> +               cap_raise(context->cap_used, cap);
> +               audit_set_auditable(context);
> +       } else {
> +               audit_log(NULL, GFP_NOFS, AUDIT_CAPABILITY,
> +                         "cap_used=%d pid=%d no audit_context",
> +                         cap, task_pid_nr(current));
> +       }
> +}

You can't log "no audit_context" in the audit record, all information
logged should follow the "<field>=<value>" format.

-- 
paul moore
www.paul-moore.com
