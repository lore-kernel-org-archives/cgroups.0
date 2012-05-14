From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 4/6] memcg: move charges to root cgroup if
 use_hierarchy=0.
Date: Mon, 14 May 2012 13:14:38 -0700
Message-ID: <20120514201438.GI2366@google.com>
References: <4FACDED0.3020400@jp.fujitsu.com>
 <4FACE0A2.30608@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=mNZVSPWBps9COGO2Su4rAUKkdBesQRkuG3kbVGLt54k=;
        b=tvOCAZNJoppISR39tHL1cR5ZSVE+XWD92AMGW7tNT6x3SYIY/dQA5R70G/tgVJbHGV
         NQq4wQTqhDGWNgYYUITnneMBZaljX5ulye37MnXi7jH+nG3tv6G8NL1N2ncKc+VlQO2W
         2EYOXPDmDw1XNF92G8gWqhrolYo9IR8poS1esQLjZRVC9n5mf+o/m9KVnvWDtCtbP+4I
         G5vOh7aI4v5wG/SXUmck0ODkKBun/s1Q4y3w2qQcvRVRZHFmlcUeQUy4JcifqG1OWuqy
         33hZ3d9zxMiaZtCI6GNm1yRo+iDC7Rcj8B+P1F/WvTDNzbAym9JJw0lyxUOVG9lWiVVP
         paPg==
Content-Disposition: inline
In-Reply-To: <4FACE0A2.30608-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hiroyuki Kamezawa <kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, May 11, 2012 at 06:49:22PM +0900, KAMEZAWA Hiroyuki wrote:
> @@ -3351,9 +3339,8 @@ int mem_cgroup_move_hugetlb_parent(int idx, struct cgroup *cgroup,
>  	struct page_cgroup *pc;
>  	int csize,  ret = 0;
>  	struct res_counter *fail_res;
> -	struct cgroup *pcgrp = cgroup->parent;
> -	struct mem_cgroup *parent = mem_cgroup_from_cont(pcgrp);
>  	struct mem_cgroup *memcg  = mem_cgroup_from_cont(cgroup);
> +	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
>  	struct res_counter *counter;
>  
>  	if (!get_page_unless_zero(page))
> @@ -3366,13 +3353,11 @@ int mem_cgroup_move_hugetlb_parent(int idx, struct cgroup *cgroup,
>  
>  	csize = PAGE_SIZE << compound_order(page);
>  	/* If parent->use_hierarchy == 0, we need to charge parent */
> -	if (!parent->use_hierarchy) {
> -		ret = res_counter_charge(&parent->hugepage[idx],
> -					 csize, &fail_res);
> -		if (ret) {
> -			ret = -EBUSY;
> -			goto err_out;
> -		}
> +	if (!parent) {
> +		parent = root_mem_cgroup;
> +		/* root has no limit */
> +		res_counter_charge_nofail(&parent->hugepage[idx],
> +				 csize, &fail_res);
>  	}
>  	counter = &memcg->hugepage[idx];
>  	res_counter_uncharge_until(counter, counter->parent, csize);

This function can simply return 0 now, so no point in having int
return.  Make it return void?

Also, follow-up patches to cleanup -ENOMEM failure handling in the
callers would be nice.

Thanks.

-- 
tejun
