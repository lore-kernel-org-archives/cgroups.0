From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 9/9] blk-throttle: clean up flag 'THROTL_TG_PENDING'
Date: Fri, 19 Aug 2022 07:35:20 -1000
Message-ID: <Yv/J2CXNdEimfqlv@slm.duckdns.org>
References: <20220802140415.2960284-1-yukuai1@huaweicloud.com>
 <20220802140415.2960284-10-yukuai1@huaweicloud.com>
 <Yvv6kk/RD5LT+3dk@slm.duckdns.org>
 <65d93ec6-2465-35f1-314f-f092ce631100@huaweicloud.com>
 <Yv0rR9gBL0qbYeXp@slm.duckdns.org>
 <841b7b5a-b908-649a-c09d-32c8de5f1c14@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc;
        bh=HJOADyjEijTZgHMmhk5s3Tca02tMu8m4cNUu2EhYaAU=;
        b=fdmiJtb9RMBLJTQ+Xgl/kx6fm6FmEyy0L/lYlYxIWJX5k3m+R5z3YbZgU7aYih8WAc
         sAmQjBqm9+W17s6M38OvDRgjiaSaOqlC0SCu+JBOU3BI1QYBGiJOsQ+t76kaxgeBcVGJ
         NuCOoSKl8ukmGAzUbJrV5NkBVynK+S6LGQjUYKInpZa7u/wu9ffgjzLdBX0VsxlKllze
         1VjABlNkXWdpcbqbtajq/AT7I3QwDIS9ZOX2ev3qXXy/waWCcM9UnVkD2OOyffE+BsUR
         ZRZQCqFQ25mZ5LqtHndedni2VRA0mWJ1bu8qjDcUWiWZEPkPcZiQmUfAl3l5vL+MdaJs
         46vQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <841b7b5a-b908-649a-c09d-32c8de5f1c14-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Thu, Aug 18, 2022 at 05:29:39PM +0800, Yu Kuai wrote:
> Hi, Tejun!
> 
> 在 2022/08/18 1:54, Tejun Heo 写道:
> > Hello,
> > 
> > On Wed, Aug 17, 2022 at 09:45:13AM +0800, Yu Kuai wrote:
> > > > I don't know whether this is better or not. It's minutely less lines of code
> > > > but also makes the code a bit more fragile. I'm ambivalent. At any rate,
> > > > please move these trivial patches to the head of the series or post them
> > > > separately.
> > > 
> > > Can I ask why do you think this patch makes the code a bit more fragile?
> > 
> > It's just one step further removed. Before, the flag was trivially in sync
> > with the on queue status. After, the relationship is more indirect and
> > easier to break accidentally. Not that it's a major problem. Just not sure
> > what the benefit of the change is.
> 
> If you are worried about that, I can keep the flag, then the last two
> patches will cleanup:

I wasn't necessarily worried. It's more that I couldn't tell why the code is
better afterwards. Maybe update the commit message to explain why the new
code is better?

Thanks.

-- 
tejun
