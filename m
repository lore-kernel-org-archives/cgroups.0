From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next 3/4] blk-iocost: dispatch all throttled bio in
 ioc_pd_offline
Date: Mon, 19 Dec 2022 11:31:41 -1000
Message-ID: <Y6DYPRWtEAfUrH4Q@slm.duckdns.org>
References: <20221217030527.1250083-1-yukuai1@huaweicloud.com>
 <20221217030527.1250083-4-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BomEC32AM6ovoRGRoa2VDMC3YGhwNtq2L7oOB+Yvsps=;
        b=hCitRNCAgCMGc3lcKkdvYuqgyJSbzuhh31Zq8cJgEQT9EaoWFJ4aaOrosn+xToc3qi
         i1v64YtOXP8bUBG2wBWvL3mACkuvAEqwNgDKAG6u4/MgUwZ5ofzcTqTlTzO/cafayrhX
         uuoevjjPURg+Ytr/7jBe4iZ071G7h9or/VaEgqEhoC9cxHoQALhUfGrA6q/OK33NDmwW
         Nhvldk7qZX1BtpNwDwRXjvJsUUwiVSDEmZYFfa4e4fD9V7uRTWxS0fX7QN63JVA/ov7x
         wSFKzrHlRIyTMaFo/oCDtArYOtAWDuYathCiaB4iq0hsIW9+zQ8SamE8trjHALAgXHL6
         aTNw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221217030527.1250083-4-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Sat, Dec 17, 2022 at 11:05:26AM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Currently, if cgroup is removed while some bio is still throttled, such
> bio will still wait for timer to dispatch. On the one hand, it
> doesn't make sense to throttle bio while cgroup is removed, on the other
> hand, this behaviour makes it hard to guarantee the exit order for
> iocg(in ioc_pd_free() currently).

Yeah, idk about this. So, now if you're in a cgroup with IO restriction, you
can create a sub-cgroup shove all the IOs in there and then kill the cgroup
and escape control and do so repeatedly.

The refcnting is rather complicated in blkcg world because it gets pulled
from several different directions but the problem you're trying to address
likely should be addressed through refcnting.

Thanks.

-- 
tejun
