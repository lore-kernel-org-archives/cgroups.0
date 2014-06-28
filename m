From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/3] cgroup: fix mount failure in a corner case
Date: Sat, 28 Jun 2014 07:58:39 -0400
Message-ID: <20140628115743.GB10829@htj.dyndns.org>
References: <53AD18D0.3090100@huawei.com>
 <53AD2852.2060304@huawei.com>
 <53AD35A8.7030908@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=wUsaJq19i4KwVw3I1Y7HQFBggzWAGgnZLvuF7JOss6w=;
        b=p0dDygmGPZx4rAKslfFrUEP9mfZ0Re+nsmstY/L2yYEy3xqTjteNOJQ8p1RZclmWMv
         Hvy+B3EtmRrWduhAe5XDzjN7/qmNPC9reaG3sAp9cXqsAJyI/kT+0bNDTKhabYtAyXAd
         68WL607468C7UYJ1LqgIwwgvq8Hfd4BW+RZfR63zbZZnrFc/rpF6ideEf5DWIsow74Qb
         hXvK4eFP5kVd/VWTn1GJqaSaJZWUCtktW8OE203CVjTAdSHpc7VAjZBaMfn5c+r+UoeB
         8cgeIyWAOfd0UgmPUDBwA7L4GMN+naa3K9DvaHIYarLT/BxD77+bOjwX4U5BXTA7I4sI
         SBZg==
Content-Disposition: inline
In-Reply-To: <53AD35A8.7030908-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Li.

On Fri, Jun 27, 2014 at 05:13:12PM +0800, Li Zefan wrote:
> +	for_each_subsys(ss, i) {
> +		if (!(opts.subsys_mask & (1 << i)) ||
> +		    ss->root == &cgrp_dfl_root)
> +			continue;
> +
> +		if (!percpu_ref_tryget_live(&ss->root->cgrp.self.refcnt)) {
> +			mutex_unlock(&cgroup_mutex);
> +			msleep(10);
> +			ret = restart_syscall();
> +			goto out_free;
> +		}

Why not just put it immediately?  We know that it's not gonna be
destroyed while holding cgroup_mutex.  It may look a bit weird but
this is a pretty special case anyway and deferring put doesn't buy
anything.

Thanks.

-- 
tejun
