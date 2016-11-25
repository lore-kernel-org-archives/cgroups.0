From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cpuset: Remove unused 'struct cpuset*' variable
Date: Fri, 25 Nov 2016 13:46:04 +0800
Message-ID: <5837D01C.1070803@huawei.com>
References: <kirtika@chromium.org>
 <1480049712-17224-1-git-send-email-kirtika@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480049712-17224-1-git-send-email-kirtika-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Kirtika Ruchandani <kirtika-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: arnd-r2nGTMty4D4@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2016/11/25 12:55, Kirtika Ruchandani wrote:
> 'struct cpuset* cs' that is set but not used, was introduced in commit
> 1f7dd3e5a6e4 ("cgroup: fix handling of multi-destination migration from subtree_control enabling").
> cpuset_cancel_attach() uses css_cs(css) instead. Compiling with W=1
> gives the folllowing harmless warning, which we'd like to fix to
> reduce the noise with W=1 in the kernel.
> 
> kernel/cpuset.c: In function ‘cpuset_cancel_attach’:
> kernel/cpuset.c:1502:17: warning: variable ‘cs’ set but not used [-Wunused-but-set-variable]
>   struct cpuset *cs;
>                  ^
> 
> Fixes: 1f7dd3e5a6e4 ("cgroup: fix handling of multi-destination migration from subtree_control enabling").

This isn't a bug, so I don't think this tag is proper.

> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Kirtika Ruchandani <kirtika-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

Acked-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

> ---
>  kernel/cpuset.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 29f815d..af51460 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -1499,10 +1499,8 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
>  static void cpuset_cancel_attach(struct cgroup_taskset *tset)
>  {
>  	struct cgroup_subsys_state *css;
> -	struct cpuset *cs;
>  
>  	cgroup_taskset_first(tset, &css);
> -	cs = css_cs(css);
>  
>  	mutex_lock(&cpuset_mutex);
>  	css_cs(css)->attach_in_progress--;
> 
