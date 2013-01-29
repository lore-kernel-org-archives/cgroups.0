From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 9/9] devcg: propagate local changes down the hierarchy
Date: Tue, 29 Jan 2013 12:35:00 -0800
Message-ID: <20130129203500.GK6824@mtj.dyndns.org>
References: <20130129190759.117458287@napanee.usersys.redhat.com>
 <20130129190800.590181489@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=DHnfj0hvNxUniQCXP32g0nBG+qwrQpJynrpVA+Tv9sY=;
        b=HmPg1gBCrTmVVBGZzv8hnGiO9QZA4khrNR/rWstSEgPmucRntgxDYbZ/J16W1xmLjr
         otu/0EGHnACiDR/d3Shjq9SQv8fmDaCFSYIDj39s6hnXEkwZzik5KoU7Gpk3OisFwuFR
         /ui3rG4+ewiGzhi+AO7DbaytiZoOxuIawYIMJYwzjzt0JP9WkIA6EEo0N66gqxEbKlbj
         67PgWpi5b5QGtly2gwn6wH7zUlXWk0oB3RgR0drIRUPEODxD6iMtPAu1A1H6XpMUu09K
         P9PkyB1Qt6viAxWUZa60KNPQyiaUyma1Ra8yhRQQhJP/M4D9hHgMZ93O8VplFGdo31BN
         kIXA==
Content-Disposition: inline
In-Reply-To: <20130129190800.590181489-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Hey,

Generally looks good to me although I haven't really delved into the
behavior (you're gonna be there for the fallouts, right?).  Just some
minor comments.

> +static int propagate_behavior(struct dev_cgroup *devcg_root)
> +{
> +	struct cgroup *root = devcg_root->css.cgroup, *pos;
> +	struct dev_cgroup *parent, *devcg, *tmp;
> +	int rc = 0;
> +	LIST_HEAD(pending);
> +
> +	rcu_read_lock();
> +	cgroup_for_each_descendant_pre(pos, root) {
> +		devcg = cgroup_to_devcgroup(pos);
> +		if (is_devcg_online(devcg))
> +			list_add_tail(&devcg->propagate_pending, &pending);
> +	}
> +	rcu_read_unlock();

I think it could be a good idea to factor out the above and document
what's going on and why.

Other than that,

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
