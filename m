From: Eric Dumazet <edumazet@google.com>
Subject: Re: [RFC PATCH net-next] sock: Propose socket.urgent for sockmem isolation
Date: Fri, 9 Jun 2023 11:07:05 +0200
Message-ID: <CANn89i+Qqq5nV0oRLh_KEHRV6VmSbS5PsSvayVHBi52FbB=sKA@mail.gmail.com>
References: <20230609082712.34889-1-wuyun.abel@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev+bounces-9460-gl-netdev-2=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686301639; x=1688893639;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vVqqNiTWipF9tqQGIXfWiYHdhPZGr5sY95HAiAKaa/c=;
        b=hCpzPeWKrNa3kekE9t5+6tDGSGcCQNB3zp8QEUHG4S9aAMvfBGhQ4PfM93rGsuXPFa
         XAdMHbYGoAgMHUdP7C86X3/YC5WBNHcO+tYLDQ7WJRH3KHMLAhAPceHEz5V+7a0eNz8n
         6BdC2h3I6c52v+lOoNNkqwgFIRxI4y27BpE5+EQ5P94dTP6vMSPoEzHQ766ExdYHZyCe
         bWLvSKay1lJ71VzY0BYjxm0cgMMSDA5XA4F8DOYu6EbSlK4V1KEpgo0701dPY9IADLJR
         imqcGAwsIwdrHTunYAFWuUgoUTl9bxSM7r7RNzf7zJJvpJRLUZXM/8Sz3/X1hRhSW5jD
         GJUg==
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
In-Reply-To: <20230609082712.34889-1-wuyun.abel@bytedance.com>
Content-Type: text/plain; charset="windows-1252"
To: Abel Wu <wuyun.abel@bytedance.com>
Cc: Tejun Heo <tj@kernel.org>, Christian Warloe <cwarloe@google.com>, Wei Wang <weiwan@google.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, David Ahern <dsahern@kernel.org>, Yosry Ahmed <yosryahmed@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Yu Zhao <yuzhao@google.com>, Vasily Averin <vasily.averin@linux.dev>, Kuniyuki Iwashima <kuniyu@amazon.com>, Martin KaFai Lau <martin.lau@kernel.org>, Xin Long <lucien.xin@gmail.com>, Jason Xing <kernelxing@tencent.com>, Michal Hocko <mhocko@suse.com>, Alexei Starovoitov <ast@kernel.org>, open list <linux-kernel@vger.ke>

On Fri, Jun 9, 2023 at 10:28=E2=80=AFAM Abel Wu <wuyun.abel@bytedance.com> =
wrote:
>
> This is just a PoC patch intended to resume the discussion about
> tcpmem isolation opened by Google in LPC'22 [1].
>
> We are facing the same problem that the global shared threshold can
> cause isolation issues. Low priority jobs can hog TCP memory and
> adversely impact higher priority jobs. What's worse is that these
> low priority jobs usually have smaller cpu weights leading to poor
> ability to consume rx data.
>
> To tackle this problem, an interface for non-root cgroup memory
> controller named 'socket.urgent' is proposed. It determines whether
> the sockets of this cgroup and its descendants can escape from the
> constrains or not under global socket memory pressure.
>
> The 'urgent' semantics will not take effect under memcg pressure in
> order to protect against worse memstalls, thus will be the same as
> before without this patch.
>
> This proposal doesn't remove protocal's threshold as we found it
> useful in restraining memory defragment. As aforementioned the low
> priority jobs can hog lots of memory, which is unreclaimable and
> unmovable, for some time due to small cpu weight.
>
> So in practice we allow high priority jobs with net-memcg accounting
> enabled to escape the global constrains if the net-memcg itselt is
> not under pressure. While for lower priority jobs, the budget will
> be tightened as the memory usage of 'urgent' jobs increases. In this
> way we can finally achieve:
>
>   - Important jobs won't be priority inversed by the background
>     jobs in terms of socket memory pressure/limit.
>
>   - Global constrains are still effective, but only on non-urgent
>     jobs, useful for admins on policy decision on defrag.
>
> Comments/Ideas are welcomed, thanks!
>

This seems to go in a complete opposite direction than memcg promises.

Can we fix memcg, so that :

Each group can use the memory it was provisioned (this includes TCP buffers=
)

Global tcp_memory can disappear (set tcp_mem to infinity)

