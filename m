From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH v3 14/21] fs: Allow superblock owner to change ownership
 of inodes with unmappable ids
Date: Mon, 25 Apr 2016 15:30:47 -0500
Message-ID: <20160425203047.GA29927@mail.hallyn.com>
References: <1461339521-123191-1-git-send-email-seth.forshee@canonical.com>
 <1461339521-123191-15-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1461339521-123191-15-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, cgroups@vger.kernel.org

Quoting Seth Forshee (seth.forshee@canonical.com):
> In a userns mount some on-disk inodes may have ids which do not
> map into s_user_ns, in which case the in-kernel inodes are owned
> by invalid users. The superblock owner should be able to change
> attributes of these inodes but cannot. However it is unsafe to
> grant the superblock owner privileged access to all inodes in the
> superblock since proc, sysfs, etc. use DAC to protect files which
> may not belong to s_user_ns. The problem is restricted to only
> inodes where the owner or group is an invalid user.
> 
> We can work around this by allowing users with CAP_CHOWN in
> s_user_ns to change an invalid owner or group id, so long as the
> other id is either invalid or mappable in s_user_ns. After
> changing ownership the user will be privileged towards the inode
> and thus able to change other attributes.
> 
> As an precaution, checks for invalid ids are added to the proc
> and kernfs setattr interfaces. These filesystems are not expected
> to have inodes with invalid ids, but if it does happen any
> setattr operations will return -EPERM.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

bug a request below,

> ---
>  fs/attr.c             | 47 +++++++++++++++++++++++++++++++++++++++--------
>  fs/kernfs/inode.c     |  2 ++
>  fs/proc/base.c        |  2 ++
>  fs/proc/generic.c     |  3 +++
>  fs/proc/proc_sysctl.c |  2 ++
>  5 files changed, 48 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/attr.c b/fs/attr.c
> index 3cfaaac4a18e..a8b0931654a5 100644
> --- a/fs/attr.c
> +++ b/fs/attr.c
> @@ -16,6 +16,43 @@
>  #include <linux/evm.h>
>  #include <linux/ima.h>
>  
> +static bool chown_ok(const struct inode *inode, kuid_t uid)
> +{
> +	struct user_namespace *user_ns;
> +
> +	if (uid_eq(current_fsuid(), inode->i_uid) && uid_eq(uid, inode->i_uid))
> +		return true;
> +	if (capable_wrt_inode_uidgid(inode, CAP_CHOWN))
> +		return true;
> +
> +	user_ns = inode->i_sb->s_user_ns;
> +	if (!uid_valid(inode->i_uid) &&
> +	    (!gid_valid(inode->i_gid) || kgid_has_mapping(user_ns, inode->i_gid)) &&

This confused me to no end :)  Perhaps a "is_unmapped_valid_gid()" helper
would make it clearer what this is meant to do?  Or else maybe a comment
above chown_ok(), explaining that

1. for a blockdev, the uid is converted at inode read so that it is
either mapped or invalid
2. for sysfs / etc, uid can be valid but not mapped into the userns

> +	    ns_capable(user_ns, CAP_CHOWN))
> +		return true;
> +
> +	return false;
> +}
> +
> +static bool chgrp_ok(const struct inode *inode, kgid_t gid)
> +{
> +	struct user_namespace *user_ns;
> +
> +	if (uid_eq(current_fsuid(), inode->i_uid) &&
> +	    (in_group_p(gid) || gid_eq(gid, inode->i_gid)))
> +		return true;
> +	if (capable_wrt_inode_uidgid(inode, CAP_CHOWN))
> +		return true;
> +
> +	user_ns = inode->i_sb->s_user_ns;
> +	if (!gid_valid(inode->i_gid) &&
> +	    (!uid_valid(inode->i_uid) || kuid_has_mapping(user_ns, inode->i_uid)) &&
> +	    ns_capable(user_ns, CAP_CHOWN))
> +		return true;
> +
> +	return false;
> +}
> +
>  /**
>   * inode_change_ok - check if attribute changes to an inode are allowed
>   * @inode:	inode to check
> @@ -58,17 +95,11 @@ int inode_change_ok(const struct inode *inode, struct iattr *attr)
>  		return 0;
>  
>  	/* Make sure a caller can chown. */
> -	if ((ia_valid & ATTR_UID) &&
> -	    (!uid_eq(current_fsuid(), inode->i_uid) ||
> -	     !uid_eq(attr->ia_uid, inode->i_uid)) &&
> -	    !capable_wrt_inode_uidgid(inode, CAP_CHOWN))
> +	if ((ia_valid & ATTR_UID) && !chown_ok(inode, attr->ia_uid))
>  		return -EPERM;
>  
>  	/* Make sure caller can chgrp. */
> -	if ((ia_valid & ATTR_GID) &&
> -	    (!uid_eq(current_fsuid(), inode->i_uid) ||
> -	    (!in_group_p(attr->ia_gid) && !gid_eq(attr->ia_gid, inode->i_gid))) &&
> -	    !capable_wrt_inode_uidgid(inode, CAP_CHOWN))
> +	if ((ia_valid & ATTR_GID) && !chgrp_ok(inode, attr->ia_gid))
>  		return -EPERM;
>  
>  	/* Make sure a caller can chmod. */
> diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
> index 16405ae88d2d..2e97a337ee5f 100644
> --- a/fs/kernfs/inode.c
> +++ b/fs/kernfs/inode.c
> @@ -117,6 +117,8 @@ int kernfs_iop_setattr(struct dentry *dentry, struct iattr *iattr)
>  
>  	if (!kn)
>  		return -EINVAL;
> +	if (!uid_valid(inode->i_uid) || !gid_valid(inode->i_gid))
> +		return -EPERM;
>  
>  	mutex_lock(&kernfs_mutex);
>  	error = inode_change_ok(inode, iattr);
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index b1755b23893e..648d623e2158 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -711,6 +711,8 @@ int proc_setattr(struct dentry *dentry, struct iattr *attr)
>  
>  	if (attr->ia_valid & ATTR_MODE)
>  		return -EPERM;
> +	if (!uid_valid(inode->i_uid) || !gid_valid(inode->i_gid))
> +		return -EPERM;
>  
>  	error = inode_change_ok(inode, attr);
>  	if (error)
> diff --git a/fs/proc/generic.c b/fs/proc/generic.c
> index ff3ffc76a937..1461570c552c 100644
> --- a/fs/proc/generic.c
> +++ b/fs/proc/generic.c
> @@ -105,6 +105,9 @@ static int proc_notify_change(struct dentry *dentry, struct iattr *iattr)
>  	struct proc_dir_entry *de = PDE(inode);
>  	int error;
>  
> +	if (!uid_valid(inode->i_uid) || !gid_valid(inode->i_gid))
> +		return -EPERM;
> +
>  	error = inode_change_ok(inode, iattr);
>  	if (error)
>  		return error;
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index fe5b6e6c4671..f5d575157194 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -752,6 +752,8 @@ static int proc_sys_setattr(struct dentry *dentry, struct iattr *attr)
>  
>  	if (attr->ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID))
>  		return -EPERM;
> +	if (!uid_valid(inode->i_uid) || !gid_valid(inode->i_gid))
> +		return -EPERM;
>  
>  	error = inode_change_ok(inode, attr);
>  	if (error)
> -- 
> 1.9.1
