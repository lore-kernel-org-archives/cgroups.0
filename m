From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [RFC PATCH 4/7] memcg: sleep during flushing stats in safe contexts
Date: Thu, 23 Mar 2023 09:01:12 -0700
Message-ID: <CAJD7tkZ7Dz9myftc9bg7jhiaOYcn7qJ+V4sxZ_2kfnb+k=zhJQ@mail.gmail.com>
References: <20230323040037.2389095-1-yosryahmed@google.com>
 <20230323040037.2389095-5-yosryahmed@google.com> <20230323155613.GC739026@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679587309;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aTWMwAKhcBWTOZZjhXh8n/JlmrY7tCK7IC8lep3UpDs=;
        b=MOKQDwxr/deUL4llWSGhblhVEo9WcWB8efRLUE2dc0/j/VRqv9bfW7mrppwQxxgW5/
         tkBhmPc2q+ri9+Bv9s4HE1ypBchPI41TQJZklkyPM5Q6PZGpWEfKqozM+UTPGQQJE0dM
         hJxqGnb+d2+KlRMAUvMO8LiGIBEeAtLWMEoXFNt8F4/jnSiPtWtQD6m19Wr8h/VOWnzd
         8/xfKDTgIMwacD63eX1ewPzVWyQaygjPDTysXqZ5QUBHWAg+Pc4Q/l1gT3Kja+vh6XdT
         ZKyu/0YKEgAds7xfT+9+aomHkoK1r0md0ZyzBUSwzUwg/Ha4/tOPzpEAi28hh7nmSQNC
         hOsQ==
In-Reply-To: <20230323155613.GC739026@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Thu, Mar 23, 2023 at 8:56=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Thu, Mar 23, 2023 at 04:00:34AM +0000, Yosry Ahmed wrote:
> > @@ -644,26 +644,26 @@ static void __mem_cgroup_flush_stats(void)
> >               return;
> >
> >       flush_next_time =3D jiffies_64 + 2*FLUSH_TIME;
> > -     cgroup_rstat_flush(root_mem_cgroup->css.cgroup, false);
> > +     cgroup_rstat_flush(root_mem_cgroup->css.cgroup, may_sleep);
>
> How is it safe to call this with may_sleep=3Dtrue when it's holding the
> stats_flush_lock?

stats_flush_lock is always called with trylock, it is only used today
so that we can skip flushing if another cpu is already doing a flush
(which is not 100% correct as they may have not finished flushing yet,
but that's orthogonal here). So I think it should be safe to sleep as
no one can be blocked waiting for this spinlock.

Perhaps it would be better semantically to replace the spinlock with
an atomic test and set, instead of having a lock that can only be used
with trylock?

>
> >       atomic_set(&stats_flush_threshold, 0);
> >       spin_unlock(&stats_flush_lock);
> >  }
