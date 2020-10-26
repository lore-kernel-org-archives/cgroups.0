From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] blk-cgroup: Pre-allocate tree node on
 blkg_conf_prep
Date: Mon, 26 Oct 2020 09:55:18 -0400
Message-ID: <20201026135518.GE73258@mtj.duckdns.org>
References: <20201022205842.1739739-1-krisman@collabora.com>
 <20201022205842.1739739-3-krisman@collabora.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jX24QeKkjdOlvJuc0hUsXeiJL0gdps1PYbhorm/jTvI=;
        b=QcgGE2zq5tlg4aRL6rRQryJ9lB/2am/wpjipaPG+tIN34AxOJFVTXDEiRd5jYhNQba
         KzdcOLXV5fnScA5MK6tI1qh2n3DKO4jKfWwjGJWi+8SMwPtlKp61N0vxLBeNSrAyZUWI
         W57zxGvbQiR59vwvVURVHWHA6Xk7p6nllu+8Dq0nVIyR0bNvjaUf8uMOB+GyJUB5L+15
         ubcx0oIxBrwmd6GkDvAkTJb9kBHSErrxAlW/rDNqO1wZQvBDs5ocxzW7J0nYuLht763N
         05WxcoYLLLp03NlC9P5to3hwkOwacuIdHKk57qsA9CH4I04QRNSsmTEdmrnDrN4P79q3
         tvjA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20201022205842.1739739-3-krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gabriel Krisman Bertazi <krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, khazhy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org

On Thu, Oct 22, 2020 at 04:58:42PM -0400, Gabriel Krisman Bertazi wrote:
> Similarly to commit 457e490f2b741 ("blkcg: allocate struct blkcg_gq
> outside request queue spinlock"), blkg_create can also trigger
> occasional -ENOMEM failures at the radix insertion because any
> allocation inside blkg_create has to be non-blocking, making it more
> likely to fail.  This causes trouble for userspace tools trying to
> configure io weights who need to deal with this condition.
> 
> This patch reduces the occurrence of -ENOMEMs on this path by preloading
> the radix tree element on a GFP_KERNEL context, such that we guarantee
> the later non-blocking insertion won't fail.
> 
> A similar solution exists in blkcg_init_queue for the same situation.
> 
> Signed-off-by: Gabriel Krisman Bertazi <krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
