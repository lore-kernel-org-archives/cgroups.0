From: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cgroup: Delete unnecessary if statement in css_visible()
Date: Tue, 8 Sep 2020 12:48:52 +0000
Message-ID: <20200908124852.GB22780@haolee.github.io>
References: <20200829100202.GA855@haolee.github.io>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tWON0+1XdczHoZAJuQK9B5Y7ioXiOI58hC6mWgDZwPw=;
        b=KC+X7VswXrScqirdxGrptiUf3sW5/V9eti0jfe/rQeuXOmuHl020tCgfg6WEgzkqoa
         hhdPEQP/9JV0KpAN9nzQoEsl5H7c5w+VudjujLIi2sXPGQaEDOpGjDNQidZavdZflIyj
         TFx3JhxQUVN/bJ9/3F0O1Eq6DJvWFDHeJYFBpDfcN+F6fwz57sMdk7tBoofKS64yL0AB
         vyI5U1d6E4bB/SHZ5ioQp4uLZnzSKqicBI8h5m1sgy8+O4lRvyEp2ovdP9M8fk00Nd9Q
         bi0+VJRa+A92OXPuX+Bw1GOFQUnV0Ta6Do8F9lRRXsfdDfnn9MNbcs3cVNgzsNq2/0iW
         sF9g==
Content-Disposition: inline
In-Reply-To: <20200829100202.GA855-aLGwGs2JoHKXlosIQRE7iA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

ping

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
