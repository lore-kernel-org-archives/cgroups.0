From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] blk-cgroup: fix missing pd_online_fn() while activating
 policy
Date: Thu, 5 Jan 2023 07:00:35 -1000
Message-ID: <Y7cCM60kalx+MnYu@slm.duckdns.org>
References: <20230103112833.2013432-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lWuNYcgMRUdXt3lrKpOOAhpTNHvmJnhLtWA6WFPkqzw=;
        b=Ip639JaYOV1aW93fhR9fwRH10jtovSU7bc+87GLEpQ+7rAxYP89lDQrJAJsr2FX6W4
         aI4VpoefbHI4W7mUgseXFMeB3elqfgJAmZIvaMFo5/s6Z0OjDK3eHaWaHAmCn0uFnX6t
         kOHaQWZWvNX8ogHf+qeBkzT3vQbBpAo48dSLguLwXtrFfBJXmtjwkHNqJUhPzdXc6PkS
         BDkw7vuxKXEyvEu4F9Bk2v+2c9TDA3TXClOaIDNfSxIYjOkAwt6/suSKu1swOAB2Ut44
         rhTI0gv4n6qsAGEuBQGHyBx0fZFcj9lXGw6KBaKYwIypB0W5q90hjWTlQKrYwgVG5yUy
         JbhA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230103112833.2013432-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Tue, Jan 03, 2023 at 07:28:33PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> If the policy defines pd_online_fn(), it should be called after
> pd_init_fn(), like blkg_create().
> 
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

However, it'd be useful to note the practical implication of the bug in the
patch description, which seems like not much as discussed in the thread.

Thanks.

-- 
tejun
