From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 07/16] memcg: enable accounting for new namesapces and
 struct nsproxy
Date: Fri, 7 May 2021 08:45:28 -0500
Message-ID: <20210507134528.GA22665@mail.hallyn.com>
References: <8664122a-99d3-7199-869a-781b21b7e712@virtuozzo.com>
 <fcec18da-0e46-a29e-0a67-26bd024146b1@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <fcec18da-0e46-a29e-0a67-26bd024146b1-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Andrei Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Apr 28, 2021 at 09:52:43AM +0300, Vasily Averin wrote:
> Container admin can create new namespaces and force kernel to allocate
> up to several pages of memory for the namespaces and its associated
> structures.
> Net and uts namespaces have enabled accounting for such allocations.
> It makes sense to account for rest ones to restrict the host's memory
> consumption from inside the memcg-limited container.
> 
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

makes sense.

Acked-by: Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>

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
> index 56bb5a5..5ecfa349 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -3286,7 +3286,7 @@ static struct mnt_namespace *alloc_mnt_ns(struct user_namespace *user_ns, bool a
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
> index 9a4b980..9c6a42b 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -1378,7 +1378,7 @@ static struct user_namespace *userns_owner(struct ns_common *ns)
>  
>  static __init int user_namespaces_init(void)
>  {
> -	user_ns_cachep = KMEM_CACHE(user_namespace, SLAB_PANIC);
> +	user_ns_cachep = KMEM_CACHE(user_namespace, SLAB_PANIC | SLAB_ACCOUNT);
>  	return 0;
>  }
>  subsys_initcall(user_namespaces_init);
> -- 
> 1.8.3.1
