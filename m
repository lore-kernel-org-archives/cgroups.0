Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.218
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795594283;
	b=jq8ilwH/YK+nLxQKG4HhHrWRWIbXZGM6EXr3UVPmhrgYI4eltGMCNs78X3n72SO5tjBI
	 XNvPCQosnxuquFIWxnDc2NDKTSVIIItjDTD7CmvxfG1RLWEaiBl4236sWtLCHmT1pI4j5
	 BuxyWzzb99w+D2zD1dIaAcn1wUUzQvMTkTz16NFq6gBGs1whcoLtt/Drkh4a+nJa1zacd
	 TtTrQgVHEctklKz8t9DmdxPyt/BryI+tmhxiN1nR53beLXpNfHB2RhNbjEEDtfEGEjxJE
	 re46tgs8NL0D370rNt/bqtiECYBkYuKSWMbvH/Q95UQSFq+yImHfsBXsM+Oc8s3ABBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795594283;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=2giyVH86fiD0iX5yZJuW6a/h1ndm6zT9fM4WKgXkwXM=;
	b=5sHZHdcLhxdoJq10v06bKNWEPTN2CNjNOJXIzDiV9oX2nBeARtvfFJR0GTKDY6BfNywx
	 NIa1SbMLJYSB80GxIiTrFM21+0n3t+lzMjQD+DA8KQRVnWOnSGTrZ2TBL3TqHaV/cYh5u
	 UzEZMho+Sro9H7AXIsyyXtHJQFwRa/S9iSQ02YcZNDCcU/8lgwQATNrvh24X5U/xHVdoa
	 +Q26gtPIuvDNSxUtAT1zR+0gTouXiplZbgJLqW6dswzUJ99fnuFKRLps/EcCScXgp81SB
	 cbrxon+VlqVB4ScToyQT9xnmYR/cTT/YAUH0YtJaanwF5u8K5sLAy7JZwE1fhyOF0iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=dQPpRoOs;
	arc=none smtp.remote-ip=95.215.58.218
Received: from mta1.migadu.com (out-218.mta1.migadu.com [95.215.58.218])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCDF606A31E
	for <cgroups@vger.kernel.org>; Wed, 25 Nov 2026 08:11:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4BCDF606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=dQPpRoOs
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=XIDuvbDmASzXTaeTkwCkboNpVob5bHBGaZ8fqBcxs1A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795594280; v=1; x=1796199080;
 b=dQPpRoOsndcFOWCRMeREL5tZjUzaZ8N51udrgxJmMiP7z60H81w/fhc/8gC1Mu+EQHWvFtBF
 xKOTcC2qrohXsA8LNpT5NG7wWOAQbMRkz9LZU6AokVeQf239sXIWjeepsF+wE/05o5CcKMWa9kU
 R/zM864Eh3imnGAnQGCzFV4o=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8f26a41e6856e0d2;
	Wed, 25 Nov 2026 08:11:20 +0000
X-Mizu-Trace-ID: 8f26a41e6856e0d2
X-Migadu-Flow: FLOW_OUT
Message-ID: <5ace7a93-b12e-4f15-a857-eff02ec8cb40@linux.dev>
Date: Wed, 25 Nov 2026 16:11:13 +0800
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
Subject: Re: [PATCH v5 00/12] cpuset: rework local partition logic
To: Waiman Long <longman@redhat.com>
Cc: Guopeng Zhang <zhangguopeng@kylinos.cn>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
References: <20261114083124.1340140-1-ridong.chen@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261114083124.1340140-1-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/14/2026 4:31 PM, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> This is v5 of the cpuset local partition rework [1], which I started
> while at Huawei and am now continuing at Xiaomi. Since v4, the fixes and
> preparatory changes at the start of the series have been posted
> separately, last as [2], and merged into cgroup/for-7.4-fixes. This
> version is based on it and only has the part that consolidates the
> partition state changes into common helpers, the remaining parts will
> follow.
> 
> The partition state of a cpuset is currently changed in many places, and
> local and remote partitions are handled by different code.
> update_parent_effective_cpumask() alone handles five partcmd_* commands
> for local partitions, while the remote partition helpers open code the
> same updates of partition_root_state, prs_err, effective_xcpus,
> subpartitions_cpus and isolated_cpus.
> 
> The idea is to have one set of common helpers to enable, disable and
> update a partition. Local and remote partitions only do their own
> validation and then call these helpers, and all partition related
> state is set or changed only inside them. After this series:
> 
>       update_prstate()        update_cpumask()
>       update_cpumasks_hier()  cpuset_hotplug_update_tasks()
>                            |
>            +---------------+---------------+
>            |                               |
>            v                               v
>    +-------------------+         +--------------------+
>    |  local partition  |         |  remote partition  |
>    |                   |         |                    |
>    | validate_local_   |         | remote_partition_  |
>    |     partition()   |         |     enable()       |
>    | local_partition_  |         | remote_cpus_       |
>    |     enable()      |         |     update()       |
>    |     update()      |         |                    |
>    +-------------------+         +--------------------+
>            |                               |
>            +---------------+---------------+
>                            |
>                            v
>    +------------------------------------------------+
>    |  partition_enable()                            |
>    |  partition_disable()                           |
>    |  partition_update()                            |
>    +------------------------------------------------+
>                            |
>                            |  partition state, only changed here
>                            v
>    +------------------------------------------------+
>    |  cpuset:  partition_root_state, prs_err,       |
>    |           remote_partition, effective_xcpus,   |
>    |           exclusive_cpus                       |
>    |  global:  subpartitions_cpus, isolated_cpus    |
>    +------------------------------------------------+
> 
>    partition_enable()  - make a cpuset a valid partition root, or switch
>                          a valid partition between root and isolated
>    partition_disable() - make a partition a member or invalid, give its
>                          CPUs back to the parent and propagate the change
>    partition_update()  - update the exclusive CPUs of a valid partition
> 
> A partition is disabled with partition_disable() directly, for both
> local and remote partitions, as giving the CPUs back to the parent needs
> no partition specific handling.
> 
> With this, every caller follows the same pattern (validate, then
> enable/disable/update), and it is much easier to see where and why a
> partition state changes.
> 
> Patches 1-3 introduce the common helpers and patches 4-6 use them for
> remote partitions. Patches 7-11 add validate_local_partition(),
> local_partition_enable() and local_partition_update() and convert the
> local partition paths, including the hotplug path, to them. Patch 12
> removes update_parent_effective_cpumask() and the partition_cmd enum.
> 
> The series is meant to be functionally equivalent, except that the
> failure reason of an invalid partition is kept more accurately. For
> example, PERR_CPUSEMPTY of a partition with empty cpuset.cpus and
> cpuset.cpus.exclusive is no longer overwritten by PERR_INVCPUS when its
> parent changes.
> 
> The remaining parts of the rework, e.g. validate_remote_partition(),
> removing the partition field updates left outside the helpers and
> simplifying update_prstate(), will be posted as a follow-up series.
> 
> test_cpuset_prs.sh passes with this series applied, with no boot option,
> with isolcpus=10-11 and with nohz_full=8-11. Patches 10-12, which change
> the hotplug path in between, are also tested individually.
> 
> Changes in v5:
>    - Drop the RFC tag and rebase onto cgroup/for-7.4-fixes, which has
>      patches 1-3 of v4 merged [2]. Only post patches 4-14 of v4.
>    - Call partition_disable() directly, instead of local_ and
>      remote_partition_disable().
>    - Add validate_local_partition() in a separate patch.
>    - Keep PERR_CPUSEMPTY for empty cpumasks (Sashiko).
>    - Add __maybe_unused to unused helpers (Guopeng).
>    - Link to v4: https://lore.kernel.org/all/20261101114206.2434398-1-ridong.chen@linux.dev/
> 
> [1] https://lore.kernel.org/all/20261101114206.2434398-1-ridong.chen@linux.dev/
> [2] https://lore.kernel.org/all/20261112031931.2815548-1-ridong.chen@linux.dev/
> 
> Ridong Chen (12):
>    cpuset: introduce partition_enable()
>    cpuset: introduce partition_disable()
>    cpuset: introduce partition_update()
>    cpuset: use partition_enable() for remote partition enablement
>    cpuset: use partition_disable() for remote partition disablement
>    cpuset: use partition_update() for remote partition update
>    cpuset: introduce validate_local_partition()
>    cpuset: introduce local_partition_enable()
>    cpuset: use partition_disable() for local partition disablement
>    cpuset: use partition_disable() to invalidate local partition
>    cpuset: introduce local_partition_update()
>    cpuset: remove update_parent_effective_cpumask
> 
>   kernel/cgroup/cpuset.c | 856 +++++++++++++++++++----------------------
>   1 file changed, 398 insertions(+), 458 deletions(-)
> 
> 
> base-commit: e234ed1bb82c96a5643fd70784f16cf3d72eeed3

Hi Longman,

The recent cpuset fixes have been merged, so v5 no longer applies
cleanly and needs a rebase. Before I send v6, would you have time to
take a look at v5? I'd like to fold your comments into v6, together
with the ones from Guopeng.

If you'd rather review a rebased version, I can send v6 first instead.

-- 
Best regards
Ridong

