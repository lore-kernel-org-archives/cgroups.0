From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v1 2/9] memcg: rename mem_cgroup_flush_stats_"delayed" to "ratelimited"
Date: Tue, 28 Mar 2023 06:25:13 -0700
Message-ID: <CALvZod50Kh602rFii_=8q+_xdZTqHfDJyc_XNNTixGTqgcSDHA@mail.gmail.com>
References: <20230328061638.203420-1-yosryahmed@google.com> <20230328061638.203420-3-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680009924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aKr9MaZxGZc9u8ZhIE9so1jdgqHxAOgc8JTrWbL9sqY=;
        b=i9jvfdCeB9SsJnyBiAbhdPLhoxjsfRopr7eARS5rGyPO0aOs26naUPy0TOlNDXReWF
         R5Ea79kbAr+glBAXFOfEsjm49+Nm5fB3G3LIqw9DO4pIhWqBfQICEKbBtdAas72TZMRa
         2naeIrUIfdDmFPzU0ieyV8VHQOarplR5OZFhsLhdFTJ17Qsili22215RkxE3w61P7NqR
         QN1VePuwazlq07Mx1/r+u1FhPyrqxDDF2mBmsHwUrqWufwHsPj0sdlguYWltwhWjNVjP
         5VKvQ0LXJosLvebPB+Yu1xwBQd5x8bAJlaPp08d3BXWvpGTaWuuE3u78gHSrMcThnKrJ
         Ve5g==
In-Reply-To: <20230328061638.203420-3-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Mon, Mar 27, 2023 at 11:16=E2=80=AFPM Yosry Ahmed <yosryahmed@google.com=
> wrote:
>
> mem_cgroup_flush_stats_delayed() suggests his is using a delayed_work,
> but this is actually sometimes flushing directly from the callsite.
>
> What it's doing is ratelimited calls. A better name would be
> mem_cgroup_flush_stats_ratelimited().
>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Acked-by: Shakeel Butt <shakeelb@google.com>
