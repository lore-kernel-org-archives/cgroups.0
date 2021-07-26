From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: replace in_interrupt() by !in_task() in active_memcg()
Date: Mon, 26 Jul 2021 09:57:15 -0700
Message-ID: <CALvZod5Vj-_S2gRYpGgwhiCysXuA8z1WEV2ttP0t3Tdy2MU7KQ@mail.gmail.com>
References: <CALvZod5-XtaeawPtEgnp9xwouy0KfuDbpykB6Z3b+8YJyCrLVA@mail.gmail.com>
 <ed4448b0-4970-616f-7368-ef9dd3cb628d@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4CjU2RsYvZ9x+m1FosmYIR8QGbXd8bRq67CFAxCYneo=;
        b=KE/UnX3ML3Xw/5e0wwlWbS/xgPSyv+N4V3ynbBhw+BEqgokKCdDHOAQhI2EC4em4FI
         cF66Zk05KBdsDmPSV049y02ENoBdBIMLG4JuUL2hXcmObOgnJ+De8vRbYqHytF8iNP4t
         sc/n9LmbTDHqiyzZI4oM96x5N3DbQsNV71w1NIcbajXRmFKqfDUx/qyexNcykqgooXDb
         VWGTrDPpa96AfCN0BPcHQo1ZHj7ILA7C8IZgGhGDMDPa/PAjuJIAAzwEwgYZDhJmYbQf
         QrZsjEpOLvAXRhLTggf9OOBrPFb+jgt+OJKMdnoh81XeQppUTCOTYevElzQAK8t3lWnx
         MeXg==
In-Reply-To: <ed4448b0-4970-616f-7368-ef9dd3cb628d-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Mon, Jul 26, 2021 at 9:53 AM Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
>
> set_active_memcg() uses in_interrupt() check to select proper storage for
> cgroup: pointer on task struct or per-cpu pointer.
>
> It isn't fully correct: obsoleted in_interrupt() includes tasks with disabled BH.
> It's better to use '!in_task()' instead.
>
> Link: https://lkml.org/lkml/2021/7/26/487
> Fixes: 37d5985c003d ("mm: kmem: prepare remote memcg charging infra for interrupt contexts")
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Thanks.

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
