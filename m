From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next v2 2/9] blk-iocost: improve hanlder of match_u64()
Date: Thu, 1 Dec 2022 00:08:48 -1000
Message-ID: <Y4h9MEd3q4LXDGQq@slm.duckdns.org>
References: <20221130132156.2836184-1-linan122@huawei.com>
 <20221130132156.2836184-3-linan122@huawei.com>
 <Y4e90zFnhhq764lP@slm.duckdns.org>
 <7e4f1cea-2691-9b81-35f6-0dd236149f56@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x7QUbC62dh1yGOD50m45VAuI8cYxtojjn7C+uZOwpQw=;
        b=CeZFgZoW2rpZ3wb4OIITdw6PZfPwrOWAdcEismfeizU78ewLtv3ymPltZr32jLCUE4
         G3sZ5/Hz2BCeIfKATdzFLu2C/uzX3DvEqhCNJ3bQ2k3/xeQyiyYJfA8FRaKw6qdCl+/A
         SaDslbrhDpffqAN0sXHDsHmqGbZEGPggDA5MQ+MBicHBGZsPy3z2DSzoO0MAAi0ba1pA
         /EWtJpwtCigHCFk+0PnK3X8phb4SLCB8pAeaWdh5QBI3Iu2W+o7uvYw6/rxISN2S8W2K
         wKddXVMfWWgCJRirTX5a6WC2gWayBiK5I4a0vGcrLbdtr7NUVl5TUbh10nERAJViKXg1
         rj6w==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7e4f1cea-2691-9b81-35f6-0dd236149f56-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Thu, Dec 01, 2022 at 10:15:53AM +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2022/12/01 4:32, Tejun Heo 写道:
> > On Wed, Nov 30, 2022 at 09:21:49PM +0800, Li Nan wrote:
> > > From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > > 
> > > 1) There are one place that return value of match_u64() is not checked.
> > > 2) If match_u64() failed, return value is set to -EINVAL despite that
> > >     there are other possible errnos.
> > 
> > Ditto. Does this matter?
> > 
> 
> It's not a big deal, but I think at least return value of match_u64()
> should be checked, we don't want to continue with invalid input, right?

Yeah, sure.

> By the way, match_u64() can return -ERANGE, which can provide more
> specific error messge to user.

I'm really not convinced going over 64bit range would be all that difficult
to spot whether the error code is -EINVAL or -ERANGE. There isn't anything
wrong with returning -ERANGE but the fact that that particular function
returns an error code doesn't necessarily mean that it *must* be forwarded.

Imagine that we used sscanf(buf, "%llu", &value) to parse the number
instead. We'd only know whether the parsing would have succeeded or not and
would probably return -EINVAL on failure and the behavior would be just
fine. This does not matter *at all*.

So, idk, I'm not necessarily against it but changing -EINVAL to -ERANGE is
pure churn. Nothing material is being improved by that change.

Thanks.

-- 
tejun
