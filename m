From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix fail path in cgroup_load_subsys()
Date: Thu, 12 Dec 2013 14:01:12 +0800
Message-ID: <52A95128.9020309@huawei.com>
References: <1386403085-24866-1-git-send-email-vdavydov@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1386403085-24866-1-git-send-email-vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

> @@ -4861,10 +4861,8 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
>  	 */
>  	css = ss->css_alloc(cgroup_css(cgroup_dummy_top, ss));
>  	if (IS_ERR(css)) {
> -		/* failure case - need to deassign the cgroup_subsys[] slot. */
> -		cgroup_subsys[ss->subsys_id] = NULL;
> -		mutex_unlock(&cgroup_mutex);
> -		return PTR_ERR(css);
> +		ret = PTR_ERR(css);
> +		goto out_err;
>  	}
>  
>  	list_add(&ss->sibling, &cgroup_dummy_root.subsys_list);
> @@ -4873,6 +4871,10 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
>  	/* our new subsystem will be attached to the dummy hierarchy. */
>  	init_css(css, ss, cgroup_dummy_top);
>  
> +	ret = online_css(css);
> +	if (ret)
> +		goto free_css;
> +
>  	/*
>  	 * Now we need to entangle the css into the existing css_sets. unlike
>  	 * in cgroup_init_subsys, there are now multiple css_sets, so each one
> @@ -4896,18 +4898,17 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
>  	}
>  	write_unlock(&css_set_lock);
>  
> -	ret = online_css(css);
> -	if (ret)
> -		goto err_unload;
> -

Moving online_css() upwards should be fine.

Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

>  	/* success! */
>  	mutex_unlock(&cgroup_mutex);
>  	return 0;
>  
> -err_unload:
> +free_css:
> +	list_del(&ss->sibling);
> +	ss->css_free(css);
> +out_err:
> +	/* failure case - need to deassign the cgroup_subsys[] slot. */
> +	cgroup_subsys[ss->subsys_id] = NULL;
>  	mutex_unlock(&cgroup_mutex);
> -	/* @ss can't be mounted here as try_module_get() would fail */
> -	cgroup_unload_subsys(ss);
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(cgroup_load_subsys);
> 
