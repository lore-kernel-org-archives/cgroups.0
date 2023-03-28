From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v1 8/9] vmscan: memcg: sleep when flushing stats during reclaim
Date: Tue, 28 Mar 2023 08:19:33 -0700
Message-ID: <CALvZod7wJ-e-dHEhMynquiqQWFU2j+05wUyUe_yv_rBqJLu2rw@mail.gmail.com>
References: <20230328061638.203420-1-yosryahmed@google.com> <20230328061638.203420-9-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680016784;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZcS8n/4+59b+VXd6eXMn877oxhRuuiSj8mRyLdeW/tM=;
        b=Ar4Zra7am34XuPMhOvIUcA5xD0kVon3c99ACx4qVdYKc7PvMpeZbPc7LV4yiktxx93
         ugQcjwZKj3vROoqeRauJSOBpb/R7U0idQKpJU7syI6uOUqxt1iBIF8l4r9F7EviaUoDi
         5eGZKwhRwKRZxVY+kApK4O0HT7InuJX8mw3M0HfrCXDYjBj5bNd8FOTKy3yI06ZWgwjO
         HPR0Gz42df+GFqUpBoW8UGumfJGgpC4TxJYcxJ2J6DfmavIUYu4J0xle/MsU2yYWX7OR
         ESI5YObo7wWB9KiZs8NeKzMtj5Q2PHwXIhtBG2Qb1iBMLwwQvMGYO3D8HHRZ3Q70iOfB
         d1KQ==
In-Reply-To: <20230328061638.203420-9-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Mon, Mar 27, 2023 at 11:16=E2=80=AFPM Yosry Ahmed <yosryahmed@google.com=
> wrote:
>
> Memory reclaim is a sleepable context. Allow sleeping when flushing
> memcg stats to avoid unnecessarily performing a lot of work without
> sleeping. This can slow down reclaim code if flushing stats is taking
> too long, but there is already multiple cond_resched()'s in reclaim
> code.
>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Acked-by: Shakeel Butt <shakeelb@google.com>

> ---
>  mm/vmscan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a9511ccb936f..9c1c5e8b24b8 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2845,7 +2845,7 @@ static void prepare_scan_count(pg_data_t *pgdat, st=
ruct scan_control *sc)
>          * Flush the memory cgroup stats, so that we read accurate per-me=
mcg
>          * lruvec stats for heuristics.
>          */
> -       mem_cgroup_flush_stats_atomic();
> +       mem_cgroup_flush_stats();

I wonder if we should just replace this with
mem_cgroup_flush_stats_ratelimited().
