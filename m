Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223F7238C1A
	for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 03:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790737665; cv=none; b=AJIvVOqkJp8yc+riaS43hl4YnFUHs26pEVxDRMRRsb/hEq62ydvuVD5oLEe/vb0qfOWOgp9QFp2EzwL8diyLXJuLtJHQey3L/p1sdzat27e6hO6/0pcug4nsSyFUcahamboUAHJvvyVSQbmeV1XrKPOAyZyxI/GJGyctLxPTKRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790737665; c=relaxed/simple;
	bh=l8mKIw6ogTTKxQCLtmNGUJkNJTzQumrWXkiYAMJc89w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VAWeMHELlmq8+p3R1FzZ0AnDqKAuN7b9ddw4gLclHsIgn+8IScOjtdl/T+BlXYIyi00AGQ2GYtyMHWoTzllv55T8T2TSWS99SprFCnwdxnJ/DESe2/ZuYZGqAN92L4KnY8/fkpxKQIpJEn6fKjHTqvbPDxrMeroJjT7GPgpua8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hqxc7DoO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hqxc7DoO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790737663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4IDKqY5iGTsXAzQQPBUuW2h7M791Q7f8nwF8osNavRE=;
	b=hqxc7DoOa3fDdT+jDR1z5LIlcqCukfnF2PSRx8POL5VZCfe+tYUCcUetmTTVg84bE/Nnbe
	+BlvVq47L9Ghee2nE9hE/0hosV0wK1Nlilx/QSAkChREdR6QJN4mfzFw/sB9lKBy54Joac
	tqVCORePbPudHw+UqgPW7u8f2gOw46M=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-606-2BBb6dHfN_qVr92UNO54JQ-1; Tue,
 29 Sep 2026 23:07:39 -0400
X-MC-Unique: 2BBb6dHfN_qVr92UNO54JQ-1
X-Mimecast-MFC-AGG-ID: 2BBb6dHfN_qVr92UNO54JQ_1790737649
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4C134180ACC8;
	Wed, 30 Sep 2026 03:07:29 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9B60E195604C;
	Wed, 30 Sep 2026 03:07:27 +0000 (UTC)
Message-ID: <9154694a-bdc5-4654-9514-b33d3dea6afc@redhat.com>
Date: Tue, 29 Sep 2026 23:07:26 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next] cgroup/cpuset: Move cpuset_update_flag() to
 cpuset-v1.c
To: Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260930023139.495964-1-ridong.chen@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260930023139.495964-1-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On 9/29/26 10:31 PM, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
>
> cpuset_update_flag() is only used by the legacy (v1) interface: its
> callers are the write handlers of cpuset1_files via cpuset_write_u64(),
> and cpuset_css_offline() which invokes it only on the legacy hierarchy
> (!cpuset_v2() && is_sched_load_balance()).
>
> Move it, together with its sole helper cpuset1_update_tasks_flags(),
> into cpuset-v1.c so both can go back to being static and drop out of
> cpuset-internal.h.  As a result:
>
>   - dup_or_alloc_cpuset(), free_cpuset() and validate_change() are now
>     referenced from cpuset-v1.c, so they lose their static qualifier and
>     gain declarations in cpuset-internal.h.
>
>   - The v2 branch in cpuset_update_flag() that called
>     cpuset_force_rebuild() is dead on the v1-only call paths and is
>     dropped; the remaining rebuild_sched_domains_locked() path is kept.
>     callback_lock, a static in cpuset.c, is taken through the existing
>     cpuset_callback_lock_irq() wrapper.
>
>   - The open-coded "!cpuset_v2() && is_sched_load_balance()" test in
>     cpuset_css_offline() is wrapped in a new cpuset1_offline_css() helper
>     (a no-op stub when CONFIG_CPUSETS_V1=n), removing the last
>     cpuset_v2() branch from that path in cpuset.c.
>
> No functional change intended.
>
> Assisted-by: LLM
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>   kernel/cgroup/cpuset-internal.h |  8 ++--
>   kernel/cgroup/cpuset-v1.c       | 59 +++++++++++++++++++++++++++-
>   kernel/cgroup/cpuset.c          | 68 ++-------------------------------
>   3 files changed, 67 insertions(+), 68 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset-internal.h b/kernel/cgroup/cpuset-internal.h
> index e7d010661fd3..5da9c91295b0 100644
> --- a/kernel/cgroup/cpuset-internal.h
> +++ b/kernel/cgroup/cpuset-internal.h
> @@ -304,7 +304,9 @@ void cpuset_callback_lock_irq(void);
>   void cpuset_callback_unlock_irq(void);
>   void cpuset_update_tasks_cpumask(struct cpuset *cs, struct cpumask *new_cpus);
>   void cpuset_update_tasks_nodemask(struct cpuset *cs);
> -int cpuset_update_flag(cpuset_flagbits_t bit, struct cpuset *cs, int turning_on);
> +struct cpuset *dup_or_alloc_cpuset(struct cpuset *cs);
> +void free_cpuset(struct cpuset *cs);
> +int validate_change(struct cpuset *cur, struct cpuset *trial);
>   ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
>   				    char *buf, size_t nbytes, loff_t off);
>   int cpuset_common_seq_show(struct seq_file *sf, void *v);
> @@ -318,7 +320,6 @@ void cpuset_full_unlock(void);
>   extern struct cftype cpuset1_files[];
>   void cpuset1_update_task_spread_flags(struct cpuset *cs,
>   					struct task_struct *tsk);
> -void cpuset1_update_tasks_flags(struct cpuset *cs);
>   void cpuset1_hotplug_update_tasks(struct cpuset *cs,
>   			    struct cpumask *new_cpus, nodemask_t *new_mems,
>   			    bool cpus_updated, bool mems_updated);
> @@ -328,11 +329,11 @@ void cpuset1_init(struct cpuset *cs);
>   void cpuset1_online_css(struct cgroup_subsys_state *css);
>   int cpuset1_generate_sched_domains(cpumask_var_t **domains,
>   			struct sched_domain_attr **attributes);
> +void cpuset1_offline_css(struct cpuset *cs);
>   
>   #else
>   static inline void cpuset1_update_task_spread_flags(struct cpuset *cs,
>   					struct task_struct *tsk) {}
> -static inline void cpuset1_update_tasks_flags(struct cpuset *cs) {}
>   static inline void cpuset1_hotplug_update_tasks(struct cpuset *cs,
>   			    struct cpumask *new_cpus, nodemask_t *new_mems,
>   			    bool cpus_updated, bool mems_updated) {}
> @@ -344,6 +345,7 @@ static inline void cpuset1_init(struct cpuset *cs) {}
>   static inline void cpuset1_online_css(struct cgroup_subsys_state *css) {}
>   static inline int cpuset1_generate_sched_domains(cpumask_var_t **domains,
>   			struct sched_domain_attr **attributes) { return 0; };
> +static inline void cpuset1_offline_css(struct cpuset *cs) {}
>   
>   #endif /* CONFIG_CPUSETS_V1 */
>   
> diff --git a/kernel/cgroup/cpuset-v1.c b/kernel/cgroup/cpuset-v1.c
> index 562ad35f00d0..7c7f2887dfaf 100644
> --- a/kernel/cgroup/cpuset-v1.c
> +++ b/kernel/cgroup/cpuset-v1.c
> @@ -229,7 +229,7 @@ void cpuset1_update_task_spread_flags(struct cpuset *cs,
>    * function is called with cpuset_mutex held, cpuset membership stays
>    * stable.
>    */
> -void cpuset1_update_tasks_flags(struct cpuset *cs)
> +static void cpuset1_update_tasks_flags(struct cpuset *cs)
>   {
>   	struct css_task_iter it;
>   	struct task_struct *task;
> @@ -473,6 +473,51 @@ static u64 cpuset_read_u64(struct cgroup_subsys_state *css, struct cftype *cft)
>   	return 0;
>   }
>   
> +/*
> + * cpuset_update_flag - read a 0 or a 1 in a file and update associated flag
> + * bit:		the bit to update (see cpuset_flagbits_t)
> + * cs:		the cpuset to update
> + * turning_on:	whether the flag is being set or cleared
> + *
> + * Call with cpuset_mutex held.
> + */
> +static int cpuset_update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
> +			      int turning_on)
> +{
> +	struct cpuset *trialcs;
> +	int balance_flag_changed;
> +	int spread_page_changed;
> +	int err;
> +
> +	trialcs = dup_or_alloc_cpuset(cs);
> +	if (!trialcs)
> +		return -ENOMEM;
> +
> +	assign_bit(bit, &trialcs->flags, turning_on);
> +
> +	err = validate_change(cs, trialcs);
> +	if (err < 0)
> +		goto out;
> +
> +	balance_flag_changed = (is_sched_load_balance(cs) !=
> +				is_sched_load_balance(trialcs));
> +
> +	spread_page_changed = is_spread_page(cs) != is_spread_page(trialcs);
> +
> +	cpuset_callback_lock_irq();
> +	cs->flags = trialcs->flags;
> +	cpuset_callback_unlock_irq();
> +
> +	if (!cpumask_empty(trialcs->cpus_allowed) && balance_flag_changed)
> +		rebuild_sched_domains_locked();
> +
> +	if (spread_page_changed)
> +		cpuset1_update_tasks_flags(cs);
> +out:
> +	free_cpuset(trialcs);
> +	return err;
> +}
> +
>   static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
>   			    u64 val)
>   {
> @@ -581,6 +626,18 @@ void cpuset1_online_css(struct cgroup_subsys_state *css)
>   	cpuset_callback_unlock_irq();
>   }
>   
> +/*
> + * Legacy-hierarchy handling when a cpuset is taken offline: if it had
> + * sched_load_balance enabled, turn it off so the scheduler domains are
> + * rebuilt.  A no-op on the default hierarchy.
> + */
> +void cpuset1_offline_css(struct cpuset *cs)
> +{
> +	if (!cgroup_subsys_on_dfl(cpuset_cgrp_subsys) &&
> +	    is_sched_load_balance(cs))
> +		cpuset_update_flag(CS_SCHED_LOAD_BALANCE, cs, 0);
> +}
> +
>   static void
>   update_domain_attr(struct sched_domain_attr *dattr, struct cpuset *c)
>   {
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index cf55b0719a2d..9287a97310a3 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -162,7 +162,6 @@ static cpumask_var_t	isolated_hk_cpus;	/* T */
>    * It can be set in
>    *  - update_partition_sd_lb()
>    *  - update_cpumasks_hier()
> - *  - cpuset_update_flag()
>    *  - cpuset_hotplug_update_tasks()
>    *  - cpuset_handle_hotplug()
>    *
> @@ -608,7 +607,7 @@ static inline void free_tmpmasks(struct tmpmasks *tmp)
>    *
>    * Return: Pointer to newly allocated cpuset on success, NULL on failure
>    */
> -static struct cpuset *dup_or_alloc_cpuset(struct cpuset *cs)
> +struct cpuset *dup_or_alloc_cpuset(struct cpuset *cs)
>   {
>   	struct cpuset *trial;
>   
> @@ -649,7 +648,7 @@ static struct cpuset *dup_or_alloc_cpuset(struct cpuset *cs)
>    * free_cpuset - free the cpuset
>    * @cs: the cpuset to be freed
>    */
> -static inline void free_cpuset(struct cpuset *cs)
> +void free_cpuset(struct cpuset *cs)
>   {
>   	free_cpumask_var(cs->cpus_allowed);
>   	free_cpumask_var(cs->effective_cpus);
> @@ -743,7 +742,7 @@ static inline bool mems_excl_conflict(struct cpuset *cs1, struct cpuset *cs2)
>    * Return 0 if valid, -errno if not.
>    */
>   
> -static int validate_change(struct cpuset *cur, struct cpuset *trial)
> +int validate_change(struct cpuset *cur, struct cpuset *trial)
>   {
>   	struct cgroup_subsys_state *css;
>   	struct cpuset *c, *par;
> @@ -2829,56 +2828,6 @@ bool current_cpuset_is_being_rebound(void)
>   	return ret;
>   }
>   
> -/*
> - * cpuset_update_flag - read a 0 or a 1 in a file and update associated flag
> - * bit:		the bit to update (see cpuset_flagbits_t)
> - * cs:		the cpuset to update
> - * turning_on: 	whether the flag is being set or cleared
> - *
> - * Call with cpuset_mutex held.
> - */
> -
> -int cpuset_update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
> -		       int turning_on)
> -{
> -	struct cpuset *trialcs;
> -	int balance_flag_changed;
> -	int spread_page_changed;
> -	int err;
> -
> -	trialcs = dup_or_alloc_cpuset(cs);
> -	if (!trialcs)
> -		return -ENOMEM;
> -
> -	assign_bit(bit, &trialcs->flags, turning_on);
> -
> -	err = validate_change(cs, trialcs);
> -	if (err < 0)
> -		goto out;
> -
> -	balance_flag_changed = (is_sched_load_balance(cs) !=
> -				is_sched_load_balance(trialcs));
> -
> -	spread_page_changed = is_spread_page(cs) != is_spread_page(trialcs);
> -
> -	spin_lock_irq(&callback_lock);
> -	cs->flags = trialcs->flags;
> -	spin_unlock_irq(&callback_lock);
> -
> -	if (!cpumask_empty(trialcs->cpus_allowed) && balance_flag_changed) {
> -		if (cpuset_v2())
> -			cpuset_force_rebuild();
> -		else
> -			rebuild_sched_domains_locked();
> -	}
> -
> -	if (spread_page_changed)
> -		cpuset1_update_tasks_flags(cs);
> -out:
> -	free_cpuset(trialcs);
> -	return err;
> -}
> -
>   /**
>    * update_prstate - update partition_root_state
>    * @cs: the cpuset to update
> @@ -3632,21 +3581,12 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
>   	return 0;
>   }
>   
> -/*
> - * If the cpuset being removed has its flag 'sched_load_balance'
> - * enabled, then simulate turning sched_load_balance off, which
> - * will call rebuild_sched_domains_locked(). That is not needed
> - * in the default hierarchy where only changes in partition
> - * will cause repartitioning.
> - */
>   static void cpuset_css_offline(struct cgroup_subsys_state *css)
>   {
>   	struct cpuset *cs = css_cs(css);
>   
>   	cpuset_full_lock();
> -	if (!cpuset_v2() && is_sched_load_balance(cs))
> -		cpuset_update_flag(CS_SCHED_LOAD_BALANCE, cs, 0);
> -
> +	cpuset1_offline_css(cs);
>   	cpuset_dec();
>   	cpuset_full_unlock();
>   }

LGTM

Reviewed-by: Waiman Long <longman@redhat.com>

