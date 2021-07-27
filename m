From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] blk-throtl: optimize IOPS throttle for large IO scenarios
Date: Tue, 27 Jul 2021 06:21:11 -1000
Message-ID: <YQAydzEhZfPUpzWI@mtj.duckdns.org>
References: <1626416569-30907-1-git-send-email-brookxu.cn@gmail.com>
 <YPGvIzZUI+QxP1js@mtj.duckdns.org>
 <957ab14d-c4bc-32f0-3f7d-af98832ab955@gmail.com>
 <YP8tPwkJNMAcjDqk@mtj.duckdns.org>
 <34a6f4b5-9055-e519-5693-068f8dcb169c@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aKSXNwDjopSziuCU/tjPk+z1jeKEq3gWP1NdV3AtHro=;
        b=p0y3P4/22F5hQkn3WFmpiaZsoG3SjwD9e4gQmaK7VA6kHL2uLm//Kv2uEa3ojTXZNc
         XwxeYKIpE5ECCXztRDAzRUyUY77SSexmcB38ytVKWg1dgKp45Xmej1t+YsnnliSFzJrn
         OMWdfRoXs218uT6SCOfCikE7/9GtnIjPzbP5jfRCTY/w4wdQALgtYlxSHXUg36/a3LD6
         UG2gADHwg1LleP2jxPRM6H5sstIO4THOD1fXqD8HDzZL5G6K4D2/cXHaRE7XxHZNtsPj
         Y8DwM8N0T7h/cyO8ZJvBnyoSnmLpeX9JZUw0cyBA7pKQpBWkqVwoJhkAmgfrqnyXzsQn
         S8ew==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <34a6f4b5-9055-e519-5693-068f8dcb169c-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, Jul 27, 2021 at 11:06:18AM +0800, brookxu wrote:
> Make blk-throttle use rq-qos may be more elegant. But I found that there may be at least
> one problem that is difficult to solve. blk-throttle supports separate throttle for read
> and write IOs, which means that we cannot suspend tasks during throttle, but rq-qos
> throttle IOs by suspending tasks.

Ah, right, I forgot about that.

> We may be able to relocate the blk-throttle hooks to the rq-qos hooks. Since we may not
> be able to replace the throttle hook, in this case, if we register a rq-qos to the system,
> part of the blk-throttle hooks is in rq-qos and part hooks not, which feels a bit confusing.
> In addition, we may need to implement more hooks, such as IO merge hook.

Would it be possible to just move the blk-throtl throttling hook right next
to the rq-qos hook so that it gets throttled after splitting?

Thanks.

-- 
tejun
