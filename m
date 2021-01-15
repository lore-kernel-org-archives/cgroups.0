From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] tg: add cpu's wait_count of a task group
Date: Fri, 15 Jan 2021 15:19:15 -0500
Message-ID: <YAH4w5T3/oCTGJny@mtj.duckdns.org>
References: <20210115143005.7071-1-wu860403@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=17vzS6L8VVV24OmDmZNyqFRhRB1Jb2yRyiJ9OkEqTr4=;
        b=tw6kLMYLoAN7TOMqUxemf47gDQUJB2azmtU+AzfA0VXBXz8CxnedZJBSc69EX+FaOW
         QT/5owhriHG938HeqiSNTNyWvCXlP0b0mBLNVjEkXM+U7hYdoGb7SPthhyxyfSAMUS0m
         NHWs2B31OgVB7A/p0glABnCQJTPzOsuQALdZTNI2yzXXWNIFC4syJHdOeo5EHL9Varvl
         0nHtsvz6MOswhCTa5T+lJFoAyXSna3lXzkQxP4LTWgMCJ3KsKxnClToL8CK+q0snAKgF
         yAU9x4kbNHKvu89Rg1CkEuaFnVqS2WVCsfgmXzJLHPlDyRrk1LkSXBGBB8zNyWT3mut/
         cRoA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210115143005.7071-1-wu860403-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: wu860403-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 398776277-9uewiaClKEY@public.gmane.org

Hello,

On Fri, Jan 15, 2021 at 10:30:05PM +0800, wu860403-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> -	seq_printf(sf, "throttled_time %llu\n", cfs_b->throttled_time);
...
> +	seq_printf(sf, "nr_periods %d\n"
> +		   "nr_throttled %d\n"
> +		   "throttled_usec %llu\n",
> +		   cfs_b->nr_periods, cfs_b->nr_throttled,
> +		   throttled_usec);

This is interface breaking change. I don't think we can do this at this
point.

> @@ -8255,6 +8265,19 @@ static int cpu_extra_stat_show(struct seq_file *sf,
>  			   "throttled_usec %llu\n",
>  			   cfs_b->nr_periods, cfs_b->nr_throttled,
>  			   throttled_usec);
> +		if (schedstat_enabled() && tg != &root_task_group) {
> +			u64 ws = 0;
> +			u64 wc = 0;
> +			int i;
> +
> +			for_each_possible_cpu(i) {
> +				ws += schedstat_val(tg->se[i]->statistics.wait_sum);
> +				wc += schedstat_val(tg->se[i]->statistics.wait_count);
> +			}
> +
> +			seq_printf(sf, "wait_sum %llu\n"
> +				"wait_count %llu\n", ws, wc);
> +		}

What does sum/count tell?

Thanks.

-- 
tejun
