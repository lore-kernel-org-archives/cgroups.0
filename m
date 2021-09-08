From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [RFC PATCH 2/2] support cgroup pool in v1
Date: Wed, 8 Sep 2021 14:35:56 +0200
Message-ID: <YTiuLES5qd086qRu@kroah.com>
References: <cover.1631102579.git.escape@linux.alibaba.com>
 <03e2b37678c9b2aef4f5dee303b3fb87a565d56b.1631102579.git.escape@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631104558;
        bh=IeEnqVOQ4/mgD07WFn13/gOR/som678mwOUAhNFnUrw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xpJKSosNTteuQ/VVdeadIgG4tjl+qcTdHD4iyKneWU+L1j4w3oaSUDd1o2Fz98GB3
         PPw9uyyWv5GZp0vWFP1YTYyVNxjQrYEkgJhV5dlCubxCpwKnA/9fujGQ57M0kZgV4o
         STO7zQXsQfWUcgLRELcTHek7B+140EXCnajiPEMM=
Content-Disposition: inline
In-Reply-To: <03e2b37678c9b2aef4f5dee303b3fb87a565d56b.1631102579.git.escape-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yi Tao <escape-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shanpeic-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org

On Wed, Sep 08, 2021 at 08:15:13PM +0800, Yi Tao wrote:
> Add pool_size interface and delay_time interface. When the user writes
> pool_size, a cgroup pool will be created, and then when the user needs
> to create a cgroup, it will take the fast path protected by spinlock to
> obtain it from the resource pool. Performance is improved by the
> following aspects:
> 	1.reduce the critical area for creating cgroups
> 	2.reduce the scheduling time of sleep
> 	3.avoid competition with other cgroup behaviors which protected
> 	  by cgroup_mutex
> 
> The essence of obtaining resources from the pool is kernfs rename. With
> the help of the previous pinned kernfs node function, when the pool is
> enabled, these cgroups will be in the pinned state, and the protection
> of the kernfs data structure will be protected by the specified
> spinlock, thus getting rid of the cgroup_mutex and kernfs_rwsem.
> 
> In order to avoid random operations by users, the kernfs nodes of the
> cgroups in the pool will be placed under a hidden kernfs tree, and users
> can not directly touch them. When a user creates a cgroup, it will take
> the fast path, select a node from the hidden tree, and move it to the
> correct position.
> 
> As users continue to obtain resources from the pool, the number of
> cgroups in the pool will gradually decrease. When the number is less
> than a certain value, it will be supplemented. In order to avoid
> competition with the currently created cgroup, you can delay this by
> setting delay_time process
> 
> Suggested-by: Shanpei Chen <shanpeic-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Signed-off-by: Yi Tao <escape-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> ---
>  include/linux/cgroup-defs.h |  16 +++++
>  include/linux/cgroup.h      |   2 +
>  kernel/cgroup/cgroup-v1.c   | 139 ++++++++++++++++++++++++++++++++++++++++++++

I thought cgroup v1 was "obsolete" and not getting new features added to
it.  What is wrong with just using cgroups 2 instead if you have a
problem with the v1 interface?

thanks,

greg k-h
