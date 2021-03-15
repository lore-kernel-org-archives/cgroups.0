From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/8] memcg: accounting for fib6_nodes cache
Date: Mon, 15 Mar 2021 08:23:34 -0700
Message-ID: <CALvZod7pts6i9Zfijt+ht331z04D=t3p+6JD6yoLCw9vtzDBbQ@mail.gmail.com>
References: <YEnWUrYOArju66ym@dhcp22.suse.cz> <85b5f428-294b-af57-f496-5be5fddeeeea@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QcfCS3OT8mvBdrnyO72dgaCH8JvijbKyt7yMCuBSTlQ=;
        b=JlCakE/RcNDC7cdQJ2qbTWWcuBViyVc8yQxJ/a3Rbc7xxypLQGhdBJWuMRQ7XgqY2D
         H/caDda5QYMgkAKbUo8Q1vRyGEsseBdOEkuIuOyvvxXUEFyRmzem78jmXqlDFIH26C0o
         FvNmKqpChls7ZYziwyNI8jIHSVW6GRhp8/TCeOxA9/1kCIIFMtRL+PSzipX6bsFfJBaf
         Okn1IiP9o3JSMyRNNmxtu2CUHxfDEHvZeB9z415x23+4TzvJPdIbfU6B+8vHOwheE3ME
         UDlpK1PmsswIVQIggydljLXiNlJ82C6Rt8TtgVYmvSmLQUJcrBns/xGxTeHPiVR89mFc
         AhiA==
In-Reply-To: <85b5f428-294b-af57-f496-5be5fddeeeea-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Mon, Mar 15, 2021 at 5:23 AM Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
>
> An untrusted netadmin inside a memcg-limited container can create a
> huge number of routing entries. Currently, allocated kernel objects
> are not accounted to proper memcg, so this can lead to global memory
> shortage on the host and cause lot of OOM kiils.
>
> One such object is the 'struct fib6_node' mostly allocated in
> net/ipv6/route.c::__ip6_ins_rt() inside the lock_bh()/unlock_bh() section:
>
>  write_lock_bh(&table->tb6_lock);
>  err = fib6_add(&table->tb6_root, rt, info, mxc);
>  write_unlock_bh(&table->tb6_lock);
>
> It this case is

'In this case it is'

> not enough to simply add SLAB_ACCOUNT to corresponding
> kmem cache. The proper memory cgroup still cannot be found due to the
> incorrect 'in_interrupt()' check used in memcg_kmem_bypass().
> To be sure that caller is not executed in process contxt

'context'

> '!in_task()' check should be used instead

You missed the signoff and it seems like the whole series is missing
it as well. Please run scripts/checkpatch.pl on the patches before
sending again.

> ---
>  mm/memcontrol.c    | 2 +-
>  net/ipv6/ip6_fib.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 845eec0..568f2cb 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1076,7 +1076,7 @@ static __always_inline bool memcg_kmem_bypass(void)
>                 return false;
>
>         /* Memcg to charge can't be determined. */
> -       if (in_interrupt() || !current->mm || (current->flags & PF_KTHREAD))
> +       if (!in_task() || !current->mm || (current->flags & PF_KTHREAD))

Can you please also add some explanation in the commit message on the
differences between in_interrupt() and in_task()? Why is
in_interrupt() not correct here but !in_task() is? What about kernels
with or without PREEMPT_COUNT?

>                 return true;
>
>         return false;
> diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
> index ef9d022..fa92ed1 100644
> --- a/net/ipv6/ip6_fib.c
> +++ b/net/ipv6/ip6_fib.c
> @@ -2445,7 +2445,7 @@ int __init fib6_init(void)
>
>         fib6_node_kmem = kmem_cache_create("fib6_nodes",
>                                            sizeof(struct fib6_node),
> -                                          0, SLAB_HWCACHE_ALIGN,
> +                                          0, SLAB_HWCACHE_ALIGN|SLAB_ACCOUNT,
>                                            NULL);
>         if (!fib6_node_kmem)
>                 goto out;
> --
> 1.8.3.1
>
