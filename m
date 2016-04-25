From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH v3 03/21] fs: Allow sysfs and cgroupfs to share super
 blocks between user namespaces
Date: Mon, 25 Apr 2016 14:01:52 -0500
Message-ID: <20160425190152.GB28975@mail.hallyn.com>
References: <1461339521-123191-1-git-send-email-seth.forshee@canonical.com>
 <1461339521-123191-4-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1461339521-123191-4-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, cgroups@vger.kernel.org

Quoting Seth Forshee (seth.forshee@canonical.com):
> Both of these filesystems already have use cases for mounting the
> same super block from multiple user namespaces. For sysfs this
> happens when using criu for snapshotting a container, where sysfs
> is mounted in the containers network ns but the hosts user ns.
> The cgroup filesystem shares the same super block for all mounts
> of the same hierarchy regardless of the namespace.
> 
> As a result, the restriction on mounting a super block from a
> single user namespace creates regressions for existing uses of
> these filesystems. For these specific filesystems this
> restriction isn't really necessary since the backing store is
> objects in kernel memory and thus the ids assigned from inodes
> is not subject to translation relative to s_user_ns.
> 
> Add a new filesystem flag, FS_USERNS_SHARE_SB, which when set
> causes sget_userns() to skip the check of s_user_ns. Set this
> flag for the sysfs and cgroup filesystems to fix the
> regressions.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>

thanks.

> ---
>  fs/super.c         | 3 ++-
>  fs/sysfs/mount.c   | 3 ++-
>  include/linux/fs.h | 1 +
>  kernel/cgroup.c    | 4 ++--
>  4 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index 092a7828442e..ead156b44bf8 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -472,7 +472,8 @@ retry:
>  		hlist_for_each_entry(old, &type->fs_supers, s_instances) {
>  			if (!test(old, data))
>  				continue;
> -			if (user_ns != old->s_user_ns) {
> +			if (!(type->fs_flags & FS_USERNS_SHARE_SB) &&
> +			    user_ns != old->s_user_ns) {
>  				spin_unlock(&sb_lock);
>  				if (s) {
>  					up_write(&s->s_umount);
> diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
> index f3db82071cfb..9555accd4322 100644
> --- a/fs/sysfs/mount.c
> +++ b/fs/sysfs/mount.c
> @@ -59,7 +59,8 @@ static struct file_system_type sysfs_fs_type = {
>  	.name		= "sysfs",
>  	.mount		= sysfs_mount,
>  	.kill_sb	= sysfs_kill_sb,
> -	.fs_flags	= FS_USERNS_VISIBLE | FS_USERNS_MOUNT,
> +	.fs_flags	= FS_USERNS_VISIBLE | FS_USERNS_MOUNT |
> +			  FS_USERNS_SHARE_SB,
>  };
>  
>  int __init sysfs_init(void)
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index be0f8023e28c..66a639ec1bc4 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1988,6 +1988,7 @@ struct file_system_type {
>  #define FS_USERNS_MOUNT		8	/* Can be mounted by userns root */
>  #define FS_USERNS_DEV_MOUNT	16 /* A userns mount does not imply MNT_NODEV */
>  #define FS_USERNS_VISIBLE	32	/* FS must already be visible */
> +#define FS_USERNS_SHARE_SB	64	/* Allow sharing sb between userns-es */
>  #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move() during rename() internally. */
>  	struct dentry *(*mount) (struct file_system_type *, int,
>  		       const char *, void *);
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 671dc05c0b0f..9c9aa27e531a 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2247,14 +2247,14 @@ static struct file_system_type cgroup_fs_type = {
>  	.name = "cgroup",
>  	.mount = cgroup_mount,
>  	.kill_sb = cgroup_kill_sb,
> -	.fs_flags = FS_USERNS_MOUNT,
> +	.fs_flags = FS_USERNS_MOUNT | FS_USERNS_SHARE_SB,
>  };
>  
>  static struct file_system_type cgroup2_fs_type = {
>  	.name = "cgroup2",
>  	.mount = cgroup_mount,
>  	.kill_sb = cgroup_kill_sb,
> -	.fs_flags = FS_USERNS_MOUNT,
> +	.fs_flags = FS_USERNS_MOUNT | FS_USERNS_SHARE_SB,
>  };
>  
>  static char *cgroup_path_ns_locked(struct cgroup *cgrp, char *buf, size_t buflen,
> -- 
> 1.9.1
