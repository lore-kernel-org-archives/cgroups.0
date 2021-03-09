From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/9] memcg: accounting for allocations called with
 disabled BH
Date: Tue, 9 Mar 2021 11:39:41 -0800
Message-ID: <CALvZod4QiAhjgQOGO4KYCs4-GjUmqb6th+4tr8nQ+bPumGFzNg@mail.gmail.com>
References: <18a0ae77-89ff-2679-ab19-378e38ce2be2@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O46M3IIWV4RV88W2VUWchBj7kwlQmirz9u+5Alym8yc=;
        b=m2G4dpRKCKk4jAg5sje4s8QPtz+nuPv9/ny7IjNDQ40seewDXWUrpQnBW2ZtvbFkdX
         sLuivAlg3hdtXWVYzKghMWNIet57gAxVg5Jyd4Chjk0Ss54nblyCP3DKQdjk+q8ip9uw
         dQaw4fDbgJqwnukPuBBi/X6uptSI19BeLBryTRWseEiZ7kDnorSJsrWLexiAEGQ/5l9Y
         ut0CwZo2K9aDnRu9OpC6gyYJPbdZCkq2DDo2UJzxL20MOhLH65tBairR93pWREEo5cZ0
         M7ciABLzghZJ8mmp3ZdaBBnplgO7juWHIaJEDMMB5VcQR08TBNYL+JcR/VymX7c4FI57
         oCdg==
In-Reply-To: <18a0ae77-89ff-2679-ab19-378e38ce2be2-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Tue, Mar 9, 2021 at 12:04 AM Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
>
> in_interrupt() check in memcg_kmem_bypass() is incorrect because
> it does not allow to account memory allocation called from task context
> with disabled BH, i.e. inside spin_lock_bh()/spin_unlock_bh() sections
>
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

In that file in_interrupt() is used at other places too. Should we
change those too?

> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
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
>                 return true;
>
>         return false;
> --
> 1.8.3.1
>
