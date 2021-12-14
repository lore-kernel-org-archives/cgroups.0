From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH for-5.16/block] iocost: Fix divide-by-zero on donation from low hweight cgroup
Date: Tue, 14 Dec 2021 06:58:20 -0700
Message-ID: <163949030003.173863.14081933851643062205.b4-ty@kernel.dk>
References: <Ybfh86iSvpWKxhVM@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=IeJEDuwrHuRaa+Ik/SvG/4JB6lqbm2wKrnNt11uuG4A=;
        b=wMb1zuONQwHdeid8S1mJv4yX2A2Yx3Z/jQ3x4ORQDBB7GS1EzW2Fmb33wZTbX8v2H7
         vlHWBrKTa1fuyiHpwFLEwGL4ByT9HaNvQNinFzQlphTwm/GTRuFGTP0nZEtPedwOJC4s
         AlTZTc01fPcj+twJQ5FmKV0qBKTeGPyCVEg46rJ3Whua4tLY2av7mihgHt/8RyrQ5C4Z
         nGeM3Pqadn4UvSal3UTyBkY+8qXs4RVhEnku3LPJfF52pbvKyzkPKLTYmTMnauD+asfC
         vzeOe7HKQJIacSFtyKrCc9WWAzxumDw5Ad4/u9iklppC9Fv5nJ398Igz/W1wjr8iUdbT
         5joA==
In-Reply-To: <Ybfh86iSvpWKxhVM-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 13 Dec 2021 14:14:43 -1000, Tejun Heo wrote:
> The donation calculation logic assumes that the donor has non-zero
> after-donation hweight, so the lowest active hweight a donating cgroup can
> have is 2 so that it can donate 1 while keeping the other 1 for itself.
> Earlier, we only donated from cgroups with sizable surpluses so this
> condition was always true. However, with the precise donation algorithm
> implemented, f1de2439ec43 ("blk-iocost: revamp donation amount
> determination") made the donation amount calculation exact enabling even low
> hweight cgroups to donate.
> 
> [...]

Applied, thanks!

[1/1] iocost: Fix divide-by-zero on donation from low hweight cgroup
      commit: edaa26334c117a584add6053f48d63a988d25a6e

Best regards,
-- 
Jens Axboe


