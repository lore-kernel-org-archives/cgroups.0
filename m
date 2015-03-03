From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: Use kvfree in pidlist_free()
Date: Tue, 3 Mar 2015 11:36:04 +0800
Message-ID: <54F52C24.9050309@huawei.com>
References: <jpgioej3tep.fsf@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <jpgioej3tep.fsf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Bandan Das <bsd-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2015/3/3 6:51, Bandan Das wrote:
> 
> The wrapper already calls the appropriate free
> function, use it instead of spinning our own.
> 
> Signed-off-by: Bandan Das <bsd-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

> ---
>  kernel/cgroup.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 29a7b2c..c19d66d 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -3806,10 +3806,7 @@ static void *pidlist_allocate(int count)
>  
>  static void pidlist_free(void *p)
>  {
> -	if (is_vmalloc_addr(p))
> -		vfree(p);
> -	else
> -		kfree(p);
> +	kvfree(p);
>  }
>  
>  /*
> 
