From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] mm: memcg/slab: Rename *_lruvec_slab_state to *_lruvec_kmem_state
Date: Thu, 29 Oct 2020 08:52:54 -0700
Message-ID: <CALvZod5PcvSOszj7L-qbh_mOmKRwsrH+4Er_vQAiRqRf9GhcnA@mail.gmail.com>
References: <20201028035013.99711-1-songmuchun@bytedance.com> <20201028035013.99711-3-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MUp5qMqJOVbZKYoMqJH3XNqp7xnfXB9wzQttcgJOSd8=;
        b=cbK+yBgzyQXmtq+AD9wEnzaVNXe3mfmDrMTEqViTBtdbqHEURNS9luA0TyLL4nib30
         3Boxh9kOZuUY6VQJFAygdY2G/XhItlHRWqpCzGXy0TGt+a6ZGpmx0H5vJyv1/oxNH5Lx
         i/xJv2TVagtyrnp857y3WB+q1jPwQbfDjDVUHXiJlBCpCalLGRWzFFGhmXzUUxQ1HOz1
         PT5Jy/Z6QCT1J2noMaD3WXT+b9QyC3cSxQCoFRfderFo1vjlHqQKFlQZkosRXhQiHzC2
         qzuInwS3JX8FWL4UhHPNiE9oPFFNBjTTBGffzvpUFhyhtsXoDQ3oxDrAUgIf2njzqj5P
         Gp8g==
In-Reply-To: <20201028035013.99711-3-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, areber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Tue, Oct 27, 2020 at 8:51 PM Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
>
> The *_lruvec_slab_state is also suitable for pages allocated from buddy,
> not just for the slab objects. But the function name seems to tell us that
> only slab object is applicable. So we can rename the keyword of slab to
> kmem.
>
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
