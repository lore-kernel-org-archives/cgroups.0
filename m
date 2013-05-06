From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup.h: remove some functions that are now gone
Date: Mon, 6 May 2013 08:50:19 +0800
Message-ID: <5186FE4B.1050501@huawei.com>
References: <20130503232659.GA12008@kroah.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130503232659.GA12008-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2013/5/4 7:26, Greg KH wrote:
> From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> 
> cgroup_lock() and cgroup_unlock() are now no longer exported, so fix
> cgroup.h to not declare them if CONFIG_CGROUPS is not enabled.
> 
> Signed-off-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>

Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 3bff9ce..e2ab34d 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -837,8 +837,6 @@ static inline void cgroup_fork(struct task_struct *p) {}
>  static inline void cgroup_post_fork(struct task_struct *p) {}
>  static inline void cgroup_exit(struct task_struct *p, int callbacks) {}
>  
> -static inline void cgroup_lock(void) {}
> -static inline void cgroup_unlock(void) {}
>  static inline int cgroupstats_build(struct cgroupstats *stats,
>  					struct dentry *dentry)
>  {
> 
