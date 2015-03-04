From: Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -next] cpuset: initialize cpuset a bit early
Date: Wed, 4 Mar 2015 17:19:42 +0800
Message-ID: <CACVXFVM=m6QmCSs5y2aR=V1K+Wtg1bE6ygftbHg_yaPJk+hUAw@mail.gmail.com>
References: <54F6CBCD.50009@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=phlrujeW8uYc8wDbVE7vGsi77uBBriojv69jxCP0LN4=;
        b=lJb+YoxlD5ffNWXt9ms51d3bRbyDVb7h4ZcUQHBQQTTA2E/PIaumDreNVSj6O52trZ
         O8a6lJs1ig7apsJ0pAaYHCANGfimvEwgcgb5YCZGpNj4aXJEF/J3YQPqYcAom1JNgKx5
         mD1mvljdz6qfIz1USEA6lWWoH6YoaIIeVyX8uzRGozF3ZxRCSgBtbzH8j79a0FBu3Kmr
         mYte9yC7YwfFXMdHn5jRtHn4krjvd8wA2x19q7dgbeAQlNn/hdG4uIDROg8zR2w8zb5d
         CKTMjEGsCTaUrWyH4e0RN97KHbbIRaph31MLflc5Cu74MPFPy6TYHpZGkn75/fz61t+n
         LnzA==
In-Reply-To: <54F6CBCD.50009-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

On Wed, Mar 4, 2015 at 5:09 PM, Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> Now we call ss->bind() in cgroup_init(), so cgroup_init() will
> call cpuset_bind() and then the latter will access top_cpuset's
> cpumask, which is NULL, because cpuset_init() is called after
> cgroup_init()
>
> The simplest fix is to swap cgroup_init() and cpuset_init().
>
> Cc: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Fixes: 295458e67284 ("cgroup: call cgroup_subsys->bind on cgroup subsys initialization")
> Reported by: Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Looks this patch does fix the boot issue.

> ---
>  init/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/init/main.c b/init/main.c
> index 61b9937..50d1e95 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -667,8 +667,8 @@ asmlinkage __visible void __init start_kernel(void)
>         page_writeback_init();
>         proc_root_init();
>         nsfs_init();
> -       cgroup_init();
>         cpuset_init();
> +       cgroup_init();
>         taskstats_init_early();
>         delayacct_init();
>
> --
> 1.8.0.2
>


Thanks
Ming Lei
