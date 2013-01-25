From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH] cpuset: fix cpuset_print_task_mems_allowed() vs rename()
 race
Date: Fri, 25 Jan 2013 07:26:33 +0000
Message-ID: <20130125072633.GD4503@ZenIV.linux.org.uk>
References: <51022FBC.2020705@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51022FBC.2020705-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, Jan 25, 2013 at 03:09:48PM +0800, Li Zefan wrote:
> rename() will change dentry->d_name. The result of this race can
> be worse than seeing partially rewritten name, but we might access
> a stale pointer because rename() will re-allocate memory to hold
> a longer name.
> 
> It's safe in the protection of dentry->d_lock.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  kernel/cpuset.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 16be7c9..b2476c2 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -2606,8 +2606,12 @@ void cpuset_print_task_mems_allowed(struct task_struct *tsk)
>  
>  	dentry = task_cs(tsk)->css.cgroup->dentry;
>  	spin_lock(&cpuset_buffer_lock);
> +
> +	spin_lock(&dentry->d_lock);
>  	snprintf(cpuset_name, CPUSET_NAME_LEN,
>  		 dentry ? (const char *)dentry->d_name.name : "/");

Ahem...  Can dentry actually be NULL here?  If not, this conditional
is bogus; otherwise, spin_lock(&dentry->d_lock) is going to blow up...
