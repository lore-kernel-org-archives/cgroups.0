From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: avoid cgroup root name longer than max
Date: Mon, 11 Dec 2017 07:12:34 -0800
Message-ID: <20171211151234.GE2421075@devbig577.frc2.facebook.com>
References: <20171208084746.5793-1-mashimiao.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yiJrV4Ga6DTd7dncH7v15YOFuXTUBUelPRh4eaSwUpk=;
        b=D0BriLnwJyNtIpc0y+wRfxO535Gf1iv8tiODtXVrlg5o0NeGqwbN2x0NWmwjYVWqWw
         s/R4221YmlvPm4MOBOq72LSnMAWj/OSXhRk2F4+NBYa7a2bHDQJepeOirrsOR+2sv7Xn
         UzFZN4D8NpbcxW5A9WB4XiY83E6SUJg65rMfvrWRC3oMnwdwWcgUrjo8e2IELgyp8sHb
         rLJWRxT8Ab0mA4HUPPncALUPJoGRLydd1zYk+YhQn87v/J2yfzE3Fv30jPx6A0r4h3Qi
         iGOkzcQFvhdhHcY8Cbi9c6oBbTrSKzg3eUCcfaxTxgmuGZSTZw3+FjSBx1hKEJMpuJDJ
         7vwQ==
Content-Disposition: inline
In-Reply-To: <20171208084746.5793-1-mashimiao.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ma Shimiao <mashimiao.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Dec 08, 2017 at 04:47:46PM +0800, Ma Shimiao wrote:
> cgroup root name has max length limit, we should avoid copying
> longer name than that to the name.
> 
> Signed-off-by: Ma Shimiao <mashimiao.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> ---
>  kernel/cgroup/cgroup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 0b1ffe147f24..3614a21ad6b8 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -1866,7 +1866,7 @@ void init_cgroup_root(struct cgroup_root *root, struct cgroup_sb_opts *opts)
>  	if (opts->release_agent)
>  		strcpy(root->release_agent_path, opts->release_agent);
>  	if (opts->name)
> -		strcpy(root->name, opts->name);
> +		strncpy(root->name, opts->name, MAX_CGROUP_ROOT_NAMELEN);

Ditto here, let's use strscpy().

Thanks.

-- 
tejun
