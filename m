From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 08/10] memcg: enable accounting for posix_timers_cache slab
Date: Tue, 27 Jul 2021 15:33:35 -0700
Message-ID: <CALvZod6avZ=1qHug1ziLwYPNf1c0366Fb9pvYXBx9gh1HBcr6A@mail.gmail.com>
References: <6f21a0e0-bd36-b6be-1ffa-0dc86c06c470@virtuozzo.com>
 <cover.1627362057.git.vvs@virtuozzo.com> <57795560-025c-267c-6b1a-dea852d95530@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DhOk56syJ49REgl7tdN9zLvJ0rtCnMIghUB5ztLzd68=;
        b=X9HEBVjB56EM/zdnzOtQqZAcd0A9JsH/VivVb3IjMVcf2q1P2MKr9pSgpwXQw0ADgk
         0faL6G3ID3xJJdC1ecfdb5/kqZjJdV9V+Qg4Zg37NfIlS4FHVZ1EuUazf4JyT4dmfhJc
         2NtqH75DUU5rRtXBMt4o2ymJQ3zf1x3QCR45bc3EBBx0eNSZM1xf+ProTdk3JMSfWTjb
         zY69yaw9jmkHrJ70V/jLSd30wwsUeHl006UfdJ4lP7JLhgd+T3EcqgoeBjl+STNS4vyz
         ugREqEDyNA1GyqnZwjCZaI39uiE0CFbaxtDv+bw0BYDqAsBf4wJDTyb1zh6dmKY+6u9+
         2bGA==
In-Reply-To: <57795560-025c-267c-6b1a-dea852d95530-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Jul 26, 2021 at 10:34 PM Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
>
> A program may create multiple interval timers using timer_create().
> For each timer the kernel preallocates a "queued real-time signal",
> Consequently, the number of timers is limited by the RLIMIT_SIGPENDING
> resource limit. The allocated object is quite small, ~250 bytes,
> but even the default signal limits allow to consume up to 100 megabytes
> per user.
>
> It makes sense to account for them to limit the host's memory consumption
> from inside the memcg-limited container.
>
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> Reviewed-by: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
