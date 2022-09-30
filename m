From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v6 3/3] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Fri, 30 Sep 2022 14:34:11 -0400
Message-ID: <93cb697d-3bd5-65f9-96c4-662345360337@redhat.com>
References: <20220602192020.166940-1-longman@redhat.com>
 <20220602192020.166940-4-longman@redhat.com>
 <20220608165732.GB19399@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664562854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=blyeoX43uCWFLodZ33Eb0oRW8hMqk+cpk/XX0tInob4=;
        b=a8tqbI5cJ7Cja169ZRjitXI4rRhO2ksYWYjblmdyQS3317B8D21kob25Uv5fpk1taGxRHQ
        2u3KkkoXIb5Os6xiccLBtL9jE/tDpFJIQoBrVffmLWZBPwRV4WpqQxANfocMcq8hKqj9L0
        1nQvhylEarVnDkDGcrHav3eNg6V49qs=
Content-Language: en-US
In-Reply-To: <20220608165732.GB19399@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>

On 6/8/22 12:57, Michal Koutn=C3=BD wrote:
> @@ -2011,9 +2092,16 @@ void blk_cgroup_bio_start(struct bio *bio)
>>   	}
>>   	bis->cur.ios[rwd]++;
>>  =20
>> +	if (!READ_ONCE(bis->lnode.next)) {
>> +		struct llist_head *lhead =3D per_cpu_ptr(blkcg->lhead, cpu);
>> +
>> +		llist_add(&bis->lnode, lhead);
>> +		percpu_ref_get(&bis->blkg->refcnt);
>> +	}
>> +
> When a blkg's cgroup is rmdir'd, what happens with the lhead list?
> We have cgroup_rstat_exit() in css_free_rwork_fn() that ultimately flushe=
s rstats.
> init_and_link_css however adds reference form blkcg->css to cgroup->css.
> The blkcg->css would be (transitively) pinned by the lhead list and
> hence would prevent the final flush (when refs drop to zero). Seems like
> a cyclic dependency.

That is not true. The percpu lhead list is embedded in blkcg but it does=20
not pin blkcg. What the code does is to pin the blkg from being freed=20
while it is on the lockless list. I do need to move the percpu_ref_put()=20
in blkcg_rstat_flush() later to avoid use-after-free though.


>
> Luckily, there's also per-subsys flushing in css_release which could be
> moved after rmdir (offlining) but before last ref is gone:
>
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index adb820e98f24..d830e6a8fb3b 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -5165,11 +5165,6 @@ static void css_release_work_fn(struct work_struct=
 *work)
>
>          if (ss) {
>                  /* css release path */
> -               if (!list_empty(&css->rstat_css_node)) {
> -                       cgroup_rstat_flush(cgrp);
> -                       list_del_rcu(&css->rstat_css_node);
> -               }
> -
>                  cgroup_idr_replace(&ss->css_idr, NULL, css->id);
>                  if (ss->css_released)
>                          ss->css_released(css);
> @@ -5279,6 +5274,11 @@ static void offline_css(struct cgroup_subsys_state=
 *css)
>          css->flags &=3D ~CSS_ONLINE;
>          RCU_INIT_POINTER(css->cgroup->subsys[ss->id], NULL);
>
> +       if (!list_empty(&css->rstat_css_node)) {
> +               cgroup_rstat_flush(css->cgrp);
> +               list_del_rcu(&css->rstat_css_node);
> +       }
> +
>          wake_up_all(&css->cgroup->offline_waitq);
>   }
>
> (not tested)

I don't think that code is necessary. Anyway, I am planning go make a=20
parallel set of helpers for a lockless list with sentinel variant as=20
suggested.

Thanks,
Longman

