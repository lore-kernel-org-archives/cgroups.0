Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585554;
	b=ijWHWOQhJJGJbKC5O7ITTXS6jhx1NDGhAaDSWjN3vmdNnmX+vQJbLu5DSK9GIE/QBhrL
	 ovwnDV5pzFlSEiR5+toQ+C+Je2V6Zs9Sk7Ql9LctxFOlreR398d21dpdK+3BP5p4pu8AU
	 Lv4SZvciizbH5gnoRUXP9fvjZKMrKYvPke2sb2LkkC/RdlG2qve4IrS+zQuqgcZ2CTswD
	 MHfBep1mZiqOb8P8m9MTzcw7gqLtntU1H4eHgfJg0iYV8ToOweo49+wVJGM1jRB1gprgY
	 L8AoZZLZZG3O+8YMnmo8HrjSh19iV9lM6aiJjO/TmEze6tzT9TdTvEeMWM6thBEtQeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585554;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=v7OsVuI68toVGxoukGdn/ITq8yHt6b7No6mV5OpaB5c=;
	b=nRSz1SBYzXjbSw6WQZgDFnt/+q3aahSYa5vue9Vu3uTcb+sZD+33wyxDtrvcycoXvCu3
	 6SGkaDTkQ0HcjGomONMvxh+4chG2gU9LlqZ8T18tCpw6mhJ0xjM+zK66iGu0upxfC2fZ/
	 W3yGjZM+hIJYSunaGYepMNobmshut4p2Pl6Q7GHj9usFj3ISRFan2xWLLQetV5Jr8im6G
	 AnWHkquKQYacpkSoHEumAwh1yJuYdAyCkbWZvSR12JFK9PfNiT9/fqGQ1O0Pvpb2Xfo1x
	 FpzOnWRRuOf8ADHoZc+1HU/Ac2mYcQHZvWZO/0SEum+58TbMfxhEj3X6SwQTVSz9DYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="IQUKC/TD";
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C22260A260C
	for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 15:59:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C22260A260C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=IQUKC/TD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794585553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v7OsVuI68toVGxoukGdn/ITq8yHt6b7No6mV5OpaB5c=;
	b=IQUKC/TDwX0j1P1J466NJz3WjeZbrhbgn7/3fIw1b3/UMpEM4vsAESL+sZFbmz7ZjgvNse
	FpknmcNvpEAqZeiX1k8K0xqU8MC24C4RpPEa14nnzN0XvVzxz2rS+PuQMSwVzsMcJRJ7oO
	21AJrbH6hBoC+ISJsy3VD86x8DPi4Vs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-693-Ntv96ZN_OVapg2RQPilAHA-1; Fri,
 13 Nov 2026 10:59:08 -0500
X-MC-Unique: Ntv96ZN_OVapg2RQPilAHA-1
X-Mimecast-MFC-AGG-ID: Ntv96ZN_OVapg2RQPilAHA_1794585545
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 306AE1955F3E;
	Fri, 13 Nov 2026 15:59:04 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4DC441956040;
	Fri, 13 Nov 2026 15:58:58 +0000 (UTC)
Message-ID: <4cdb4452-f11f-4e56-b03a-6d751dcfb62b@redhat.com>
Date: Fri, 13 Nov 2026 10:58:57 -0500
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
Subject: Re: [PATCH v5 19/29] cgroup/cpuset: Wait for an attach before
 rebuilding the sched domains
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 juri.lelli@redhat.com, peterz@infradead.org, mingo@redhat.com,
 vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org, tglx@kernel.org, will@kernel.org,
 boqun@kernel.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, luca.abeni@santannapisa.it,
 mathieu.poirier@linaro.org, ridong.chen@linux.dev, tj@kernel.org,
 hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
 bigeasy@linutronix.de, clrkwllms@kernel.org, parri.andrea@gmail.com,
 m.szyprowski@samsung.com, kayracizmeci@gmail.com, weihengqiuu@gmail.com,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, stable@vger.kernel.org
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-20-mathieu.desnoyers@efficios.com>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20261108185406.1549770-20-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On 11/8/26 1:53 PM, Mathieu Desnoyers wrote:
> cpuset_can_attach() reserves the bandwidth of the deadline tasks it
> moves in the destination root domain. cpuset_attach() moves their
> bandwidth later, on the strength of that reservation.
>
> Commit 75f7a25ec6bb ("cgroup/cpuset: Prevent race between task attach
> and cpuset state change") lets cpuset_attach() rely on what
> cpuset_can_attach() set up. The writes of cpus, mems and cpus.partition
> wait for an attach in progress, in wait_attach_done_lock(). CPU hotplug
> cannot run in between either: it takes cpus_write_lock, and the attach
> holds cpus_read_lock throughout.
>
> But a rebuild of the sched domains does not wait. A write of
> sched_rt_runtime_us and the energy model rebuild them through
> rebuild_sched_domains(). The cgroup v1 writes of sched_load_balance and
> sched_relax_domain_level, and hk_sd_workfn(), use cpuset_full_lock().
>
> In this example, a rebuild drops the reservation. T is a deadline task
> asleep in root domain R. Thread A moves T to a partition root P, which
> has a root domain of its own. Thread B writes sched_rt_runtime_us:
>
>    A                                      B
>
>    cpuset_can_attach()
>      takes cpuset_mutex
>      cpuset_reserve_dl_bw()
>        P's total_bw += T's bandwidth
>      drops cpuset_mutex
>                                           rebuild_sched_domains()
>                                             takes cpuset_mutex
>                                             dl_rebuild_rd_accounting()
>                                               clears R's and P's total_bw
>                                               counts T in R (not moved yet)
>                                             drops cpuset_mutex
>    cpuset_attach()
>      takes cpuset_mutex
>      cpuset_attach_task(T)
>        set_cpus_allowed_dl(T)
>          R's total_bw -= T's bandwidth
>          records a CPU of P
>
> P now lacks the bandwidth of T, and admits deadline tasks beyond its
> capacity. When T leaves P, P's total_bw underflows. In testing, the
> race left a destination admitting 3 tasks of 10% too many, or P
> admitting no task at all.
>
> Fix this by waiting for an attach in progress in
> rebuild_sched_domains_cpuslocked() and in cpuset_full_lock(). The
> latter then takes its locks in the order of the writes of cpus and
> cpus.partition. A rebuild from CPU hotplug finds no attach in progress.
> The online, offline and kill of a cpuset never wait: they hold
> cgroup_mutex, which the attach holds throughout.
>
> The move_vs_rebuild case of deadline_bw_test, added later in this
> series, tests this race. Without this patch, it fails in 5 of 8 VMs with
> 8 CPUs. With it, the case passes in 8 of 8. The next patch needs this
> wait too: without it, it would give back a reservation that a rebuild
> dropped already.
>
> Found by the Sashiko AI reviews of v2 (the race) and v3 (the cgroup v1
> writes) of this series.
>
> Fixes: 2ef269ef1ac0 ("cgroup/cpuset: Free DL BW in case can_attach() fails")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---
>   kernel/cgroup/cpuset.c | 16 +++++++++++++---
>   1 file changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 194a438e25c3..51b6be460794 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -296,17 +296,20 @@ void lockdep_assert_cpuset_lock_held(void)
>   	lockdep_assert_held(&cpuset_mutex);
>   }
>   
> +static void wait_attach_done_lock(void) __acquires(&cpuset_mutex);
> +
>   /**
>    * cpuset_full_lock - Acquire full protection for cpuset modification
>    *
>    * Takes both CPU hotplug read lock (cpus_read_lock()) and cpuset mutex
> - * to safely modify cpuset data.
> + * to safely modify cpuset data. Waits for an attach in progress before
> + * it takes cpuset mutex.
>    */
>   void cpuset_full_lock(void)
>   {
>   	mutex_lock(&cpuset_top_mutex);
>   	cpus_read_lock();
> -	mutex_lock(&cpuset_mutex);
> +	wait_attach_done_lock();
>   }
>   
>   void cpuset_full_unlock(void)
> @@ -1005,7 +1008,14 @@ void rebuild_sched_domains_locked(void)
>   
>   static void rebuild_sched_domains_cpuslocked(void)
>   {
> -	mutex_lock(&cpuset_mutex);
> +	/*
> +	 * Wait for an attach in progress. cpuset_can_attach() has reserved
> +	 * the deadline bandwidth of the moving tasks in their new root
> +	 * domain, and cpuset_attach() moves it on the strength of that
> +	 * reservation. A rebuild of the accounting in between would drop
> +	 * the reservation.
> +	 */
> +	wait_attach_done_lock();
>   	rebuild_sched_domains_locked();
>   	mutex_unlock(&cpuset_mutex);
>   }

I agree that rebuild_sched_domains() should wait for an in-progress 
attach operation. The change to cpuset_full_lock(), however, is not 
really necessary. This cpuset_full_lock() is now mainly used for 
operations like cpuset_css_online() that are initiated from the cgroup 
side where cgroup_mutex should have been held. IOW, an attach operation 
which requires holding cgroup_mutex cannot happen in parallel. The only 
exception is hk_sd_workfn() which is a work item for updating the 
housekeeping cpumasks from hotplug which has no dependency on an attach 
operation.

Cheers,
Longman

