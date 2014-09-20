From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: remove redundant variable in cgroup_mount()
Date: Sat, 20 Sep 2014 13:12:31 -0400
Message-ID: <20140920171231.GB3681@htj.dyndns.org>
References: <541D2366.2020107@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=byglOwl4AFljGxHew2TikqqwzkUFSz54yHzJFQs4JHU=;
        b=vbFY9iRP4V9ltbQgR19ThP/fzhypYyEdEe6Ogaf89wfThkpckO1VW3tLbLyFUuoRkr
         WWVOg+UqLg4OCPaoFIXq8dWJXeu1kxFDuzLPGum+Gbm0PKfmo763o+I6kfBChGAO4CR9
         xFnNwKocj+XUR23D4HyVWdRTGErCORdeZbtQkME/aPIyKVZygk20Faphz2mzqBlsonoS
         l1ONcpPwU8tUxE8MBHs/CIJXHjP3oVYcBwnL2dN94e1aNs9fviOP/7nL+xd73Ec44w9M
         OV9KVGuAH00HjJv7hDO0vf74ZpN5fYwP4qZXARgt5CFdt7PnYnZBftIiKa19NwixbLO+
         T40A==
Content-Disposition: inline
In-Reply-To: <541D2366.2020107-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Li.

On Sat, Sep 20, 2014 at 02:49:10PM +0800, Zefan Li wrote:
> Both pinned_sb and new_sb indicate if a new superblock is needed,
> so we can just remove new_sb.
> 
> Note now we must check if kernfs_tryget_sb() returns NULL, because
> when it returns NULL, kernfs_mount() may still re-use an existing
> superblock, which is just allocated by another concurent mount.
> 
> Suggested-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Ah, this is so much better.  Thanks for doing this.  Applied to
cgroup/for-3.18.

> ---
> 
> Hi Tejun,
> 
> I think you wanted to see the @new_sb argument removed from kernfs_mount(),
> but it's also used in debugfs and we can't use kernfs_tryget_sb() to
> replace the new_sb check.

Bummer, someday. :)

Thanks.

-- 
tejun
