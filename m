From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] blk-cgroup: Flush stats before releasing blkcg_gq
Date: Wed, 24 May 2023 00:04:14 -0400
Message-ID: <11e81fc8-24db-54db-a518-b9bb67d0b504@redhat.com>
References: <20230524011935.719659-1-ming.lei@redhat.com>
 <CAJD7tkZkbro4H-QC=RJx_dfCdGQ5c=4NJhbFrcEmQSidaaMOmg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684901060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RTp4n2rYhzZJCAzB2miuWTK/N8BXkz9FRgQIh2oQlBI=;
        b=Pj/EOwMGzWhmiQh/4P16yTlF8GK6IwlctRT9N5MunUutNEJ/y6A96mWqX994ICBNT1sIZu
        G+yo1BjXksuS7JyWvOQOFFgnp2FQZWKoEhsmCNs1on6tDIIfxRx24EyJvw6YClJxWwbDst
        VldJjszO76uY1oS1QHDdd+FNwgh+J9w=
Content-Language: en-US
In-Reply-To: <CAJD7tkZkbro4H-QC=RJx_dfCdGQ5c=4NJhbFrcEmQSidaaMOmg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, mkoutny-IBi9RG/b67k@public.gmane.org

On 5/23/23 22:06, Yosry Ahmed wrote:
> Hi Ming,
>
> On Tue, May 23, 2023 at 6:21=E2=80=AFPM Ming Lei <ming.lei-H+wXaHxf7aLQT0=
dZR+AlfA@public.gmane.org> wrote:
>> As noted by Michal, the blkg_iostat_set's in the lockless list
>> hold reference to blkg's to protect against their removal. Those
>> blkg's hold reference to blkcg. When a cgroup is being destroyed,
>> cgroup_rstat_flush() is only called at css_release_work_fn() which
>> is called when the blkcg reference count reaches 0. This circular
>> dependency will prevent blkcg and some blkgs from being freed after
>> they are made offline.
> I am not at all familiar with blkcg, but does calling
> cgroup_rstat_flush() in offline_css() fix the problem? or can items be
> added to the lockless list(s) after the blkcg is offlined?
>
>> It is less a problem if the cgroup to be destroyed also has other
>> controllers like memory that will call cgroup_rstat_flush() which will
>> clean up the reference count. If block is the only controller that uses
>> rstat, these offline blkcg and blkgs may never be freed leaking more
>> and more memory over time.
>>
>> To prevent this potential memory leak:
>>
>> - a new cgroup_rstat_css_cpu_flush() function is added to flush stats for
>> a given css and cpu. This new function will be called in __blkg_release(=
).
>>
>> - don't grab bio->bi_blkg when adding the stats into blkcg's per-cpu
>> stat list, and this kind of handling is the most fragile part of
>> original patch
>>
>> Based on Waiman's patch:
>>
>> https://lore.kernel.org/linux-block/20221215033132.230023-3-longman-H+wX=
aHxf7aLQT0dZR+AlfA@public.gmane.org/
>>
>> Fixes: 3b8cc6298724 ("blk-cgroup: Optimize blkcg_rstat_flush()")
>> Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Cc: mkoutny-IBi9RG/b67k@public.gmane.org
>> Signed-off-by: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.or=
g>
>> ---
>>   block/blk-cgroup.c     | 15 +++++++++++++--
>>   include/linux/cgroup.h |  1 +
>>   kernel/cgroup/rstat.c  | 18 ++++++++++++++++++
>>   3 files changed, 32 insertions(+), 2 deletions(-)
>>
>> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>> index 0ce64dd73cfe..5437b6af3955 100644
>> --- a/block/blk-cgroup.c
>> +++ b/block/blk-cgroup.c
>> @@ -163,10 +163,23 @@ static void blkg_free(struct blkcg_gq *blkg)
>>   static void __blkg_release(struct rcu_head *rcu)
>>   {
>>          struct blkcg_gq *blkg =3D container_of(rcu, struct blkcg_gq, rc=
u_head);
>> +       struct blkcg *blkcg =3D blkg->blkcg;
>> +       int cpu;
>>
>>   #ifdef CONFIG_BLK_CGROUP_PUNT_BIO
>>          WARN_ON(!bio_list_empty(&blkg->async_bios));
>>   #endif
>> +       /*
>> +        * Flush all the non-empty percpu lockless lists before releasing
>> +        * us. Meantime no new bio can refer to this blkg any more given
>> +        * the refcnt is killed.
>> +        */
>> +       for_each_possible_cpu(cpu) {
>> +               struct llist_head *lhead =3D per_cpu_ptr(blkcg->lhead, c=
pu);
>> +
>> +               if (!llist_empty(lhead))
>> +                       cgroup_rstat_css_cpu_flush(&blkcg->css, cpu);
>> +       }
>>
>>          /* release the blkcg and parent blkg refs this blkg has been ho=
lding */
>>          css_put(&blkg->blkcg->css);
>> @@ -991,7 +1004,6 @@ static void blkcg_rstat_flush(struct cgroup_subsys_=
state *css, int cpu)
>>                  if (parent && parent->parent)
>>                          blkcg_iostat_update(parent, &blkg->iostat.cur,
>>                                              &blkg->iostat.last);
>> -               percpu_ref_put(&blkg->refcnt);
>>          }
>>
>>   out:
>> @@ -2075,7 +2087,6 @@ void blk_cgroup_bio_start(struct bio *bio)
>>
>>                  llist_add(&bis->lnode, lhead);
>>                  WRITE_ONCE(bis->lqueued, true);
>> -               percpu_ref_get(&bis->blkg->refcnt);
>>          }
>>
>>          u64_stats_update_end_irqrestore(&bis->sync, flags);
>> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
>> index 885f5395fcd0..97d4764d8e6a 100644
>> --- a/include/linux/cgroup.h
>> +++ b/include/linux/cgroup.h
>> @@ -695,6 +695,7 @@ void cgroup_rstat_flush(struct cgroup *cgrp);
>>   void cgroup_rstat_flush_atomic(struct cgroup *cgrp);
>>   void cgroup_rstat_flush_hold(struct cgroup *cgrp);
>>   void cgroup_rstat_flush_release(void);
>> +void cgroup_rstat_css_cpu_flush(struct cgroup_subsys_state *css, int cp=
u);
>>
>>   /*
>>    * Basic resource stats.
>> diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
>> index 9c4c55228567..96e7a4e6da72 100644
>> --- a/kernel/cgroup/rstat.c
>> +++ b/kernel/cgroup/rstat.c
>> @@ -281,6 +281,24 @@ void cgroup_rstat_flush_release(void)
>>          spin_unlock_irq(&cgroup_rstat_lock);
>>   }
>>
>> +/**
>> + * cgroup_rstat_css_cpu_flush - flush stats for the given css and cpu
>> + * @css: target css to be flush
>> + * @cpu: the cpu that holds the stats to be flush
>> + *
>> + * A lightweight rstat flush operation for a given css and cpu.
>> + * Only the cpu_lock is being held for mutual exclusion, the cgroup_rst=
at_lock
>> + * isn't used.
> (Adding linux-mm and memcg maintainers)
> +Linux-MM +Michal Hocko +Shakeel Butt +Johannes Weiner +Roman Gushchin
> +Muchun Song
>
> I don't think flushing the stats without holding cgroup_rstat_lock is
> safe for memcg stats flushing. mem_cgroup_css_rstat_flush() modifies
> some non-percpu data (e.g. memcg->vmstats->state,
> memcg->vmstats->state_pending).
>
> Perhaps have this be a separate callback than css_rstat_flush() (e.g.
> css_rstat_flush_cpu() or something), so that it's clear what
> subsystems support this? In this case, only blkcg would implement this
> callback.

That function is added to call blkcg_rstat_flush() only which flush the=20
stat in the blkcg and it should be safe. I agree that we should note=20
that in the comment to list the preconditions for calling it.

Cheers,
Longman

