Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794162927;
	b=qSy6IKtq3kKdgj4AE5ZWX6sc0lLB5S5PEx0CNARskKGCqUiSpB2SYEkUvOO6jg7o7NNz
	 KMf4dDzdMlVGLMlcfPnBr2ZpiqckHJoW4R9rTC3t2UyvRd4YVb4NGxaAKxm8v7nO9Nf2/
	 PQNOFL+8FVSPbhpF9LcYpepBjtKw0WBmwRVdhkupdTRijTRopCr5NTpNZ1bFy9GhYXM0f
	 iCom8b1I794IGa+5Pg3aCmsHyEj2QmgOtlFNnwhCZBnvtd13lkun8vw620tivc5WJzFW1
	 fSK9AMx8Gbg8eoBYlqGnU8jiZJythoLHu0UL7F0xZYezkvtW9gqbLM/ovyJY385fHYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794162927;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Scanned-By;
	bh=/59c3QrulEqumgXbuURXyaJldWPpFkzwKYE+rDJq53w=;
	b=Wh56V19neVQT96x9rlxniTYk9EyzkmkX7wHH5asj9FvRlhO8qOY701L3JgwzECKUK+zB
	 gM3xwVHDA5mjWwYmyn8NfAnbNEl6s0ZUR0Y/dZ05Joeb1/o6DOmHBFAk7vR1LCLfE5XcJ
	 kSsRuCmH9eIOJOa9pBnYxkIoiA+0Nneid50VgV2WX2YJTZ4wB8K4ZgUU1JSOpc9jjx6ac
	 bZ5MZR/AfintKgcdj032ocmaVCXo2LS7Ab3c6p/h6i24gSTCDWfcWBXxp9iqT+eBqPRIE
	 /m1H6KoJ4phQrfZWB8dhMMsNjxGq/l+aYsRW8QWpv4FtQSc9shV8JyeKBkl2jQ14L3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=CxaJ8v1K;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164E9606A320
	for <cgroups@vger.kernel.org>; Sun,  8 Nov 2026 18:35:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 164E9606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=CxaJ8v1K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794162926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/59c3QrulEqumgXbuURXyaJldWPpFkzwKYE+rDJq53w=;
	b=CxaJ8v1KdojPDZqOGkCwqbfZVLIFSPrEaE/SPyG1Pc1eeipvCPz/SJqvreUg446AcDsitD
	4d0ofpUoit2t1TIW9Kn3OO6KAUZpb04T2xk23MlOq2rdo+jMs80s40sIRK8MH+s/nUqHMg
	csWHXDK/l5xT+xXUaL3K28nfDoyKzro=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-120-Yfe4vYd0NUal8zs2sVuJ3w-1; Sun,
 08 Nov 2026 13:35:22 -0500
X-MC-Unique: Yfe4vYd0NUal8zs2sVuJ3w-1
X-Mimecast-MFC-AGG-ID: Yfe4vYd0NUal8zs2sVuJ3w_1794162920
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 41FED19560B4;
	Sun,  8 Nov 2026 18:35:20 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0CE1E1956089;
	Sun,  8 Nov 2026 18:35:17 +0000 (UTC)
Message-ID: <12cb0bee-57aa-4609-bc2e-77806e0b6805@redhat.com>
Date: Sun, 8 Nov 2026 13:35:17 -0500
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
Subject: Re: [BUG] cpuset: empty sched domain with isolcpus=domain, panic at
 CPU offline
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Chen Yu <yu.c.chen@intel.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Ridong Chen <ridong.chen@linux.dev>, Tim Chen <tim.c.chen@linux.intel.com>,
 Valentin Schneider <vschneid@redhat.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261108145744.1532128-1-mathieu.desnoyers@efficios.com>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20261108145744.1532128-1-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On 11/8/26 9:57 AM, Mathieu Desnoyers wrote:
> Hi,
>
> With isolcpus=domain, cpuset partitions can take all the housekeeping
> CPUs. The top cpuset then gets an empty sched domain. In a VM, this
> gave a WARNING in build_sched_domains(), then a panic at the next CPU
> offline. I hit it once, while testing a SCHED_DEADLINE series [1]. The
> analysis below is from reading the code after that panic. A proposed
> fix follows the scissors line.
>
> The code involved is the same in v7.4-rc1 and in tip sched/urgent
> (006991aa8997). The series does not change it.
>
> Trigger
> =======
>
> Boot 5 CPUs with isolcpus=domain,0,1. Then, with cgroup v2:
>
>    cd /sys/fs/cgroup
>    echo +cpuset > cgroup.subtree_control
>    mkdir P Q
>    echo 4 > P/cpuset.cpus
>    echo root > P/cpuset.cpus.partition
>    echo 2-3 > Q/cpuset.cpus
>    echo root > Q/cpuset.cpus.partition          # WARNING
>    echo 0 > /sys/devices/system/cpu/cpu2/online  # panic
>
> The test that hit it made these writes. It also ran a deadline task in
> Q, which the analysis does not need. After the writes, the top cpuset
> keeps only CPUs 0 and 1, which are isolated.
>
> Log
> ===
>
>    WARNING: kernel/sched/topology.c:3111 at build_sched_domains+0x1321/0x1830, CPU#0: orig/91
>    CPU: 0 UID: 0 PID: 91 Comm: orig Not tainted 7.4.0-rc1-00300-gc36e8c1d51c9 #98 PREEMPT(lazy)
>    Call Trace:
>     partition_sched_domains+0x331/0x990
>     cpuset_update_sd_hk_unlock+0x76/0x80
>     cpuset_partition_write+0x9e/0xe0
>     kernfs_fop_write_iter+0x14d/0x210
>     vfs_write+0x252/0x550
>     ksys_write+0x6c/0xe0
>     do_syscall_64+0x109/0x5d0
>    [...]
>    BUG: unable to handle page fault for address: 0000000083cf6513
>    #PF: supervisor read access in kernel mode
>    #PF: error_code(0x0000) - not-present page
>    Oops: Oops: 0000 [#1] SMP NOPTI
>    CPU: 2 UID: 0 PID: 26 Comm: cpuhp/2 Tainted: G        W           7.4.0-rc1-00300-gc36e8c1d51c9 #98 PREEMPT(lazy)
>    RIP: 0010:partition_sched_domains+0x5ee/0x990
>    RAX: 0000000083cf58c3 RBX: 0000000000000003 RCX: ff11000004f60b58
>    R10: 0000000000000200 R11: 0000000000000004 R12: 0000000000000040
>    Call Trace:
>     cpuset_update_active_cpus+0x512/0xb00
>     sched_cpu_deactivate+0x1f3/0x300
>     cpuhp_invoke_callback+0x1b4/0x780
>     cpuhp_thread_fun+0x183/0x260
>     smpboot_thread_fn+0x143/0x300
>     kthread+0xfe/0x130
>     ret_from_fork+0x22a/0x330
>    Kernel panic - not syncing: Fatal exception
>
> Analysis
> ========
>
> The top cpuset may hold CPUs isolated at boot. generate_sched_domains()
> keeps a partition root if its effective_cpus is not empty. For the top
> cpuset, it then builds the domain from effective_cpus without these
> CPUs:
>
> 	if ((cp->partition_root_state == PRS_ROOT) &&
> 	    !cpumask_empty(cp->effective_cpus))
> 		csa[ndoms++] = cp;
> 	[...]
> 	if (!csa || csa[i] == &top_cpuset)
> 		cpumask_and(doms[i], top_cpuset.effective_cpus,
> 			    housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
>
> Here effective_cpus is 0-1, so the domain is empty.
> build_sched_domains() warns and builds nothing. But
> partition_sched_domains_locked() still records the empty mask in
> doms_cur.

This is a known problem and we are working to address this in the cpuset 
code to make sure that there is at least one online domain housekeeping 
CPUs for the top_cpuset.

>
> At the CPU offline, cpuset passes the empty domain again. It matches
> the empty one in doms_cur. The reuse branch then reads the runqueue of
> the first CPU of the mask:
>
> 	int cpu = cpumask_first(doms_cur[j]);
>
> 	guard(rcu)();
> 	sd = rcu_dereference(cpu_rq(cpu)->sd);
>
> On an empty mask, cpumask_first() returns NR_CPUS when NR_CPUS is at
> most BITS_PER_LONG. This kernel has NR_CPUS=64. R12 = 0x40 is that
> index into __per_cpu_offset[], one entry past its end. The load of
> rq->sd then faults.
>
> The partition checks do not refuse Q. tasks_nocpu_error() tests the
> effective_cpus of the top cpuset, which still holds CPUs 0 and 1.
> prstate_housekeeping_conflict() keeps boot time isolated CPUs out of
> root partitions. Nothing asks the top cpuset to keep a housekeeping
> CPU.
>
> Versions:
> - The empty domain comes from 9b496a8bbed9 ("cgroup/cpuset: Prevent
>    leakage of isolated CPUs into sched domains"), in v6.13.
> - The reuse branch comes from a7660ce1590f ("sched/cache: Fix
>    has_multi_llcs iff at least one partition has multiple LLCs"), in
>    v7.2.
>
>  From v6.13 to v7.1, a similar read would happen elsewhere. This is from
> reading only:
> - detach_destroy_domains() reads per_cpu() of cpumask_any() of the
>    mask, when the empty domain goes away.
> - With CONFIG_ENERGY_MODEL, build_perf_domains() reads
>    cpu_rq(cpumask_first()) of the mask at its first build.
>
> Where to fix
> ============
>
> Commit cd1cb3350561 ("sched/topology: Don't try to build empty sched
> domains") fixed a crash of this kind in 2019. It made
> generate_sched_domains() skip empty masks. Its changelog says that the
> scheduler should not have to check cpumask_first() against nr_cpu_ids.
> So the patch below fixes cpuset. It keeps a partition root only if its
> effective_cpus holds a housekeeping CPU.
>
> Two questions:
> - Should cpuset refuse a partition that leaves the top cpuset without
>    a housekeeping CPU? The patch keeps the current behaviour. The
>    partition is valid. The tasks of the top cpuset run on the isolated
>    CPUs.

Yes, we are going to add the check to make sure that there will be at 
least one housekeeping CPU left for the top_cpuset sched domain.

See 
https://lore.kernel.org/lkml/20261105130344.664336-1-guopeng.zhang@linux.dev/

> - Should the scheduler also skip empty masks? The reuse branch, the
>    perf domain code and detach_destroy_domains() all take a CPU from
>    the mask.
>
> Testing1
> =======
>
> With the patch on tip sched/urgent (006991aa8997), in a VM with
> 5 CPUs:
> - isolcpus=domain,0,1 and the sequence above. There is no WARNING.
>    All CPU offlines and onlines complete. Q gets the domain 2-3, and the
>    top cpuset gets none. The top cpuset gets the domain 2-3 back when Q
>    becomes a member again.
> - The same boot, with P as an isolated partition. Q is a root
>    partition first, then isolated too. With both isolated, no partition
>    root has a housekeeping CPU. The scheduler then gets no domain, and
>    CPU hotplug works. Making Q isolated also warns in
>    cpuset_update_sd_hk_unlock(). That is a separate problem, which I
>    report separately. The patch does not touch that path.
> - No isolcpus, and the same sequence. There is no WARNING. The top
>    cpuset keeps its domain 0-1.
>
> test_cpuset_prs.sh passes on 9 CPUs. It also passes on 10 CPUs with
> isolcpus=domain,9. I did not run the crash sequence again on a kernel
> without the fix.
>
> The analysis and the patch were written by an LLM coding assistant
> under my direction and review.
>
> Thanks,
>
> Mathieu
>
> [1] https://lore.kernel.org/all/20261107014451.1487825-1-mathieu.desnoyers@efficios.com/
>
> -- >8 --
> From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Subject: cgroup/cpuset: Do not build an empty sched domain for the top cpuset
>
> The scheduler expects each sched domain from cpuset to hold at least
> one CPU. Commit cd1cb3350561 ("sched/topology: Don't try to build empty
> sched domains") made generate_sched_domains() skip a cpuset with an
> empty effective_cpus. It also made build_sched_domains() warn on an
> empty mask.
>
> The top cpuset may hold CPUs isolated at boot. Commit 9b496a8bbed9
> ("cgroup/cpuset: Prevent leakage of isolated CPUs into sched domains")
> removes them from its sched domain. The check for an empty domain was
> not updated. It still tests effective_cpus, which includes the isolated
> CPUs.
>
> So partitions that take all the housekeeping CPUs leave the top cpuset
> with an empty domain. For example, boot 5 CPUs with isolcpus=domain,0,1.
> Then make CPUs 2-3 and 4 root partitions. build_sched_domains() warns.
> The scheduler still records the empty mask as a current domain. At the
> next rebuild, the new empty domain matches it.
> partition_sched_domains_locked() then calls cpu_rq() on cpumask_first()
> of the empty mask, which is not a valid CPU. In a VM, the next CPU
> offline panicked there.
>
> Fix this by keeping a partition root only if its effective_cpus holds a
> housekeeping CPU. This tests the mask that the top cpuset gets.
> prstate_housekeeping_conflict() keeps boot time isolated CPUs out of
> the other partition roots. So nothing changes for them.
>
> This change was developed with assistance from an LLM.
>
> Fixes: 9b496a8bbed9 ("cgroup/cpuset: Prevent leakage of isolated CPUs into sched domains")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---
>   kernel/cgroup/cpuset.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 3219f927c35e..426c98cf4a08 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -894,10 +894,13 @@ static int generate_sched_domains(cpumask_var_t **domains,
>   	cpuset_for_each_descendant_pre(cp, pos_css, &top_cpuset) {
>   		/*
>   		 * Only valid partition roots that are not isolated and with
> -		 * non-empty effective_cpus will be saved into csa[].
> +		 * housekeeping CPUs in effective_cpus will be saved into csa[].
> +		 * The top cpuset may keep only boot time isolated CPUs. It then
> +		 * gets no sched domain.
>   		 */
>   		if ((cp->partition_root_state == PRS_ROOT) &&
> -		    !cpumask_empty(cp->effective_cpus))
> +		    cpumask_intersects(cp->effective_cpus,
> +				       housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)))
>   			csa[ndoms++] = cp;
>   
>   		/*

This patch is correct AFAICS. I am not against it but it may not be 
necessary after we make sure that there is at least one HK online CPU in 
the top sched domain.

Cheers,
Longman

