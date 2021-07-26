From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v5 02/16] memcg: enable accounting for IP address and
 routing-related objects
Date: Mon, 26 Jul 2021 06:48:02 -0700
Message-ID: <CALvZod5-XtaeawPtEgnp9xwouy0KfuDbpykB6Z3b+8YJyCrLVA@mail.gmail.com>
References: <CALvZod66KF-8xKB1dyY2twizDE=svE8iXT_nqvsrfWg1a92f4A@mail.gmail.com>
 <cover.1626688654.git.vvs@virtuozzo.com> <9123bca3-23bb-1361-c48f-e468c81ad4f6@virtuozzo.com>
 <CALvZod4HCRHpPJtGE=8tU1Yj=WsWHpocP0q0JU3r4F2fMmAw5w@mail.gmail.com> <08151b5b-f84a-aa32-82a6-0b6e94e63338@virtuozzo.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ivg9o7rg5ISps4s8xPiG/wJJnOVUYqQKPCeKI3UTaIM=;
        b=wDfbtJKa8rkewnwwlv1vOunBRLNNIZ0IAovVCNkT8dYkmoebPukHdYjqoBpQQCkIPA
         BSt7fdmqa99u+m2zWNqQXPIC1VyfNkdhpQOt/dZe5Qh9mr62G7pLWe8ZCGTuungQ1xzl
         IXolVFnrUHy9hm4a4ZtiCHE96Lwb9Wo+lPA++LrNbqUvHEi77vClI/M3LdrANuaNqJy9
         8v7id8U/2+MLo/Kt9EM/YRgkO9MPXW/E5uW9KkqLdXpt9ojmw6qiGWwGmimZ9Bw2NJoY
         kLz9pzTwHjsCTamE5VXBJc5y6ICqsWUmNjz05PYzPX3FCWkc4HYvNnmpELZmljm1jO5t
         nrcQ==
In-Reply-To: <08151b5b-f84a-aa32-82a6-0b6e94e63338@virtuozzo.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Cgroups <cgroups@vger.kernel.org>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, David Ahern <dsahern@kernel.org>, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Mon, Jul 26, 2021 at 3:23 AM Vasily Averin <vvs@virtuozzo.com> wrote:
>
[...]
> >
> > Can you please also change in_interrupt() in active_memcg() as well?
> > There are other unrelated in_interrupt() in that file but the one in
> > active_memcg() should be coupled with this change.
>
> Could you please elaborate?
> From my point of view active_memcg is paired with set_active_memcg() and is not related to this case.
> active_memcg uses memcg that was set by set_active_memcg(), either from int_active_memcg per-cpu pointer
> or from current->active_memcg pointer.
> I'm agree, it in case of disabled BH it is incorrect to use int_active_memcg,
> we still can use current->active_memcg. However it isn't a problem,
> memcg will be properly provided in both cases.
>
> I think it's better to fix set_active_memcg/active_memcg by separate patch.
>
> Am I missed something perhaps?
>

No you are right. That should be a separate patch.
