From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/5] device_cgroup: make may_access() stronger
Date: Mon, 3 Dec 2012 09:44:14 -0800
Message-ID: <20121203174414.GI19802@htj.dyndns.org>
References: <20121127193501.255267751@napanee.usersys.redhat.com>
 <20121127193502.817704289@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=qAsmMK3lC9YTzvWMprDQJpPrVSkFcqWYbR28DxVMVZ8=;
        b=jP3uHD2JDX3tPfkimTOXshZ7+oL5Kl2Mc3S2m+bkBuHACPw13A9ViqZhoJ1lA/J3du
         CDjvqPKLf+kHFxOEf2VD3soOaxMUP/9eHwUfYkZeP+c8I7Kh8ibNMED2j2vxwJ2Kq/QG
         /LMp4q0cu18KgItXRxVqhiDrrtu8SrImGTq4xQyxmNlu6kw7thsg3nNa/+GYehDQ4XLY
         aqk11H2R+ZAkJGGWbV9ALOqYMFwq98hm+z8iKkyVc9h0C/2p8nu1WdS88z+zAF8SAuRk
         8am69uBFL80gw6K3Pc189cRcVjTYb59lFFWIpt3ov2mwKS9tEv7551Bs99/MtEL2urlC
         8kZA==
Content-Disposition: inline
In-Reply-To: <20121127193502.817704289-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, Nov 27, 2012 at 02:35:05PM -0500, Aristeu Rozanski wrote:
> @@ -375,22 +376,33 @@
>  			continue;
>  		if (refex->access & (~ex->access))
>  			continue;
> -		match = true;
> +		match = 1;
>  		break;
>  	}
>  
>  	/*
> -	 * In two cases we'll consider this new exception valid:
> -	 * - the dev cgroup has its default policy to allow + exception list:
> -	 *   the new exception should *not* match any of the exceptions
> -	 *   (behavior == DEVCG_DEFAULT_ALLOW, !match)
> -	 * - the dev cgroup has its default policy to deny + exception list:
> -	 *   the new exception *should* match the exceptions
> -	 *   (behavior == DEVCG_DEFAULT_DENY, match)
> +	 * The only three possibilities are:
> +	 * devcg->behavior == ALLOW, rule behavior == ALLOW
> +	 * devcg->behavior == ALLOW, rule behavior == DENY
> +	 * devcg->behavior == DENY, rule behavior == DENY
> +	 * the remaining
> +	 * devcg->behavior == DENY, rule behavior == ALLOW
> +	 * won't be possible by hierarchy
> +	 *
> +	 * Since we want to simplify the code, here're the possibilites to
> +	 * make easier to understand:
> +	 *
> +	 * devcg behavior   rule behavior  match  result
> +	 * allow            allow          1      0
> +	 * allow            allow          0      1
> +	 * allow            deny           1      0
> +	 * allow            deny           0      1
> +	 * deny             deny           1      1
> +	 * deny             deny           0      0
>  	 */
> -	if ((dev_cgroup->behavior == DEVCG_DEFAULT_DENY) == match)
> -		return 1;
> -	return 0;
> +	if (dev_cgroup->behavior == DEVCG_DEFAULT_ALLOW)
> +		return !match;
> +	return match;

I kinda dislike this.  This isn't a performanc critical path where we
must try our best to shave off a few condition checks.  There's no
reason to encode the test like this.  Please just spell the conditions
out in code rather than trying to build a magic series of equality
tests which somehow ends up spewing out the correct results.

Thanks.

-- 
tejun
