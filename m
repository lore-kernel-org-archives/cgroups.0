From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] sysfs: fix namespace refcnt leak
Date: Tue, 18 Feb 2014 18:12:42 -0500
Message-ID: <20140218231242.GJ31892@mtj.dyndns.org>
References: <53018813.7030409@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=w4fCARzAwXu0yXnESiCEgYE8QF9jsHUTC3jl7r7HqeU=;
        b=0I6BPihTE01G31N49vmuvS+ANRzc0q8Xh7lASlkrLf7RS4yOo28YAt3LGLUAJUFFlC
         DE6VhRu6pFhnpU2lSND4GWlRXDWyNg+OzGhV+g/c5YZoyuKhqNg/lLwpf0y0lSjzR5Lu
         T8gVuSUnnvjLLkPIYx07Vn5o8L1cxDmY1kxL6qJf8q9bNzAAxnlWLDTl/kC8MCCu8pKR
         BvoymG2rQEI+aJxuOTL2++yFAR8VRLpJxd47FC7U/6etk3vbK2K6T/yeO3fjZlOqUPOz
         N/gycW88n7sS3GrLo0XfM9fFc20HdbyHlkG4lH1fYDoosKES6yXM8pv/NP2ZdyobGCAT
         epxA==
Content-Disposition: inline
In-Reply-To: <53018813.7030409@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

Hey,

On Mon, Feb 17, 2014 at 11:54:59AM +0800, Li Zefan wrote:
> I think we have to fix kernfs in order to fix refcnt leak in sysfs
> and cgroupfs. This fix is for 3.14, but it creates conflicts for
> cgroup-next.
> 
> ====================
> 
> As mount() and kill_sb() is not a one-to-one match, we shoudn't get
> ns refcnt unconditionally in sysfs_mount(), and instead we should
> get the refcnt only when kernfs_mount() allocated a new superblock.

Ugh... nasty :(

> @@ -132,6 +132,7 @@ const void *kernfs_super_ns(struct super_block *sb)
>   * @flags: mount flags specified for the mount
>   * @root: kernfs_root of the hierarchy being mounted
>   * @ns: optional namespace tag of the mount
> + * @new: tell the caller if we allocated a new superblock

Maybe something like @new_sb_created is better?

>  	struct super_block *sb;
>  	struct kernfs_super_info *info;
>  	int error;
>  
> +	*new_sb = false;

Can we make it optional so that users who don't care about it can
ignore it?

> @@ -430,9 +431,9 @@ static inline int kernfs_rename(struct kernfs_node *kn,
>  
>  static inline struct dentry *
>  kernfs_mount(struct file_system_type *fs_type, int flags,
> -	     struct kernfs_root *root)
> +	     struct kernfs_root *root, bool *new_sb)
>  {
> -	return kernfs_mount_ns(fs_type, flags, root, NULL);
> +	return kernfs_mount_ns(fs_type, flags, root, NULL, new_sb);

And let kernfs_mount() just use NULL for the parameter?

Thanks.

-- 
tejun
