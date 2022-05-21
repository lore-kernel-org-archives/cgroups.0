From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next v3 2/2] blk-throttle: fix io hung due to
 configuration updates
Date: Fri, 20 May 2022 19:00:15 -1000
Message-ID: <Yohx305S2bkSemQx@slm.duckdns.org>
References: <20220519085811.879097-1-yukuai3@huawei.com>
 <20220519085811.879097-3-yukuai3@huawei.com>
 <20220519095857.GE16096@blackbody.suse.cz>
 <a8953189-af42-0225-3031-daf61347524a@huawei.com>
 <20220519161026.GG16096@blackbody.suse.cz>
 <73464ca6-9412-cc55-d9c0-f2e8a10f0607@huawei.com>
 <fe3c03f7-9b52-7948-075d-cbdf431363e1@huawei.com>
 <20220520160305.GA17335@blackbody.suse.cz>
 <Yoe/1BRYzSRI0JBd@slm.duckdns.org>
 <97be6af0-ea94-f4ee-5ab2-02b6fc02cbff@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TT52cKU8Oo9pvmq53QQ/gpy/l4ehF6WUmfOqY1Ifb5w=;
        b=Ri4Q2yDK9UddopX/efZVecxLBB/qzjAX8bOizIYqnYBz/IVPnAqRxKzwm1vJ0T8X0+
         nuqli3W/XU2w+3+GIA1ghzD5MCISZJd+atg1PhfSHFZW8V7M+vLgShlWqqVmmArVHAAj
         zffrOtgFX9Rqj5/HifljRxmrvGxNRZ4O1kzoXZZs4f9WN5Ykt4MQYUKi7LteHzVVgHyW
         bpJ7xFRb4wFhtzMY02KmxQhyr0XbS9Y1JJhNAkx9exmbRdG/+E4chTBnMvnwAbkQWjFw
         0NmE6kHrDNabzqwLUR32uOHW5Rv+xwsWUiIYDkEz1PtdnS4d6hk0vr0HXy7biSD13qSm
         FTBQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <97be6af0-ea94-f4ee-5ab2-02b6fc02cbff-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Sat, May 21, 2022 at 11:51:11AM +0800, yukuai (C) wrote:
> It's right the problem is self-inflicted. However, I do think with
> Michal's suggestion, how throttled bios are handled while new config is
> submitted really make sense from the functional poinit of view.
> 
> Do you think the solution is OK?

I haven't followed the details but anything which isn't overly complex and
doesn't produce extra budget or eat into existing one on config change is
fine by me.

Thanks.

-- 
tejun
