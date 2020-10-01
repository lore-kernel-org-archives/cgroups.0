From: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cgroup: Delete unnecessary if statement in css_visible()
Date: Thu, 1 Oct 2020 14:44:26 +0000
Message-ID: <20201001144426.GA8928@haolee.github.io>
References: <20200829100202.GA855@haolee.github.io>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zMEk1N3CPCYeqn3NdVc8YKuWmziT/BdSn/3LxjNiWOU=;
        b=oQQBAehJs1Sn1ReuyfeqJbYvwoxoA8y+v5MEwvM2JIUhO3ln3XX1m/RkxitRT5Va+O
         NZOZMTBf53KxgTUUu7JauIBYEOLXSyOmljXm2VWWePOfOdDpVQbwfGHXaN9fOAQCSq7A
         j1M0/gcMDuIbO/QiA6piA4mrs5YbNaVagVsf9TSbFahelXCeQnyoZr/CEvh521IVNTWz
         rNkogept4EfC35lmArB9frWAs8+81EqlPoW+c8wgaw3ey9v8EqB86AM4M/fH0rSIDHQF
         aNW79D0G9oiJTuXKtcNjugOVD5gY5PsyO76bZq2IXoGF+w22aa3auu9JsAZj+RC3nV9+
         u73Q==
Content-Disposition: inline
In-Reply-To: <20200829100202.GA855-aLGwGs2JoHKXlosIQRE7iA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi, ping...

On Sat, Aug 29, 2020 at 10:03:16AM +0000, Hao Lee wrote:
> css_visible() is called in either cgroup_apply_control_enable()
> or cgroup_apply_control_disable().
> In cgroup_apply_control_enable(), we have checked ss_mask before calling
> css_visible(), so there is no need to do the same thing again.
> In cgroup_apply_control_disable():
>  - If css->parent is not NULL, we have checked ss_mask in the
>    second condition, so there is no need to do the same thing again.
>  - If css->parent is NULL, dsct is root cgroup so the deleted if
>    statement is always false and there is no need to keep it.
> 
> Signed-off-by: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  kernel/cgroup/cgroup.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index dd247747ec14..b6714166106d 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -3023,8 +3023,6 @@ static bool css_visible(struct cgroup_subsys_state *css)
>  
>  	if (cgroup_control(cgrp) & (1 << ss->id))
>  		return true;
> -	if (!(cgroup_ss_mask(cgrp) & (1 << ss->id)))
> -		return false;
>  	return cgroup_on_dfl(cgrp) && ss->implicit_on_dfl;
>  }
>  
> -- 
> 2.24.1
> 
