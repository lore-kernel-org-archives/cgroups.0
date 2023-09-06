From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATH v2] cgroup: add cgroup_favordynmods= command-line option
Date: Tue, 5 Sep 2023 21:53:52 -0400
Message-ID: <362f96ba-ca87-8343-a139-626f8b167e78@redhat.com>
References: <20230906005712.66461-1-luizcap@amazon.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693965237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xk9RaIlRaxly3xfCOhiwU7el2VjWg2i8+fH/Clz644M=;
        b=ihbNDE+38iiA/kuPPJoFa+XKlrCc6YKsPtAqiAirK8tt6HR8cKg8WvkYNNiJVkp6vZpOex
        UC0KtSfpZqhaxkVhUzPEyDLk7/tkx4sgEFGq70WEblJ1UDD3TJ/U8X9zExji6mafKeqwxr
        RrAH0Ymc67/b0izuVgenmmc+0aS28Rc=
Content-Language: en-US
In-Reply-To: <20230906005712.66461-1-luizcap-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Luiz Capitulino <luizcap-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: lcapitulino-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org


On 9/5/23 20:57, Luiz Capitulino wrote:
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
> ---
>   Documentation/admin-guide/kernel-parameters.txt |  4 ++++
>   kernel/cgroup/cgroup.c                          | 14 +++++++++++---
>   2 files changed, 15 insertions(+), 3 deletions(-)
>
> o v2
>   - Use __ro_after_init [Waiman]
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 0a1731a0f0ef..8b744d39d393 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -580,6 +580,10 @@
>   			named mounts. Specifying both "all" and "named" disables
>   			all v1 hierarchies.
>   
> +	cgroup_favordynmods= [KNL] Enable or Disable favordynmods.
> +			Format: { "true" | "false" }
> +			Defaults to the value of CONFIG_CGROUP_FAVOR_DYNMODS.
> +
>   	cgroup.memory=	[KNL] Pass options to the cgroup memory controller.
>   			Format: <string>
>   			nosocket -- Disable socket memory accounting.
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 1fb7f562289d..2b7d74304606 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -207,6 +207,8 @@ static u16 have_exit_callback __read_mostly;
>   static u16 have_release_callback __read_mostly;
>   static u16 have_canfork_callback __read_mostly;
>   
> +static bool have_favordynmods __ro_after_init = IS_ENABLED(CONFIG_CGROUP_FAVOR_DYNMODS);
> +
>   /* cgroup namespace for init task */
>   struct cgroup_namespace init_cgroup_ns = {
>   	.ns.count	= REFCOUNT_INIT(2),
> @@ -2243,9 +2245,9 @@ static int cgroup_init_fs_context(struct fs_context *fc)
>   	fc->user_ns = get_user_ns(ctx->ns->user_ns);
>   	fc->global = true;
>   
> -#ifdef CONFIG_CGROUP_FAVOR_DYNMODS
> -	ctx->flags |= CGRP_ROOT_FAVOR_DYNMODS;
> -#endif
> +	if (have_favordynmods)
> +		ctx->flags |= CGRP_ROOT_FAVOR_DYNMODS;
> +
>   	return 0;
>   }
>   
> @@ -6764,6 +6766,12 @@ static int __init enable_cgroup_debug(char *str)
>   }
>   __setup("cgroup_debug", enable_cgroup_debug);
>   
> +static int __init cgroup_favordynmods_setup(char *str)
> +{
> +	return (kstrtobool(str, &have_favordynmods) == 0);
> +}
> +__setup("cgroup_favordynmods=", cgroup_favordynmods_setup);
> +
>   /**
>    * css_tryget_online_from_dir - get corresponding css from a cgroup dentry
>    * @dentry: directory dentry of interest
Reviewed-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

