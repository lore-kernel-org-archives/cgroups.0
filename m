From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH v5 13/16] memcg: enable accounting for signals
Date: Mon, 19 Jul 2021 12:32:46 -0500
Message-ID: <87k0lmryyp.fsf@disp2133>
References: <CALvZod66KF-8xKB1dyY2twizDE=svE8iXT_nqvsrfWg1a92f4A@mail.gmail.com>
        <cover.1626688654.git.vvs@virtuozzo.com>
        <b19f065e-f3c9-2b20-2798-b60f0fc6b05f@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b19f065e-f3c9-2b20-2798-b60f0fc6b05f-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> (Vasily
        Averin's message of "Mon, 19 Jul 2021 13:45:44 +0300")
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> writes:

> When a user send a signal to any another processes it forces the kernel
> to allocate memory for 'struct sigqueue' objects. The number of signals
> is limited by RLIMIT_SIGPENDING resource limit, but even the default
> settings allow each user to consume up to several megabytes of memory.
> Moreover, an untrusted admin inside container can increase the limit or
> create new fake users and force them to sent signals.

Not any more.  Currently the number of sigqueue objects is limited
by the rlimit of the creator of the user namespace of the container.

> It makes sense to account for these allocations to restrict the host's
> memory consumption from inside the memcg-limited container.

Does it?  Why?  The given justification appears to have bit-rotted
since -rc1.

I know a lot of these things only really need a limit just to catch a
program that starts malfunctioning.  If that is indeed the case
reasonable per-resource limits are probably better than some great big
group limit that can be exhausted with any single resource in the group.

Is there a reason I am not aware of that where it makes sense to group
all of the resources together and only count the number of bytes
consumed?

Eric


> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> ---
>  kernel/signal.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/signal.c b/kernel/signal.c
> index a3229ad..8921c4a 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -4663,7 +4663,7 @@ void __init signals_init(void)
>  {
>  	siginfo_buildtime_checks();
>  
> -	sigqueue_cachep = KMEM_CACHE(sigqueue, SLAB_PANIC);
> +	sigqueue_cachep = KMEM_CACHE(sigqueue, SLAB_PANIC | SLAB_ACCOUNT);
>  }
>  
>  #ifdef CONFIG_KGDB_KDB
