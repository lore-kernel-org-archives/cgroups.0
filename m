From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/7] cgroup: update and fix parsing of "cgroup.subtree_control"
Date: Tue, 13 May 2014 11:51:51 +0800
Message-ID: <537196D7.3020302@huawei.com>
References: <1399663975-315-1-git-send-email-tj@kernel.org> <1399663975-315-5-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1399663975-315-5-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 35daf89..b81e7c0 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2542,11 +2542,13 @@ static int cgroup_subtree_control_write(struct cgroup_subsys_state *dummy_css,
>  	int ssid, ret;
>  
>  	/*
> -	 * Parse input - white space separated list of subsystem names
> -	 * prefixed with either + or -.
> +	 * Parse input - space separated list of subsystem names prefixed
> +	 * with either + or -.
>  	 */
>  	p = buffer;
> -	while ((tok = strsep(&p, " \t\n"))) {
> +	while ((tok = strsep(&p, " "))) {
> +		if (tok[0] =='\0')

if (tok[0] == '\0')

> +			continue;
