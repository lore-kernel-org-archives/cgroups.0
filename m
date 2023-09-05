From: Luiz Capitulino <luizcap-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATH] cgroup: add cgroup_favordynmods= command-line option
Date: Tue, 5 Sep 2023 17:03:27 +0000
Message-ID: <20230905170318.GA16629@dev-dsk-luizcap-1d-37beaf15.us-east-1.amazon.com>
References: <20230831142046.37177-1-luizcap@amazon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1693937447; x=1725473447;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QaGIBp+4yXT+4ZJENNV5tF4S5zI+vHTeYurxUnNu70g=;
  b=CIioFm80Lqy8nX6NZjJL0Z8296AbZefvcwJxNGcgZb8DUTl7tix6zCpo
   UcXwqq9fPR2t3cQ0utQG58mXTSCLxxapsQFVdHHpK/s9+iDf3WbVCKLIp
   y+wE1q+qR8cLzDKAEkdq2Xpu6wmpcXFGhTrK6BddoDzCaIgRp/oGuIEQx
   U=;
Content-Disposition: inline
In-Reply-To: <20230831142046.37177-1-luizcap-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: lcapitulino-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Thu, Aug 31, 2023 at 10:20:46AM -0400, Luiz Capitulino wrote:
> We have a need of using favordynmods with cgroup v1, which doesn't support
> changing mount flags during remount. Enabling CONFIG_FAVOR_DYNMODS at
> build-time is not an option because we want to be able to selectively
> enable it for certain systems.
> 
> This commit addresses this by introducing the cgroup_favordynmods=
> command-line option. This option works for both cgroup v1 and v2 and
> also allows for disabling favorynmods when the kernel built with
> CONFIG_FAVOR_DYNMODS=y.
> 
> Signed-off-by: Luiz Capitulino <luizcap-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>

Hi,

Would somebody take a look at this patch please?

Thanks,

- Luiz

> ---
>  Documentation/admin-guide/kernel-parameters.txt |  4 ++++
>  kernel/cgroup/cgroup.c                          | 14 +++++++++++---
>  2 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 0c38a8af95ce..672f76a3c002 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -580,6 +580,10 @@
>  			named mounts. Specifying both "all" and "named" disables
>  			all v1 hierarchies.
>  
> +	cgroup_favordynmods= [KNL] Enable or Disable favordynmods.
> +			Format: { "true" | "false" }
> +			Defaults to the value of CONFIG_CGROUP_FAVOR_DYNMODS.
> +
>  	cgroup.memory=	[KNL] Pass options to the cgroup memory controller.
>  			Format: <string>
>  			nosocket -- Disable socket memory accounting.
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 5fa95f86cb4d..b625825e270b 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -207,6 +207,8 @@ static u16 have_exit_callback __read_mostly;
>  static u16 have_release_callback __read_mostly;
>  static u16 have_canfork_callback __read_mostly;
>  
> +static bool have_favordynmods __read_mostly = IS_ENABLED(CONFIG_CGROUP_FAVOR_DYNMODS);
> +
>  /* cgroup namespace for init task */
>  struct cgroup_namespace init_cgroup_ns = {
>  	.ns.count	= REFCOUNT_INIT(2),
> @@ -2265,9 +2267,9 @@ static int cgroup_init_fs_context(struct fs_context *fc)
>  	fc->user_ns = get_user_ns(ctx->ns->user_ns);
>  	fc->global = true;
>  
> -#ifdef CONFIG_CGROUP_FAVOR_DYNMODS
> -	ctx->flags |= CGRP_ROOT_FAVOR_DYNMODS;
> -#endif
> +	if (have_favordynmods)
> +		ctx->flags |= CGRP_ROOT_FAVOR_DYNMODS;
> +
>  	return 0;
>  }
>  
> @@ -6767,6 +6769,12 @@ static int __init enable_cgroup_debug(char *str)
>  }
>  __setup("cgroup_debug", enable_cgroup_debug);
>  
> +static int __init cgroup_favordynmods_setup(char *str)
> +{
> +	return (kstrtobool(str, &have_favordynmods) == 0);
> +}
> +__setup("cgroup_favordynmods=", cgroup_favordynmods_setup);
> +
>  /**
>   * css_tryget_online_from_dir - get corresponding css from a cgroup dentry
>   * @dentry: directory dentry of interest
> -- 
> 2.40.1
> 
