Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA3B38A725;
	Tue, 13 Oct 2026 07:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791877106; cv=none; b=hmPdpSIGvnUh/AZ2Fub0X/cwQjwNHbAuBj4QWxFKG5Cr/NrigJ1Wrlr2w5CRBIiCAxiJ9DcvbFtd56DKSx4aXtQs5a8AkgyFXxeWYscPI/8caRn01lrB1i2tFXu1EKUgZh81cDDuc4CpDc54oyIedEjGFRoknrlSZ4WhcpexqgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791877106; c=relaxed/simple;
	bh=ZyYqWXIUfrHec9/Q4SP2Vj1puzNLnZc//qGe5AvQoNM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l6eaYaeRHdI5fy99RlV/59A1FSvcfs81XYEY7RxorCtyKZtuwn660r/7PiXrGUtvhifsbkd3PoOsMmj1LVJD2tTPDNFrqighlv7gvEQaGxJ5jgDMv55GZvU0FXRQsUurtIFc08FV8E+0UAFOjXAJuV1D4w6hkLOWx/rYJ9qQguw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DlB0kj8g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DlB0kj8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F001F00893;
	Tue, 13 Oct 2026 07:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791877104;
	bh=DcuYY3+mv/Ns6uvfacyrd4dBgpfSbyMtyecX3H4y2hE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DlB0kj8gOlFNSD84BZwMWb5ZbV2oXW4IaLaFGcapmHBAUuLC7zPJAEShEflW7d90Z
	 2ITF8SGCDnhIDxAHfjDEwEtAvXceuwSpN5Fasml6JY9Wn9huixCPCLyT3uZ+1AsP/f
	 QOGdh8bpPL2f7KQEgdkMQFTpJg+d/VB0ZERes3AU7EeweYpj1IPdrZRVasXloHdV2K
	 FjdS4eNfe0CbiVGPsgPqkqk1Hc6oPE4Il1DhEwPDaQ3vfenYbgtC509EdQiZhRvTGK
	 ukmwwkNFOwzqRryAIPa6FUnK5PNz4426a8gtHsmxyZGUcdlQo01a/ZMlDCQP2iOTA7
	 O7NL/VpOcZOZA==
Message-ID: <96324eec-d307-4bbf-975e-3c9b3dd5e190@kernel.org>
Date: Tue, 13 Oct 2026 09:38:14 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 1/3] sched: add helpers for numa balancing
To: Yafang Shao <laoar.shao@gmail.com>, ast@kernel.org, daniel@iogearbox.net,
 andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, mingo@redhat.com,
 peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 akpm@linux-foundation.org, gourry@gourry.net, tj@kernel.org,
 hannes@cmpxchg.org, mkoutny@suse.com, shakeel.butt@linux.dev,
 roman.gushchin@linux.dev, yu.c.chen@intel.com, zhao1.liu@intel.com
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261012120438.52849-1-laoar.shao@gmail.com>
 <20261012120438.52849-2-laoar.shao@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261012120438.52849-2-laoar.shao@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/12/26 14:04, Yafang Shao wrote:
> Two new helpers task_numab_enabled() and numab_mode_tiering() are
> introduced to replace the scattered direct accesses to the
> sched_numa_balancing static key and the sysctl_numa_balancing_mode
> bitmask.
> 

I'll only comment on the new exposed helpers. Some of these might make sense
even without the bigger series.

(obviously, minus the task change)

> No functional change.
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  include/linux/sched/numa_balancing.h | 31 ++++++++++++++++++++++++++++
>  kernel/sched/fair.c                  | 16 +++++++-------
>  kernel/sched/sched.h                 |  1 -
>  mm/memory-tiers.c                    |  3 ++-
>  mm/migrate.c                         |  7 ++++---
>  mm/vmscan.c                          |  6 +++---
>  6 files changed, 48 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/sched/numa_balancing.h b/include/linux/sched/numa_balancing.h
> index 52b22c5c396d..353772b49c5f 100644
> --- a/include/linux/sched/numa_balancing.h
> +++ b/include/linux/sched/numa_balancing.h
> @@ -8,6 +8,7 @@
>   */
>  
>  #include <linux/sched.h>
> +#include <linux/sched/sysctl.h>
>  
>  #define TNF_MIGRATED	0x01
>  #define TNF_NO_GROUP	0x02
> @@ -32,6 +33,28 @@ extern void set_numabalancing_state(bool enabled);
>  extern void task_numa_free(struct task_struct *p, bool final);
>  bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
>  				int src_nid, int dst_cpu);
> +
> +extern struct static_key_false sched_numa_balancing;
> +
> +/*
> + * Whether NUMA balancing applies to @p.  The @p argument is unused for
> + * now: a later patch will consult a per-cgroup BPF policy with it.

Talking about later patches in a function doc is ... wrong.

> + */
> +static inline bool task_numab_enabled(struct task_struct *p)
> +{
> +	return static_branch_unlikely(&sched_numa_balancing);
> +}
> +
> +/*
> + * The global sysctl state, for the system-wide tiering machinery: this
> + * reflects kernel.numa_balancing_mode only and takes no task.

The latter part doesn't make a lot of sense in this documentation.

> + */
> +static inline bool numab_mode_tiering(void)

The function name isn't really intuitive. Should this be

	numab_in_tiering_mode

	
	numab_tiering_enabled

or something like this.

> +{
> +	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
> +		return true;
> +	return false;


return sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING;

?

Both functions could directly have proper kerneldoc if we are already
documenting these.

> +}
>  #else
>  static inline void task_numa_fault(int last_node, int node, int pages,
>  				   int flags)
> @@ -52,6 +75,14 @@ static inline bool should_numa_migrate_memory(struct task_struct *p,
>  {
>  	return true;
>  }
> +static inline bool task_numab_enabled(struct task_struct *p)
> +{
> +	return false;
> +}
> +static inline bool numab_mode_tiering(void)
> +{
> +	return false;
> +}


-- 
Cheers,

David
