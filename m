From: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Mon, 4 Dec 2017 10:44:49 +0530
Message-ID: <623f214b-8b9a-f967-7a3d-ca9c06151267@codeaurora.org>
References: <CANaxB-zT+sz=z1FFk5npnwMySdfKCBZDkM+P+=JXDkCXbh=rCw@mail.gmail.com>
 <1511868946-23959-1-git-send-email-prsood@codeaurora.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1512364501;
        bh=zlGua2VlpWCIEZHMs1m2qGU7JF8z6+eMujd1S2OxQPc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=IVLPOYTBRjVuUb+A2lPMbuTBFuafUYMmUQyByhjBVK05WYwGzkd19kZsHHD+hXq6P
         fuZr7CLZnB/gvM2DIPx6le5iLtdDmdrIvxeED6M+WgTyiAFNhsVbMMrCBKrmqAWj93
         77WSYvaIj9klKf7ONd/EN41atsRpw+dOoCvsyOhE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1512364499;
        bh=zlGua2VlpWCIEZHMs1m2qGU7JF8z6+eMujd1S2OxQPc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=GB29/zzUHaMaseXf+EPsKT3/Do8hjT9A1pi4Yc9rNEcBIq6J4AcZ1PXfN7fJ6lLp6
         nG4OGYOspvT0NRFj9oBlTkC+Yg6u2MjpG+vo4X1bSo+iV3cTC6FVqWRat8dTNYCSp9
         YM91A8OtI79P45apeisjc9Cpd2eTmMcOEYVnG8Cs=
In-Reply-To: <1511868946-23959-1-git-send-email-prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org

On 11/28/2017 05:05 PM, Prateek Sood wrote:
> CPU1
> cpus_read_lock+0x3e/0x80
> static_key_slow_inc+0xe/0xa0
> cpuset_css_online+0x62/0x330
> online_css+0x26/0x80
> cgroup_apply_control_enable+0x266/0x3d0
> cgroup_mkdir+0x37d/0x4f0
> kernfs_iop_mkdir+0x53/0x80
> vfs_mkdir+0x10e/0x1a0
> SyS_mkdirat+0xb3/0xe0
> entry_SYSCALL_64_fastpath+0x23/0x9a
> 
> CPU0
> lock_acquire+0xec/0x1e0
> __mutex_lock+0x89/0x920
> cpuset_write_resmask+0x61/0x1100
> cgroup_file_write+0x7b/0x200
> kernfs_fop_write+0x112/0x1a0
> __vfs_write+0x23/0x150
> vfs_write+0xc8/0x1c0
> SyS_write+0x45/0xa0
> entry_SYSCALL_64_fastpath+0x23/0x9a
> 
> CPU0                               CPU1
> ----                               ----
> lock(cpu_hotplug_lock.rw_sem);
>                                 lock(cpuset_mutex);
>                                 lock(cpu_hotplug_lock.rw_sem);
> lock(cpuset_mutex);
> 
> Change locking order of cpu_hotplug_lock.rw_sem and
> cpuset_mutex in cpuset_css_online(). Use _cpuslocked()
> version for static_branch_inc/static_branch_dec in
> cpuset_inc()/cpuset_dec().
> 
> Signed-off-by: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> ---
>  include/linux/cpuset.h     |  8 ++++----
>  include/linux/jump_label.h | 10 ++++++++--
>  kernel/cgroup/cpuset.c     |  4 ++--
>  kernel/jump_label.c        | 13 +++++++++++++
>  4 files changed, 27 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> index 2ab910f..5aadc25 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -40,14 +40,14 @@ static inline bool cpusets_enabled(void)
>  
>  static inline void cpuset_inc(void)
>  {
> -	static_branch_inc(&cpusets_pre_enable_key);
> -	static_branch_inc(&cpusets_enabled_key);
> +	static_branch_inc_cpuslocked(&cpusets_pre_enable_key);
> +	static_branch_inc_cpuslocked(&cpusets_enabled_key);
>  }
>  
>  static inline void cpuset_dec(void)
>  {
> -	static_branch_dec(&cpusets_enabled_key);
> -	static_branch_dec(&cpusets_pre_enable_key);
> +	static_branch_dec_cpuslocked(&cpusets_enabled_key);
> +	static_branch_dec_cpuslocked(&cpusets_pre_enable_key);
>  }
>  
>  extern int cpuset_init(void);
> diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
> index c7b368c..890e21c 100644
> --- a/include/linux/jump_label.h
> +++ b/include/linux/jump_label.h
> @@ -160,6 +160,8 @@ extern void arch_jump_label_transform_static(struct jump_entry *entry,
>  extern int jump_label_text_reserved(void *start, void *end);
>  extern void static_key_slow_inc(struct static_key *key);
>  extern void static_key_slow_dec(struct static_key *key);
> +extern void static_key_slow_incr_cpuslocked(struct static_key *key);
> +extern void static_key_slow_decr_cpuslocked(struct static_key *key);
>  extern void jump_label_apply_nops(struct module *mod);
>  extern int static_key_count(struct static_key *key);
>  extern void static_key_enable(struct static_key *key);
> @@ -259,6 +261,8 @@ static inline void static_key_disable(struct static_key *key)
>  
>  #define static_key_enable_cpuslocked(k)		static_key_enable((k))
>  #define static_key_disable_cpuslocked(k)	static_key_disable((k))
> +#define static_key_slow_incr_cpuslocked(k)	static_key_slow_inc((k))
> +#define static_key_slow_decr_cpuslocked(k)	static_key_slow_dec((k))
>  
>  #define STATIC_KEY_INIT_TRUE	{ .enabled = ATOMIC_INIT(1) }
>  #define STATIC_KEY_INIT_FALSE	{ .enabled = ATOMIC_INIT(0) }
> @@ -414,8 +418,10 @@ struct static_key_false {
>   * Advanced usage; refcount, branch is enabled when: count != 0
>   */
>  
> -#define static_branch_inc(x)		static_key_slow_inc(&(x)->key)
> -#define static_branch_dec(x)		static_key_slow_dec(&(x)->key)
> +#define static_branch_inc(x)			static_key_slow_inc(&(x)->key)
> +#define static_branch_dec(x)			static_key_slow_dec(&(x)->key)
> +#define static_branch_inc_cpuslocked(x)		static_key_slow_incr_cpuslocked(&(x)->key)
> +#define static_branch_dec_cpuslocked(x)		static_key_slow_decr_cpuslocked(&(x)->key)
>  
>  /*
>   * Normal usage; boolean enable/disable.
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 227bc25..4ad8bae 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1985,7 +1985,7 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
>  	if (!parent)
>  		return 0;
>  
> -	mutex_lock(&cpuset_mutex);
> +	cpuset_sched_change_begin();
>  
>  	set_bit(CS_ONLINE, &cs->flags);
>  	if (is_spread_page(parent))
> @@ -2034,7 +2034,7 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
>  	cpumask_copy(cs->effective_cpus, parent->cpus_allowed);
>  	spin_unlock_irq(&callback_lock);
>  out_unlock:
> -	mutex_unlock(&cpuset_mutex);
> +	cpuset_sched_change_end();
>  	return 0;
>  }
>  
> diff --git a/kernel/jump_label.c b/kernel/jump_label.c
> index 8594d24..dde0eaa 100644
> --- a/kernel/jump_label.c
> +++ b/kernel/jump_label.c
> @@ -126,6 +126,12 @@ void static_key_slow_inc(struct static_key *key)
>  }
>  EXPORT_SYMBOL_GPL(static_key_slow_inc);
>  
> +void static_key_slow_incr_cpuslocked(struct static_key *key)
> +{
> +	static_key_slow_inc_cpuslocked(key);
> +}
> +EXPORT_SYMBOL_GPL(static_key_slow_incr_cpuslocked);
> +
>  void static_key_enable_cpuslocked(struct static_key *key)
>  {
>  	STATIC_KEY_CHECK_USE(key);
> @@ -229,6 +235,13 @@ void static_key_slow_dec(struct static_key *key)
>  }
>  EXPORT_SYMBOL_GPL(static_key_slow_dec);
>  
> +void static_key_slow_decr_cpuslocked(struct static_key *key)
> +{
> +	STATIC_KEY_CHECK_USE(key);
> +	static_key_slow_dec_cpuslocked(key, 0, NULL);
> +}
> +EXPORT_SYMBOL_GPL(static_key_slow_decr_cpuslocked);
> +
>  void static_key_slow_dec_deferred(struct static_key_deferred *key)
>  {
>  	STATIC_KEY_CHECK_USE(key);
> 

TJ,

Any feedback/suggestion for this patch?


-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation
Center, Inc., is a member of Code Aurora Forum, a Linux Foundation
Collaborative Project
