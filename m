From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next v2 1/3] blk-cgroup: dropping parent refcount after
 pd_free_fn() is done
Date: Wed, 18 Jan 2023 06:54:41 -1000
Message-ID: <Y8gkUZtbWltG/vI3@slm.duckdns.org>
References: <20230118123152.1926314-1-yukuai1@huaweicloud.com>
 <20230118123152.1926314-2-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d9OP8oV65JxIUAfGtsGFxPR9aOpiL07LaKAZQ5LY4+8=;
        b=FMmwB5hmA/Th3ZFkKr78WupQ0I9Ky1YNdVlkyiJ7vyA3gwsXckPf4Llnr8mFrlAW+d
         MnUuagJq15CF2N4gvUdJMh8vL7aJREH8allAUTWEUp7NUV/I587rdeuR7c1JQ8YpR3Yk
         zUxdqkr46VnVTiwH7YUpbJXhVZWu59iWkWBh/lULZ8rl8RmZH/dgJnZXiP76gjrdeuX+
         Bk5Pd9ufG2BvWVFURawcDgu+DVrcuCPxeO04P83wI9MIIjQ5H0iDGgrdRV4Fe5rqOrDd
         TI4MlgnElMy1eCczsySheHNHs9ur+IwcfltR/jrns20VlYCSFxON2DD3Z0zb78IqLdG6
         BtzQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230118123152.1926314-2-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: hch-jcswGhMUV9g@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Wed, Jan 18, 2023 at 08:31:50PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Some cgroup policies will access parent pd through child pd even
> after pd_offline_fn() is done. If pd_free_fn() for parent is called
> before child, then UAF can be triggered. Hence it's better to guarantee
> the order of pd_free_fn().
> 
> Currently refcount of parent blkg is dropped in __blkg_release(), which
> is before pd_free_fn() is called in blkg_free_work_fn() while
> blkg_free_work_fn() is called asynchronously.
> 
> This patch make sure pd_free_fn() called from removing cgroup is ordered
> by delaying dropping parent refcount after calling pd_free_fn() for
> child.
> 
> BTW, pd_free_fn() will also be called from blkcg_deactivate_policy()
> from deleting device, and following patches will guarantee the order.
> 
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
