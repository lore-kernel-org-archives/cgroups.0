From: Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: cgroup: avoid attaching a cgroup root to two different
 superblocks
Date: Mon, 17 Apr 2017 21:09:10 -0700
Message-ID: <20170418040909.GA5546@outlook.office365.com>
References: <58E7532B.4030505@huawei.com>
 <20170414232737.GC20350@outlook.office365.com>
 <20170414233233.GA8183@outlook.office365.com>
 <58F49BE2.8080200@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=eMqtjCLtKgEoxQefpo9jdSb1fDpqzRwfAFKQ0FO6fpg=;
 b=CclKszAWAZe1RYekQgMRuFb0G5QF22dqqzUPP8cmeIeXcN4pARQOpXj+GW5pjDoRoUQPUmjM00Gmm3XjwJHJvP917dJMTvIWIAZ7CWD8Br6kjpltTSI9pV/FblOI4HucBdfwe1Z2Zm15ZS37Dq2hXZkOqrUmJRCR+M1NIWKkI8g=
Content-Disposition: inline
In-Reply-To: <58F49BE2.8080200-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Apr 17, 2017 at 06:41:38PM +0800, Zefan Li wrote:
> On 2017/4/15 7:32, Andrei Vagin wrote:
> > On Fri, Apr 14, 2017 at 04:27:37PM -0700, Andrei Vagin wrote:
> >> Hello,
> >>
> >> One of our CRIU tests hangs with this patch.
> >>
> >> Steps to reproduce:
> >> curl -o cgroupns.c https://gist.githubusercontent.com/avagin/f87c8a8bd2a0de9afcc74976327786bc/raw/5843701ef3679f50dd2427cf57a80871082eb28c/gistfile1.txt
> >> gcc cgroupns.c -o cgroupns
> >> ./cgroupns
> >> ./cgroupns
> > 
> > I've found a trivial reproducer:
> > mkdir /tmp/xxx
> > mount -t cgroup -o none,name=zdtmtst xxx /tmp/xxx
> > mkdir /tmp/xxx/xxx
> > umount /tmp/xxx
> > mount -t cgroup -o none,name=zdtmtst xxx /tmp/xxx
> > 
> 
> Now I remember why it didn't check NULL pointer... Could you try the following fix?
> It also reverts my previous patch. I would appreciate if you run the full test suit,
> to make sure it won't break anything.

It works for me. Thanks.

Tested-by: Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

> 
> PS: Tejun, I found recently I can no longer receive your emails. Don't know why...
> 
> =======
> 
> [PATCH] cgruop: avoid attaching a cgroup root to two different superblocks, take 2
> 
> Commit bfb0b80db5f9 is broken. Now we try to fix the race by delaying
> the initialization of cgroup root refcnt until a superblock has been
> allocated.
> 
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 3.16+
> Reported-by: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Reported-by: Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  kernel/cgroup/cgroup-internal.h |  2 +-
>  kernel/cgroup/cgroup-v1.c       | 18 ++++++++++++++++--
>  kernel/cgroup/cgroup.c          |  8 ++++----
>  3 files changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
> index 9203bfb..e470268 100644
> --- a/kernel/cgroup/cgroup-internal.h
> +++ b/kernel/cgroup/cgroup-internal.h
> @@ -163,7 +163,7 @@ int cgroup_path_ns_locked(struct cgroup *cgrp, char *buf, size_t buflen,
>  
>  void cgroup_free_root(struct cgroup_root *root);
>  void init_cgroup_root(struct cgroup_root *root, struct cgroup_sb_opts *opts);
> -int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask);
> +int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask, int ref_flags);
>  int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask);
>  struct dentry *cgroup_do_mount(struct file_system_type *fs_type, int flags,
>  			       struct cgroup_root *root, unsigned long magic,
> diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
> index 12e19f0..6ca9b12 100644
> --- a/kernel/cgroup/cgroup-v1.c
> +++ b/kernel/cgroup/cgroup-v1.c
> @@ -1072,6 +1072,7 @@ struct dentry *cgroup1_mount(struct file_system_type *fs_type, int flags,
>  	struct cgroup_subsys *ss;
>  	struct dentry *dentry;
>  	int i, ret;
> +	bool new_root = false;
>  
>  	cgroup_lock_and_drain_offline(&cgrp_dfl_root.cgrp);
>  
> @@ -1146,7 +1147,7 @@ struct dentry *cgroup1_mount(struct file_system_type *fs_type, int flags,
>  		 * path is super cold.  Let's just sleep a bit and retry.
>  		 */
>  		pinned_sb = kernfs_pin_sb(root->kf_root, NULL);
> -		if (IS_ERR_OR_NULL(pinned_sb) ||
> +		if (IS_ERR(pinned_sb) ||
>  		    !percpu_ref_tryget_live(&root->cgrp.self.refcnt)) {
>  			mutex_unlock(&cgroup_mutex);
>  			if (!IS_ERR_OR_NULL(pinned_sb))
> @@ -1181,10 +1182,11 @@ struct dentry *cgroup1_mount(struct file_system_type *fs_type, int flags,
>  		ret = -ENOMEM;
>  		goto out_unlock;
>  	}
> +	new_root = true;
>  
>  	init_cgroup_root(root, &opts);
>  
> -	ret = cgroup_setup_root(root, opts.subsys_mask);
> +	ret = cgroup_setup_root(root, opts.subsys_mask, PERCPU_REF_INIT_DEAD);
>  	if (ret)
>  		cgroup_free_root(root);
>  
> @@ -1201,6 +1203,18 @@ struct dentry *cgroup1_mount(struct file_system_type *fs_type, int flags,
>  				 CGROUP_SUPER_MAGIC, ns);
>  
>  	/*
> +	 * There's a race window after we release cgroup_mutex and before
> +	 * allocating a superblock. Make sure a concurrent process won't
> +	 * be able to re-use the root during this window by delaying the
> +	 * initialization of root refcnt.
> +	 */
> +	if (new_root) {
> +		mutex_lock(&cgroup_mutex);
> +		percpu_ref_reinit(&root->cgrp.self.refcnt);
> +		mutex_unlock(&cgroup_mutex);
> +	}
> +
> +	/*
>  	 * If @pinned_sb, we're reusing an existing root and holding an
>  	 * extra ref on its sb.  Mount is complete.  Put the extra ref.
>  	 */
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 4885132..0f98010 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -1640,7 +1640,7 @@ void init_cgroup_root(struct cgroup_root *root, struct cgroup_sb_opts *opts)
>  		set_bit(CGRP_CPUSET_CLONE_CHILDREN, &root->cgrp.flags);
>  }
>  
> -int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
> +int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask, int ref_flags)
>  {
>  	LIST_HEAD(tmp_links);
>  	struct cgroup *root_cgrp = &root->cgrp;
> @@ -1656,8 +1656,8 @@ int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
>  	root_cgrp->id = ret;
>  	root_cgrp->ancestor_ids[0] = ret;
>  
> -	ret = percpu_ref_init(&root_cgrp->self.refcnt, css_release, 0,
> -			      GFP_KERNEL);
> +	ret = percpu_ref_init(&root_cgrp->self.refcnt, css_release,
> +			      ref_flags, GFP_KERNEL);
>  	if (ret)
>  		goto out;
>  
> @@ -4512,7 +4512,7 @@ int __init cgroup_init(void)
>  	hash_add(css_set_table, &init_css_set.hlist,
>  		 css_set_hash(init_css_set.subsys));
>  
> -	BUG_ON(cgroup_setup_root(&cgrp_dfl_root, 0));
> +	BUG_ON(cgroup_setup_root(&cgrp_dfl_root, 0, 0));
>  
>  	mutex_unlock(&cgroup_mutex);
>  
> -- 
> 1.8.3.1
> 
