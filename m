From: Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH RESEND net-next 1/2] net-memcg: Scopify the indicators of
 sockmem pressure
Date: Thu, 20 Jul 2023 10:57:23 +0200
Message-ID: <CANn89iLBLBO0CK-9r-eZiQL+h2bwTHL2nR6az5Az6W_-pBierw@mail.gmail.com>
References: <20230711124157.97169-1-wuyun.abel@bytedance.com> <d114834c-2336-673f-f200-87fc6efb411f@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev+bounces-19429-gl-netdev-2=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689844257; x=1690449057;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k0Q8HK8TX799KwlVsueVU2Vn6pAZBPxCHZbkBqMog0w=;
        b=KGu3G60TOGRLcruEhisXUXiUEndw3y1bTGZ4+JTPqa0pzslDfSMX3gX1Jm0bStvtzd
         ueQB4VaVMfLwWkZ0o3xRSyKgJgX2gCERAiHeen4kiauOhWaNRwpPdtUI8Yt0kWaC6Q4H
         1MdbPw+eicIbg/P5qR6n31Evi2ldNs4huycbeN6iOba422XZaY7UamtXtYMC1ycWr33A
         2YRyRIV7dKnlfMavYxqhbREbHPzrDULVQaKzfIzskU+GrBChxJ+UyGEnSw3XRt440GMv
         rxdPhVPraVgaRKx2SZYZ+ZF8vjOadxDfBzndSjnRL/CB5izuZ2T33E7tJaMrYjEZIPoI
         aHNQ==
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
In-Reply-To: <d114834c-2336-673f-f200-87fc6efb411f@bytedance.com>
Content-Type: text/plain; charset="windows-1252"
To: Abel Wu <wuyun.abel@bytedance.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, David Ahern <dsahern@kernel.org>, Yosry Ahmed <yosryahmed@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Yu Zhao <yuzhao@google.com>, Kefeng Wang <wangkefeng.wang@huawei.com>, Yafang Shao <laoar.shao@gmail.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, Martin KaFai Lau <martin.lau@kernel.org>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, Breno Leitao <leitao@debian.org>, David Howells <dhowells@redhat.com>, Jason Xing <kernelxing@tencent.com>, Xin Long <lucien.xin@gmail.com>, Michal Hocko <mhocko@suse.com>, Alexe

On Thu, Jul 20, 2023 at 9:59=E2=80=AFAM Abel Wu <wuyun.abel@bytedance.com> =
wrote:
>
> Gentle ping :)

I was hoping for some feedback from memcg experts.

You claim to fix a bug, please provide a Fixes: tag so that we can
involve original patch author.

Thanks.

>
> On 7/11/23 8:41 PM, Abel Wu wrote:
> > Now there are two indicators of socket memory pressure sit inside
> > struct mem_cgroup, socket_pressure and tcpmem_pressure.
> >
> > When in legacy mode aka. cgroupv1, the socket memory is charged
> > into a separate counter memcg->tcpmem rather than ->memory, so
> > the reclaim pressure of the memcg has nothing to do with socket's
> > pressure at all. While for default mode, the ->tcpmem is simply
> > not used.
> >
> > So {socket,tcpmem}_pressure are only used in default/legacy mode
> > respectively. This patch fixes the pieces of code that make mixed
> > use of both.
> >
> > Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
> > ---
> >   include/linux/memcontrol.h | 4 ++--
> >   mm/vmpressure.c            | 8 ++++++++
> >   2 files changed, 10 insertions(+), 2 deletions(-)
> >

