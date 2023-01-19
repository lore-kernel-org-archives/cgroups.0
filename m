From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: switch blk-cgroup to work on gendisk
Date: Thu, 19 Jan 2023 07:13:51 -1000
Message-ID: <Y8l6TySjEuGT9Q+5@slm.duckdns.org>
References: <20230117081257.3089859-1-hch@lst.de>
 <Y8l34/qeHPLV4rKJ@slm.duckdns.org>
 <20230119170526.GA5050@lst.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HFfg4vjHMlgAnxwHU0IZDYXZDE9o/oiWwSlrAYq3R5g=;
        b=X+pv9m4dyfqTTh7NZfU1L4amF07biWIPm63cC9fNYYpkbNI0qpBHzcRDEv4T/Ejr6i
         A8E2+JfZ8da4ELFsiatHjimOU/8/kDX4+Q2aI4BH5PlPLP/vNFa9ivtY4/SeqnH4eQt7
         3e5QyZ3SiaUZmmuYD2krSfow7EB8PfehPb2FJ6/jkd4AvvjmG/wMjAWv6r4mxsNPgLQ+
         YEk2ItBSLWk4QGxz9SHfCz73gwCT0SaDHLePGGsb//2+m8NuJX4oBZtDS2poXWWNLHfE
         CesCZu9SCOOJuAaxeea6v6eSExq26OGrje6hH+Q7kSvUlpXYKXyfvWO0f+X1BxpOsUGR
         IX2Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230119170526.GA5050-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jan 19, 2023 at 06:05:26PM +0100, Christoph Hellwig wrote:
> Yes, it can.  Not sure if my sentence was unclear, but:
> 
>  - everything doing non-passthrough I/O only should be in the gendisk
>  - everything related to blk-mq, including infrastruture for passthrough
>    should remain in the request_queue
> 
> The idea that the request_queue will eventually become a blk-mq only
> data structure and not exist (or just have a very leight weight stub)
> for bio based drivers.

That makes sense. I was thinking about it the other way around. Yeah, genhd
would exist for everybody. request_queue only for the ones which are
actually handling rq's.

Thanks.

-- 
tejun
