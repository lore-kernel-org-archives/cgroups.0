From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/2] blk-iocost: add refcounting for iocg
Date: Thu, 12 Jan 2023 15:15:46 -1000
Message-ID: <Y8CwwghZ0adMsHFC@slm.duckdns.org>
References: <Y7iCId3pnEnLqY8G@slm.duckdns.org>
 <875eb43e-202d-5b81-0bff-ef0434358d99@huaweicloud.com>
 <Y7xbpidpq7+DqJan@slm.duckdns.org>
 <a71f997f-6cae-d57b-85dd-2fd499d238f6@huaweicloud.com>
 <Y72wF/b0/xNRmP7f@slm.duckdns.org>
 <53b30ac8-d608-ba0b-8b1b-7fe5cfed6d61@huaweicloud.com>
 <Y77s0f741mFfGlTO@slm.duckdns.org>
 <4aeef320-c6c8-d9b4-8826-d58f00ea6264@huaweicloud.com>
 <Y8CrloCDGhbU42OH@slm.duckdns.org>
 <efa1c73b-e94f-373f-e535-2cfc32ce2433@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AeckwhmPMW45EEyivIGHK4a0N0SsWyt5j7qOc0U6OBc=;
        b=ndtl4m+cWjUg2p8DP6Y6KGeN0FtPY3sZb3XcirBM9bu1GUMQlwtHJWdPmTUFEBjH+W
         XIUAK3HLuTbzGYXntgLP9ei1RopAt9hihd9sCXmIDX+S3m4WiLKxB20s+BdL0d+Bnt+m
         f64bg4YJADgNJ0PDOfwkr6Wg/ExfAOKuxfVEvWYEoHjHdCioodUwI06nhdvhNvKEW9EA
         Tsvk2+u/r6Gw1axfoe8fobRJJO3qJI0PU/F5tspG4Sw0LtZ8BrHSoinbZyriuyTAUuG5
         FU2z8ucBG280+E0t+MhW7cf22gu8oihqsRHOXzMqeFoA4eOrReWX9uZkfNAPcWFPEa8H
         Iaog==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <efa1c73b-e94f-373f-e535-2cfc32ce2433-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hello,

On Fri, Jan 13, 2023 at 09:10:25AM +0800, Yu Kuai wrote:
> > only activate the policy when the controller is actually enabled. So, idk.
> > What's wrong with synchronizing the two removal paths? blkcg policies are
> > combinations of cgroups and block device configurations, so having exit
> > paths from both sides is kinda natural.
> 
> I still can't figure out how to synchronizing them will a mutex. Maybe
> I'm being foolish...

Hmm... can't you just use e.g. per-bdev mutex which is grabbed by both
blkg_free_workfn() and blkcg_deactivate_policy()?

Thanks.

-- 
tejun
