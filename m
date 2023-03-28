From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v1 9/9] memcg: do not modify rstat tree for zero updates
Date: Tue, 28 Mar 2023 08:20:15 -0700
Message-ID: <CALvZod4boccrKxrCm9aDBCupror1zC0J3spHeidSiAZgei_r9Q@mail.gmail.com>
References: <20230328061638.203420-1-yosryahmed@google.com> <20230328061638.203420-10-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680016826;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ONZYLiGDk21RMFgMpaXH7s4UWxHkNsJ+wUGHRFEkuCc=;
        b=c8ynwXPsqcK1BZ6E1vrYfDJcqWTKC225pVcmZQQIcGa+4WzKkC/FwoXCPTIZP0uqNW
         jalQxGai5+TUgtreV4lGVmixYr6hAEF97bJP6udFm1yicUDr3KPFXDmLE2aJHchJhqAj
         7J4XebvBwK691HXXFYm5J21xAY8msOd5k/OOZSjNYpGC2QnLfu+09Jc4Pbhux+Hpz5l/
         35fyjYPGGFQ/WwDLWWO9LuBpYSShrGA9j+zLmlaXc44UkvAaGsRQX8zqrH4aOojgeFnH
         DBkes4tXkEWXNeFd/n9ARofjF5njrlz0PZjoz9j8BGF67LqPGhfa7EH16H69NZfFsNx5
         Xcaw==
In-Reply-To: <20230328061638.203420-10-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Mon, Mar 27, 2023 at 11:17=E2=80=AFPM Yosry Ahmed <yosryahmed@google.com=
> wrote:
>
> In some situations, we may end up calling memcg_rstat_updated() with a
> value of 0, which means the stat was not actually updated. An example is
> if we fail to reclaim any pages in shrink_folio_list().
>
> Do not add the cgroup to the rstat updated tree in this case, to avoid
> unnecessarily flushing it.
>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Acked-by: Shakeel Butt <shakeelb@google.com>
