From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH V5] memcg, oom: provide more precise dump info while
 memcg oom happening
Date: Thu, 20 Dec 2012 14:15:31 +0100
Message-ID: <20121220131531.GB31912@dhcp22.suse.cz>
References: <1355925061-3858-1-git-send-email-handai.szj@taobao.com>
 <20121219141218.c1bb423b.akpm@linux-foundation.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=Ey9+DJlwAYSm8oLjYB6++T1W79mVsHvNKv4xpqyTZJw=;
        b=Zg4B4uyqZAqHH5djMbEiQmNgzyd6+E16RRz6jbGs57wZtHURz3jqClbIsTlCzVQdcH
         QotApLxcpUFwY3drBvEZCPULA+c6spQ1cs96UxivwBXKdlqo9q9c+HF9D1GxTPO46nDl
         g/wejyMjnkK2+nk30OrXGb+4b0luKET8dk/rAS77DwdLKT6DPn0+QYquSt38sf7BCBr0
         Li2K2DXFU39sLBIeCVly6MF0xfgF9zb19uSA7plydlg/TyCagUJShnj7a8XTGrDlvI/z
         rBv3FyXvphjsUMgnqdi8IVhbadtUN6mJP+p3CMWPxF9Yiw8Ut5wigCh9cz7DuvIOvHtZ
         04uA==
Content-Disposition: inline
In-Reply-To: <20121219141218.c1bb423b.akpm@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sha Zhengju <handai.szj@gmail.com>, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, rientjes@google.com, linux-mm@kvack.org, Sha Zhengju <handai.szj@taobao.com>

On Wed 19-12-12 14:12:18, Andrew Morton wrote:
> On Wed, 19 Dec 2012 21:51:01 +0800
> Sha Zhengju <handai.szj@gmail.com> wrote:
> 
> > +		pr_info("Memory cgroup stats");
> 
> Well if we're going to do that, we may as well finish the job:
> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm/memcontrol.c: convert printk(KERN_FOO) to pr_foo()
> 
> Cc: Sha Zhengju <handai.szj@taobao.com>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: David Rientjes <rientjes@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Thanks Andrew!

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
> 
>  mm/memcontrol.c |   15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff -puN mm/memcontrol.c~mm-memcontrolc-convert-printkkern_foo-to-pr_foo mm/memcontrol.c
> --- a/mm/memcontrol.c~mm-memcontrolc-convert-printkkern_foo-to-pr_foo
> +++ a/mm/memcontrol.c
> @@ -1574,7 +1574,7 @@ void mem_cgroup_print_oom_info(struct me
>  	}
>  	rcu_read_unlock();
>  
> -	printk(KERN_INFO "Task in %s killed", memcg_name);
> +	pr_info("Task in %s killed", memcg_name);
>  
>  	rcu_read_lock();
>  	ret = cgroup_path(mem_cgrp, memcg_name, PATH_MAX);
> @@ -1587,19 +1587,18 @@ void mem_cgroup_print_oom_info(struct me
>  	/*
>  	 * Continues from above, so we don't need an KERN_ level
>  	 */
> -	printk(KERN_CONT " as a result of limit of %s\n", memcg_name);
> +	pr_cont(" as a result of limit of %s\n", memcg_name);
>  done:
>  
> -	printk(KERN_INFO "memory: usage %llukB, limit %llukB, failcnt %llu\n",
> +	pr_info("memory: usage %llukB, limit %llukB, failcnt %llu\n",
>  		res_counter_read_u64(&memcg->res, RES_USAGE) >> 10,
>  		res_counter_read_u64(&memcg->res, RES_LIMIT) >> 10,
>  		res_counter_read_u64(&memcg->res, RES_FAILCNT));
> -	printk(KERN_INFO "memory+swap: usage %llukB, limit %llukB, "
> -		"failcnt %llu\n",
> +	pr_info("memory+swap: usage %llukB, limit %llukB, failcnt %llu\n",
>  		res_counter_read_u64(&memcg->memsw, RES_USAGE) >> 10,
>  		res_counter_read_u64(&memcg->memsw, RES_LIMIT) >> 10,
>  		res_counter_read_u64(&memcg->memsw, RES_FAILCNT));
> -	printk(KERN_INFO "kmem: usage %llukB, limit %llukB, failcnt %llu\n",
> +	pr_info("kmem: usage %llukB, limit %llukB, failcnt %llu\n",
>  		res_counter_read_u64(&memcg->kmem, RES_USAGE) >> 10,
>  		res_counter_read_u64(&memcg->kmem, RES_LIMIT) >> 10,
>  		res_counter_read_u64(&memcg->kmem, RES_FAILCNT));
> @@ -4424,8 +4423,8 @@ void mem_cgroup_print_bad_page(struct pa
>  
>  	pc = lookup_page_cgroup_used(page);
>  	if (pc) {
> -		printk(KERN_ALERT "pc:%p pc->flags:%lx pc->mem_cgroup:%p\n",
> -		       pc, pc->flags, pc->mem_cgroup);
> +		pr_alert("pc:%p pc->flags:%lx pc->mem_cgroup:%p\n",
> +			 pc, pc->flags, pc->mem_cgroup);
>  	}
>  }
>  #endif
> _
> 

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
