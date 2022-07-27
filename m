From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RESEND v6 8/8] blk-throttle: clean up flag
 'THROTL_TG_PENDING'
Date: Wed, 27 Jul 2022 08:44:29 -1000
Message-ID: <YuGHjf9MWjirOWcm@slm.duckdns.org>
References: <20220701093441.885741-1-yukuai1@huaweicloud.com>
 <20220701093441.885741-9-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=om6BXy1+SA87/CyEYzLsfCaTtqizfiZkOOEb0xpUUBA=;
        b=B7/ER0VlJBi4Wqn6vZTg4IUv5o+ct1e++q+yV5mOqrDaPKS3wfHQVW1mQ/WfT13sbj
         PjX3ewiWbtX2QMD8qJrELmgFn5JY2jozltHeSCumUdlF6S6wAcFFTt+CbLs9JLMM/zbM
         OrvrvcthcbZDzrTRYY3MlZsImCnihzTJAQ2UMDm9P1thCMUJe7g69uEztIlHwKUJi7+8
         lQzgfVN5rM4l0MpEflVgy5AAbZOcDEwCxM3wFWKM940MOQFcQwU3mGJk4FDcby0kv+w/
         Sqxy21ZI6VoXDQzErkTC2yEw7n/V6LcETt89rlh0v8127+MFzwjRMJHen9+7RsVp3EY3
         XiKg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220701093441.885741-9-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Fri, Jul 01, 2022 at 05:34:41PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> All related operations are inside 'queue_lock', there is no need to use
> the flag, we only need to make sure throtl_enqueue_tg() is called when
> the first bio is throttled, and throtl_dequeue_tg() is called when the
> last throttled bio is dispatched.

Ah, okay, so the prev patch was to enable this cleanup. Can you please note
so in the previous patch and also that this doesn't cause any functional
changes?

Thanks.

-- 
tejun
