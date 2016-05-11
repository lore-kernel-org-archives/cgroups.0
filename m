From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: remove an unused variable
Date: Wed, 11 May 2016 09:26:11 -0500
Message-ID: <20160511142611.GB18632@mail.hallyn.com>
References: <1462971450-728759-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1462971450-728759-1-git-send-email-arnd-r2nGTMty4D4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Serge E . Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Quoting Arnd Bergmann (arnd-r2nGTMty4D4@public.gmane.org):
> The newly introduced cgroup_show_path has an extraneous variable
> that gcc warns about:
> 
> kernel/cgroup.c: In function 'cgroup_show_path':
> kernel/cgroup.c:1634:15: error: unused variable 'ret' [-Werror=unused-variable]
>   int len = 0, ret = 0;
> 
> This must have been left over from a previous version that was
> changed before it got committed. I checked the function and
> found that two other variables in the same function have an
> extraneous initialization, presumably another artifact from
> the same rework.
> 
> This patch removes the useless warning and the extra initializations.
> 
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

Thanks, Arnd.

Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

> ---
>  kernel/cgroup.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index afea39eb7649..29ead73d2536 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1631,8 +1631,8 @@ static int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
>  static int cgroup_show_path(struct seq_file *sf, struct kernfs_node *kf_node,
>  			    struct kernfs_root *kf_root)
>  {
> -	int len = 0, ret = 0;
> -	char *buf = NULL;
> +	int len;
> +	char *buf;
>  	struct cgroup_root *kf_cgroot = cgroup_root_from_kf(kf_root);
>  	struct cgroup *ns_cgroup;
>  
> -- 
> 2.7.0
