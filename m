From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] device_cgroup: check if exception removal is allowed
Date: Fri, 2 May 2014 11:29:30 -0400
Message-ID: <20140502152930.GF10204@htj.dyndns.org>
References: <20140424193254.GR29214@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=2e6Zw2pCOnJOgvCcn5R0Ubp+xoUGc+dcSBNrIubvqQ8=;
        b=xCy1ScGz0WQhGqAP3THlPcxyBES2F1IHoF2L3GLh83JiDtE9/bNasPtHG7BA7V1awN
         /PX+7mLZDEYMHELfDflGQFEIt3verIDYc8u/tiS/oxh89S82AQXtVFS1akk9e372PvA0
         6Jy5WxyaMumcObwSG7yxOu8ZCvpeQLOpWBCzwhwqUo8BX9VR5HD3Y1kyAqL54VIJOree
         x1WnEyCaTIoVAzBPZba9Am33LTkh019h8snZcjph2Rg2c3cVIu97GEup16yw1xsd1f8Y
         RaKMBnGbk9ZB17QGpBiObsjXCiP3+EqkFZnLIKbsbZiRdOz3jB6WODSLjqCD1i5bv0fR
         VxIQ==
Content-Disposition: inline
In-Reply-To: <20140424193254.GR29214-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Apr 24, 2014 at 03:32:55PM -0400, Aristeu Rozanski wrote:
> In a scenario when the child cgroup is trying to remove an exception
> which will effectively add more access rights, verify if the parent's
> rules allow it.

Can you please elaborate a bit more on how the bug was introduced and
what its implications are?  People can't really decipher what the
patch means from the above text.

> +/*

/**

> + * parent_allows_removal - check if the parent cgroup allows an exception to
> + *			   be removed

Why is devcg using a different comment form from everything else?

/**
 * FUNC_NAME - one line description
 * @params: description
 *
 * Long description
 */

> + * @childcg: child cgroup from where the exception will be removed
> + * @ex: exception being removed
> + */
> +static bool parent_allows_removal(struct dev_cgroup *childcg,
> +				  struct dev_exception_item *ex)
> +{
> +	struct dev_cgroup *parent = css_to_devcgroup(css_parent(&childcg->css));
> +
> +	if (!parent)
> +		return true;
> +
> +	if (childcg->behavior == DEVCG_DEFAULT_DENY)
> +		/* It's always allowed to remove access to devices */

If you don't wanna add {}, move the comment above if.

> +		return true;
> +
> +	/*
> +	 * Make sure you're not removing part or a whole exception existing in
> +	 * the parent cgroup
> +	 */
> +	return !match_exception_partial(&parent->exceptions, ex->type,
> +					ex->major, ex->minor, ex->access);
> +}

Thanks.

-- 
tejun
