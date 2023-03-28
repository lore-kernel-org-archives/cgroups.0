From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v1 3/9] memcg: do not flush stats in irq context
Date: Tue, 28 Mar 2023 06:26:14 -0700
Message-ID: <CALvZod6n64b80+ZPX13bBiJWagcMJBstAcLauQoiT=UMdx0QGw@mail.gmail.com>
References: <20230328061638.203420-1-yosryahmed@google.com> <20230328061638.203420-4-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680009985;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8bJymL0yBKvMYTD1Xc/qu3GglkLI9FvB8Lv/yuqvRQc=;
        b=eZy1jM+Kd53ZIzWNbOqgWbWL45Dr+Nw9ANo2PWtQbmVaWtrjCdrDAwPWv3yK9p7pwn
         NdX2H4aYwg5QRk1CBz5Q+PDjxvTvxqOymyHBX8fhYiwV1krbMVJo3/thEa0eeD2ncqtr
         11MW+NX2xIo4RJWivNGz5B/TSrAzZmnzZLla0MAE4rR5mfGrSLcqNM08TimNues3s+u/
         7Y5UuSgD0RzJHWmkNAiahoW2q/TpdkuXvww90IJ4ZT0HDPDLUtzwosiL6k1Ay9MagttR
         Xll6pq0j7ma1HAlACEp1cDHFcxilfs9tVtLUSpSaT3tswN2NAz96yvtBv6Q2jzszETWW
         11rA==
In-Reply-To: <20230328061638.203420-4-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Mon, Mar 27, 2023 at 11:16=E2=80=AFPM Yosry Ahmed <yosryahmed@google.com=
> wrote:
>
> Currently, the only context in which we can invoke an rstat flush from
> irq context is through mem_cgroup_usage() on the root memcg when called
> from memcg_check_events(). An rstat flush is an expensive operation that
> should not be done in irq context, so do not flush stats and use the
> stale stats in this case.
>
> Arguably, usage threshold events are not reliable on the root memcg
> anyway since its usage is ill-defined.
>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Suggested-by: Shakeel Butt <shakeelb@google.com>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Acked-by: Shakeel Butt <shakeelb@google.com>
