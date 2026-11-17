Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794932166;
	b=cgrSaJlzxtHfr+1TkUiC11PpjCjzfoDf48eXucSxqenkbUtnx1clK6Eb1R7btQkod0c2
	 QqnN+X/JUfn/X/9bE2OwKItjtasCj4g4SuEq3KDK6PS4LycLwOQMA4AH9MDUVMP4IcyWF
	 8np5cJqH46phcx3fYSIQD+qIsd2ETEZwJaNpwgR9IcBM8apuvlFEdW6qgM1SkcX2wza6W
	 n9BPx8krYCrBt4mq38ILzXt6hGck4RJOqSvIutF1uBL/s/WLcexfknpmceKjFLyQt9HiT
	 056F16EPSv2Ziv0StHcCw6lULtuWoozkzPfYA2hDJh3poFkR5xC9QfiS5Sqasjdu2og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794932166;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=UHRxHeVrPHHFkZ/kT+M0V1DV3h2pbSZTeeb2kX9CGr4=;
	b=PE7jB0ZQ/blM/CTqkvFspQLHdJ1/58Wq/V2oxzstCs8OcimKzMgNK3C0mEq3/RS6zCr9
	 DsFx0oJ3m5IeKWnkHvqb+pJPfDv7mFyDZs5ozsFErxsfWdEj2qh4VU3VClu+33ygZQZsX
	 HUxZI4WOdTOS9kwXfLdBviUhB7Lw7Es5EhKoC+UBsvtaFhYUJpMzqENJm+2MmtkW0P111
	 alUiWqowuPz94saW6VA2e7U4WyWo7iiYlRo+gIVud9KznXFCeZlCWU4+DorqYGwEopqvg
	 BOCoWUiEAPRlFMWDydV5LD8uBjPX1c0VaR+qGeMfyBLs/d21l5DVFZ9+GgUQKi02/8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hjKFWd7Q;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3788606A31C
	for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 16:16:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3788606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hjKFWd7Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794932164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UHRxHeVrPHHFkZ/kT+M0V1DV3h2pbSZTeeb2kX9CGr4=;
	b=hjKFWd7QiREf0jezOIQ4lSGk59jxLf7xZYSHSCXQgqjd6u1yxJoBKyREX03MquNs9irtWk
	QNt7IRxWqNEQXGFk0QJUeRIQXu9DS1xggnWzOMuH2MLX1sUlobYJFKjLatYilr1Nqv5Zbk
	f/qCCsdl0Sprkxem1Ex0f8oKtGogiAs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-591-ZiM3dXTdMLCkGHYWWr6hqw-1; Tue,
 17 Nov 2026 11:16:01 -0500
X-MC-Unique: ZiM3dXTdMLCkGHYWWr6hqw-1
X-Mimecast-MFC-AGG-ID: ZiM3dXTdMLCkGHYWWr6hqw_1794932157
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B612818004F6;
	Tue, 17 Nov 2026 16:15:56 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E1DC23001DB3;
	Tue, 17 Nov 2026 16:15:52 +0000 (UTC)
Message-ID: <36d49371-31de-4305-89c4-2ce64dd6848c@redhat.com>
Date: Tue, 17 Nov 2026 11:15:52 -0500
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] sched/isolation: Publish new HK_TYPE_DOMAIN cpumask under
 cpuset_mutex
To: Ridong <ridong.chen@linux.dev>, frederic@kernel.org, tj@kernel.org,
 peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, hannes@cmpxchg.org, mkoutny@suse.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 guopeng.zhang@linux.dev, mathieu.desnoyers@efficios.com,
 Ridong Chen <chenridong@xiaomi.com>
References: <054a53a3-c038-48fe-ac01-fc24fd8065d0@linux.dev>
 <20261117083915.2971979-1-ridong.chen@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20261117083915.2971979-1-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On 11/17/26 3:39 AM, Ridong wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
>
> Commit a84097e625f2 ("cgroup/cpuset: Call housekeeping_update() without
> holding cpus_read_lock") calls housekeeping_update() after dropping
> cpus_read_lock and cpuset_mutex, so the HK_TYPE_DOMAIN cpumask is now
> switched and freed outside of those locks. But readers holding either
> lock may still access it without rcu_read_lock() as allowed by
> housekeeping_dereference_check(), and synchronize_rcu() doesn't wait
> for them:
>
>    CPU A                                  CPU B
>    rebuild_sched_domains()                cpuset_update_sd_hk_unlock()
>                                             mutex_unlock(&cpuset_mutex)
>                                             cpus_read_unlock()
>      mutex_lock(&cpuset_mutex)
>      p = housekeeping_cpumask(DOMAIN)
>                                             housekeeping_update()
>                                               rcu_assign_pointer()
>                                               synchronize_rcu()
>                                               kfree(old)
>      access p <- UAF
>
> Fix it by moving the pointer switch into housekeeping_publish(), which
> is called before dropping the locks. Then CPU A either finishes before
> CPU B switches the pointer, or only sees the new cpumask:
>
>    CPU A                                  CPU B
>                                           cpuset_update_sd_hk_unlock()
>                                             housekeeping_publish()
>                                               rcu_assign_pointer()
>      mutex_lock(&cpuset_mutex) <- wait
>                                             mutex_unlock(&cpuset_mutex)
>                                             cpus_read_unlock()
>      p = housekeeping_cpumask(DOMAIN)       housekeeping_update()
>          <- new cpumask                       synchronize_rcu()
>                                               kfree(old)
>
> The rest of housekeeping_update(), including the workqueue flushes,
> still runs without those locks.
>
> Fixes: a84097e625f2 ("cgroup/cpuset: Call housekeeping_update() without holding cpus_read_lock")
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>   include/linux/sched/isolation.h |  6 ++++--
>   kernel/cgroup/cpuset.c          | 12 ++++++++----
>   kernel/sched/isolation.c        | 23 ++++++++++++++++-------
>   3 files changed, 28 insertions(+), 13 deletions(-)
>
> diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
> index cf0fd03dd7a24..09fabf42e3224 100644
> --- a/include/linux/sched/isolation.h
> +++ b/include/linux/sched/isolation.h
> @@ -43,7 +43,8 @@ extern const struct cpumask *housekeeping_cpumask(enum hk_type type);
>   extern bool housekeeping_enabled(enum hk_type type);
>   extern void housekeeping_affine(struct task_struct *t, enum hk_type type);
>   extern bool housekeeping_test_cpu(int cpu, enum hk_type type);
> -extern int housekeeping_update(struct cpumask *isol_mask);
> +extern struct cpumask *housekeeping_publish(struct cpumask *isol_mask);
> +extern void housekeeping_update(struct cpumask *isol_mask, struct cpumask *old);
>   extern void __init housekeeping_init(void);
>   
>   #else
> @@ -71,7 +72,8 @@ static inline bool housekeeping_test_cpu(int cpu, enum hk_type type)
>   	return true;
>   }
>   
> -static inline int housekeeping_update(struct cpumask *isol_mask) { return 0; }
> +static inline struct cpumask *housekeeping_publish(struct cpumask *isol_mask) { return NULL; }
> +static inline void housekeeping_update(struct cpumask *isol_mask, struct cpumask *old) { }
>   static inline void housekeeping_init(void) { }
>   #endif /* CONFIG_CPU_ISOLATION */
>   
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 8a8a424a389f3..1673bb25a797b 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1472,17 +1472,21 @@ static void cpuset_update_sd_hk_unlock(void)
>   		rebuild_sched_domains_locked();
>   
>   	if (update_housekeeping) {
> +		struct cpumask *old;
> +
>   		update_housekeeping = false;
>   		cpumask_copy(isolated_hk_cpus, isolated_cpus);
>   
>   		/*
> -		 * housekeeping_update() is now called without holding
> -		 * cpus_read_lock and cpuset_mutex. Only cpuset_top_mutex
> -		 * is still being held for mutual exclusion.
> +		 * Publish the new cpumask with cpus_read_lock and cpuset_mutex
> +		 * held, but call housekeeping_update() without them. Only
> +		 * cpuset_top_mutex is still being held for mutual exclusion.
>   		 */
> +		old = housekeeping_publish(isolated_hk_cpus);
>   		mutex_unlock(&cpuset_mutex);
>   		cpus_read_unlock();
> -		WARN_ON_ONCE(housekeeping_update(isolated_hk_cpus));
> +		if (!WARN_ON_ONCE(IS_ERR(old)))
> +			housekeeping_update(isolated_hk_cpus, old);
>   		mutex_unlock(&cpuset_top_mutex);
>   	} else {
>   		cpuset_full_unlock();
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index 156025ef81b75..9e202269e42f6 100644
> --- a/kernel/sched/isolation.c
> +++ b/kernel/sched/isolation.c
> @@ -120,23 +120,26 @@ bool housekeeping_test_cpu(int cpu, enum hk_type type)
>   }
>   EXPORT_SYMBOL_GPL(housekeeping_test_cpu);
>   
> -int housekeeping_update(struct cpumask *isol_mask)
> +/* Called with cpus_read_lock and cpuset_mutex held */
> +struct cpumask *housekeeping_publish(struct cpumask *isol_mask)
>   {
>   	struct cpumask *trial, *old = NULL;
> -	int err;
> +
> +	lockdep_assert_cpus_held();
> +	lockdep_assert_cpuset_lock_held();
>   
>   	trial = kmalloc(cpumask_size(), GFP_KERNEL);
>   	if (!trial)
> -		return -ENOMEM;
> +		return ERR_PTR(-ENOMEM);
>   
>   	cpumask_andnot(trial, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT), isol_mask);
>   	if (!cpumask_intersects(trial, cpu_online_mask)) {
>   		kfree(trial);
> -		return -EINVAL;
> +		return ERR_PTR(-EINVAL);
>   	}
>   
>   	if (!housekeeping.flags)
> -		static_branch_enable(&housekeeping_overridden);
> +		static_branch_enable_cpuslocked(&housekeeping_overridden);
>   
>   	if (housekeeping.flags & HK_FLAG_DOMAIN)
>   		old = housekeeping_cpumask_dereference(HK_TYPE_DOMAIN);
> @@ -144,6 +147,14 @@ int housekeeping_update(struct cpumask *isol_mask)
>   		WRITE_ONCE(housekeeping.flags, housekeeping.flags | HK_FLAG_DOMAIN);
>   	rcu_assign_pointer(housekeeping.cpumasks[HK_TYPE_DOMAIN], trial);
>   
> +	return old;
> +}
> +
> +/* Called without cpus_read_lock and cpuset_mutex held */
> +void housekeeping_update(struct cpumask *isol_mask, struct cpumask *old)
> +{
> +	int err;
> +
>   	synchronize_rcu();
>   
>   	pci_probe_flush_workqueue();
> @@ -160,8 +171,6 @@ int housekeeping_update(struct cpumask *isol_mask)
>   	WARN_ON_ONCE(err < 0);
>   
>   	kfree(old);
> -
> -	return 0;
>   }
>   
>   void __init housekeeping_init(void)

Yes, that should work too.

Acked-by: Waiman Long <longman@redhat.com>

I will let other decide which one do they want.

Cheers,
Longman

