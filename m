From: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH v6 11/16] memcg: enable accounting for new namesapces and
 struct nsproxy
Date: Mon, 26 Jul 2021 22:58:02 +0300
Message-ID: <6c72e9c3-7ce3-0bd9-fb18-60d0a3f86254@virtuozzo.com>
References: <9bf9d9bd-03b1-2adb-17b4-5d59a86a9394@virtuozzo.com>
 <cover.1627321321.git.vvs@virtuozzo.com>
 <86c99f5a-d717-9d4e-91db-e68ccc93cade@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=tv98G035lh2G/ipIGk9DWaPwErr9DdmX0FfG30VCqLY=; b=G3iiKhr3Yr3vEkX2a
        UQ8cCtq5ZpJ8MEZqD7NvK3bB1N8hUeqGfthNBucZosDiFwX96HGYcqoYWlpp5zDKSKGZSZHQMgOXT
        nlLzLHrP+RM/NFWuluO4rEQIL8gB1DeBiq87FXjLB8hDaH3zh5vONrMfR+rD99xsbAttPVxadph1g
        =;
In-Reply-To: <86c99f5a-d717-9d4e-91db-e68ccc93cade-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Andrei Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 26.07.2021 22:01, Vasily Averin wrote:
> Container admin can create new namespaces and force kernel to allocate
> up to several pages of memory for the namespaces and its associated
> structures.
> Net and uts namespaces have enabled accounting for such allocations.
> It makes sense to account for rest ones to restrict the host's memory
> consumption from inside the memcg-limited container.
> 
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> Acked-by: Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
> Acked-by: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

Acked-by: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

> ---
>  fs/namespace.c            | 2 +-
>  ipc/namespace.c           | 2 +-
>  kernel/cgroup/namespace.c | 2 +-
>  kernel/nsproxy.c          | 2 +-
>  kernel/pid_namespace.c    | 2 +-
>  kernel/time/namespace.c   | 4 ++--
>  kernel/user_namespace.c   | 2 +-
>  7 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index c6a74e5..e443ee6 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -3289,7 +3289,7 @@ static struct mnt_namespace *alloc_mnt_ns(struct user_namespace *user_ns, bool a
>  	if (!ucounts)
>  		return ERR_PTR(-ENOSPC);
>  
> -	new_ns = kzalloc(sizeof(struct mnt_namespace), GFP_KERNEL);
> +	new_ns = kzalloc(sizeof(struct mnt_namespace), GFP_KERNEL_ACCOUNT);
>  	if (!new_ns) {
>  		dec_mnt_namespaces(ucounts);
>  		return ERR_PTR(-ENOMEM);
> diff --git a/ipc/namespace.c b/ipc/namespace.c
> index 7bd0766..ae83f0f 100644
> --- a/ipc/namespace.c
> +++ b/ipc/namespace.c
> @@ -42,7 +42,7 @@ static struct ipc_namespace *create_ipc_ns(struct user_namespace *user_ns,
>  		goto fail;
>  
>  	err = -ENOMEM;
> -	ns = kzalloc(sizeof(struct ipc_namespace), GFP_KERNEL);
> +	ns = kzalloc(sizeof(struct ipc_namespace), GFP_KERNEL_ACCOUNT);
>  	if (ns == NULL)
>  		goto fail_dec;
>  
> diff --git a/kernel/cgroup/namespace.c b/kernel/cgroup/namespace.c
> index f5e8828..0d5c298 100644
> --- a/kernel/cgroup/namespace.c
> +++ b/kernel/cgroup/namespace.c
> @@ -24,7 +24,7 @@ static struct cgroup_namespace *alloc_cgroup_ns(void)
>  	struct cgroup_namespace *new_ns;
>  	int ret;
>  
> -	new_ns = kzalloc(sizeof(struct cgroup_namespace), GFP_KERNEL);
> +	new_ns = kzalloc(sizeof(struct cgroup_namespace), GFP_KERNEL_ACCOUNT);
>  	if (!new_ns)
>  		return ERR_PTR(-ENOMEM);
>  	ret = ns_alloc_inum(&new_ns->ns);
> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> index abc01fc..eec72ca 100644
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -568,6 +568,6 @@ static void commit_nsset(struct nsset *nsset)
>  
>  int __init nsproxy_cache_init(void)
>  {
> -	nsproxy_cachep = KMEM_CACHE(nsproxy, SLAB_PANIC);
> +	nsproxy_cachep = KMEM_CACHE(nsproxy, SLAB_PANIC|SLAB_ACCOUNT);
>  	return 0;
>  }
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index ca43239..6cd6715 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -449,7 +449,7 @@ static struct user_namespace *pidns_owner(struct ns_common *ns)
>  
>  static __init int pid_namespaces_init(void)
>  {
> -	pid_ns_cachep = KMEM_CACHE(pid_namespace, SLAB_PANIC);
> +	pid_ns_cachep = KMEM_CACHE(pid_namespace, SLAB_PANIC | SLAB_ACCOUNT);
>  
>  #ifdef CONFIG_CHECKPOINT_RESTORE
>  	register_sysctl_paths(kern_path, pid_ns_ctl_table);
> diff --git a/kernel/time/namespace.c b/kernel/time/namespace.c
> index 12eab0d..aec8328 100644
> --- a/kernel/time/namespace.c
> +++ b/kernel/time/namespace.c
> @@ -88,13 +88,13 @@ static struct time_namespace *clone_time_ns(struct user_namespace *user_ns,
>  		goto fail;
>  
>  	err = -ENOMEM;
> -	ns = kmalloc(sizeof(*ns), GFP_KERNEL);
> +	ns = kmalloc(sizeof(*ns), GFP_KERNEL_ACCOUNT);
>  	if (!ns)
>  		goto fail_dec;
>  
>  	refcount_set(&ns->ns.count, 1);
>  
> -	ns->vvar_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
> +	ns->vvar_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>  	if (!ns->vvar_page)
>  		goto fail_free;
>  
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index ef82d40..6b2e3ca 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -1385,7 +1385,7 @@ static struct user_namespace *userns_owner(struct ns_common *ns)
>  
>  static __init int user_namespaces_init(void)
>  {
> -	user_ns_cachep = KMEM_CACHE(user_namespace, SLAB_PANIC);
> +	user_ns_cachep = KMEM_CACHE(user_namespace, SLAB_PANIC | SLAB_ACCOUNT);
>  	return 0;
>  }
>  subsys_initcall(user_namespaces_init);
> 

