From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/3] cgroup: don't destroy the default root
Date: Tue, 3 Jun 2014 08:57:28 -0400
Message-ID: <20140603125728.GA26210@htj.dyndns.org>
References: <538D4956.5050205@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=iHiTWTLrd/f4jn5VD/8Cz3d8p89t2VzJ7Y9jhnN7VPo=;
        b=m0xVDkqFotejR0dI/biPiTpy+N949kQ8unOsBQD7lgz3UeTpHfCTz3zsalDk8cRJJM
         lDDy41yCMCHbJewTwDxHZaK1PPgg8KR2U0gOzQI4HPhcvD0ZOchEtXMTn+YVtyy+VyF5
         IqydT2+0Ji9F5yoLE+SAtTxZcdNeYb+xdMC55BBdenxSQI7ubM5nxzbRXyOmINWkDoVD
         1/QGWk0y+O1CNRryUfOn5pxyAus0N2Yw9RB/FV8CTpUAo7f+W9VufsV8krjHcaBXRl2U
         /9PfMY1Zj+rBg8l6t/8o+Hlo30N3/WSj2z1jRAOE98dSHGZ5hCRt0XPY8WVXcxjNLNHg
         TAxw==
Content-Disposition: inline
In-Reply-To: <538D4956.5050205-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Li.

On Tue, Jun 03, 2014 at 12:04:38PM +0800, Li Zefan wrote:
>  static void cgroup_get(struct cgroup *cgrp)
>  {
>  	WARN_ON_ONCE(cgroup_is_dead(cgrp));
> -	css_get(&cgrp->self);
> +	if (!(cgrp->self.flags & CSS_NO_REF))
> +		css_get(&cgrp->self);

Hmmm?  The same condition is tested by css_get().  Why should it be
tested again here?

>  static void cgroup_put(struct cgroup *cgrp)
>  {
> -	css_put(&cgrp->self);
> +	if (!(cgrp->self.flags & CSS_NO_REF))
> +		css_put(&cgrp->self);

Ditto.

> @@ -1781,10 +1783,12 @@ static void cgroup_kill_sb(struct super_block *sb)
>  	 * This prevents new mounts by disabling percpu_ref_tryget_live().
>  	 * cgroup_mount() may wait for @root's release.
>  	 */
> -	if (css_has_online_children(&root->cgrp.self))
> +	if (css_has_online_children(&root->cgrp.self)) {
>  		cgroup_put(&root->cgrp);
> -	else
> -		percpu_ref_kill(&root->cgrp.self.refcnt);
> +	} else {
> +		if (root != &cgrp_dfl_root)
> +			percpu_ref_kill(&root->cgrp.self.refcnt);
> +	}

As conceptually percpu_ref_kill() just puts the base ref and the
dfl_root's refcnt never reaches zero, it won't actually trigger.
Hmmm.... wouldn't the above leak a ref each time the default hierarchy
is unmounted tho?  Shouldn't it be like the following?

	if (root == &cgrp_dfl_root || css_has_online_children(...))
		cgroup_put(&root->cgrp);
	else
		percpu_ref_kill(...);

Thanks.

-- 
tejun
