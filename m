From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v5 0/5] cgroup: eliminate atomic rstat flushing
Date: Fri, 21 Apr 2023 11:54:25 -0700
Message-ID: <CAJD7tkZKBGzBjkTGiVtwA=0VJ_L+UdGXjMWL7RcurQoooHTAUg@mail.gmail.com>
References: <20230421174020.2994750-1-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682103304; x=1684695304;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AyMpFu/gW7V1QrWAD4ujKdEEmizb8dHB+Px9T26Bj7E=;
        b=isKqoY3MjZ10VkA1kWh+K/1YIbVB4ZAvLYZAyLAJfiirefha06VhT3jDD1NVNvMn8Q
         J9hQAx4CkqnErz52Kq2lCF6CcQ2DlcWv1SDGLyfzbCLdaOS2m6YvuHyDkbCYi2O3KRzU
         YxJPXTplFtFOoXZ9rGRR05f8wB2F/PTGdI3KnL86UeQFtPuP5pmvYzlw39z5pkHLEMWv
         0GYdOXyk3zC7QDBU4hzTaWRiOZIzh7kFLLqwAnDnVcpsKaH+o/o3VaBMuPNQ5xBKNSSB
         eNGUVOqm2tTMl+uuWvl6lg6RC+1CnCnvJFQ5ePHUUfAnd9D6D/VKsAE1UZh3+ZtCq6Qa
         HlZQ==
In-Reply-To: <20230421174020.2994750-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Fri, Apr 21, 2023 at 10:40=E2=80=AFAM Yosry Ahmed <yosryahmed@google.com=
> wrote:
>
> A previous patch series ([1] currently in mm-stable) changed most
> atomic rstat flushing contexts to become non-atomic. This was done to
> avoid an expensive operation that scales with # cgroups and # cpus to
> happen with irqs disabled and scheduling not permitted. There were two
> remaining atomic flushing contexts after that series. This series tries
> to eliminate them as well, eliminating atomic rstat flushing completely.
>
> The two remaining atomic flushing contexts are:
> (a) wb_over_bg_thresh()->mem_cgroup_wb_stats()
> (b) mem_cgroup_threshold()->mem_cgroup_usage()
>
> For (a), flushing needs to be atomic as wb_writeback() calls
> wb_over_bg_thresh() with a spinlock held. However, it seems like the
> call to wb_over_bg_thresh() doesn't need to be protected by that
> spinlock, so this series proposes a refactoring that moves the call
> outside the lock criticial section and makes the stats flushing
> in mem_cgroup_wb_stats() non-atomic.
>
> For (b), flushing needs to be atomic as mem_cgroup_threshold() is called
> with irqs disabled. We only flush the stats when calculating the root
> usage, as it is approximated as the sum of some memcg stats (file, anon,
> and optionally swap) instead of the conventional page counter. This
> series proposes changing this calculation to use the global stats
> instead, eliminating the need for a memcg stat flush.
>
> After these 2 contexts are eliminated, we no longer need
> mem_cgroup_flush_stats_atomic() or cgroup_rstat_flush_atomic(). We can
> remove them and simplify the code.
>
> [1] https://lore.kernel.org/linux-mm/20230330191801.1967435-1-yosryahmed@=
google.com/
>
> RFC -> v1:
> - Collected R-b's and A-b's (Thanks everyone!).
> - Rebased onto mm-stable.
> - Cosmetic changes to commit logs.
>
> RFC: https://lore.kernel.org/linux-mm/20230403220337.443510-1-yosryahmed@=
google.com/

This is v1, not v5. I really suck at sending emails. Sorry.

>
> Yosry Ahmed (5):
>   writeback: move wb_over_bg_thresh() call outside lock section
>   memcg: flush stats non-atomically in mem_cgroup_wb_stats()
>   memcg: calculate root usage from global state
>   memcg: remove mem_cgroup_flush_stats_atomic()
>   cgroup: remove cgroup_rstat_flush_atomic()
>
>  fs/fs-writeback.c          | 16 +++++++----
>  include/linux/cgroup.h     |  1 -
>  include/linux/memcontrol.h |  5 ----
>  kernel/cgroup/rstat.c      | 26 ++++--------------
>  mm/memcontrol.c            | 54 ++++++++------------------------------
>  5 files changed, 27 insertions(+), 75 deletions(-)
>
> --
> 2.40.0.634.g4ca3ef3211-goog
>
