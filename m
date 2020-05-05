From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [block/for-5.7] iocost: protect iocg->abs_vdebt with
 iocg->waitq.lock
Date: Tue, 5 May 2020 09:23:35 -0600
Message-ID: <e4377265-1605-077b-9415-183c8efe3da5@kernel.dk>
References: <20200504232754.GB3209250@mtj.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TPwxKE0klTjrvpCqkN/+GZfurYoGuk/drCYIDVYxA1Q=;
        b=W1y7ye3xLvDWbdVRSKUUL0S+8HrvaPz16PwNA1IjuoxOj8GVxyKW6B6/eMTtHRlIiw
         ocp5PbDJkd5E3DLCWaXeitPpzuGHudOfwlWg5LSj3q6nff83JSBz6DvAeONP/hmEapQN
         2PMBRjrlNEg2eUMQbLK8DAdexla7k7MjnyfemM6nfThLo7eD7rFlFkWVMDUygtBKHDAT
         EPuG8ZLDOPKyb2jXLzt4Midt4KUy4VERIq5gbofnW+NSfKhJpCNaV2ggpvueRJd3SYgV
         vJ5Ed3Tpb+IfkIPJNBfbUrpSCFTJ1tXMu2dTSd1JsQcgNW0A9aaSgJdy9OWOhe932euT
         CXdQ==
In-Reply-To: <20200504232754.GB3209250-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlad Dmitriev <vvd-b10kYP2dOMg@public.gmane.org>

On 5/4/20 5:27 PM, Tejun Heo wrote:
> Subject: iocost: protect iocg->abs_vdebt with iocg->waitq.lock
> 
> abs_vdebt is an atomic_64 which tracks how much over budget a given cgroup
> is and controls the activation of use_delay mechanism. Once a cgroup goes
> over budget from forced IOs, it has to pay it back with its future budget.
> The progress guarantee on debt paying comes from the iocg being active -
> active iocgs are processed by the periodic timer, which ensures that as time
> passes the debts dissipate and the iocg returns to normal operation.
> 
> However, both iocg activation and vdebt handling are asynchronous and a
> sequence like the following may happen.
> 
> 1. The iocg is in the process of being deactivated by the periodic timer.
> 
> 2. A bio enters ioc_rqos_throttle(), calls iocg_activate() which returns
>    without anything because it still sees that the iocg is already active.
> 
> 3. The iocg is deactivated.
> 
> 4. The bio from #2 is over budget but needs to be forced. It increases
>    abs_vdebt and goes over the threshold and enables use_delay.
> 
> 5. IO control is enabled for the iocg's subtree and now IOs are attributed
>    to the descendant cgroups and the iocg itself no longer issues IOs.
> 
> This leaves the iocg with stuck abs_vdebt - it has debt but inactive and no
> further IOs which can activate it. This can end up unduly punishing all the
> descendants cgroups.
> 
> The usual throttling path has the same issue - the iocg must be active while
> throttled to ensure that future event will wake it up - and solves the
> problem by synchronizing the throttling path with a spinlock. abs_vdebt
> handling is another form of overage handling and shares a lot of
> characteristics including the fact that it isn't in the hottest path.
> 
> This patch fixes the above and other possible races by strictly
> synchronizing abs_vdebt and use_delay handling with iocg->waitq.lock.

Applied, thanks.

-- 
Jens Axboe

