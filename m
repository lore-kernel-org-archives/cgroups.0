From: Jens Axboe <axboe@kernel.dk>
Subject: Re: blk-iocost: fix NULL iocg deref from racing against
 initialization
Date: Tue, 5 Jan 2021 11:33:40 -0700
Message-ID: <a7723952-93f2-d719-29df-c7e25691cf38@kernel.dk>
References: <X/Sj014x+U8ubiFT@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ohK/WOqK+ZvrSsmSNelyPVjobCoSndTH+kRVqdgfQck=;
        b=yFCzBAb7pcp52jJAYR4+TvKZCaWguAg151R8BOkItBOboa6Pf0MRWIgKlY+/3q/RwU
         NaNtTOJF12GlyfeIA8Tannb+uK9ysgMco/LBIu6Pa2ewNKmF8GDiWiyDvkDjwevtgxL0
         89J9KzDXPBmE6AlYfvFZCo4z2KBGTpX27GVlXrw5RAtqyN1m5CyAgzpVIRJbKF5Gukq/
         Q8XKu8zQfKg82GlbE398/jw4vzYt5R5BjtqzGh657vTt0beXCVCA1irAGTwLs9EDMjPx
         qo3J3/OHKFnJ+Webs96VpJJAW/XcVVWuITnQts46kGPxLL1ewl8oYp6GYef2SMA5C1Yn
         ZIhQ==
In-Reply-To: <X/Sj014x+U8ubiFT@mtj.duckdns.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, bsd@fb.com, kernel-team@fb.com

On 1/5/21 10:37 AM, Tejun Heo wrote:
> When initializing iocost for a queue, its rqos should be registered before
> the blkcg policy is activated to allow policy data initiailization to lookup
> the associated ioc. This unfortunately means that the rqos methods can be
> called on bios before iocgs are attached to all existing blkgs.
> 
> While the race is theoretically possible on ioc_rqos_throttle(), it mostly
> happened in ioc_rqos_merge() due to the difference in how they lookup ioc.
> The former determines it from the passed in @rqos and then bails before
> dereferencing iocg if the looked up ioc is disabled, which most likely is
> the case if initialization is still in progress. The latter looked up ioc by
> dereferencing the possibly NULL iocg making it a lot more prone to actually
> triggering the bug.
> 
> * Make ioc_rqos_merge() use the same method as ioc_rqos_throttle() to look
>   up ioc for consistency.
> 
> * Make ioc_rqos_throttle() and ioc_rqos_merge() test for NULL iocg before
>   dereferencing it.

Applied, thanks.

-- 
Jens Axboe

