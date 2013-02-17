From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: fix cgroup_path() vs rename() race, take 2
Date: Sun, 17 Feb 2013 06:48:52 +0000
Message-ID: <20130217064852.GD4503@ZenIV.linux.org.uk>
References: <51205684.5040407@huawei.com>
 <51205699.5080900@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51205699.5080900-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Sun, Feb 17, 2013 at 12:03:37PM +0800, Li Zefan wrote:
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
> Alternatively we make a copy of dentry->d_lock and save it in
> cgrp->name when a cgroup is created, and update cgrp->name at
> rename().

Yecchhh...  This is just plain wrong.  If nothing else, your locking
is way too heavy for your uses.  Just put freeing those separately
allocated names in RCU callback and assign them on rename with
rcu_assign_pointer().  Then put cgroup_path() under rcu_read_lock()
(most of the callers already are) and be done with that.
