From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.13-fixes] cgroup: fix oops in cgroup init
 failure path
Date: Fri, 6 Dec 2013 11:02:07 +0400
Message-ID: <52A1766F.5090808@parallels.com>
References: <1386234006-1633-1-git-send-email-vdavydov@parallels.com> <20131205211814.GA29598@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131205211814.GA29598-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On 12/06/2013 01:18 AM, Tejun Heo wrote:
> Hello, Vladimir.
>
> Thanks a lot for the report and fix; however, I really wanna make sure
> that only online css's become visible, so I wrote up a different fix.
> Can you please test this one?

Hi, Tejun

This patch fixes this bug, but I have a couple of questions regarding it.

First, cgroup_load_subsys() also calls css_online(), and if it fails, it
calls cgroup_unload_subsys() to rollback. The latter function executes
the following command:

    offline_css(cgroup_css(cgroup_dummy_top, ss));

But since we failed to online_css(), cgroup_css() will return NULL
resulting in another oops.

Second, it's not clear to me why we need the CSS_ONLINE flag at all if
we never assign css's that we fail to online to a cgroup. AFAIU we will
never see such css's, because in all places we call offline_css(),
namely cgroup_destroy_locked() (via kill_css()) and
cgroup_unload_subsys(), we use cgroup_css() which will return NULL for them.

Third, please see commends inline.

Thanks.

> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -4399,13 +4399,13 @@ static long cgroup_create(struct cgroup
>  		css = ss->css_alloc(cgroup_css(parent, ss));
>  		if (IS_ERR(css)) {
>  			err = PTR_ERR(css);
> -			goto err_free_all;
> +			goto err_deactivate;
>  		}
>  		css_ar[ss->subsys_id] = css;
>  
>  		err = percpu_ref_init(&css->refcnt, css_release);
>  		if (err)
> -			goto err_free_all;
> +			goto err_deactivate;
>  
>  		init_css(css, ss, cgrp);
>  	}
> @@ -4417,7 +4417,7 @@ static long cgroup_create(struct cgroup
>  	 */
>  	err = cgroup_create_file(dentry, S_IFDIR | mode, sb);
>  	if (err < 0)
> -		goto err_free_all;
> +		goto err_deactivate;
>  	lockdep_assert_held(&dentry->d_inode->i_mutex);
>  
>  	cgrp->serial_nr = cgroup_serial_nr_next++;
> @@ -4445,6 +4445,9 @@ static long cgroup_create(struct cgroup
>  		if (err)
>  			goto err_destroy;

Before we get here, we call

    /* each css holds a ref to the cgroup's dentry and the parent css */
    for_each_root_subsys(root, ss) {
        struct cgroup_subsys_state *css = css_ar[ss->subsys_id];

        dget(dentry);
        css_get(css->parent);
    }

If we fail to online a css, we will only call

    ss->css_free(css);

on it skipping css_put() on parent.

css_put() is called on parent in css_release() on normal destroy path.

>  
> +		/* @css successfully attached, now owned by @cgrp */
> +		css_ar[ss->subsys_id] = NULL;
> +
>  		if (ss->broken_hierarchy && !ss->warned_broken_hierarchy &&
>  		    parent->parent) {
>  			pr_warning("cgroup: %s (%d) created nested cgroup for controller \"%s\" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.\n",
> @@ -4470,15 +4473,7 @@ static long cgroup_create(struct cgroup
>  
>  	return 0;
>  
> -err_free_all:
> -	for_each_root_subsys(root, ss) {
> -		struct cgroup_subsys_state *css = css_ar[ss->subsys_id];
> -
> -		if (css) {
> -			percpu_ref_cancel_init(&css->refcnt);
> -			ss->css_free(css);
> -		}
> -	}
> +err_deactivate:
>  	mutex_unlock(&cgroup_mutex);
>  	/* Release the reference count that we took on the superblock */
>  	deactivate_super(sb);
> @@ -4488,12 +4483,21 @@ err_free_name:
>  	kfree(rcu_dereference_raw(cgrp->name));
>  err_free_cgrp:
>  	kfree(cgrp);
> -	return err;
> +	goto out_free_css_ar;
>  
>  err_destroy:
>  	cgroup_destroy_locked(cgrp);
>  	mutex_unlock(&cgroup_mutex);
>  	mutex_unlock(&dentry->d_inode->i_mutex);
> +out_free_css_ar:
> +	for_each_root_subsys(root, ss) {
> +		struct cgroup_subsys_state *css = css_ar[ss->subsys_id];
> +
> +		if (css) {
> +			percpu_ref_cancel_init(&css->refcnt);
> +			ss->css_free(css);
> +		}
> +	}
>  	return err;
>  }
>  
> @@ -4650,10 +4654,14 @@ static int cgroup_destroy_locked(struct
>  	/*
>  	 * Initiate massacre of all css's.  cgroup_destroy_css_killed()
>  	 * will be invoked to perform the rest of destruction once the
> -	 * percpu refs of all css's are confirmed to be killed.
> +	 * percpu refs of all css's are confirmed to be killed.  Not all
> +	 * css's may be present if @cgrp failed init half-way.
>  	 */
> -	for_each_root_subsys(cgrp->root, ss)
> -		kill_css(cgroup_css(cgrp, ss));
> +	for_each_root_subsys(cgrp->root, ss) {
> +		struct cgroup_subsys_state *css = cgroup_css(cgrp, ss);
> +		if (css)
> +			kill_css(cgroup_css(cgrp, ss));
> +	}
>  
>  	/*
>  	 * Mark @cgrp dead.  This prevents further task migration and child
