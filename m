From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 1/2] cgroup: fix cgroup_path() vs rename() race
Date: Mon, 4 Mar 2013 09:50:32 -0800
Message-ID: <20130304175032.GD30413@htj.dyndns.org>
References: <51305264.2080602@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=7SXhjnL/7UOI4tKBZRRa9iRo6IwJfwCXkM5AuYeOVlY=;
        b=m0go5L6s6Z++BdhrpCBzMs989Swd8KZimFOUuLotP4q5bNwthM6kox24sxZ8Yx5iy7
         Wqi+rahPUBSYndiH0968hOABYPj+ZxWHfaKsCWY7bOOOYa8GIIH8w4XCl+9cc3zh7XY6
         UFZuiuPuCRWf2wqmPOMNoGClL7bNOM4U/sXLCcKYb5QvMb83U/1ggotrmkQdKfNuHy1H
         a1aocynNxjh9+/+oByMpJXfJvXH+ZQnDSRBwdkUthJ0UaXgHsQXu6BJcQ59N2CuCu4Vw
         T1R3a4BIAQJxxOWhIBWpW02mEUFQZ0PRbvkNy+nzolJ+VMp4JZIrJi8lycpjAGgGl+VQ
         /SYg==
Content-Disposition: inline
In-Reply-To: <51305264.2080602-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Mar 01, 2013 at 03:01:56PM +0800, Li Zefan wrote:
> rename() will change dentry->d_name. The result of this race can
> be worse than seeing partially rewritten name, but we might access
> a stale pointer because rename() will re-allocate memory to hold
> a longer name.
> 
> As accessing dentry->name must be protected by dentry->d_lock or
> parent inode's i_mutex, while on the other hand cgroup-path() can
> be called with some irq-safe spinlocks held, we can't generate
> cgroup path using dentry->d_name.
> 
> Alternatively we make a copy of dentry->d_name and save it in
> cgrp->name when a cgroup is created, and update cgrp->name at
> rename().
> 
> v5: use flexible array instead of zero-size array.
> v4: - allocate root_cgroup_name and all root_cgroup->name points to it.
>     - add cgroup_name() wrapper.
> v3: use kfree_rcu() instead of synchronize_rcu() in user-visible path.
> v2: make cgrp->name RCU safe.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied 1-2 to cgroup/for-3.10.

Thanks.

-- 
tejun
