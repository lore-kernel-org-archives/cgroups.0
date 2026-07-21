Received: from sonic310-30.consmr.mail.ne1.yahoo.com (sonic310-30.consmr.mail.ne1.yahoo.com [66.163.186.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0946B395AF6
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 15:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.186.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784646386; cv=none; b=OaY3ZNd6TgQADUsf6pJhvJcnPCOQrmHXgIc2hchzHKDhxkYdy0AmTAHBU6AR2EKUTF/zWSjWhlgJwiL7b5hrKHpfm2e47yAtcax2K0WaWV3rgAM9H1AHh3rSRcBVoYM/r/LvcbTk8tSJePr96aWu87sUfrsiEUu5pUSmWpMPBs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784646386; c=relaxed/simple;
	bh=kK4xZfxTA95byE5oO02tItnvWaXmK9lwzoGxrWKyo30=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CZqNoDhecmB+S1QI+rYwGwrFL4fD73IV3nyPEnKP/uCq0iyVv5XPVH+B17aNPBJOXxsrGREshr8Jwmxci3CAB9ObkdFAZwoogYXp756t3OJnbQ8WrHzt2BjG15VG9ctE0cYKhmXIJnirrU1zq5mlihtsJo0V8BQS5ZxfcsLcar8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=SFet64V1; arc=none smtp.client-ip=66.163.186.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="SFet64V1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1784646382; bh=SbPpHK7n/PLGXejt2HugMFabKMLNU4zpNq+7HXxGf/I=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=SFet64V1qljMCg5WFp55yUoGvfCYYbkOv5Xmc86bIrc/pTHKzD57fYF+ajS9aTKO5rwJGW3tNbRqDtkCWQUdKTu/aVSZYhsOGHoXGjLobsXC/h3ZYMVnMAQW3MSXIYo0zz4ZyxIU2nbdCqO+QI018gPchSFuF6Ikj0uNX2KhoHQw4//9ZBIagZJcZY79Dh/G4bDELH7RJJbPqne5pCOaxH5y5cdttEMd+jFYVbpRi0YYPf634dZb1ESXyftwA81NgmQvsyhhOPVtduHjEp585KyRtk/M6mKpVcD9ysRlXXX82DclPaYRUx/H7zWHa/6slEBWlnxu55n8ptfoi5nyCA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1784646382; bh=wcOUzprMBm3EfKUMbcue41ohNI+xugb1KKMtXWRF0yR=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=BaT2EN9RQLjwNKZlwIebZJNDHYzYcp7vX4t20z6NsASJc1u6uhaCM7NL0xyzm5YQdP0E8j58N0CenBIw508xsBCLVGrn2Y2yZjZfQlw8/FviJyOctpXDNlNbYq+lCJqqGImfK5ErYGKlJCnqkLZI5OXDWnpgUAAWgvqDqnMHesVFPjJQWYw9iEgZZLlHsJ46MkYQDDOhoLfrmN6fNucp1f/pl+9oVrk3fxTHLo+t4wWeDfYheBug9XMQPKMlS/3VKwtTEpCAA2sLiSNo7c/XdilX+ehVeMsvzIu4qzjhRu094s+q0WlRNWZeWlbf0AQNP2FQw4Vg833Jjm3du4Di4Q==
X-YMail-OSG: nylUabwVM1kfcHWxuI7upd9oeXlJFLh1VNr9j0.4ViNHwOTwAj1rAXG0GK3Q2gs
 6KU6VqN2GUhBWBfFNPyaKsqjmdCJJ5bRf3.RYBd5M7UG38Sn63UGuO5hupWIkdUH.PRV9CMsFYrr
 sz_MX3hfhft2XAMmD8xCuVMkoEgkeHh4veMyAxcb5EuVanYOOVB4FQIohJjnX0CCMhRo.kdfu6DK
 0KgyotKodBpx4HE2mEGsiEWsewzp.Ov4pbSF3HaUKUmMZZZgW8Mg9htzOMF.8Hc6xNWS4czTCYrC
 9tu77XuVsdbo91CRywdeXvkLhgwuxUp5T09IwhJG02fz8meFJcMbJFTIec8b1V13YvPwwlQOG3o6
 h8vqDypdfe_of7ikfZGr.mZepqjIIRdJOrKe5bdqUA1wDtk5olUMt61r806s5zVX7vyj9fnpy8Xg
 wq.0rj4HlDrjiiBYzjf565ZhZ4u2ATlmfK6Mok.LDnFuBBO9JWGWy9JP5qdNm7Szf3a0Qa2hHQfx
 wfv2xfGCKaCYXGM6ZzNekhmwQmFm5F3s08eGjnUVcXRNBKqSnE1Si.DPfHWW4H.UfXwdJ9CB5yVr
 PnVYs9vfdWXkY4u1MGAw7mDdr5_BAvj7k5wiJSn5BPAfPMIBL_YW99NdWqu8mOgnSlUOELzN.gTB
 Im_6a7gEnuHKAQEtbdzTrR767f3GbdOaQpqN1NjeFfx_LhqUu_TRV4rspo3eEf7B.ck6RwCBHN8l
 zMyQ0cTLelA.aQb9S9LEjAVfs4EutneWQz.G29HO6nGzvGSbA6uyzNCgLp7pteODY0s4h6mr1pUI
 8WmEPqy_IJA.5jXoKqAo1kVvaH7TuE0Ma5e.F2.qAYoWjapbS.4cT6kB2UgWkYLQdASMPZpOVphE
 eQI4Qx3IAovQ0xXvfrD5kuhe5VY7OIXc995cwsqNhZFcSg5NNEqt_9PgDnCa1tSXSgsVE3hWg5xx
 qRb.LWEzzBr0tB60gQT6biHVZ_M1MAf7Js1Q7VCWrWqeTtz3DqZh4Nkp0edKlLnEGpoW._hfq7.d
 t7r4KPRPFZGqX__NpaNOGo6zyz8fGfDm37D5H65MpSr3ZVqT9.FBi.E9AOO3DHibmLdu7N14w0QN
 gB2nq0Q4t4hHbXv73Rikje0TTqlrfjOkaKd780YQFb4OsSEY4eYwPt7ldGLt2mUzQXRgiw93kxPx
 zPrZ6AyG60dO59oRjp2J.3o8Rb_W4s0DJaOtHssc5S.q0fJJp424P4j_DSzF6KIGCgmQI3vzeHMX
 jeDCxer_SUE64_bKkkBsgw4ObvLRGP2AJ4KA5hkk3TA6u.V3Y5hEYM6GgFhvcteywj0bdhzTOt14
 bnm1OShUkI3g05ZetQa7TB0mYgvZX8myNvDea4CYtpOC71QzKXBVoJc3po7HnhjO1uPEjA5epR.E
 IpGa1K9TomirP2T5E2eZXmcHwz1vlgqgADcFjv7px5QJ8m36mMzba9cWwVBN8IMtIOaWuvjKyins
 Ihfai6vynSOK5P87mIsmv8_BIBMs3vuyJe4_4oxYu4MFTRCqgI_Qoj8IZ9vQix0kFF7AaWwhqdfH
 3dtghM_cIMnVhmcsT4KVDn8p6kjFD8k.u30v5a.G14pf07JRJygQ7R_DTZlIfirWBYXrc7Y06O1L
 .vQy8iAfK_e2Rj9lub9Q6vGHEKQdD9EC__6o.SG2.fywcnRfKrFee9eu6IgUENl4kDdkiPojtjNO
 N3MLx_tGraZAL1qeBgR0xyEcAyRdv_TVpgiDRKGzuabWsdpbk8BcqOExjayDgu9j9TYcrM6FVRG3
 dDSZMip2Akb79R_EETlzwzhJ2asVxOldkc5d5QJqXOa8xdm92BR3eieEXGw6t1tN4WBETMJ_PmMO
 10JsOCgoCMZ5Ps.DzK5GLKghNqjkfofuaR4G35P_bEFXSdEsZUgevAO77MQREdI.b0Bd.1CVFuZa
 5CsDWnict8oiwiDdy01SOFEDjbv.1QvabUqqkXH3oUakW.QlSz6IWJ.BmwSkQeVqGXybpQGbS.Ht
 yXcjqvHQQDfgIdXsklMx8k0TYna6hMpHhALya0ErZcbChLLr1Jxnx4Znn0iPbfEu2eNYCKHF1RhA
 MlKVNUzrOJVIy6nFZCNkaTPZLynY61anzbuY0G_wOEYnKcUQ6_5ZqeX.xoCTiZf6sEvcKTDd.HB4
 XLWYb2BARP5jLpyT0lCemqaUcM0ROgE4ncYi3HrQ.i_3JjzH3Pz7WsfTI7GNJDwmWRtGJcyVP4M_
 IazLj1xWdOETFnE2A7oGPy_NuK_uiHXtbAuEbqLPfdXkf93vHaRCPIwAkxm9.gRT47WOQQ.XayA-
 -
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 91e39c91-1502-4a88-a976-9785d0a2bcae
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.ne1.yahoo.com with HTTP; Tue, 21 Jul 2026 15:06:22 +0000
Received: by hermes--production-gq1-6dc558886b-f759z (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 61ac3cc839425aafa5e490c9d3b7301b;
          Tue, 21 Jul 2026 14:45:44 +0000 (UTC)
Message-ID: <31679bf5-a0cb-41b6-bc1d-7833c4fc9744@schaufler-ca.com>
Date: Tue, 21 Jul 2026 07:45:41 -0700
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] security: Expand task_setscheduler LSM hook
To: Aaron Tomlin <atomlin@atomlin.com>, tsbogend@alpha.franken.de,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, mingo@redhat.com,
 peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 stephen.smalley.work@gmail.com, longman@redhat.com, tj@kernel.org,
 hannes@cmpxchg.org, mkoutny@suse.com
Cc: chenridong@huaweicloud.com, dietmar.eggemann@arm.com,
 rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
 vschneid@redhat.com, kprateek.nayak@amd.com, omosnace@redhat.com,
 kees@kernel.org, neelx@suse.com, sean@ashe.io, chjohnst@gmail.com,
 steve@abita.co, mproche@gmail.com, nick.lange@gmail.com,
 cgroups@vger.kernel.org, linux-mips@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
 selinux@vger.kernel.org, linux-kernel@vger.kernel.org,
 Casey Schaufler <casey@schaufler-ca.com>
References: <20260720014156.459386-1-atomlin@atomlin.com>
Content-Language: en-US
From: Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <20260720014156.459386-1-atomlin@atomlin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.26180 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

On 7/19/2026 6:41 PM, Aaron Tomlin wrote:
> At present, the task_setscheduler LSM hook provides security modules
> with the opportunity to mediate changes to a task's scheduling policy by
> inspecting the requested sched_attr. However, when invoked via
> sched_setaffinity(), the hook lacks visibility into the actual CPU
> affinity mask being requested. Consequently, security modules are
> entirely blind to the target CPUs and cannot make granular access
> control decisions based on spatial isolation.
>
> In modern multi-tenant and real-time environments, CPU isolation is a
> critical boundary. The inability to audit or restrict specific CPU
> pinning requests limits the effectiveness of security policies,
> particularly when attempting to shield isolated or cryptographic cores
> from unprivileged or compromised tasks.
>
> This patch expands the security_task_setscheduler() hook signature to
> include a pointer to the requested cpumask alongside the existing
> sched_attr. Because this is a shared hook used for multiple scheduling
> attribute changes, call sites that do not modify CPU affinity are
> updated to safely pass NULL for the mask. To protect against unverified
> dereferences, the parameter is annotated with __nullable in the LSM hook
> definition, ensuring the BPF verifier mandates explicit NULL checks for
> attached eBPF programs.
>
> Historically, SELinux has governed all scheduling alterations under a
> single, monolithic PROCESS__SETSCHED access vector. However, by
> inspecting fields such as attr->sched_policy or attr->sched_priority, a
> security module can introduce granular access controls. For instance,
> differentiating between standard time-sharing policies and
> latency-sensitive real-time policies.
>
> This change updates all in-tree security modules (SELinux and Smack) to
> accommodate the new parameter mechanically, while providing LSMs with
> the necessary context to enforce strict affinity policies.
>
> Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
> ---
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
>  - Linked to v3: https://lore.kernel.org/lkml/20260526142838.774711-1-atomlin@atomlin.com/
>
> Changes since v2:
>
>  - Dropped patch 1. This is to be addressed by the cgroup cpuset
>    maintainer (Waiman Long)
>
>  - Dropped patch 3. Will be submitted as a separate patch (Paul Moore)
>
>  - Linked to v2: https://lore.kernel.org/lkml/20260509213803.968464-1-atomlin@atomlin.com/
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
>  - Linked to v1: https://lore.kernel.org/lkml/20260509164847.939294-1-atomlin@atomlin.com/
>
> Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>

For the (trivial) Smack changes:
Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>

> ---
>  arch/mips/kernel/mips-mt-fpaff.c |  2 +-
>  fs/proc/base.c                   |  2 +-
>  include/linux/lsm_hook_defs.h    |  4 +++-
>  include/linux/security.h         | 15 +++++++++++----
>  kernel/cgroup/cpuset.c           |  4 ++--
>  kernel/sched/syscalls.c          |  4 ++--
>  security/commoncap.c             |  9 +++++++--
>  security/security.c              | 14 +++++++++-----
>  security/selinux/hooks.c         |  4 +++-
>  security/smack/smack_lsm.c       | 13 +++++++++++--
>  10 files changed, 50 insertions(+), 21 deletions(-)
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
> index 780f81259052..b14401030e5c 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2589,7 +2589,7 @@ static ssize_t timerslack_ns_write(struct file *file, const char __user *buf,
>  		}
>  		rcu_read_unlock();
>  
> -		err = security_task_setscheduler(p);
> +		err = security_task_setscheduler(p, NULL, NULL);
>  		if (err) {
>  			count = err;
>  			goto out;
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index 65c9609ec207..80ca02879620 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -255,7 +255,9 @@ LSM_HOOK(int, 0, task_prlimit, const struct cred *cred,
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
> index 153e9043058f..82dfe4e3f8d1 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -82,6 +82,7 @@ struct ctl_table;
>  struct audit_krule;
>  struct user_namespace;
>  struct timezone;
> +struct sched_attr;
>  
>  enum lsm_event {
>  	LSM_POLICY_CHANGE,
> @@ -196,7 +197,9 @@ extern int cap_mmap_addr(unsigned long addr);
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
> @@ -531,7 +534,9 @@ int security_task_prlimit(const struct cred *cred, const struct cred *tcred,
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
> @@ -1393,9 +1398,11 @@ static inline int security_task_setrlimit(struct task_struct *p,
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
> index 45944b3e31ca..6ab47cf5582b 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -3042,7 +3042,7 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
>  			goto out_unlock;
>  
>  		if (setsched_check) {
> -			ret = security_task_setscheduler(task);
> +			ret = security_task_setscheduler(task, NULL, cs->effective_cpus);
>  			if (ret)
>  				goto out_unlock;
>  		}
> @@ -3600,7 +3600,7 @@ static int cpuset_can_fork(struct task_struct *task, struct css_set *cset)
>  	if (ret)
>  		goto out_unlock;
>  
> -	ret = security_task_setscheduler(task);
> +	ret = security_task_setscheduler(task, NULL, cs->effective_cpus);
>  	if (ret)
>  		goto out_unlock;
>  
> diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
> index b215b0ead9a6..86490035e815 100644
> --- a/kernel/sched/syscalls.c
> +++ b/kernel/sched/syscalls.c
> @@ -540,7 +540,7 @@ int __sched_setscheduler(struct task_struct *p,
>  		if (attr->sched_flags & SCHED_FLAG_SUGOV)
>  			return -EINVAL;
>  
> -		retval = security_task_setscheduler(p);
> +		retval = security_task_setscheduler(p, attr, NULL);
>  		if (retval)
>  			return retval;
>  	}
> @@ -1213,7 +1213,7 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
>  			return -EPERM;
>  	}
>  
> -	retval = security_task_setscheduler(p);
> +	retval = security_task_setscheduler(p, NULL, in_mask);
>  	if (retval)
>  		return retval;
>  
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 3399535808fe..d83eee0459fe 100644
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
> index 71aea8fdf014..a6725dddc34f 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -3240,17 +3240,21 @@ int security_task_setrlimit(struct task_struct *p, unsigned int resource,
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
> index 8d6945edae7a..d77a8d5c364c 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -4559,7 +4559,9 @@ static int selinux_task_setrlimit(struct task_struct *p, unsigned int resource,
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
> index ff115068c5c0..cf28ccc28b80 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -2338,10 +2338,19 @@ static int smack_task_getioprio(struct task_struct *p)
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
