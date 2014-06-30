From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 3/3] cgroup: fix a race between cgroup_mount() and
 cgroup_kill_sb()
Date: Mon, 30 Jun 2014 10:23:24 -0400
Message-ID: <20140630142324.GD14807@htj.dyndns.org>
References: <53B0DE66.5080100@huawei.com>
 <53B0DEA3.80807@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=MiaW4a8nSKcSqhkG0yb7HHmm7zmLkCCfgtDmfayLRG8=;
        b=gJfHMqnJKMTtBmnPYC31uW6de/cfSQXTirX6QnI+CudyzIO2EFSeDrRjc3jk2nYFzm
         TEUtdxdNAhEmMYhKuuSSHiE4GNJFCjHT/pfTHFverglxin46LbB1wkAQEqZXJfUivIwW
         aBul1RdelnLLxnt6P9kKW40R72X6IyD0CDXYSV7VTPo3llu5fRZnSVHPl1O/VAwr5gj+
         3czAyVuOgnqikB3MGaXYaTUMkBTUGfF3xP8gFHioEJZpI0KNZXdRtAcmWOE4m8APt2dV
         wZkVFTTITlK0oQks7hQ63gu98hHccco0uKFTTpT3BItdtgxINdBqVIlMaOY4SaF3LhFh
         v6zQ==
Content-Disposition: inline
In-Reply-To: <53B0DEA3.80807-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>

Hello, Li.

I applied the three patches with some updates (mostly comments).
Dynamic root management is turning out to be pretty ugly but I think
we can clean it up a bit.

On Mon, Jun 30, 2014 at 11:50:59AM +0800, Li Zefan wrote:
> @@ -1790,6 +1795,17 @@ out_free:
>  	dentry = kernfs_mount(fs_type, flags, root->kf_root, &new_sb);
>  	if (IS_ERR(dentry) || !new_sb)
>  		cgroup_put(&root->cgrp);
> +
> +	if (sb) {
> +		/*
> +		 * On success kernfs_mount() returns with sb->s_umount held,
> +		 * but kernfs_mount() also increases the superblock's refcnt,
> +		 * so calling deactivate_super() to drop the refcnt we got when
> +		 * looking up cgroup root won't acquire sb->s_umount again.
> +		 */
> +		WARN_ON(new_sb);
> +		deactivate_super(sb);
> +	}

So, @new_sb and @sb indicate the same conditions now.  When we reuse
an existing root, we always reuse its sb too which means that we at
least no longer need the @new_sb ugliness.  I actually kinda prefer it
as this means that the ugliness is confined to one ugly function -
kernfs_pin_sb() - instead of the generic kernfs_mount().  Can you
please prepare patches to clean these up?  I'll pull in for-3.16-fixes
into for-3.17 and apply the cleanup on top.

Thanks!

-- 
tejun
