From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 09/11] blk-throttle: remove unnecessary check for
 validation of limit index
Date: Wed, 23 Nov 2022 08:31:55 -1000
Message-ID: <Y35nG1CguzXf0GX8@slm.duckdns.org>
References: <20221123060401.20392-1-shikemeng@huawei.com>
 <20221123060401.20392-10-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0WaeNxRFAhW4+njSz3oymHAfGYjiGBjYSgTnlxkSAys=;
        b=jxxUgRm3rae626X/F21Ixmc+goaczD8yETEXBu7QKc5qDMcofymNGMqTIMRVMFSRgo
         MWh0pdG+HtHw/CoioHszw6hAOBoiZlBfcQaWru3S0hQoUOw0a150L6bPjTztvDXr6EHd
         LQHcc7w27lcEfmNURWK2YGbv5ooe00NXtY9/nHbuKrqPlRfT6GjcjDNIZQx7wHCcEeiK
         uFNz1BwW7Y/3JL5VqEoKKeLWI94+tneUv4fB0k9afElk693ZB3qerfUL+jP+GlR6/LAb
         AmqWawnah09OIwkxNg3OtH5d6XnCCa5Bp02R8mdnjDRzhKp8PWkO5lPULhVQTq8eJzxB
         cxdA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221123060401.20392-10-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Nov 23, 2022 at 02:03:59PM +0800, Kemeng Shi wrote:
> We always keep limit index valid as following:
> Max limit is always valid and low limit can only be invalidated in
> blk_throtl_update_limit_valid. Each time low limit may become invalid
> after blk_throtl_update_limit_valid is called, we will check and make
> sure current limit index is valid.
> 
> It's reasonable to always keep limit index valid, so we can remove this
> check.

It's not obvious to me that it's correct and I'm not sure what we're gaining
by removing this while risking subtle breakages.

-- 
tejun
