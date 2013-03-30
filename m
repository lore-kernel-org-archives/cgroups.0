From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroups: Documentation/kernel-parameters.txt.
Date: Sat, 30 Mar 2013 17:33:29 +0800
Message-ID: <5156B169.7000709@huawei.com>
References: <1364628374-4554-1-git-send-email-wkevils@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1364628374-4554-1-git-send-email-wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On 2013/3/30 15:26, Kevin Wilson wrote:
> This patch removes the line "{Currently supported controllers - "memory"}"
> from Documentation/kernel-parameters.txt, as all controllers are supported.

Only memcg is supported, because only memcg checks subsys.disabled.
Greg mem_cgroup_disabled in include/linux/memcontrol.h and
mm/memcontrol.c

> 
> Signed-off-by: Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  Documentation/kernel-parameters.txt | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 4609e81..a671c6f 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -451,7 +451,6 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  
>  	cgroup_disable= [KNL] Disable a particular controller
>  			Format: {name of the controller(s) to disable}
> -				{Currently supported controllers - "memory"}
>  
>  	checkreqprot	[SELINUX] Set initial checkreqprot flag value.
>  			Format: { "0" | "1" }
> 
