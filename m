From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 4/5] blk-iocost: fix sleeping in atomic context
 warnning
Date: Thu, 8 Dec 2022 05:59:36 -1000
Message-ID: <Y5IJ6Nk56KPBhpfr@slm.duckdns.org>
References: <20221104023938.2346986-1-yukuai1@huaweicloud.com>
 <20221104023938.2346986-5-yukuai1@huaweicloud.com>
 <Y3K8MSFWw8eTnxtm@slm.duckdns.org>
 <3da991c6-21e4-8ed8-ba75-ccb92059f0ae@huaweicloud.com>
 <Y306xJV6aNXd94kb@slm.duckdns.org>
 <1f52ccb1-c357-a2a0-ef9d-48d7e2eb51f8@kernel.dk>
 <Y31sYFdA2lHIvjt3@slm.duckdns.org>
 <ec3754a6-3249-51ab-b659-fd795884e346@huaweicloud.com>
 <f227e4bd-c74b-a02e-2a02-11a1376ee4f9@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q0YLsvBKzhSCVgibbSxOvtb/WdQ/EJIsYcqmRJMPdrA=;
        b=LKqMi50ut5W+4QYLYDzZRJz8rOYDM1FZOI+bsaRUBjbfPxkaXOkGHv/B58zlQJCVp9
         MOjRUaRqxNz0nLVuO6/F76JbXbGZitk+2iyDmotSKGPXPoVVHHddmOrwt9KP6Mv6y5Xd
         SxD/qLNSLtneYFA9954fdAcCxDvWe7t+RaCdqX50dbiBJuc0xdbdRlVvJKMOZr6k2AeA
         UN4OLtD63b3uEgMi5eMop+qH9rGyXYzEIxZ1PinFgbvoWMIZ8pq6K8gfKFZ/b8EHRO6N
         rXk0i0ECbUePeDcBgMkYPccKs/o9Q4EQc3aSt5FYGtktl4E40BnuiUuFe8kE39ATlds/
         GDuA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f227e4bd-c74b-a02e-2a02-11a1376ee4f9-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Mon, Dec 05, 2022 at 05:39:33PM +0800, Yu Kuai wrote:
> Hi, Tejun
> 
> 在 2022/11/23 18:22, Yu Kuai 写道:
> > Hi, Tejun
> > 
> > 在 2022/11/23 8:42, Tejun Heo 写道:
> > > On Tue, Nov 22, 2022 at 05:14:29PM -0700, Jens Axboe wrote:
> > > > > > Then match_strdup() and kfree() in match_NUMBER() can be replaced with
> > > > > > get_buffer() and put_buffer().
> > > > > 
> > > > > Sorry about the late reply. Yeah, something like this.
> > 
> 
> I wonder can we just use arary directly in stack? The max size is just
> 24 bytes, which should be fine:
> 
> HEX: "0xFFFFFFFFFFFFFFFF" --> 18
> DEC: "18446744073709551615" --> 20
> OCT: "01777777777777777777777" --> 23
> 
> Something like:
> #define U64_MAX_SIZE 23
> static int match_strdup_local(const substring_t *s, char *buf)
> {
> 	size_t len = s->to - s->from;
> 
> 	if (len > U64_MAX_SIZE)
> 		return -ERANGE;
> 
> 	if (!s->from)
> 		return -EINVAL;
> 
> 	memcpy(buf, s->from, len);
> 	buf[len] = '\0';
> 	return 0;
> }
> 
>  static int match_u64int(substring_t *s, u64 *result, int base)
>  {
> 	char buf[U64_MAX_SIZE + 1];
>  	int ret;
>  	u64 val;
> 
> 	ret = match_strdup_local(s, buf);
> 	if (ret)
> 		return ret;
>  	ret = kstrtoull(buf, base, &val);
>  	if (!ret)
>  		*result = val;;
>  	return ret;
>  }

Oh yeah, absolutely. That's much better.

Thanks.

-- 
tejun
