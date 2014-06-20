From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/5] cgroup: fix mount failure in a corner case
Date: Fri, 20 Jun 2014 15:10:25 -0400
Message-ID: <20140620191025.GA28324@mtj.dyndns.org>
References: <53994943.60703@huawei.com>
 <5399496D.6060003@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Htw72IC0nAcEaFbrlMvHkFYeGvmsnZ+LTcGin7kmmEI=;
        b=MKBQnoMFxrwqjafg3Rs0dVCE+2VeQGXuk+xw76D57e4Uq0rXI4vkX2AXGlEt/j4Q8S
         32FSfhP65LWk3OoIDz8qvLJls9l6PziVW1tUtpWO/u0WASwdheO8lol+wOpUQeYIgJjX
         hMQ7Os2v1CHs2dMB1EbeVBvYjG6CuJ697ZrUiDVKwlMnyGSWpsJEaTHIg0nXmpKxUG7U
         1iudDavJKJ9k1pb8lAtnuwsgt4q5i+xYgMrwie5jKd3kQM9QLOg63GZRyAweqIAMhlzY
         HmgjfP7kYDtSGCeKAxb0tvoVBacw14qdSoouPy7eIj7J7qFrrNVn1elM5iI7ySQ+1vlM
         ONMQ==
Content-Disposition: inline
In-Reply-To: <5399496D.6060003-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Jun 12, 2014 at 02:32:13PM +0800, Li Zefan wrote:
> @@ -1677,6 +1679,22 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
>  		goto out_unlock;
>  	}
>  
> +	/*
> +	 * If some subsystems have been bound to existing cgroup hierarchies,
> +	 * but those hierachies are being destroyed, let's wait a little bit
> +	 * and retry.
> +	 */
> +	for_each_subsys(ss, i) {
> +		if (!(opts.subsys_mask & (1 << i)))
> +			continue;
> +		if (!percpu_ref_alive(&ss->root->cgrp.self.refcnt)) {

Can't we just do tryget_live() instead and then put before retrying?
It's not exactly a hot path and the operations are dirt cheap anyway.

Thanks.

-- 
tejun
