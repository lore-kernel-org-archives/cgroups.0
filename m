From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.15-fixes 1/2] cgroup: introduce task_css_is_root()
Date: Wed, 7 May 2014 10:50:22 +0800
Message-ID: <53699F6E.3070107@huawei.com>
References: <20140505223557.GU11231@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140505223557.GU11231-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Tejun,

> -static struct css_set init_css_set = {
> +struct css_set init_css_set = {
>  	.refcount		= ATOMIC_INIT(1),
>  	.cgrp_links		= LIST_HEAD_INIT(init_css_set.cgrp_links),
>  	.tasks			= LIST_HEAD_INIT(init_css_set.tasks),
> @@ -356,6 +356,7 @@ static struct css_set init_css_set = {
>  	.mg_preload_node	= LIST_HEAD_INIT(init_css_set.mg_preload_node),
>  	.mg_node		= LIST_HEAD_INIT(init_css_set.mg_node),
>  };
> +EXPORT_SYMBOL_GPL(init_css_set);
>  

Why do we export this symbol?
