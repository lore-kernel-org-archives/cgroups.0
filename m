From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next 1/4] block/rq_qos: move implementions of init/exit
 rq-qos apis to blk-rq-qos.c
Date: Wed, 4 Jan 2023 11:30:34 -1000
Message-ID: <Y7Xv+rtqXQM8gf+A@slm.duckdns.org>
References: <20230104085354.2343590-1-yukuai1@huaweicloud.com>
 <20230104085354.2343590-2-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QUxjPqi8cIjWiZ4wgk9iUZ3U2OAiaNP4OQpT53WV9V4=;
        b=XHg29x/xZNjdTm//dbuc775EIoI9HMgi3iyEYs8SyHdybx5CB84wsv0dt8CY18Rb6+
         n8NNZRGZm0EPHN/tL8w/1pzIx1GCaTryX0QV0R/UI7JrYWTUAr3hJ9Qp2iaYPtOg+Jh3
         QQXIhBzb9qDYiD98zixXkhWfzrJE7RUj7UBTHemmMDjKssASMTxLBNyimWO/IxlX6Qt/
         QEocTqc3A9MZWTqSmLuiUkNXiDDCNW0hU43r/6bkTwpt+uHX7/FZV+cRc5ctkX2YDPo+
         gToPpHWLhdLXOpMYeN/OnEstNepYdbn2ikoN7J3fOEsl9CLGMAKYzCAEXEqPHzd1cFm2
         hzCg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230104085354.2343590-2-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Wed, Jan 04, 2023 at 04:53:51PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> These init/exit rq-qos apis are super cold path, there is no need to
> inline them to improve performance. This patch also prepare to use a
> global mutex to protect these apis, move these implementions to
> blk-rq-qos.c so that the global mutex won't be exposed. There are no
> functional changes.
> 
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
