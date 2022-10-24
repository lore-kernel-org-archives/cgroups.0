From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH net] net-memcg: avoid stalls when under memory pressure
Date: Mon, 24 Oct 2022 09:02:12 -0700
Message-ID: <Y1a3BHQqllCEymHi@P9FQF9L96D>
References: <20221021160304.1362511-1-kuba@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666627336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O/N8OMyo9s1B/PNzZrAaI2GwA6VF66/CDcmX3TC5Nt4=;
        b=l4eEMprVk58nUDlv7z8FLEtx1aDuXiDvMj360HMeYTGq6NRIH1TIsuS3fqHASZY9kxebW7
        qvFokj5qToXX63woIoDXoYP8WjTUL76BZfpkZUHbZydTeXRvQyNqJDw5SLNeF1pqSQbwS1
        pqOcY8XcupnBJnfONszHBqJc5ASMClY=
Content-Disposition: inline
In-Reply-To: <20221021160304.1362511-1-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, weiwan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ncardwell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ycheng-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Fri, Oct 21, 2022 at 09:03:04AM -0700, Jakub Kicinski wrote:
> As Shakeel explains the commit under Fixes had the unintended
> side-effect of no longer pre-loading the cached memory allowance.
> Even tho we previously dropped the first packet received when
> over memory limit - the consecutive ones would get thru by using
> the cache. The charging was happening in batches of 128kB, so
> we'd let in 128kB (truesize) worth of packets per one drop.
> 
> After the change we no longer force charge, there will be no
> cache filling side effects. This causes significant drops and
> connection stalls for workloads which use a lot of page cache,
> since we can't reclaim page cache under GFP_NOWAIT.
> 
> Some of the latency can be recovered by improving SACK reneg
> handling but nowhere near enough to get back to the pre-5.15
> performance (the application I'm experimenting with still
> sees 5-10x worst latency).
> 
> Apply the suggested workaround of using GFP_ATOMIC. We will now
> be more permissive than previously as we'll drop _no_ packets
> in softirq when under pressure. But I can't think of any good
> and simple way to address that within networking.
> 
> Link: https://lore.kernel.org/all/20221012163300.795e7b86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org/
> Suggested-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Fixes: 4b1327be9fe5 ("net-memcg: pass in gfp_t mask to mem_cgroup_charge_skmem()")
> Signed-off-by: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

Thanks!
