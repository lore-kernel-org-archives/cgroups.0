From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 02/16] memcg: enable accounting for IP address and
 routing-related objects
Date: Tue, 20 Jul 2021 12:26:48 -0700
Message-ID: <CALvZod4HCRHpPJtGE=8tU1Yj=WsWHpocP0q0JU3r4F2fMmAw5w@mail.gmail.com>
References: <CALvZod66KF-8xKB1dyY2twizDE=svE8iXT_nqvsrfWg1a92f4A@mail.gmail.com>
 <cover.1626688654.git.vvs@virtuozzo.com> <9123bca3-23bb-1361-c48f-e468c81ad4f6@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EI2a6CePBuQR5Qmt/hIAg9BsSGRZLvCH1L7dvlW0uiw=;
        b=C/IMoejLQ3TpAwWYMjgZegIoM3Ljsd0fchCpMbLPN0uYHEs1jmSCEBv6KPLLzExal4
         0LbYsqLNPRLzA3+wLI5TdzUtmrYg6vZAes3ebz8vsJgXKaIBilRm2/xQWyTTGjN5PzDK
         cMPnwUPZDMkvN5llO6UyNuK/a5D5WQectAgzehBqPkcz/Ac4EsX30+MR84+gFOaI1gzR
         4J2I88iq7Y2E2mq4ewAltFyL+qCLUXcBCmbCKDitSeGnYei1G843MWztVnuwFXYr6gX2
         2woprX0y3Iar4L4M24OgoI/JiMLIH+m199zJtJF6zCHRfxY5ijhU1s3YEHwnYB7coF6M
         Hxwg==
In-Reply-To: <9123bca3-23bb-1361-c48f-e468c81ad4f6-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Jul 19, 2021 at 3:44 AM Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
>
> An netadmin inside container can use 'ip a a' and 'ip r a'
> to assign a large number of ipv4/ipv6 addresses and routing entries
> and force kernel to allocate megabytes of unaccounted memory
> for long-lived per-netdevice related kernel objects:
> 'struct in_ifaddr', 'struct inet6_ifaddr', 'struct fib6_node',
> 'struct rt6_info', 'struct fib_rules' and ip_fib caches.
>
> These objects can be manually removed, though usually they lives
> in memory till destroy of its net namespace.
>
> It makes sense to account for them to restrict the host's memory
> consumption from inside the memcg-limited container.
>
> One of such objects is the 'struct fib6_node' mostly allocated in
> net/ipv6/route.c::__ip6_ins_rt() inside the lock_bh()/unlock_bh() section:
>
>  write_lock_bh(&table->tb6_lock);
>  err = fib6_add(&table->tb6_root, rt, info, mxc);
>  write_unlock_bh(&table->tb6_lock);
>
> In this case it is not enough to simply add SLAB_ACCOUNT to corresponding
> kmem cache. The proper memory cgroup still cannot be found due to the
> incorrect 'in_interrupt()' check used in memcg_kmem_bypass().
>
> Obsoleted in_interrupt() does not describe real execution context properly.
> From include/linux/preempt.h:
>
>  The following macros are deprecated and should not be used in new code:
>  in_interrupt() - We're in NMI,IRQ,SoftIRQ context or have BH disabled
>
> To verify the current execution context new macro should be used instead:
>  in_task()      - We're in task context
>
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> ---
>  mm/memcontrol.c      | 2 +-
>  net/core/fib_rules.c | 4 ++--
>  net/ipv4/devinet.c   | 2 +-
>  net/ipv4/fib_trie.c  | 4 ++--
>  net/ipv6/addrconf.c  | 2 +-
>  net/ipv6/ip6_fib.c   | 4 ++--
>  net/ipv6/route.c     | 2 +-
>  7 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ae1f5d0..1bbf239 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -968,7 +968,7 @@ static __always_inline bool memcg_kmem_bypass(void)
>                 return false;
>
>         /* Memcg to charge can't be determined. */
> -       if (in_interrupt() || !current->mm || (current->flags & PF_KTHREAD))
> +       if (!in_task() || !current->mm || (current->flags & PF_KTHREAD))
>                 return true;
>
>         return false;

Can you please also change in_interrupt() in active_memcg() as well?
There are other unrelated in_interrupt() in that file but the one in
active_memcg() should be coupled with this change.
