From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH-block v3 1/2] bdi, blk-cgroup: Fix potential UAF of blkcg
Date: Tue, 13 Dec 2022 09:29:26 -1000
Message-ID: <Y5jSllwwBdmQ1jQz@slm.duckdns.org>
References: <20221213184446.50181-1-longman@redhat.com>
 <20221213184446.50181-2-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l7iej3uCNn9r6CuK7MDwP9bcqGiFhUgLAt5WQq2ePLA=;
        b=k8gA9BVoaw8yYqfb3WcJbE9PU/wx0MjT4ZBH29rHEE3YZ3p83vX1GakjNnqCAcr3Oa
         w6DCBxMko8Pkra2ttxA70QRGC/qJ8u41XaQk/aQRUMqKMu+9EdRMvNNYiUYtXquHXbXW
         EQBcIUH+jFUoC1easz32DDyL/LrE0eqZAquVXbEF0JdQmPFImn+DaIcmGyYqrao9JnnG
         OqVnsgPQT6iPNsOraxbEg1fuzcRSct08BKWiI60WV2gSktSzVsDtIzV38eWQE8AeXzko
         Cbhu8ACMVwRUIkiXKZM9+47YNbVzzb9o1LPbCLTf34DBbTVzKUMCElxP8GsBdL+gZDZL
         cnfQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221213184446.50181-2-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, "Dennis Zhou (Facebook)" <dennisszhou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yi Zhang <yi.zhang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Tue, Dec 13, 2022 at 01:44:45PM -0500, Waiman Long wrote:
> Commit 59b57717fff8 ("blkcg: delay blkg destruction until after
> writeback has finished") delayed call to blkcg_destroy_blkgs() to
> cgwb_release_workfn(). However, it is done after a css_put() of blkcg
> which may be the final put that causes the blkcg to be freed as RCU
> read lock isn't held.
> 
> Another place where blkcg_destroy_blkgs() can be called indirectly via
> blkcg_unpin_online() is from the offline_css() function called from
> css_killed_work_fn(). Over there, the potentially final css_put() call
> is issued after offline_css().
> 
> By adding a css_tryget() into blkcg_destroy_blkgs() and warning its
> failure, the following stack trace was produced in a test system on
> bootup.

This doesn't agree with the code anymore. Otherwise

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
