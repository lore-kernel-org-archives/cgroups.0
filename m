From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v4 3/4] mm/page_owner: Print memcg information
Date: Thu, 3 Feb 2022 13:46:31 +0100
Message-ID: <YfvOp5VXrxy9IW1w@dhcp22.suse.cz>
References: <20220131192308.608837-5-longman@redhat.com>
 <20220202203036.744010-4-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1643892392; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WD0KsuFGAKxwPJ8TEDz3MZAplll7b1MiXcSJo4CExx4=;
        b=CQmLudPTvW4RaIzlWaw2EchZq5DbsHcpikxLxdiNyQzFdoT3+nVxC9O6xi3q9rw27Ye6Lp
        7ygFDsjVCbZNeC2UEUGl9dY/9Gcry845qVzIqZPWuHDHO0NJgA4S862fpTyluqIeFsoRn4
        p7lD24R7/HNiHwa1VlivOZxKVRNMnAQ=
Content-Disposition: inline
In-Reply-To: <20220202203036.744010-4-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Wed 02-02-22 15:30:35, Waiman Long wrote:
[...]
> +#ifdef CONFIG_MEMCG
> +	unsigned long memcg_data;
> +	struct mem_cgroup *memcg;
> +	bool online;
> +	char name[80];
> +
> +	rcu_read_lock();
> +	memcg_data = READ_ONCE(page->memcg_data);
> +	if (!memcg_data)
> +		goto out_unlock;
> +
> +	if (memcg_data & MEMCG_DATA_OBJCGS)
> +		ret += scnprintf(kbuf + ret, count - ret,
> +				"Slab cache page\n");
> +
> +	memcg = page_memcg_check(page);
> +	if (!memcg)
> +		goto out_unlock;
> +
> +	online = (memcg->css.flags & CSS_ONLINE);
> +	cgroup_name(memcg->css.cgroup, name, sizeof(name));

Is there any specific reason to use another buffer allocated on the
stack? Also 80B seems too short to cover NAME_MAX.

Nothing else jumped at me.
-- 
Michal Hocko
SUSE Labs
