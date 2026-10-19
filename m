Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBCD489897;
	Mon, 19 Oct 2026 07:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792394078; cv=none; b=pr3MRgGCAnMIIk3lZbzzb11OtyN67aqbg5vK4L0EB0ev0cXDsO44Uzk+laK5Bk/Gw152+nA+G0HaS/xj31jfPDotG4j2A1ARHNVLtanBE3k3Bt/o8zhTrbtnK1YCTCsFNfgpt4oX1hB68xRZAg0qEzFLqzgOW/WZs5wXAhNlGxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792394078; c=relaxed/simple;
	bh=7CV3JuowRHiD7me0v0jviQVZs6DcoQzgPKmStIBgNQQ=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=HO5RL2DBqFIdurxfgxYXuRCZhgsm8Dw3Ida935XCsM/0d/gADUQRhbneQXcrbWwPNd6dp6zYm9phf2BqP/hDiac3E654ATfPb+2OwjPTAYhdd/5TJZKyUaX4Voobn3ewi3erAuKrpqekzXLOwLcAJ1hKyUG3KcbKgYkdS6MUEKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TO3/piPO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TO3/piPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DFDF1F000C4;
	Mon, 19 Oct 2026 07:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792394076;
	bh=bjfAc2gny8dQsYPeC3CuZrupUfIwRcHCXU8B21O53cM=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=TO3/piPOM3x60PNpztvZMRu22lNm4l7few6eRCSKB1FrHx2knOjeG/Oa7F0Fc0C9l
	 UmVkO/ZWa6oeP5/zf9/BfXFxg6KQZVuewNvTgb5BCC8Hu2DA+Ev+FT2wz0lYRiBgk+
	 YUWS+niNabITtQe/7d75LLWlDjywICF7JaYnSOfaXlG35XFHF50Ntf2bSz2MA4GbjS
	 Vv7kT71/ONlhp0fLiEnQngyIR1ijOewuz9jel3TNNWJblNpyaAryXAoorWX1neL5rK
	 OpFJJQv3VFTlWthXwOa84cWgk77PrwZ9YGGMTuK9Ee6YY6g9j8J+Z1dkU7WBqOe9QC
	 y6oZG6pgkOJXg==
Content-Type: multipart/mixed; boundary="===============4079140705519087332=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <03f6cc15036fbecfd577d878d80d7b182b1cc6574e8bb7daabf6ad8e44fd59dd@mail.kernel.org>
In-Reply-To: <20261019064157.29885-4-laoar.shao@gmail.com>
References: <20261019064157.29885-4-laoar.shao@gmail.com>
Subject: Re: [RFC PATCH v3 bpf-next 3/5] sched: add helpers for numa balancing
From: bot+bpf-ci@kernel.org
To: laoar.shao@gmail.com,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,mingo@redhat.com,peterz@infradead.org,juri.lelli@redhat.com,vincent.guittot@linaro.org,akpm@linux-foundation.org,david@kernel.org,gourry@gourry.net,tj@kernel.org,hannes@cmpxchg.org,mkoutny@suse.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,yu.c.chen@intel.com,zhao1.liu@intel.com,tim.c.chen@linux.intel.com,lizhe.67@bytedance.com
Cc: bpf@vger.kernel.org,linux-mm@kvack.org,cgroups@vger.kernel.org,linux-kernel@vger.kernel.org,laoar.shao@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Mon, 19 Oct 2026 07:14:36 +0000 (UTC)

--===============4079140705519087332==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> sched: add helpers for numa balancing

TL;DR: Nits only: redundant parentheses around the new numab_in_tiering_mode()
helper calls in should_numa_migrate_memory() and migrate_misplaced_folio()
could be dropped.

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 71dc47d6114d..066818498c76 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c

[ ... ]

> @@ -2963,8 +2965,8 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
>  	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
>  	last_cpupid = folio_xchg_last_cpupid(folio, this_cpupid);
>  
> -	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
> -	    !node_is_toptier(src_nid) && !cpupid_valid(last_cpupid))
> +	if (!(numab_in_tiering_mode()) && !node_is_toptier(src_nid) &&
> +	    !cpupid_valid(last_cpupid))
>  		return false;

this isn't a bug, but could the extra parentheses in
!(numab_in_tiering_mode()) be dropped here?  They were needed around the
old bitwise test, and the other converted sites such as
task_numa_fault() call the helper without them.

[ ... ]

> diff --git a/mm/migrate.c b/mm/migrate.c
> index 15b45832bcfa..a622df9a9b42 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c

[ ... ]

> @@ -2770,7 +2771,7 @@ int migrate_misplaced_folio(struct folio *folio, int node)
>  	if (nr_succeeded) {
>  		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
>  		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
> -		if ((sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
> +		if ((numab_in_tiering_mode())
>  		    && !node_is_toptier(folio_nid(folio))
>  		    && node_is_toptier(node))
>  			mod_lruvec_state(lruvec, PGPROMOTE_SUCCESS, nr_succeeded);

The same applies to the parentheses in
if ((numab_in_tiering_mode()) here.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/39213018427
--===============4079140705519087332==--
