From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 1/7] cgroup: rstat: only disable interrupts for the
 percpu lock
Date: Wed, 22 Mar 2023 21:29:46 -0700
Message-ID: <CALvZod7e7dMmkhKtXPAxmXjXQoTyeBf3Bht8HJC8AtWW93As3g@mail.gmail.com>
References: <20230323040037.2389095-1-yosryahmed@google.com> <20230323040037.2389095-2-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679545798;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M6Z12Yl5nLSsOMl2fi1BiOi6Pl2TD3G32jOrqzC3mL0=;
        b=ONDvFP8aiDe7lC9ChfSlJwxuZjUc2taO1V0gqzpNaWPq+3DUFbaJ6fBfqtYS6UBhPl
         +twFVu1wV8x5fCbwTn5V1Lihx3V6LjQiFhqoVRf026zxNZNYI0wCxZtvkrzwBlnJAHlw
         phT88TX9S6JJn8R+sNaPoepfNJXosdRUbxC7lr2EzAr2CeMtN0FpfSHp9qIwVrUphpt2
         ezZgnwr14FxwMXpOon5ciF0R3aTW1OqjXNqoit8Tl9YPD6dL6OGJbccfeA3XifU87yLl
         C6wTyQGFhHUUnuiz9u9pd87A1uzmMozyDMjNWHjTHYCARyEkS5DvcWOsJEwZLLtgBqq7
         TEdA==
In-Reply-To: <20230323040037.2389095-2-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Mar 22, 2023 at 9:00=E2=80=AFPM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>=
 wrote:
>
> Currently, when sleeping is not allowed during rstat flushing, we hold
> the global rstat lock with interrupts disabled throughout the entire
> flush operation. Flushing in an O(# cgroups * # cpus) operation, and
> having interrupts disabled throughout is dangerous.
>
> For some contexts, we may not want to sleep, but can be interrupted
> (e.g. while holding a spinlock or RCU read lock). As such, do not
> disable interrupts throughout rstat flushing, only when holding the
> percpu lock. This breaks down the O(# cgroups * # cpus) duration with
> interrupts disabled to a series of O(# cgroups) durations.
>
> Furthermore, if a cpu spinning waiting for the global rstat lock, it
> doesn't need to spin with interrupts disabled anymore.
>
> If the caller of rstat flushing needs interrupts to be disabled, it's up
> to them to decide that, and it should be fine to hold the global rstat
> lock with interrupts disabled. There is currently a single context that
> may invoke rstat flushing with interrupts disabled, the
> mem_cgroup_flush_stats() call in mem_cgroup_usage(), if called from
> mem_cgroup_threshold().
>
> To make it safe to hold the global rstat lock with interrupts enabled,
> make sure we only flush from in_task() contexts. The side effect of that
> we read stale stats in interrupt context, but this should be okay, as
> flushing in interrupt context is dangerous anyway as it is an expensive
> operation, so reading stale stats is safer.
>
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Couple of questions:

1. What exactly is cgroup_rstat_lock protecting? Can we just remove it
altogether?
2. Are we really calling rstat flush in irq context?
3. The mem_cgroup_flush_stats() call in mem_cgroup_usage() is only
done for root memcg. Why is mem_cgroup_threshold() interested in root
memcg usage? Why not ignore root memcg in mem_cgroup_threshold() ?
