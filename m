From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroups: Do not show inactive devices in cgroups
 statistics
Date: Thu, 27 Jun 2013 09:59:43 -0700
Message-ID: <20130627165943.GA5599@mtj.dyndns.org>
References: <20130627012304.GG4536@htj.dyndns.org>
 <1372351046-11976-1-git-send-email-anatol.pomozov@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=L+J7sXeb0YO6VX8oFo34IBVM3VxiDcxsTtHFR7l76cw=;
        b=TzHUQUJMDwk3mV7vg9EzjlY9dr4z41jjH1H+B7MiuMUECDRKB6kQSIq8Q4wdXvBCaj
         Fxre6WKpLSIKahEPwQ8d2+lWmVtFHaRVmd48XCKVVxhFsGY48QeWCWwirzWcPI1KG1KX
         oz/gBuMrCfO3JgaMarq+qdMOELT//0ZiLBlkDXIqvbExD01S0fpmxTyfALE6wD9bPb5k
         dg8Om+zAbeAHjiytRRJbFmOPCnVl16JRYuFdvlomAU3ygByhpcjQ7fn4coL4+XnpC4+k
         FJEjVDLSHdSOEc0JrIyeeug4XBCdsR1z2LuACuzuVs2Ce7pgu45zZ55WMRlb63c6rIb6
         eWkA==
Content-Disposition: inline
In-Reply-To: <1372351046-11976-1-git-send-email-anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

(cc'ing Jens)

Hello,

This one probably needs -stable cc'd.  Jens, do you wanna take this?
If not, I'll be happy to take it through cgroup tree.

Thanks.

On Thu, Jun 27, 2013 at 09:37:26AM -0700, Anatol Pomozov wrote:
> Before 3.5 CFQ cgroups stats was lazy initialized - the stat object was created
> only if the device had any I/O in that cgroup.
> 
> Around 3.5 time CFQ stat structure became part of device structure. And
> zero stat is created when device is initialized. Initialization can happen
> e.g. when we configure it via 'weight_device' file. It calls
> cfqg_set_weight_device() and it creates cfq_group structure.
> 
> But even if device is initialized the stats is still zero.
> If we configure all devices in all in all cgroups it generates a lot of
> useless stat info that takes more resources to process and store. Imagine
> servers with handreds cgroups and handreds iSCSI block devices.
> 
> Do not print stats for inactive devices - it restores functionality
> that was before 3.5
> 
> Signed-off-by: Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

> ---
>  block/blk-cgroup.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index e8918ff..4e07e73 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -560,6 +560,7 @@ EXPORT_SYMBOL_GPL(__blkg_prfill_u64);
>   * @rwstat: rwstat to print
>   *
>   * Print @rwstat to @sf for the device assocaited with @pd.
> + * Devices with zero activity will not be printed.
>   */
>  u64 __blkg_prfill_rwstat(struct seq_file *sf, struct blkg_policy_data *pd,
>  			 const struct blkg_rwstat *rwstat)
> @@ -571,19 +572,23 @@ u64 __blkg_prfill_rwstat(struct seq_file *sf, struct blkg_policy_data *pd,
>  		[BLKG_RWSTAT_ASYNC]	= "Async",
>  	};
>  	const char *dname = blkg_dev_name(pd->blkg);
> -	u64 v;
> +	u64 total;
>  	int i;
>  
>  	if (!dname)
>  		return 0;
>  
> +	total = rwstat->cnt[BLKG_RWSTAT_READ] + rwstat->cnt[BLKG_RWSTAT_WRITE];
> +	/* skip devices with no activity */
> +	if (!total)
> +		return 0;
> +
>  	for (i = 0; i < BLKG_RWSTAT_NR; i++)
>  		seq_printf(sf, "%s %s %llu\n", dname, rwstr[i],
>  			   (unsigned long long)rwstat->cnt[i]);
>  
> -	v = rwstat->cnt[BLKG_RWSTAT_READ] + rwstat->cnt[BLKG_RWSTAT_WRITE];
> -	seq_printf(sf, "%s Total %llu\n", dname, (unsigned long long)v);
> -	return v;
> +	seq_printf(sf, "%s Total %llu\n", dname, (unsigned long long)total);
> +	return total;
>  }
>  EXPORT_SYMBOL_GPL(__blkg_prfill_rwstat);
>  
> -- 
> 1.8.3
> 

-- 
tejun
