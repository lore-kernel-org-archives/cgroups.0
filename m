From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 9/9] blk-throttle: clean up flag 'THROTL_TG_PENDING'
Date: Wed, 17 Aug 2022 07:54:15 -1000
Message-ID: <Yv0rR9gBL0qbYeXp@slm.duckdns.org>
References: <20220802140415.2960284-1-yukuai1@huaweicloud.com>
 <20220802140415.2960284-10-yukuai1@huaweicloud.com>
 <Yvv6kk/RD5LT+3dk@slm.duckdns.org>
 <65d93ec6-2465-35f1-314f-f092ce631100@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=M9F5QNFdEfK57sV2UQvJmFf03hDAwzaS3TgU89Piblw=;
        b=LKm3raamiQttkOiXSxZhNzHXFXXkPDRQ+4So33YQ27Vizpu1Cu379NL61euS+MnNl3
         uB4IGY1VmCTQlXPdq0AlITppYn2+v8d+5T7Ij6Itk5QWQBHeDxdAnDkH6Y6oOp2/ocN9
         t40wnKzsqNYwfMf4PDSSN6XJHJf0tqOIPzrDSYRWQ0CqkO8+q5GW7afZmNxSwwNczKR0
         0gTeSv3QwwleUSv2qWBT5NZ7jZmJGlgDhYolxttNqWjfwyBzonaxlXQSzVBa5yPmW8Pw
         t65h/wtiBlWZ4GmzQebHBmX3XYeLm+gNygvcGB/uWweffCD6mNMKcOd2NmHQHf9s9zqb
         0k8A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <65d93ec6-2465-35f1-314f-f092ce631100-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hello,

On Wed, Aug 17, 2022 at 09:45:13AM +0800, Yu Kuai wrote:
> > I don't know whether this is better or not. It's minutely less lines of code
> > but also makes the code a bit more fragile. I'm ambivalent. At any rate,
> > please move these trivial patches to the head of the series or post them
> > separately.
> 
> Can I ask why do you think this patch makes the code a bit more fragile?

It's just one step further removed. Before, the flag was trivially in sync
with the on queue status. After, the relationship is more indirect and
easier to break accidentally. Not that it's a major problem. Just not sure
what the benefit of the change is.

> By the way, I'll post these trivial patches separately.

Sounds great.

Thanks.

-- 
tejun
