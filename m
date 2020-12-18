From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cgroup-v1: add disabled controller check in
 cgroup1_parse_param()
Date: Fri, 18 Dec 2020 15:02:54 +0800
Message-ID: <2d76fdf3-7f53-49c7-aa9d-13fa58081193@huawei.com>
References: <20201218061755.121205-1-chenzhou10@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20201218061755.121205-1-chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Chen Zhou <chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2020/12/18 14:17, Chen Zhou wrote:
> When mounting a cgroup hierarchy with disabled controller in cgroup v1,
> all available controllers will be attached.
> 
> Add disabled controller check in cgroup1_parse_param() and return directly
> if the specified controller is disabled.
> 
> Signed-off-by: Chen Zhou <chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
> Changes in v2:
> - Fix line over 80 characters warning.
> ---
>  kernel/cgroup/cgroup-v1.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
> index 191c329e482a..5190c42fea8b 100644
> --- a/kernel/cgroup/cgroup-v1.c
> +++ b/kernel/cgroup/cgroup-v1.c
> @@ -915,6 +915,9 @@ int cgroup1_parse_param(struct fs_context *fc, struct fs_parameter *param)
>  		for_each_subsys(ss, i) {
>  			if (strcmp(param->key, ss->legacy_name))
>  				continue;
> +			if (!cgroup_ssid_enabled(i) || cgroup1_ssid_disabled(i))
> +				return invalfc(fc, "Disabled controller '%s'",
> +					       param->key);
>  			ctx->subsys_mask |= (1 << i);
>  			return 0;
>  		}

Reviewed-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
