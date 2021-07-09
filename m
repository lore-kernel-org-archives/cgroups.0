From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 1/3] mm, memcg: add mem_cgroup_disabled checks in
 vmpressure and swap-related functions
Date: Fri, 9 Jul 2021 09:00:39 -0700
Message-ID: <CALvZod7MUemu_=ffcE3tpg_=Mazcp6OB=fSJxC9Sa2-uPPLqbA@mail.gmail.com>
References: <20210709000509.2618345-1-surenb@google.com> <20210709000509.2618345-2-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/xZI0OajFf5/ziUaY+H5m9Nzo8ghS9n7erS+9RJcXYI=;
        b=W8p7yxoX3G5IefHMsRi4RO40HwPkUuZKO3Wv0ZsSnEGlWk9UWvnKmQGYINVPYcChA9
         WqVnGAT7Ht7kptj0cHK+RO8ue80geR+dn9mK06BE+MSmBWZxzpFqj2liQKKsHQHwEm8/
         9adlW2sI8CwSPhxv6HJlqtEhnnly5kd4B07uwGmd8xdOgTfH1L2I0TPxkaJjN8DDlkDD
         1YtUnGHXQCYRub16v4ymPOdl3+c8L4KyEZjjF4acYce5MxvCBZ1TeeoUX+rWBAMUwjrR
         qfVOlkfEB974p6LhdqPzqpMyry1nWccBFX0SbgLebwQ9nEFcv5nZaY0H5dTUUHBoyq0a
         k+qA==
In-Reply-To: <20210709000509.2618345-2-surenb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Muchun Song <songmuchun@bytedance.com>, Yang Shi <shy828301@gmail.com>, alexs@kernel.org, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Wei Yang <richard.weiyang@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, Jens Axboe <axboe@kernel.dk>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, Alistair Popple <apopple@nvidia.com>, Minchan Kim <minchan@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux

On Thu, Jul 8, 2021 at 5:05 PM Suren Baghdasaryan <surenb@google.com> wrote:
>
[...]

> --- a/mm/vmpressure.c
> +++ b/mm/vmpressure.c
> @@ -240,7 +240,12 @@ static void vmpressure_work_fn(struct work_struct *work)
>  void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
>                 unsigned long scanned, unsigned long reclaimed)
>  {
> -       struct vmpressure *vmpr = memcg_to_vmpressure(memcg);
> +       struct vmpressure *vmpr;
> +
> +       if (mem_cgroup_disabled())
> +               return;
> +
> +       vmpr = memcg_to_vmpressure(memcg);

I was wondering why this was not crashing but realized that we
allocate root_mem_cgroup even in cgroup_disable=memory case.

Reviewed-by: Shakeel Butt <shakeelb@google.com>
