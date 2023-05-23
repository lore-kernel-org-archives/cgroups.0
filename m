From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 2/3] cgroup: Rely on namespace_sem in
 current_cgns_cgroup_from_root explicitly
Date: Tue, 23 May 2023 12:42:46 +0200
Message-ID: <20230523-radar-gleich-781fd4006057@brauner>
References: <20230502133847.14570-1-mkoutny@suse.com>
 <20230502133847.14570-3-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684838572;
        bh=dAZtfPEcdx8w0xksIc+4VYD58Jm8oMxQ7+S7bRplZvM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dc34T6TA2Jylxa+Ta17oKWHKcRWTtyg7v2ias+mVnUeGa6ugVmCGvGQBzxYBOBsnB
         gVR8bMa+mAb/WmZBAJg4ZHPAQ2lJgy5r/HWYoS1qTIWV7SORr49MZxUzhIN2LkQ7k4
         h2gCx3ek59wOr/O+LFTOpCQhvbXw+OrWCwXSIAQ4DjUvaJI+cZAOeKsnOOmK+h4inJ
         bve2yOEnB29XSuZUjPe686uTQO6OQajO+gMeiz429QS1MKh9QXJEuwOs6aTTiroEGa
         WMKJd1eOsA7UJBH8COgqfZsl7uTMdscQ8GmfjbyYAYj+UqAG2S0CQuIatxOWFZDFTK
         E692WpXj+M8Mw==
Content-Disposition: inline
In-Reply-To: <20230502133847.14570-3-mkoutny-IBi9RG/b67k@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org>, Jiri Wiesner <jwiesner-l3A5Bk7waGM@public.gmane.org>

On Tue, May 02, 2023 at 03:38:46PM +0200, Michal Koutný wrote:
> The function current_cgns_cgroup_from_root() expects a stable
> cgroup_root, which is currently ensured with RCU read side paired with
> cgroup_destroy_root() called after RCU period.
> 
> The particular current_cgns_cgroup_from_root() is called from VFS code
> and cgroup_root stability can be also ensured by namespace_sem. Mark it
> explicitly as a preparation for further rework.
> 
> Signed-off-by: Michal Koutný <mkoutny-IBi9RG/b67k@public.gmane.org>
> ---
>  fs/namespace.c         | 5 ++++-
>  include/linux/mount.h  | 4 ++++
>  kernel/cgroup/cgroup.c | 7 +++----
>  3 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 54847db5b819..0d2333832064 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -71,7 +71,10 @@ static DEFINE_IDA(mnt_group_ida);
>  static struct hlist_head *mount_hashtable __read_mostly;
>  static struct hlist_head *mountpoint_hashtable __read_mostly;
>  static struct kmem_cache *mnt_cache __read_mostly;
> -static DECLARE_RWSEM(namespace_sem);
> +DECLARE_RWSEM(namespace_sem);
> +#ifdef CONFIG_LOCKDEP
> +EXPORT_SYMBOL_GPL(namespace_sem);
> +#endif
>  static HLIST_HEAD(unmounted);	/* protected by namespace_sem */
>  static LIST_HEAD(ex_mountpoints); /* protected by namespace_sem */
>  
> diff --git a/include/linux/mount.h b/include/linux/mount.h
> index 1ea326c368f7..6277435f6748 100644
> --- a/include/linux/mount.h
> +++ b/include/linux/mount.h
> @@ -80,6 +80,10 @@ static inline struct mnt_idmap *mnt_idmap(const struct vfsmount *mnt)
>  	return smp_load_acquire(&mnt->mnt_idmap);
>  }
>  
> +#ifdef CONFIG_LOCKDEP
> +extern struct rw_semaphore namespace_sem;
> +#endif

Nope, we're not putting namespace_sem in a header. The code it protects
is massively sensitive and it interacts with mount_lock and other locks.
This stays private to fs/namespace.c as far as I'm concerned.
