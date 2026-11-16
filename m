Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.57
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794825214;
	b=vlzZwR6LoN/dbt3PF6nfkVMtDdYpYtSz2OLxNoBNRQuXNHAKDEVjG9xjmIWEye6QAs4v
	 uLWA0+Gi6eNraG4TD0VMmIbZLHUZKkJbXt4F6HIISLF3KtVNKPhCIoLaWTzB3tqC8F/a3
	 pOCkv1935piV/19ewmFRUyH2FFI8hnk1G/g+UeSvxHTg1VWOJ27Yh6f9UvXg/8h0dCd+N
	 Pmqtw3DPjgrksnAjvmwDYGtaWK8aj72auKlhB/dSAU66hGeTbECgSTIQ/1Lo8XOsQtHEX
	 4sH4HApL/hw2nJJu9eE+dMCmU4chPnajN7xQUoVJc80AYDED/PJNofOkRSoFrSyg7ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794825214;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=4xP1wCT3CiCMUHIs8oS3HTOWW4Ga4YMLeo5r3EiUl/I=;
	b=NmPGDlsJZILlesXTQZjytLu8ZYVv0qLZz037rVcssTQmIQaT5e2WksVeTTOKQyVzBb6g
	 8MNGOnoP3ROkBL4zLt1dhR+uxLXrvVEWsh+yubRA+SfTKnB2FC48RPRR7bHiIpFiNZGNb
	 DxdHA/MWOCCBMgcn1aoH7c87aVTlTAMs62nKk1EOrgsy4Ek10NRVgElb7QgF6WUEBZonI
	 ts7LGLk7LzKa6E6obQPRdlYyCQ6moQ61XISNQ3ty8b8kM/F/1RVQEHhYSxehoDshLAg+r
	 0bZVnzukHCT5So0daLjT4nZqx1+VLtPdBThpHddq3rKUCblgO0/rDr/tK6e/SVV6VZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hVxrfMMr;
	arc=none smtp.remote-ip=91.218.175.57
Received: from mta0.migadu.com (out-57.mta0.migadu.com [91.218.175.57])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249C2606A323
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 10:33:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 249C2606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hVxrfMMr
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=6WEEXQpnySfT6ftjryWS5P4mMchJTeCrPm9lJA9qPkM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794825211; v=1; x=1795430011;
 b=hVxrfMMrAA2fdPYjZDrbeMt/pMa4Csur7WEHK1+eZVs7amumk30TilCZ89AXrKJ9oDFRBx5h
 qFFsezuLQJv8IEYZH0+D83ICDn+h2J+zqfWvlFVtas6uOGuDPp7BaN2AIP5CqcZgC86HVHAxKfB
 oPuR2Bt2/M+hucRT9fxhio4g=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d3af8dde2262cb53;
	Mon, 16 Nov 2026 10:33:30 +0000
X-Mizu-Trace-ID: d3af8dde2262cb53
X-Migadu-Flow: FLOW_OUT
Message-ID: <70eb1395-ebcf-4ece-ac03-f0796cd02c81@linux.dev>
Date: Mon, 16 Nov 2026 18:33:25 +0800
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
Subject: Re: [PATCH-next v4 5/6] cgroup/cpuset: Handle remote partitions
 before local partitions in cpuset_handle_hotplug()
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
References: <20261116012330.2271010-1-longman@redhat.com>
 <20261116012330.2271010-6-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261116012330.2271010-6-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/11/16 09:23, Waiman Long 写道:
> When there is a valid remote partition underneath an invalid local
> partition with subpartitions_cpus cleared because of missing active
> CPUs in the top_cpuset partition, the current iteration logic in
> cpuset_handle_hotplug() will handle the invalid local partition first
> and potentially make the local partition valid. The remote partition
> will be handled later with the potential that both the local and remote
> partitions will be valid with overlapping exclusive CPUs violating the
> cpu exclusivity rule.
> 
> Fix this problem by adding a new remote_partition_scan() helper to
> iterate the existing remote partitions first before iterating down
> the hierarchy to handle the local partitions. That also means that
> when subpartitions_cpus is cleared, remote partitions have precedence
> to acquire the exclusive CPUs first before local partitions. It also
> gives remote partition the ability to recover from the clearing of
> subpartitions_cpus as all the remote partitions will be disabled before
> this commit.
> 
> A remote partition can only be created if there is at least one active
> CPU in its effective_xcpus. So remote_partition_scan() will also
> invalidate the remote partition if there is no active CPU left in its
> effective_xcpus. This requires a minor change in a test_cpuset_prs.sh
> test case where a remote partition with no active CPU left will now
> be invalidated.
> 
> With the addition of the remote_partition_scan() call in
> cpuset_handle_hotplug(), there is no longer a need to do a remote
> partition check in cpuset_hotplug_update_tasks() and the corresponding
> code can be removed.
> 
> While at it, the subpartition_cpus clearing logic is enhanced to
> clear it when no domain housekeeping CPUs are left in the top_cpuset
> partition. When the remote partition is disabled, the effective_cpus
> is modified in a such a way that cpus_updated will be set true later
> in cpuset_hotplug_update_tasks() so that the CPU affinity of the
> tasks within the partition will be updated. This will also fix a
> bug reported by sashiko that CPU affinity will not be updated when
> remote_partition_disable() is called in such circumstance.
> 
> When efffective_cpus is read during this interim period, the content
> will be invalid before and after this commit.
> 
> Fixes: 181c8e091aae ("cgroup/cpuset: Introduce remote partition")
> Reported-by: Guopeng Zhang <guopeng.zhang@linux.dev>
> Link: https://lore.kernel.org/lkml/fe7aa630-d323-4981-9f89-0958cb6204a2@linux.dev
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/bug/linux-ab90f7e8-0d60-40ca-83e9-e405075b24d2
> Signed-off-by: Waiman Long <longman@redhat.com>

Hi，Longman

Tested all six patches on next-20261113 (32-CPU VM, cgroup v2, no boot
isolation, all CPUs initially online). I can still reproduce an invalid
local partition becoming valid while its remote descendant remains
valid:

  cd /sys/fs/cgroup
  echo +cpuset > cgroup.subtree_control
  echo 0 > /sys/devices/system/cpu/cpu31/online
  mkdir A
  echo 0-30 > A/cpuset.cpus
  echo 0-30 > A/cpuset.cpus.exclusive
  echo root > A/cpuset.cpus.partition          # invalid local root
  echo +cpuset > A/cgroup.subtree_control
  mkdir A/B
  echo 20-25 > A/B/cpuset.cpus
  echo 20-25 > A/B/cpuset.cpus.exclusive
  echo root > A/B/cpuset.cpus.partition        # valid remote partition
  echo 1 > /sys/devices/system/cpu/cpu31/online

After CPU31 comes online, A is a valid root (exclusive.effective 0-30),
A/B is still a valid remote (exclusive.effective 20-25), and the top
cpuset's effective CPUs are 31. The kernel reports:

  WARNING: cpuset.c:1654 compute_partition_effective_cpumask()
           WARN_ON_ONCE(is_remote_partition(child))

Two more results:
1. Local partitions break too, no remote involved.  test_cpuset_prs.sh
   fails at TEST_MATRIX[19] (C0-3:P1 C2-3:P1 + O2=0): with cpu2
   offlined, both partitions become "root invalid" instead of remaining
   valid. A1's effective_cpus then falls back to 0-1,3 instead of 0-1.
2. Booted with isolcpus=31, the same kernel passes the whole suite.

Thanks，
Guopeng> ---
>  kernel/cgroup/cpuset.c                        | 97 ++++++++++++++++---
>  .../selftests/cgroup/test_cpuset_prs.sh       |  2 +-
>  2 files changed, 84 insertions(+), 15 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 0fe9f2731fee..64cbcbdbf6da 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -153,6 +153,12 @@ static cpumask_var_t	isolated_cpus;		/* CSCB */
>   */
>  static struct list_head remote_children;	/* RWCS */
>  
> +/*
> + * Temporary cpumask for local cpumask computation
> + * The cpumask may be changed when a cpuset helper is being called.
> + */
> +static cpumask_var_t	tmp_cpus;		/* RWCS */
> +
>  /*
>   * Set if housekeeping cpumasks are to be updated.
>   */
> @@ -1873,6 +1879,67 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
>  	remote_partition_disable(cs, tmp);
>  }
>  
> +/**
> + * remote_partition_scan: scan remote partitions to check exclusive CPUs
> + * @tmpmask: ptr to tmpmasks structure
> + *
> + * This function is called in cpuset_handle_hotplug() after the update on
> + * top_cpuset.effective_cpus when there is cpu online/offline operation.
> + * As subpartitions_cpus may have been cleared, we need to check if the remote
> + * partition should acquire the exclusive CPUs again without impacting
> + * effective_cpus or it needs to be disabled when one or more of the following
> + * conditions is true.
> + * 1) All the domain housekeeping CPUs in the top_cpuset will be taken away
> + * 2) A populated partition with no active CPU or no active CPU in
> + *    effective_xcpus
> + */
> +static void remote_partition_scan(struct tmpmasks *tmp)
> +{
> +	struct cpuset *cs, *next;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_safe(cs, next, &remote_children, remote_sibling) {
> +		bool noxcpus = !cpumask_subset(cs->effective_xcpus, subpartitions_cpus);
> +		bool nocpus = !cpumask_intersects(cs->effective_xcpus, cpu_active_mask) ||
> +			      (!cpumask_intersects(cs->effective_cpus, cpu_active_mask) &&
> +			       partition_is_populated(cs, NULL));
> +		int cpu;
> +
> +		cpumask_and(tmp_cpus, top_cpuset.effective_cpus,
> +			    housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
> +		if (noxcpus && !nocpus && !cpumask_subset(tmp_cpus, cs->effective_xcpus)) {
> +			/*
> +			 * Reacquire exclusive CPUs & update top_cpuset.effective_cpus
> +			 */
> +			spin_lock_irq(&callback_lock);
> +			cpumask_andnot(subpartitions_cpus, subpartitions_cpus,
> +				       cs->effective_xcpus);
> +			cpumask_andnot(top_cpuset.effective_cpus, top_cpuset.effective_xcpus,
> +				       cs->effective_xcpus);
> +			spin_unlock_irq(&callback_lock);
> +			continue;
> +		}
> +
> +		if (noxcpus || nocpus || cpumask_empty(tmp_cpus)) {
> +			/*
> +			 * Disable remote partition & modifiy effective_cpus
> +			 * so that cpus_updated will be set true in
> +			 * cpuset_hotplug_update_tasks().
> +			 */
> +			WRITE_ONCE(cs->prs_err, PERR_HOTPLUG);
> +			remote_partition_disable(cs, tmp);
> +			cpu = cpumask_first(cs->effective_cpus);
> +			spin_lock_irq(&callback_lock);
> +			if (cpu < nr_cpu_ids)
> +				cpumask_clear_cpu(cpu, cs->effective_cpus);
> +			else
> +				cpumask_set_cpu(0, cs->effective_cpus);
> +			spin_unlock_irq(&callback_lock);
> +		}
> +	}
> +	rcu_read_unlock();
> +}
> +
>  /**
>   * update_parent_effective_cpumask - update effective_cpus mask of parent cpuset
>   * @cs:      The cpuset that requests change in partition root state
> @@ -3919,6 +3986,7 @@ int __init cpuset_init(void)
>  	BUG_ON(!zalloc_cpumask_var(&subpartitions_cpus, GFP_KERNEL));
>  	BUG_ON(!zalloc_cpumask_var(&isolated_cpus, GFP_KERNEL));
>  	BUG_ON(!zalloc_cpumask_var(&isolated_hk_cpus, GFP_KERNEL));
> +	BUG_ON(!alloc_cpumask_var(&tmp_cpus, GFP_KERNEL));
>  
>  	cpumask_setall(top_cpuset.cpus_allowed);
>  	nodes_setall(top_cpuset.mems_allowed);
> @@ -3993,14 +4061,6 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>  	if (!tmp || !cs->partition_root_state)
>  		goto update_tasks;
>  
> -	if (is_remote_partition(cs) &&
> -	    (!cpumask_subset(cs->effective_xcpus, subpartitions_cpus) ||
> -	     (cpumask_empty(&new_cpus) && partition_is_populated(cs, NULL)))) {
> -		WRITE_ONCE(cs->prs_err, PERR_HOTPLUG);
> -		remote_partition_disable(cs, tmp);
> -		compute_effective_cpumask(&new_cpus, cs, parent);
> -	}
> -
>  	/*
>  	 * Force the partition to become invalid if either one of
>  	 * the following conditions hold:
> @@ -4104,22 +4164,31 @@ static void cpuset_handle_hotplug(void)
>  		if (!on_dfl)
>  			cpumask_copy(top_cpuset.cpus_allowed, &new_cpus);
>  		/*
> -		 * Make sure that CPUs allocated to child partitions
> -		 * do not show up in effective_cpus. If no CPU is left,
> -		 * we clear the subpartitions_cpus & let the child partitions
> -		 * fight for the CPUs again.
> +		 * Make sure that CPUs allocated to child partitions do not
> +		 * show up in effective_cpus. If no housekeeping CPU is left,
> +		 * we clear the subpartitions_cpus, scan the remote partitions
> +		 * to determine if they can remain valid & let the descendant
> +		 * local partitions fight for the CPUs again.
>  		 */
>  		if (!cpumask_empty(subpartitions_cpus)) {
> +			cpumask_andnot(&new_cpus, cpu_active_mask,
> +				       housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
>  			if (cpumask_subset(&new_cpus, subpartitions_cpus)) {
>  				cpumask_clear(subpartitions_cpus);
> +				cpumask_copy(&new_cpus, cpu_active_mask);
>  			} else {
> -				cpumask_andnot(&new_cpus, &new_cpus,
> +				cpumask_andnot(&new_cpus, cpu_active_mask,
>  					       subpartitions_cpus);
>  			}
>  		}
>  		cpumask_copy(top_cpuset.effective_cpus, &new_cpus);
>  		spin_unlock_irq(&callback_lock);
> -		/* we don't mess with cpumasks of tasks in top_cpuset */
> +		/*
> +		 * We don't mess with cpumasks of tasks in top_cpuset, but we
> +		 * have to examine impact on remote partition roots if present.
> +		 */
> +		if (cpuset_v2() && ptmp)
> +			remote_partition_scan(ptmp);
>  	}
>  
>  	/* synchronize mems_allowed to N_MEMORY */
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index 81f0eecaca80..5c7b583cba18 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -378,7 +378,7 @@ TEST_MATRIX=(
>  	# Remote partition offline tests
>  	"   C0-3    C1-3  C2-3     .    X2-3   X2-3 X2-3:P2:O2=0 .   0 A1:0-1|A2:1|A3:3 A1:P0|A3:P2 2-3"
>  	"   C0-3    C1-3  C2-3     .    X2-3   X2-3 X2-3:P2:O2=0 O2=1 0 A1:0-1|A2:1|A3:2-3 A1:P0|A3:P2 2-3"
> -	"   C0-3    C1-3   C3      .    X2-3   X2-3    P2:O3=0   .   0 A1:0-2|A2:1-2|A3: A1:P0|A3:P2 3"
> +	"   C0-3    C1-3   C3      .    X2-3   X2-3    P2:O3=0   .   0 A1:0-2|A2:1-2|A3:1-2 A1:P0|A3:P-2 3|"
>  	"   C0-3    C1-3   C3      .    X2-3   X2-3   T:P2:O3=0  .   0 A1:0-2|A2:1-2|A3:1-2 A1:P0|A3:P-2 3|"
>  
>  	# An invalidated remote partition cannot self-recover from hotplug

