From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH block/for-next] iocost: fix infinite loop bug in
 adjust_inuse_and_calc_cost()
Date: Mon, 14 Sep 2020 19:47:19 -0600
Message-ID: <e9e616d2-4bba-43b4-e41f-3c73f65371aa@kernel.dk>
References: <20200914150513.GC865564@mtj.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/9oiy6NhFDTGuIxMwjEr15PaiJFbKdR5/rgyk3WXdXc=;
        b=DtQVwdE2S9R/KfRwpS6ild8EgzksvCRGPDk9J+V8CdffdQfgowKv8CpUq48KX75Y1P
         669X8UNtYFor3iEDN0x0oGQoMt/dcse4uetjme/WNloj199sgOCSPdMGd69BZyG/98KT
         34HvirvPnAlPClPnxlAn/sH/HTAEL1OEJTUhT99X6xUsnAdARcdFKTgwpDARJ3p6GRaJ
         uFLHKBRC6E2GMc2MGJEDZJ4ckCz0Ba8Lan+3ifA+aA80V6O/IDFgL9cjpmYUcFChqw9a
         mavI984e7SNomsxxXorHzZN2hHE0qmiQCabw1lyz4nGWxbkz0kKDloKpkLZWcPlnHUnW
         UBow==
In-Reply-To: <20200914150513.GC865564-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On 9/14/20 9:05 AM, Tejun Heo wrote:
> adjust_inuse_and_calc_cost() is responsible for reducing the amount of
> donated weights dynamically in period as the budget runs low. Because we
> don't want to do full donation calculation in period, we keep latching up
> inuse by INUSE_ADJ_STEP_PCT of the active weight of the cgroup until the
> resulting hweight_inuse is satisfactory.
> 
> Unfortunately, the adj_step calculation was reading the active weight before
> acquiring ioc->lock. Because the current thread could have lost race to
> activate the iocg to another thread before entering this function, it may
> read the active weight as zero before acquiring ioc->lock. When this
> happens, the adj_step is calculated as zero and the incremental adjustment
> loop becomes an infinite one.
> 
> Fix it by fetching the active weight after acquiring ioc->lock.

Applied, thanks.

-- 
Jens Axboe

