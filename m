From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH 4/5] mm: rework non-root kmem_cache lifecycle
 management
Date: Thu, 18 Apr 2019 13:38:44 +0000
Message-ID: <0100016a30abc330-011d895a-b4af-40a9-8937-990297ed4ffd-000000@email.amazonses.com>
References: <20190417215434.25897-1-guro@fb.com> <20190417215434.25897-5-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=6gbrjpgwjskckoa6a5zn6fwqkn67xbtw; d=amazonses.com; t=1555594724;
        h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:MIME-Version:Content-Type:Feedback-ID;
        bh=Mn2jJaVyXnfxUugHqDabQsqBL//yamSkxsI3eXyDlrA=;
        b=X8JPWrXuwI/DmpMMQRAri2xJUwQ0i7jWaes61IDWWWuJLbXYDrbCni8Zo0sXjXuW
        yuEhkjEnFwk2btLft+ero1yzF/zwR+mKYyrtIAMwHcfTE867Fpu+T5ENro+L+x0VPM8
        HiGNCzzwCW0kHJo5F8RXhjgVSKoGCFVBJ3UtdK4A=
In-Reply-To: <20190417215434.25897-5-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guroan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, david@fromorbit.com, Pekka Enberg <penberg@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, Roman Gushchin <guro@fb.com>

On Wed, 17 Apr 2019, Roman Gushchin wrote:

>  static __always_inline int memcg_charge_slab(struct page *page,
>  					     gfp_t gfp, int order,
>  					     struct kmem_cache *s)
>  {
> -	if (is_root_cache(s))
> +	int idx = (s->flags & SLAB_RECLAIM_ACCOUNT) ?
> +		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE;
> +	struct mem_cgroup *memcg;
> +	struct lruvec *lruvec;
> +	int ret;
> +
> +	if (is_root_cache(s)) {
> +		mod_node_page_state(page_pgdat(page), idx, 1 << order);

Hmmm... This is functionality that is not memcg specific being moved into
a memcg function??? Maybe rename the function to indicate that it is not
memcg specific and add the proper #ifdefs?

>  static __always_inline void memcg_uncharge_slab(struct page *page, int order,
>  						struct kmem_cache *s)
>  {
> -	memcg_kmem_uncharge(page, order);
> +	int idx = (s->flags & SLAB_RECLAIM_ACCOUNT) ?
> +		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE;
> +	struct mem_cgroup *memcg;
> +	struct lruvec *lruvec;
> +
> +	if (is_root_cache(s)) {
> +		mod_node_page_state(page_pgdat(page), idx, -(1 << order));
> +		return;
> +	}

And again.

