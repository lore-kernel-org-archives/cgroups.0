From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/4] cgroup: reuse css->destroy_work for release agent
Date: Thu, 18 Sep 2014 06:37:34 +0900
Message-ID: <20140917213734.GD15795@mtj.dyndns.org>
References: <54195FE1.9030607@huawei.com>
 <5419606D.4070707@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=wOJ+ZsNGtH8a452xQid88aC8jIvcrPuy6Rohe5IT4oU=;
        b=yAl01+dXGKxJWHz5aW08c8hny/DQBxtDs1tVoHxUqFk1OolFObwXhA/FgyLPpG7HPN
         eL4MfCiA0fqjVVEPlt/Dhq+EvagXKMa/knp2n7wzZrNtX43d/2yC69RHjU5ayborD9Cg
         vyR85BALMg7ko/J3pz547RHJsZSwL0kMBmns7q/bCqvkRjdqbeHWfDZnSjcujMNHvjEm
         XltUCfvoadrNMy6k4h0IisMoBBOFLO95wsx9fZ7x2tXahawSrdxnwOPk91NeNjxCsSB6
         z+I5HTdc3okC3XAPgd7Di73cScvWN33jvWUTyIiovGC6JDpEWrQu7Yy11GiOUCsMXxDN
         bncQ==
Content-Disposition: inline
In-Reply-To: <5419606D.4070707-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Sep 17, 2014 at 06:20:29PM +0800, Li Zefan wrote:
> Currently we use a global work to schedule release agent on removable
> cgroups. We can change to reuse css->destroy_work to do this, which
> saves a few lines of code.
> 
> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
...
> @@ -1587,6 +1581,7 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
>  		INIT_LIST_HEAD(&cgrp->e_csets[ssid]);
>  
>  	init_waitqueue_head(&cgrp->offline_waitq);
> +	INIT_WORK(&cgrp->self.destroy_work, cgroup_release_agent);

It's weird to overload destroy_work like this as invoking
release_agent isn't necessarily related to destruction.  I like the
change overall but can we please just use a separate work item?

Thanks.

-- 
tejun
