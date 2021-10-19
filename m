From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v3] memcg, kmem: further deprecate kmem.limit_in_bytes
Date: Tue, 19 Oct 2021 13:03:32 -0700
Message-ID: <CALvZod7QPR1Zz3XcN1CJvm_DuWomoR7MrS7uEyCBHNMX5c8AiQ@mail.gmail.com>
References: <20211019153408.2916808-1-shakeelb@google.com> <20211019125147.0ad010f318bbd8233cadcdae@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DfGhAHT9HhtqeTpI2TYryH6uFTCkzU6q0SGRJXp8/6w=;
        b=gCRm1I8UHyDh7Mi8CTU+K3MIul4qxwvNzh0Ij1H6xm95MW00t7BiwXquwR0X7cgHwj
         ArlZ0SIMAiyoiWadSJTfCevxdOFU84GJu+4mFCD3CSATO/QwyMDx/UJy35eBz9r7qzft
         QuGRgjjA4D9Dq69peRhx0vqHfiIGricAiY1wmqvS9F5zKst3bh3NzKlkt4dDmPZ0TT3I
         j9bsZL1/TnO5QKdZcJ8SdlN4xT3yvpSGbw3FXc6ypi5maL3g4PBHM220xi+XS0bYuzaL
         +qqGzod2mROnt/MeAxtoA895HOcPk7PqDA8Td3He8iv4+glZAzLW2Ena2Is1cvXFZmWt
         7BZQ==
In-Reply-To: <20211019125147.0ad010f318bbd8233cadcdae@linux-foundation.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vasily Averin <vvs@virtuozzo.com>, Roman Gushchin <guro@fb.com>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, Muchun Song <songmuchun@bytedance.com>

On Tue, Oct 19, 2021 at 12:51 PM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Tue, 19 Oct 2021 08:34:08 -0700 Shakeel Butt <shakeelb@google.com> wrote:
>
> > The deprecation process of kmem.limit_in_bytes started with the commit
> > 0158115f702 ("memcg, kmem: deprecate kmem.limit_in_bytes") which also
> > explains in detail the motivation behind the deprecation. To summarize,
> > it is the unexpected behavior on hitting the kmem limit. This patch
> > moves the deprecation process to the next stage by disallowing to set
> > the kmem limit. In future we might just remove the kmem.limit_in_bytes
> > file completely.
> >
> > ...
> >
> > @@ -3791,10 +3766,8 @@ static ssize_t mem_cgroup_write(struct kernfs_open_file *of,
> >                       ret = mem_cgroup_resize_max(memcg, nr_pages, true);
> >                       break;
> >               case _KMEM:
> > -                     pr_warn_once("kmem.limit_in_bytes is deprecated and will be removed. "
> > -                                  "Please report your usecase to linux-mm@kvack.org if you "
> > -                                  "depend on this functionality.\n");
> > -                     ret = memcg_update_kmem_max(memcg, nr_pages);
> > +                     /* kmem.limit_in_bytes is deprecated. */
> > +                     ret = -ENOTSUPP;
> >                       break;
> >               case _TCP:
> >                       ret = memcg_update_tcp_max(memcg, nr_pages);
>
> checkpatch said "ENOTSUPP is not a SUSV4 error code, prefer EOPNOTSUPP"?

I should have run checkpatch and Andrew, please replace ENOTSUPP with
EOPNOTSUPP. Thanks for catching this.
