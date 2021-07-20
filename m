From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 13/16] memcg: enable accounting for signals
Date: Tue, 20 Jul 2021 12:15:37 -0700
Message-ID: <CALvZod7-S6=qzKgcnMh_=pK5HRVR6PdGkVXdNNrv9EJLcYW_aw@mail.gmail.com>
References: <CALvZod66KF-8xKB1dyY2twizDE=svE8iXT_nqvsrfWg1a92f4A@mail.gmail.com>
 <cover.1626688654.git.vvs@virtuozzo.com> <b19f065e-f3c9-2b20-2798-b60f0fc6b05f@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=07bx4NkLdn3YQo/4PUJkMzmndAbRZde3u9NpVjJE6Xo=;
        b=jH4ofDKiNAS6wninS1QG7BNfZTXGP6Tjxgvi8PtuyJ6A+fotRAxZpfxIuSyfOhDioS
         YlVz47P5bm5noadpORW7KP+FGm+QeNQJgSNXvF0keEyMaWzBtmnREHD5qMKGleIBjg2f
         gxySo7z5fJG5Y19umoVFApZQYQ0XlZNnfRMjz74qsbN0pvxhzG/iDg0+/IljYPmeY2ZY
         jjC8QCa0cP2aigYvOhYGzms8xO0zLIJfbJkRM2U84pKDUB3UZRbXq5uP0qoUsDpC6WAk
         n0hQ1Z54IU4MX/hy7VDhOw5UE6Wy7zhHbvxC6KcS/l2UPpwR42Hl1ZTnw8ZMi2wpwYUl
         AKqQ==
In-Reply-To: <b19f065e-f3c9-2b20-2798-b60f0fc6b05f-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Jul 19, 2021 at 3:46 AM Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
>
> When a user send a signal to any another processes it forces the kernel
> to allocate memory for 'struct sigqueue' objects. The number of signals
> is limited by RLIMIT_SIGPENDING resource limit, but even the default
> settings allow each user to consume up to several megabytes of memory.
> Moreover, an untrusted admin inside container can increase the limit or
> create new fake users and force them to sent signals.
>
> It makes sense to account for these allocations to restrict the host's
> memory consumption from inside the memcg-limited container.
>
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

It seems like there is an agreement on this patch with the updated
commit message. In next version you can add:

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
