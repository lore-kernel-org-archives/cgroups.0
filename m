From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH-block v2 3/3] blk-cgroup: Flush stats at blkgs
 destruction path
Date: Mon, 12 Dec 2022 12:24:02 -1000
Message-ID: <Y5eqAtwnpfEUG0EL@slm.duckdns.org>
References: <20221211222058.2946830-1-longman@redhat.com>
 <20221211222058.2946830-4-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DduZ36/gNNuK+m5qHFBGb7Zr62cBswC5K6+2kXn9vQE=;
        b=KUybaHVVN3vB51GqoRWpHL2dDTx2qMFPypuONf/AmhxlZr55HRmLSgY5wpkSn1navb
         dyTi2H+7ZAZtAStM5HvFjAtD4ljlq5qcHJKd+rnNIe5MPoHkVUIrXEk2wYr8Qawciwe+
         F3wYqQXQWHtzDjn2y/qMSnQuc+Cr3KqWgWxsE+EdXuTMEG6aOD9xbM9akomuQE/5nRWp
         AnAhL9RTKC4y0TrpDLXYj32qftrZhQQcovsuqi1GPshjIQuvDA8BDqaQ8hm82Pasqk7i
         dyTvyXn8iL4x7CjRudvASM1DyVneJ5/3auOxORwtTNf6DmwJ9N3OBtW+09+w3T0We0bI
         ixVA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221211222058.2946830-4-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, "Dennis Zhou (Facebook)" <dennisszhou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Sun, Dec 11, 2022 at 05:20:58PM -0500, Waiman Long wrote:
> As noted by Michal, the blkg_iostat_set's in the lockless list
> hold reference to blkg's to protect against their removal. Those
> blkg's hold reference to blkcg. When a cgroup is being destroyed,
> cgroup_rstat_flush() is only called at css_release_work_fn() which is
> called when the blkcg reference count reaches 0. This circular dependency
> will prevent blkcg from being freed until some other events cause
> cgroup_rstat_flush() to be called to flush out the pending blkcg stats.
> 
> To prevent this delayed blkcg removal, add a new cgroup_rstat_css_flush()
> function to flush stats for a given css and cpu and call it at the blkgs
> destruction path, blkcg_destroy_blkgs(), whenever there are still some
> pending stats to be flushed. This will ensure that blkcg reference
> count can reach 0 ASAP.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

But a nit below

> +	/*
> +	 * Flush all the non-empty percpu lockless lists.
> +	 */

Can you please explain the deadlock that's being avoided in the above
comment? ie. it should say why this flush is necessary.

> +	for_each_possible_cpu(cpu) {
> +		struct llist_head *lhead = per_cpu_ptr(blkcg->lhead, cpu);
> +
> +		if (!llist_empty(lhead))
> +			cgroup_rstat_css_cpu_flush(&blkcg->css, cpu);
> +	}

Thanks.

-- 
tejun
