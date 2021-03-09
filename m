From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/9] memcg: accounting for fib6_nodes cache
Date: Tue, 9 Mar 2021 13:16:13 -0800
Message-ID: <CALvZod5QnzwpKwGqCYDKMUpHgPcvtS99go+u34NYGKaWsr0UAA@mail.gmail.com>
References: <f105248d-bd21-8e6f-bdac-4f2c4792fc4b@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9PsluCVuRlwvVpNmgjT1JznCkDbja9NK57IpaWk5p74=;
        b=s9lSAd8/iLOVzNXJ7+zZuVfjKgIHufi60spr/JHD99zdcQQdCEksF2j31Dx6t/wwuP
         1wrCwtpVz1KdKPmmrFOO1CKrycTKe56F/duuPJGBV/Vp2CC8N9rrrYTEgB/CHKP9zYCh
         vDo0AEVMlM/0FzE6O3FCardeV9kZo+0kCYcBsBywe4XgaB4L7ooh+MumK5xlMyFG1BrF
         HNMLfOtoqAx6uzYa3aJu6VMtoQZp8qmkXTSFA2y2bjngSrrUZw3gBANXnNbsrBBL1pb5
         MHEZbKMnKFF1HArMQmutIp1QsEC6mFU7A0Wo5hSkFpky5oPudWVAvLqxTmRLbZ2GwnAx
         e5Ag==
In-Reply-To: <f105248d-bd21-8e6f-bdac-4f2c4792fc4b-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Tue, Mar 9, 2021 at 12:04 AM Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
>
> Objects can be created from memcg-limited tasks
> but its misuse may lead to host OOM.
>
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> ---
>  net/ipv6/ip6_fib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
> index ef9d022..fa92ed1 100644
> --- a/net/ipv6/ip6_fib.c
> +++ b/net/ipv6/ip6_fib.c
> @@ -2445,7 +2445,7 @@ int __init fib6_init(void)
>
>         fib6_node_kmem = kmem_cache_create("fib6_nodes",

Can you talk a bit more about the lifetime of the object created from
this kmem cache? Also who and what operation can trigger allocation?

Similarly can you add this information to the remaining patches of
your series as well?

>                                            sizeof(struct fib6_node),
> -                                          0, SLAB_HWCACHE_ALIGN,
> +                                          0, SLAB_HWCACHE_ALIGN|SLAB_ACCOUNT,
>                                            NULL);
>         if (!fib6_node_kmem)
>                 goto out;
> --
> 1.8.3.1
>
