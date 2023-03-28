From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v1 6/9] memcg: sleep during flushing stats in safe contexts
Date: Tue, 28 Mar 2023 08:09:43 -0700
Message-ID: <CALvZod7ekQD-ygrv2M-QZzDFVTj7O-v7iCYOHKp3iqG6c-Rt1g@mail.gmail.com>
References: <20230328061638.203420-1-yosryahmed@google.com> <20230328061638.203420-7-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680016194;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g+YmdZ2KifzhfvJEdg7p7f3TJNPgCoNZqPs2Cx2ndxo=;
        b=QxwODGEreqDxcIBzupdiBDMaDhVMLLzdv5CfZ77spG0lhFRud2y5nLrWzzAe/C6t7j
         ZOeI1MwZhgbHKufRmNFroSj3WemqRteMnB4I3zgWlrAqlMt2LkDL2uFa+Q4rzDU1486c
         dNNfXBmijmlYD705lBNf01BTyrCyDOrSF9RzPetnYAB3AYPpNLJYWV3MaUX8PnUEt/zX
         ZWmL0MYGGLpvauhUzo75H6kPcjwi3fp70mN3e4rJpmVhTv/25ZngEpNST6bZiJzZmjXl
         eT2y5J/uzC+53+JC7JZ5kq/eruzL0a+NXlhHEm6lqmXJr8zdho9ORG1Eq0Et9AmoG2T8
         Vnpg==
In-Reply-To: <20230328061638.203420-7-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Mon, Mar 27, 2023 at 11:16=E2=80=AFPM Yosry Ahmed <yosryahmed@google.com=
> wrote:
>
> Currently, all contexts that flush memcg stats do so with sleeping not
> allowed. Some of these contexts are perfectly safe to sleep in, such as
> reading cgroup files from userspace or the background periodic flusher.
>
> Refactor the code to make mem_cgroup_flush_stats() non-atomic (aka
> sleepable), and provide a separate atomic version. The atomic version is
> used in reclaim, refault, writeback, and in mem_cgroup_usage(). All
> other code paths are left to use the non-atomic version. This includes
> callbacks for userspace reads and the periodic flusher.
>
> Since refault is the only caller of mem_cgroup_flush_stats_ratelimited(),
> this function is changed to call the atomic version of
> mem_cgroup_flush_stats(). Reclaim and refault code paths are modified
> to do non-atomic flushing in separate later patches -- so
> mem_cgroup_flush_stats_ratelimited() will eventually become non-atomic.
>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Acked-by: Shakeel Butt <shakeelb@google.com>
