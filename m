From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/3] lib/vsprintf: Avoid redundant work with 0 size
Date: Sun, 30 Jan 2022 12:49:37 -0800 (PST)
Message-ID: <d99b3c4b-7b6e-529-6e4b-b91b65c92d81@google.com>
References: <20220129205315.478628-1-longman@redhat.com> <20220129205315.478628-2-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=aE3FiEfD4YX71c3f0yLgS/uNySrINu0tsaBgzhna2ek=;
        b=Zjc4YSbGgk5QwhyB+a51LM72RbO00quYJOUYe1md1PNeyr/pecUXyZy7c65ujwauiA
         CUXD+drBbDEDTaQ4MV92WmTsZfC1dJ8T8yrwIOweCjuFhprfvSu8cEBcojLm4+52bSK3
         hjteoxIHrZN7kcEWFRqyz9jfr3ZIvCrsWiL8+zSAtgeBonKZzynzshN8x3jZCgWYXTsy
         f3jg0rnNBNZh7xLjmAYXc8WSRADrZEQTFdN0a9S1En9/RjEz98r1OKDSxZdZ6AS+ctMq
         EcyxQCOAQSj95T6quv5E/UQAfAfzA+PKBTErMyBRTY9t23qn6560MJ0PuKndvNAQsRY3
         qj/Q==
In-Reply-To: <20220129205315.478628-2-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Sat, 29 Jan 2022, Waiman Long wrote:

> For *scnprintf(), vsnprintf() is always called even if the input size is
> 0. That is a waste of time, so just return 0 in this case.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  lib/vsprintf.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 3b8129dd374c..a65df546fb06 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -2895,13 +2895,15 @@ int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
>  {
>  	int i;
>  
> +	if (!size)
> +		return 0;

Nit: any reason this shouldn't be unlikely()?  If the conditional for 
i < size is likely(), this seems assumed already?

> +
>  	i = vsnprintf(buf, size, fmt, args);
>  
>  	if (likely(i < size))
>  		return i;
> -	if (size != 0)
> -		return size - 1;
> -	return 0;
> +
> +	return size - 1;
>  }
>  EXPORT_SYMBOL(vscnprintf);
>  
> -- 
> 2.27.0
> 
> 
> 
