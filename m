From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] docs: admin-guide: cgroup-v1: Fix typos in the file
 memory.rst
Date: Fri, 12 Mar 2021 22:51:18 -0800
Message-ID: <f3a59b47-5706-4da9-f6f6-b325b2edd289@infradead.org>
References: <20210313061029.28024-1-unixbhaskar@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=TwM+34ovqWzke2UroJ5Fb4rXHMkhYWeBFaPdq+c3MEY=; b=vAla+2hs9fXA6ziQtEpcwEIPBP
        pAudnvS3kBR/tnbbsZlXTGQtJPjNZ58YTLej24+Rl4N3lxEGjreB0FeKLGRb/bReWrO/syCYj+UTm
        6SN2qU5tl9rt4Z+aHj8s218mP4GwkxQ1c6xfXGKJdIFNW/rDw7OhV68sELuQP9/ozjVkR3BAwlhOs
        K4yak9IhNu6sX10SXvZJ+sN5TQcaOWMsBE+fTecMdSFGvGo9eG1PtsBIjaFQD2u1VFVK5gZ5XNwe4
        Y8Gz126N4sylodBm4SCwSFGfKjlv8BVzTBUtj335Y8W4iEYQ3wU3YEPEQvZe4lh+WX9E7e6+TRtUe
        nhnIOr+g==;
In-Reply-To: <20210313061029.28024-1-unixbhaskar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Bhaskar Chowdhury <unixbhaskar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 3/12/21 10:10 PM, Bhaskar Chowdhury wrote:
> 
> s/overcommited/overcommitted/
> s/Overcommiting/Overcommitting/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Acked-by: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>


> ---
>  Documentation/admin-guide/cgroup-v1/memory.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
> index 52688ae34461..0d574fd3f8e3 100644
> --- a/Documentation/admin-guide/cgroup-v1/memory.rst
> +++ b/Documentation/admin-guide/cgroup-v1/memory.rst
> @@ -360,8 +360,8 @@ U != 0, K = unlimited:
> 
>  U != 0, K < U:
>      Kernel memory is a subset of the user memory. This setup is useful in
> -    deployments where the total amount of memory per-cgroup is overcommited.
> -    Overcommiting kernel memory limits is definitely not recommended, since the
> +    deployments where the total amount of memory per-cgroup is overcommitted.
> +    Overcommitting kernel memory limits is definitely not recommended, since the
>      box can still run out of non-reclaimable memory.
>      In this case, the admin could set up K so that the sum of all groups is
>      never greater than the total memory, and freely set U at the cost of his
> --


-- 
~Randy

