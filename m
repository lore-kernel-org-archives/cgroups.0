From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [PATCH v5 2/7] mm: generalize postponed non-root kmem_cache
 deactivation
Date: Tue, 28 May 2019 20:11:26 +0300
Message-ID: <20190528171126.oaneakkydwyzied6@esperanza>
References: <20190521200735.2603003-1-guro@fb.com>
 <20190521200735.2603003-3-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A8QVP2Qf5aJcHIy8l49WfRPomDE8uUrBG/3Am/yYNlU=;
        b=tbj82VcOGB/BLqdwN+zId/aL1F3LbvsduOAs5GjftF3C0NFgGGQfU7vrCi+8ZFR4Ew
         uMeDuC9cIWItsZjEU/EYdPtcQbKmV0dwqkHg9AKjbOptmKOd7+DPQ5dAVm05PXKt+oqr
         Td+xYmJbU2LeazwHzmVCPZVcSIPUATTVRVMsqa/4LHzrIbZLk9+XKgatIB2qZQOx+2ZA
         HWq/fedWq82lYNQt9lABwgmMYVhppMEEmA50HzdtSJIgMvQoAuTqzJ3bJoQ5o3mjftyT
         3JTeLVmb57ufyHL1txvLiGXT8sTJqMyPMloJLNcl+S/m1XAOixYz0YB+OWBWw35SNfR1
         S1Yw==
Content-Disposition: inline
In-Reply-To: <20190521200735.2603003-3-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Shakeel Butt <shakeelb@google.com>, Christoph Lameter <cl@linux.com>, cgroups@vger.kernel.org, Waiman Long <longman@redhat.com>

On Tue, May 21, 2019 at 01:07:30PM -0700, Roman Gushchin wrote:
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 6e00bdf8618d..4e5b4292a763 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -866,11 +859,12 @@ static void flush_memcg_workqueue(struct kmem_cache *s)
>  	mutex_unlock(&slab_mutex);
>  
>  	/*
> -	 * SLUB deactivates the kmem_caches through call_rcu. Make
> +	 * SLAB and SLUB deactivate the kmem_caches through call_rcu. Make
>  	 * sure all registered rcu callbacks have been invoked.
>  	 */
> -	if (IS_ENABLED(CONFIG_SLUB))
> -		rcu_barrier();
> +#ifndef CONFIG_SLOB
> +	rcu_barrier();
> +#endif

Nit: you don't need to check CONFIG_SLOB here as this code is under
CONFIG_MEMCG_KMEM which depends on !SLOB.

Other than that, the patch looks good to me, provided using rcu for slab
deactivation proves to be really necessary, although I'd split it in two
patches - one doing renaming another refactoring - easier to review that
way.
