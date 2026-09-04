Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C903B7B6E;
	Fri,  4 Sep 2026 16:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788539106; cv=none; b=YMNGzoY9CijK2gOJpn6R1wqxIk1Cj6peneGD0UL28evN2hOKCBU9X39BxAcsq++facRxM29AxDMkGCkpYirrgLf7K/El8X1hLPp07dA1EKmuApt4liY5N1hvPgjHqJmlcynQzgYmHQLlQ+YlJpbVR/+xgoQZ/VD7OCmPw1tJRfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788539106; c=relaxed/simple;
	bh=0QUzvxRMva/FxviYcdt9y7yjhNEdCgby1Rg2SX6fBVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KztIuOYmWx3FJoBPPd2Hhdt7cWFdMtP32/xvYVt8Ih6bPjKsWFAQ/nR4ujpwmoTwapbvUDPw4kViDjHiOh0nuWdjDn9JawPq8VDSNrGHod+pYbnUMBPold/hwScfxbl6V+pWd87bXtGvbPnDqKKo60Wd6Y7NAexCfE/HWod4JbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WyFHp9Ge; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WyFHp9Ge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A941F00A3D;
	Fri,  4 Sep 2026 16:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788539104;
	bh=KzIjMFSH1tNjnbsKNHaVpESmlSYBZ1Zva20ytbg13fA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WyFHp9GeXwJKlncsYct5wjADPuVdgkLd2uSHFbC1mG55lAXc1U8XZoWXmnfmn9Dr2
	 PXORo+2coJ7Mph4851ypNraMEIjoOMS5zCR3wcjtLWWfghetN0zc1n+EVb7FD2/U8l
	 naTgQWztpPtatKKLKpxcMtowm4CHYIHi8CIt2tCvFG4729T85JbHsgYl4hOcPBSKe5
	 9n2GlvulkZtYJ09c13UQtPuTLY4evPQHxn6dnQSXBKuq3QzLvYB9pvF/AuT24+2u/P
	 wkSpUmHB4p4J9mFmKtXOvNAZ9oavWEkWa3uVk5jDbifS4N5aSsiiyRilgZ5DgCNRE3
	 XDY810l320myw==
Date: Fri, 4 Sep 2026 17:24:59 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: Don't call schedule_work when no spinning is
 allowed
Message-ID: <aprp6GXv8poXXad9@gremlin>
References: <20260831234339.280376-1-stevensd@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831234339.280376-1-stevensd@google.com>

On Mon, Aug 31, 2026 at 04:43:39PM -0700, David Stevens wrote:
> Memcg charging can be done from any context, but calling schedule_work()
> isn't safe from an NMI. If memory.high is breached from a context where
> spinning isn't allowed, use irq_work to schedule the reclaim work.
>
> Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
> Signed-off-by: David Stevens <stevensd@google.com>

This is in mm-unstable and breaks the build for me :)

In general - please don't rely on implicit header includes, if you're using
functions from a header that's not included, add the include because your local
config might happen to import it but another one might be broken.

$ make -j $(nproc) LLVM=1 mm/memcontrol.o
  DESCEND objtool
  CC      arch/x86/kernel/asm-offsets.s
  UPD     include/generated/asm-offsets.h
  CC      kernel/sched/rq-offsets.s
  UPD     include/generated/rq-offsets.h
  CALL    scripts/checksyscalls.sh
  CC      mm/memcontrol.o
mm/memcontrol.c:2859:6: error: call to undeclared function 'irq_work_queue'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
 2859 |                                         irq_work_queue(&memcg->high_irq_work);
      |                                         ^
mm/memcontrol.c:4234:2: error: call to undeclared function 'init_irq_work'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
 4234 |         init_irq_work(&memcg->high_irq_work, high_irq_work_func);
      |         ^
mm/memcontrol.c:4443:2: error: call to undeclared function 'irq_work_sync'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
 4443 |         irq_work_sync(&memcg->high_irq_work);
      |         ^
3 errors generated.
make[3]: *** [scripts/Makefile.build:290: mm/memcontrol.o] Error 1
make[2]: *** [scripts/Makefile.build:551: mm] Error 2
make[1]: *** [/home/lorenzo/kerndev/kernels/mm/Makefile:2229: .] Error 2
make: *** [Makefile:248: __sub-make] Error 2

> ---
>  include/linux/memcontrol.h |  1 +
>  mm/memcontrol.c            | 12 +++++++++++-
>  2 files changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 8170bb8066a2..036d973ceca6 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -219,6 +219,7 @@ struct mem_cgroup {
>  	spinlock_t	 peaks_lock;
>
>  	/* Range enforcement for interrupt charges */
> +	struct irq_work high_irq_work;
>  	struct work_struct high_work;
>
>  #ifdef CONFIG_ZSWAP
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6dc4888a90f3..5e2f749067cb 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c

You need to add:

#include <linux/irq_work.h> in this file.

> @@ -2360,6 +2360,11 @@ static void high_work_func(struct work_struct *work)
>  	reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);
>  }
>
> +static void high_irq_work_func(struct irq_work *work)
> +{
> +	schedule_work(&container_of(work, struct mem_cgroup, high_irq_work)->high_work);
> +}
> +
>  /*
>   * Clamp the maximum sleep time per allocation batch to 2 seconds. This is
>   * enough to still cause a significant slowdown in most cases, while still
> @@ -2752,7 +2757,10 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  		/* Don't bother a random interrupted task */
>  		if (!in_task()) {
>  			if (mem_high) {
> -				schedule_work(&memcg->high_work);
> +				if (allow_spinning)
> +					schedule_work(&memcg->high_work);
> +				else
> +					irq_work_queue(&memcg->high_irq_work);
>  				break;
>  			}
>  			continue;
> @@ -4129,6 +4137,7 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
>  		goto fail;
>
>  	INIT_WORK(&memcg->high_work, high_work_func);
> +	init_irq_work(&memcg->high_irq_work, high_irq_work_func);
>  	vmpressure_init(&memcg->vmpressure);
>  	INIT_LIST_HEAD(&memcg->memory_peaks);
>  	INIT_LIST_HEAD(&memcg->swap_peaks);
> @@ -4337,6 +4346,7 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
>  		static_branch_dec(&memcg_bpf_enabled_key);
>
>  	vmpressure_cleanup(&memcg->vmpressure);
> +	irq_work_sync(&memcg->high_irq_work);
>  	cancel_work_sync(&memcg->high_work);
>  	memcg1_remove_from_trees(memcg);
>  	free_shrinker_info(memcg);
>
> base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
> --
> 2.55.0.897.gb25b4bd76c-goog
>
>

--
Cheers, Lorenzo
