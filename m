From: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATH v2] cgroup: add cgroup_favordynmods= command-line option
Date: Wed, 6 Sep 2023 12:28:54 +0530
Message-ID: <5487ed0a-8483-0a92-c7c1-9ca3ed8e6162@oracle.com>
References: <20230906005712.66461-1-luizcap@amazon.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=59xsZZ3TPpxZJcNgps9giNm3BJaf1Qq91lXgRYkSeew=;
 b=dhAvNt8fpmnlj7QB0qHTnrrrHPbO0bBAzSjJaFMgilasiFBEqCx/bVg4HnZ+hw1RshXj
 yktMdEp7nUahDsuYqPBKC2gotfGggI+6yWsR8/pB8d8d/OXtXGpj6Y9BPzg1J8EztXFL
 HrXRuUNWdvYhx4Fjr1EUBACsZ4O7eEosEupZuvMg4Iu3BGuSI/LbutktDffTk4G6WfFB
 6NgJAaVnlNAwagV7aJSl9bmw121Nerhto/B5XYw9+pDUwmTdGBE4pKg2hu8VDJqBP2bp
 nZ/9UBSMxZGPtMFfCX07ro3XB6FAsteiQwzDo93PB5fPunZzDh7ryn2/mGArOz8ahzUz Kg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=59xsZZ3TPpxZJcNgps9giNm3BJaf1Qq91lXgRYkSeew=;
 b=OAhm/gL6ROFp/v9rvQ/Tjc8CS3ulCE7rG7rfcE26lCmZBN851zO+YuPWrLmIXHumqnGmVCfL375+wVjd6WM92G4/e95kIFgYM4fA0hDHmj0PB4HOs2HMQeFWUDtnm7I1nDG2U5t5OrPU52Zo8t8vnFVmO+2t9NetWRNIQJ2RKB4=
Content-Language: en-US
In-Reply-To: <20230906005712.66461-1-luizcap-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Luiz Capitulino <luizcap-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: lcapitulino-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org


On 9/6/23 06:27, Luiz Capitulino wrote:
[...]
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 1fb7f562289d..2b7d74304606 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -207,6 +207,8 @@ static u16 have_exit_callback __read_mostly;
>  static u16 have_release_callback __read_mostly;
>  static u16 have_canfork_callback __read_mostly;
>  
> +static bool have_favordynmods __ro_after_init = IS_ENABLED(CONFIG_CGROUP_FAVOR_DYNMODS);
> +
>  /* cgroup namespace for init task */
>  struct cgroup_namespace init_cgroup_ns = {
>  	.ns.count	= REFCOUNT_INIT(2),
> @@ -2243,9 +2245,9 @@ static int cgroup_init_fs_context(struct fs_context *fc)
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
> @@ -6764,6 +6766,12 @@ static int __init enable_cgroup_debug(char *str)
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

Consider a case where the kernel is compiled with
CONFIG_CGROUP_FAVOR_DYNMODS=n and kernel command line is passed with
cgroup_favordynmods=true, this would set the have_favordynmods to true.
In cgroup_favordynmods_setup(), should it return 0 with a pr_warn(),
when CONFIG_CGROUP_FAVOR_DYNMODS=n in the above case, or is this
expected behavior?

-- 
Thanks,
Kamalesh
