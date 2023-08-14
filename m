From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH net-next v2] net-memcg: Fix scope of sockmem pressure indicators
Date: Mon, 14 Aug 2023 13:18:23 -0700
Message-ID: <CALvZod5C3yWdgWr83EAdVUCH5PEK8ew7Q+FOt_zGOFOE9HVyQQ@mail.gmail.com>
References: <20230814070923.35769-1-wuyun.abel@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev+bounces-27465-gl-netdev-2=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692044316; x=1692649116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LFWKye89AohEqYgCuqyO0wjrP9O8bS1Mmve3otWwOUQ=;
        b=updUYgXLDGG4jlzZd5VTLcn4ck7IV7JsmtsFDKY3gGoK8cHcDcVAF65Px8wrcx4Rpw
         5aeohd2TIc+lBdHaUcKOLojjvG5i1Sjtomi5Efvu9HKhrYtbkVsFBJQDc/gXDZXhrqDd
         BTw7bVAxF4h6WbITliiLtT4buweGCJUSmaTwZQspzLmIKsmCe14t6a9HVIWT6YKlLvDV
         mNs74AwJ0zU0/tetCBfCfSp0XcnRJ1m3IpOmybV/upnND0Ytv7jyrvl1TXrF9NGHKWnc
         ExRJysByXqm0J8czAGmplNNLUBdHGyai37qngjYtFkqBvNbS/eLxW99NXQ+KREqbFOkq
         +u2A==
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
In-Reply-To: <20230814070923.35769-1-wuyun.abel@bytedance.com>
Content-Type: text/plain; charset="windows-1252"
To: Abel Wu <wuyun.abel@bytedance.com>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, David Ahern <dsahern@kernel.org>, Yosry Ahmed <yosryahmed@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Yu Zhao <yuzhao@google.com>, Kefeng Wang <wangkefeng.wang@huawei.com>, Yafang Shao <laoar.shao@gmail.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, Martin KaFai Lau <martin.lau@kernel.org>, Breno Leitao <leitao@debian.org>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, David Howells <dhowells@redhat.com>, Jason Xing <kernelxing@tencent.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>

On Mon, Aug 14, 2023 at 12:09=E2=80=AFAM Abel Wu <wuyun.abel@bytedance.com>=
 wrote:
>
> Now there are two indicators of socket memory pressure sit inside
> struct mem_cgroup, socket_pressure and tcpmem_pressure, indicating
> memory reclaim pressure in memcg->memory and ->tcpmem respectively.
>
> When in legacy mode (cgroupv1), the socket memory is charged into
> ->tcpmem which is independent of ->memory, so socket_pressure has
> nothing to do with socket's pressure at all. Things could be worse
> by taking socket_pressure into consideration in legacy mode, as a
> pressure in ->memory can lead to premature reclamation/throttling
> in socket.
>
> While for the default mode (cgroupv2), the socket memory is charged
> into ->memory, and ->tcpmem/->tcpmem_pressure are simply not used.
>
> So {socket,tcpmem}_pressure are only used in default/legacy mode
> respectively for indicating socket memory pressure. This patch fixes
> the pieces of code that make mixed use of both.
>
> Fixes: 8e8ae645249b ("mm: memcontrol: hook up vmpressure to socket pressu=
re")
> Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>

So, this is undoing the unintended exposure of v2 functionality for
the v1. I wonder if someone might have started depending upon that
behavior but I am more convinced that no one is using v1's tcpmem
accounting due to performance impact. So, this looks good to me.

Acked-by: Shakeel Butt <shakeelb@google.com>

I do think we should start the deprecation process of v1's tcpmem accountin=
g.

