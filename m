From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] mm: memcg/slab: Fix use after free in obj_cgroup_charge
Date: Thu, 29 Oct 2020 08:52:03 -0700
Message-ID: <CALvZod6uh7hV+_0FTpJehQtvw-f_UmYXNbiiu_YM_Egq4w-TUw@mail.gmail.com>
References: <20201028035013.99711-1-songmuchun@bytedance.com> <20201028035013.99711-2-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gKj2b5AWCjhkAnY/6wcR30bVFmlXN2BZgELxg/l/4Qc=;
        b=ughZoPhz2Dl8WA8zbaZkOQUKXOfM6TdfudncnPkaH2w2VErcLZjrLnKsTYj9mJlE/U
         QyScXP5T9cnoE2IK6W+7gVNn+ZvWHcM22Y9ZUEwMyjzAfcNCZFNjFf9oXkbajJ8nqXJu
         bEyM3S50OwxEjqUUeuuznmQ1bCZuQpI1VW1kLSjYLsGB2o6JB1JVzY+BTtt2yaZMjXn3
         YeZGcpo0qJzULk/nv1dnq5K8II6rmbN/8Xd0AJUP3d5A1Tf6EnQCpMo89CtdLZaPhvIx
         4fESoUlvLp+JGBeT4hJZyH0SRxSf01ifp27P8Efe/SZDUwGaK+/Dos8pOuvl1MJ2KpFH
         bVew==
In-Reply-To: <20201028035013.99711-2-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, areber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Tue, Oct 27, 2020 at 8:51 PM Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
>
> The rcu_read_lock/unlock only can guarantee that the memcg will
> not be freed, but it cannot guarantee the success of css_get to
> memcg.
>
> If the whole process of a cgroup offlining is completed between
> reading a objcg->memcg pointer and bumping the css reference on
> another CPU, and there are exactly 0 external references to this
> memory cgroup (how we get to the obj_cgroup_charge() then?),
> css_get() can change the ref counter from 0 back to 1.
>
> Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
