Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.63.66.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793992906;
	b=fqwYhRFhVaAla7AbzqIjUCdT+hA2fdjP3dS7X0TpUE7G+j/2pF/aFd7jADYdhnqdJL5S
	 lrFdwv6uJdcC6p/kfyu/N8kqWf58fMacmUSYruB/WbpkFhacEEPtQ+cynJBKP1ISDZRfS
	 lwDjIEQMzm7nsAOiZKTmf8v5oGYocpMrQmjJ4XtRtQ1uikXsUukNi7fYsEwu5CpKywXR0
	 mgHT2VG8W1GlvDBLJl9JizVzNFx9nxgWzzUi4ZiTm4BD8u4PwpFHWtYU03ziAMgdcDQ4U
	 ohcUPFBH0MN83Sxx3i8fx5Xr1gYjDll6iII9zfzIE1/JS2HFjh6LeX+yDdTo5t9sNqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793992906;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=Fp3Ux3N5/ZDcqoQkZSul4oAbb1keDllE2s5CNcK8XK0=;
	b=iSmke7EP4XQQoTtWfbJcCk9nWiMwASjmq/UBgjA3dpWH/XTKropfBmKyZkfu4cJUwAEc
	 UmCbFmEAuTunwmOefWVJL30AYLiOd/9d8y2dgVj/4Gc0wehGUFvKp53KGUPPaeZUem0Yv
	 ItaFXH3snoLqg9xoQhnIBxLnxHS6/8X1UIwIjIxJnep10OXcd5YQcHy17BwOP28Pyatyg
	 v8N4mbNMHmmdgXu1fnbEaWjXNlOnlr/ViRMtX9TxP5FVKg7tfTroG/eXjbrhNwf3H5Z+u
	 vIMUwCCXTwmp70CL2oghOKupAMknB7d7QBG5UyDg7FbwAqKZNqNKvQjIPTmqdQD+6GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hallyn.com;
	spf=(null) smtp.mailfrom=hallyn.com;
	dkim=pass header.d=hallyn.com header.i=@hallyn.com header.a=rsa-sha256 header.s=mail header.b=t9BqiYsH;
	arc=none smtp.remote-ip=178.63.66.53
Received: from mail.hallyn.com (mail.hallyn.com [178.63.66.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538DA606A329;
	Fri,  6 Nov 2026 19:21:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 538DA606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hallyn.com
Authentication-Results: smtp.subspace.kernel.org; spf=tempfail smtp.mailfrom=hallyn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hallyn.com header.i=@hallyn.com header.a=rsa-sha256 header.s=mail header.b=t9BqiYsH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=hallyn.com; s=mail;
	t=1793992895; bh=5wOe5sXiLvZwika6b4pNHtIUuTGj464gQDoZszPPOrE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t9BqiYsHkwpw92jfWgISTSTqyC7x5MFdBt4dPfUUn+DtXrVqJI++OLR5WdVHXvwut
	 X3g+YPeZhefs6eqou/P6FUR837cPsh7PPuBSXlUFIfrOWoDqGNhQlLBcCCanz0dGeU
	 nVQuMD8tbOQQOFv93X5OcIpfauQ1PnStHXM6/h8gE252W60pXV6fG4PMIaL299eyNj
	 Hw6LI+mHS4njlb5cxWUPLFX9RQiPRJ+ya/ShxzXR4nnRjxVRlyx+meDQAADPpUKEih
	 Qo+XVjaV7c5sT+V7Xk2hL3yT4NomI20DfnQDOsbFoEbAqKQFRbjTVGTe0g1hCd+QK6
	 4wizszt1V1Jng==
Received: by mail.hallyn.com (Postfix, from userid 1001)
	id F1856225B; Fri,  6 Nov 2026 13:21:34 -0600 (CST)
Date: Fri, 6 Nov 2026 13:21:34 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: tsbogend@alpha.franken.de, paul@paul-moore.com, jmorris@namei.org,
	mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, longman@redhat.com, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, chenridong@huaweicloud.com,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
	omosnace@redhat.com, kees@kernel.org, neelx@suse.com, sean@ashe.io,
	chjohnst@gmail.com, steve@abita.co, mproche@gmail.com,
	nick.lange@gmail.com, cgroups@vger.kernel.org,
	linux-mips@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] security: Expand task_setscheduler LSM hook
Message-ID: <au4ovp/Ghd25rtfZ@hallyn.com>
References: <20261105172210.76706-1-atomlin@atomlin.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105172210.76706-1-atomlin@atomlin.com>

On Thu, Nov 05, 2026 at 12:22:10PM -0500, Aaron Tomlin wrote:
> At present, the task_setscheduler LSM hook only accepts the target
> task_struct pointer. It lacks visibility into the requested scheduling
> attributes (sched_attr) and the requested CPU affinity mask (cpumask).
> Consequently, security modules are blind to both the target scheduling
> parameters and target CPUs, preventing granular access control decisions
> based on scheduling policy or spatial isolation.
> 
> In modern multi-tenant and real-time environments, CPU and scheduling
> isolation are critical boundaries. The inability to audit or restrict
> specific scheduling policy changes or CPU pinning requests limits the
> effectiveness of security policies, particularly when attempting to
> shield isolated or cryptographic cores from unprivileged or compromised
> tasks.
> 
> This patch expands the security_task_setscheduler() hook signature to
> include pointers to the requested sched_attr and cpumask alongside the
> target task_struct. In __sched_setscheduler(), a local copy of
> sched_attr is populated with the resolved scheduling policy so that
> parameter-only updates (such as sched_setparam() or sched_setattr() with
> SCHED_FLAG_KEEP_POLICY) always pass the effective scheduling policy to
> the hook rather than an internal sentinel. Because this is a shared hook
> used across multiple paths, call sites that do not modify scheduling
> attributes or CPU affinity pass NULL for the respective parameter. To
> protect against unverified dereferences, both parameters are annotated
> with __nullable in the LSM hook definition, ensuring the BPF verifier
> mandates explicit NULL checks for attached eBPF programs.
> 
> Historically, SELinux has governed all scheduling alterations under a
> single, monolithic PROCESS__SETSCHED access vector. By inspecting fields
> such as attr->sched_policy or attr->sched_priority, as well as the
> requested cpumask, a security module can introduce granular access
> controls, such as differentiating between standard time-sharing policies
> and latency-sensitive real-time policies.
> 
> This change updates all in-tree security modules (capabilities, SELinux,
> and Smack) to accommodate the new parameters mechanically, while
> providing LSMs with the necessary context to enforce strict scheduling
> and affinity policies.
> 
> Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>

This seems misleading - Casey explicitly said "for the smack bits".  This
makes it seem like he reviewed and approved of the whole set.

> Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
> ---

I see no issues with the commoncap.c and security.c changes, but as
Paul said two versions ago in
https://lore.kernel.org/lkml/CAHC9VhSROg6RGUN4_ZVBoEwYjRnKvyjnkbx2D88c09KiTgY3KQ@mail.gmail.com/
nothing appaers to be using these.  Where is the user?

> Changes since v4:
> 
>  - Rebased against v7.4-rc1
> 
>  - In __sched_setscheduler(), populate a local copy of sched_attr with
>    the resolved scheduling policy before calling
>    security_task_setscheduler() so parameter-only updates (such as
>    sched_setparam() or sched_setattr() with SCHED_FLAG_KEEP_POLICY) pass
>    the effective policy rather than SETPARAM_POLICY (-1)
> 
>  - Clarified the commit message to reflect that both the sched_attr and
>    cpumask parameters are introduced by this patch
> 
>  - Link to v4: https://lore.kernel.org/all/20260720014156.459386-1-atomlin@atomlin.com/
> 
> Changes since v3:
> 
>  - Expanded the task_setscheduler LSM hook to accept the 'sched_attr'
>    payload, enabling BPF and other LSMs to inspect scheduling attributes
>    (Peter Zijlstra)
> 
>  - Updated all call sites for security_task_setscheduler() to correctly
>    pass the attr structure when available, or NULL otherwise
>    (Peter Zijlstra)
> 
>  - Added the necessary forward declaration for struct sched_attr to
>    include/linux/security.h
> 
>  - Link to v3: https://lore.kernel.org/lkml/20260526142838.774711-1-atomlin@atomlin.com/
> 
> Changes since v2:
> 
>  - Dropped patch 1. This is to be addressed by the cgroup cpuset
>    maintainer (Waiman Long)
> 
>  - Dropped patch 3. Will be submitted as a separate patch (Paul Moore)
> 
>  - Link to v2: https://lore.kernel.org/lkml/20260509213803.968464-1-atomlin@atomlin.com/
> 
> Changes since v1:
> 
>  - Reordered the allocation and user-copy of new_mask in the MIPS
>    architecture's mipsmt_sys_sched_setaffinity() to occur before the
>    LSM hook is invoked. This ensures the security modules evaluate a fully
>    populated mask rather than uninitialised memory, while cleanly handling
>    error unwinding
> 
>  - Updated cpuset_can_fork() to pass the destination cpuset's effective CPU
>    mask instead of NULL
> 
>  - Link to v1: https://lore.kernel.org/lkml/20260509164847.939294-1-atomlin@atomlin.com/
> ---
>  arch/mips/kernel/mips-mt-fpaff.c |  2 +-
>  fs/proc/base.c                   |  2 +-
>  include/linux/lsm_hook_defs.h    |  4 +++-
>  include/linux/security.h         | 15 +++++++++++----
>  kernel/cgroup/cpuset.c           |  4 ++--
>  kernel/sched/syscalls.c          |  7 +++++--
>  security/commoncap.c             |  9 +++++++--
>  security/security.c              | 14 +++++++++-----
>  security/selinux/hooks.c         |  4 +++-
>  security/smack/smack_lsm.c       | 13 +++++++++++--
>  10 files changed, 53 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/mips/kernel/mips-mt-fpaff.c b/arch/mips/kernel/mips-mt-fpaff.c
> index 4fead87d2f43..c7a5d55cf7ca 100644
> --- a/arch/mips/kernel/mips-mt-fpaff.c
> +++ b/arch/mips/kernel/mips-mt-fpaff.c
> @@ -110,7 +110,7 @@ asmlinkage long mipsmt_sys_sched_setaffinity(pid_t pid, unsigned int len,
>  		goto out_unlock;
>  	}
>  
> -	retval = security_task_setscheduler(p);
> +	retval = security_task_setscheduler(p, NULL, new_mask);
>  	if (retval)
>  		goto out_unlock;
>  
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index c9aebee0a338..d9a3c892586e 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2596,7 +2596,7 @@ static ssize_t timerslack_ns_write(struct file *file, const char __user *buf,
>  		}
>  		rcu_read_unlock();
>  
> -		err = security_task_setscheduler(p);
> +		err = security_task_setscheduler(p, NULL, NULL);
>  		if (err) {
>  			count = err;
>  			goto out;
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index 87d9d06710cb..411a5b977915 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -256,7 +256,9 @@ LSM_HOOK(int, 0, task_prlimit, const struct cred *cred,
>  	 const struct cred *tcred, unsigned int flags)
>  LSM_HOOK(int, 0, task_setrlimit, struct task_struct *p, unsigned int resource,
>  	 struct rlimit *new_rlim)
> -LSM_HOOK(int, 0, task_setscheduler, struct task_struct *p)
> +LSM_HOOK(int, 0, task_setscheduler, struct task_struct *p,
> +	 const struct sched_attr *attr__nullable,
> +	 const struct cpumask *in_mask__nullable)
>  LSM_HOOK(int, 0, task_getscheduler, struct task_struct *p)
>  LSM_HOOK(int, 0, task_movememory, struct task_struct *p)
>  LSM_HOOK(int, 0, task_kill, struct task_struct *p, struct kernel_siginfo *info,
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 40831fab5470..b2c43e745447 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -84,6 +84,7 @@ struct audit_krule;
>  struct ns_common;
>  struct user_namespace;
>  struct timezone;
> +struct sched_attr;
>  
>  enum lsm_event {
>  	LSM_POLICY_CHANGE,
> @@ -198,7 +199,9 @@ extern int cap_mmap_addr(unsigned long addr);
>  extern int cap_task_fix_setuid(struct cred *new, const struct cred *old, int flags);
>  extern int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
>  			  unsigned long arg4, unsigned long arg5);
> -extern int cap_task_setscheduler(struct task_struct *p);
> +extern int cap_task_setscheduler(struct task_struct *p,
> +				 const struct sched_attr *attr,
> +				 const struct cpumask *in_mask);
>  extern int cap_task_setioprio(struct task_struct *p, int ioprio);
>  extern int cap_task_setnice(struct task_struct *p, int nice);
>  extern int cap_vm_enough_memory(struct mm_struct *mm, long pages);
> @@ -537,7 +540,9 @@ int security_task_prlimit(const struct cred *cred, const struct cred *tcred,
>  			  unsigned int flags);
>  int security_task_setrlimit(struct task_struct *p, unsigned int resource,
>  		struct rlimit *new_rlim);
> -int security_task_setscheduler(struct task_struct *p);
> +int security_task_setscheduler(struct task_struct *p,
> +			       const struct sched_attr *attr,
> +			       const struct cpumask *in_mask);
>  int security_task_getscheduler(struct task_struct *p);
>  int security_task_movememory(struct task_struct *p);
>  int security_task_kill(struct task_struct *p, struct kernel_siginfo *info,
> @@ -1408,9 +1413,11 @@ static inline int security_task_setrlimit(struct task_struct *p,
>  	return 0;
>  }
>  
> -static inline int security_task_setscheduler(struct task_struct *p)
> +static inline int security_task_setscheduler(struct task_struct *p,
> +					     const struct sched_attr *attr,
> +					     const struct cpumask *in_mask)
>  {
> -	return cap_task_setscheduler(p);
> +	return cap_task_setscheduler(p, attr, in_mask);
>  }
>  
>  static inline int security_task_getscheduler(struct task_struct *p)
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 3219f927c35e..d122de948572 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -3267,7 +3267,7 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
>  			attach_ctx.old_cs = task_cs(task);
>  
>  		if (setsched_check) {
> -			ret = security_task_setscheduler(task);
> +			ret = security_task_setscheduler(task, NULL, cs->effective_cpus);
>  			if (ret)
>  				goto out_unlock;
>  		}
> @@ -3816,7 +3816,7 @@ static int cpuset_can_fork(struct task_struct *task, struct css_set *cset)
>  	if (ret)
>  		goto out_unlock;
>  
> -	ret = security_task_setscheduler(task);
> +	ret = security_task_setscheduler(task, NULL, cs->effective_cpus);
>  	if (ret)
>  		goto out_unlock;
>  
> diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
> index 45a127deeadd..1b3f81e6e18e 100644
> --- a/kernel/sched/syscalls.c
> +++ b/kernel/sched/syscalls.c
> @@ -533,6 +533,8 @@ int __sched_setscheduler(struct task_struct *p,
>  		return -EINVAL;
>  
>  	if (user) {
> +		struct sched_attr lsm_attr = *attr;
> +
>  		retval = user_check_sched_setscheduler(p, attr, policy, reset_on_fork);
>  		if (retval)
>  			return retval;
> @@ -540,7 +542,8 @@ int __sched_setscheduler(struct task_struct *p,
>  		if (attr->sched_flags & SCHED_FLAG_SUGOV)
>  			return -EINVAL;
>  
> -		retval = security_task_setscheduler(p);
> +		lsm_attr.sched_policy = policy;
> +		retval = security_task_setscheduler(p, &lsm_attr, NULL);
>  		if (retval)
>  			return retval;
>  	}
> @@ -1215,7 +1218,7 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
>  			return -EPERM;
>  	}
>  
> -	retval = security_task_setscheduler(p);
> +	retval = security_task_setscheduler(p, NULL, in_mask);
>  	if (retval)
>  		return retval;
>  
> diff --git a/security/commoncap.c b/security/commoncap.c
> index d47ab3022343..0c33f94a5707 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -1222,13 +1222,18 @@ static int cap_safe_nice(struct task_struct *p)
>  /**
>   * cap_task_setscheduler - Determine if scheduler policy change is permitted
>   * @p: The task to affect
> + * @attr: Requested scheduling attributes (ignored)
> + * @in_mask: Requested CPU affinity mask (ignored)
>   *
>   * Determine if the requested scheduler policy change is permitted for the
> - * specified task.
> + * specified task. The capabilities security module does not evaluate the
> + * @attr or @in_mask parameters, relying solely on cap_safe_nice().
>   *
>   * Return: 0 if permission is granted, -ve if denied.
>   */
> -int cap_task_setscheduler(struct task_struct *p)
> +int cap_task_setscheduler(struct task_struct *p,
> +			  const struct sched_attr *attr __always_unused,
> +			  const struct cpumask *in_mask __always_unused)
>  {
>  	return cap_safe_nice(p);
>  }
> diff --git a/security/security.c b/security/security.c
> index f6583d507395..9ca3438ef96a 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -3261,17 +3261,21 @@ int security_task_setrlimit(struct task_struct *p, unsigned int resource,
>  }
>  
>  /**
> - * security_task_setscheduler() - Check if setting sched policy/param is allowed
> + * security_task_setscheduler() - Check if setting sched policy/param/affinity is allowed
>   * @p: target task
> + * @attr: requested scheduling attributes, or NULL if not changing parameters
> + * @in_mask: requested CPU affinity mask, or NULL if not changing affinity
>   *
> - * Check permission before setting scheduling policy and/or parameters of
> - * process @p.
> + * Check permission before setting the scheduling policy, parameters, and/or
> + * CPU affinity of process @p.
>   *
>   * Return: Returns 0 if permission is granted.
>   */
> -int security_task_setscheduler(struct task_struct *p)
> +int security_task_setscheduler(struct task_struct *p,
> +			       const struct sched_attr *attr,
> +			       const struct cpumask *in_mask)
>  {
> -	return call_int_hook(task_setscheduler, p);
> +	return call_int_hook(task_setscheduler, p, attr, in_mask);
>  }
>  
>  /**
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 6168dd5f91c2..4fc3e8c51035 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -4690,7 +4690,9 @@ static int selinux_task_setrlimit(struct task_struct *p, unsigned int resource,
>  	return 0;
>  }
>  
> -static int selinux_task_setscheduler(struct task_struct *p)
> +static int selinux_task_setscheduler(struct task_struct *p,
> +				     const struct sched_attr *attr __always_unused,
> +				     const struct cpumask *in_mask __always_unused)
>  {
>  	return avc_has_perm(current_sid(), task_sid_obj(p), SECCLASS_PROCESS,
>  			    PROCESS__SETSCHED, NULL);
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 28a8e12603ce..a5f0de59dfc0 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -2350,10 +2350,19 @@ static int smack_task_getioprio(struct task_struct *p)
>  /**
>   * smack_task_setscheduler - Smack check on setting scheduler
>   * @p: the task object
> + * @attr: Requested scheduling attributes (ignored)
> + * @in_mask: Requested CPU affinity mask (ignored)
>   *
> - * Return 0 if read access is permitted
> + * Evaluate whether the current task has write access to the target task @p
> + * to change its scheduling policy. The Smack security module relies
> + * strictly on label-based access control and does not evaluate CPU
> + * affinity masks or scheduling attributes.
> + *
> + * Return: 0 if write access is permitted
>   */
> -static int smack_task_setscheduler(struct task_struct *p)
> +static int smack_task_setscheduler(struct task_struct *p,
> +				   const struct sched_attr *attr __always_unused,
> +				   const struct cpumask *in_mask __always_unused)
>  {
>  	return smk_curacc_on_task(p, MAY_WRITE, __func__);
>  }
> -- 
> 2.55.0
