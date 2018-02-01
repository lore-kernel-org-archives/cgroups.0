From: Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>
Subject: Re: [Intel-gfx] [PATCH RFC v2 2/7] kernfs: Export kernfs_get_inode
Date: Thu, 01 Feb 2018 20:04:42 +0000
Message-ID: <151751548245.28099.2189398226332896568@mail.alporthouse.com>
References: <20180201195315.4956-1-matthew.d.roper@intel.com>
 <20180201195315.4956-3-matthew.d.roper@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180201195315.4956-3-matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Quoting Matt Roper (2018-02-01 19:53:10)
> Drivers may wish to access a cgroup's inode to perform permission checks on
> driver-specific operations.
> 
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  fs/kernfs/inode.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
> index a34303981deb..e1e8a0404c5b 100644
> --- a/fs/kernfs/inode.c
> +++ b/fs/kernfs/inode.c
> @@ -272,6 +272,7 @@ struct inode *kernfs_get_inode(struct super_block *sb, struct kernfs_node *kn)
>  
>         return inode;
>  }
> +EXPORT_SYMBOL(kernfs_get_inode);

Will want the _GPL suffix to be in keeping with the other kernfs
exports.
-Chris
