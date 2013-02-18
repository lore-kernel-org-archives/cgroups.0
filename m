From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] cgroup: fix cgroup_path() vs rename() race, take 2
Date: Mon, 18 Feb 2013 09:30:23 -0800
Message-ID: <20130218173023.GG17414@htj.dyndns.org>
References: <51218100.5020007@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=U2fm72/x1GOPIViB7T8p4DjN2MwnMW2URMMUo/32JL4=;
        b=BY6ISyWmHApUDmUQsWel61L4hfI1n5QduRlYV3N9Wwl6JRtej9kSGtJZtY7h2ipkBW
         VfN6jPL5/dSz2W7rooq9WpTo0JV2qiSoxgLaOi+9L8/JClKXCkw0llgqzRKUi6QXEyU9
         +9kGhINxTgN2uUEdvEPF7ER2weIT8LSigRHrx8Mdwr6/xaAIobGgpknY6C6oPiJDpzxh
         F8/c5p9i8sgSp9Gg9SpqNVv99FJA/xGzp/YKTRSAumJhLoeEQ6IVli0muj4Vovu3Whfk
         OGnqVh3x/FJ1nUGtgFL97K2NJl4kP/tnkaI9c+BtneDnridgXrwZ1Ep3iYHDPJqRUpNi
         MvUg==
Content-Disposition: inline
In-Reply-To: <51218100.5020007-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Li.

On Mon, Feb 18, 2013 at 09:16:48AM +0800, Li Zefan wrote:
> @@ -171,6 +171,7 @@ struct cgroup {
>  
>  	struct cgroup *parent;		/* my parent */
>  	struct dentry *dentry;		/* cgroup fs entry, RCU protected */
> +	char __rcu *name;		/* a copy of dentry->d_name */

A brief explanation of why this is necessary and how rcu is used would
be nice.

> +static char *cgroup_alloc_name(struct dentry *dentry)
> +{
> +	char *name;
> +
> +	name = kmalloc(dentry->d_name.len + 1, GFP_KERNEL);
> +	if (!name)
> +		return NULL;
> +	memcpy(name, dentry->d_name.name, dentry->d_name.len);
> +	name[dentry->d_name.len] = '\0';
> +	return name;
> +}

While d_name has length field, it's always properly NULL terminated,
so kstrdup() should suffice here.  Right, Al?

> @@ -1613,13 +1626,19 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
...
> -		inode = sb->s_root->d_inode;
> +		dentry = sb->s_root;
> +		inode = dentry->d_inode;
> +
> +		root_cgrp->name = cgroup_alloc_name(dentry);
> +		if (!root_cgrp->name)
> +			goto drop_new_super;

Don't we need an RCU assignment?  Is it safe because it isn't online
yet?  But wouldn't this still trigger sparse warning?

> @@ -1751,6 +1770,8 @@ static void cgroup_kill_sb(struct super_block *sb) {
>  	mutex_unlock(&cgroup_root_mutex);
>  	mutex_unlock(&cgroup_mutex);
>  
> +	synchronize_rcu();

An explanation on what we're synchronizing would be nice.  Barriers
without explanation sucks because there's nothing directly linking the
barriers to the things which are being protected.

> @@ -2539,13 +2558,41 @@ static int cgroup_file_release(struct inode *inode, struct file *file)
>  static int cgroup_rename(struct inode *old_dir, struct dentry *old_dentry,
>  			    struct inode *new_dir, struct dentry *new_dentry)
>  {
...
> +	old_name = cgrp->name;
> +	rcu_assign_pointer(cgrp->name, name);
> +
> +	synchronize_rcu();

Please don't call synchronize_rcu() from interface which is directly
visible to userland.  It leads to sporadic difficult-to-reproduce
latencies which hurt enough in corner cases and this is kmalloc
memory.  It's not like kfree_rcu() is difficult to use or anything.

> +	kfree(old_name);
> +	return 0;
>  }
>  
>  static struct simple_xattrs *__d_xattrs(struct dentry *dentry)
> @@ -4144,9 +4191,13 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
>  	if (!cgrp)
>  		return -ENOMEM;
>  
> +	cgrp->name = cgroup_alloc_name(dentry);
> +	if (!cgrp->name)
> +		goto err_free_cgrp;

Ditto with assignment.

Thanks.

-- 
tejun
