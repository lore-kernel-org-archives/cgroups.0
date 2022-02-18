From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 4/5] mm/memcg: Opencode the inner part of
 obj_cgroup_uncharge_pages() in drain_obj_stock()
Date: Fri, 18 Feb 2022 10:40:01 -0800
Message-ID: <CALvZod7PTwJp3eFgXiG1Qb8fJZviFZRBZ1OehV+85pwNdwcHYQ@mail.gmail.com>
References: <20220217094802.3644569-1-bigeasy@linutronix.de> <20220217094802.3644569-5-bigeasy@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JG7CBAmO1pjbLUUkaVNCRR+CekFRKgJLo0xYPxAI1lw=;
        b=P/EPFiUa21gKmNj7gaOV4hyboq1mh+5Kwu1Zzsh/B+dv3dHVY/RAViisL/ZO3ek6yK
         QDakcXkEH72XrDe7zvdXxjOijB4CbhWy4rm+hFVdoaJGMxDEZsXAKE4h1RVoW5QNmzUx
         xWKNe3jLE5H0KVn7YdrxL5nDSOAeAc9HS5/+QnUU85/JFkQz4WD4wUJbV55sdOYrb/Fn
         kRX1jgJNzMVN1nygaY40Y4N6V5OqaRnKM8myWEhGQZSvP4ZejRmOWnIzB6LCwPihIEPY
         w/mgMpYfQAkrK+ebvEaBYKIsG/66BdH7WrBc8sr9OtPhTJybesZ8RAnqOTLP01OM4dr8
         fl5A==
In-Reply-To: <20220217094802.3644569-5-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Thu, Feb 17, 2022 at 1:48 AM Sebastian Andrzej Siewior
<bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
>
> From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>
> Provide the inner part of refill_stock() as __refill_stock() without
> disabling interrupts. This eases the integration of local_lock_t where
> recursive locking must be avoided.
> Open code obj_cgroup_uncharge_pages() in drain_obj_stock() and use
> __refill_stock(). The caller of drain_obj_stock() already disables
> interrupts.
>
> [bigeasy: Patch body around Johannes' diff ]
>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
