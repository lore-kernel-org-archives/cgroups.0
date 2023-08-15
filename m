From: Abel Wu <wuyun.abel@bytedance.com>
Subject: Re: Re: [PATCH net-next v2] net-memcg: Fix scope of sockmem pressure
 indicators
Date: Tue, 15 Aug 2023 10:53:35 +0800
Message-ID: <ef6a383f-56b0-9ac5-b358-1a29cf595a24@bytedance.com>
References: <20230814070923.35769-1-wuyun.abel@bytedance.com>
 <CALvZod5C3yWdgWr83EAdVUCH5PEK8ew7Q+FOt_zGOFOE9HVyQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev+bounces-27552-gl-netdev-2=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1692068023; x=1692672823;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a8HyUjDBkW62Y7ia/YRzhrRt6SI0MoeiKF06ymvveI4=;
        b=e5H6YSxaquRTypkZyjRtJDCwTmj5Z8r9Hx5apY8RhyinYxtJgLPHfj1RJYFYO+7j7h
         /XDrG7/16OKncrgd4rQzDKiDxmTxML7eTcIcJlApNVK7VwSPMRia945Nj3UpFZFqLVxr
         c+TJdcrrYEsJ2D+NPAvrqWZ/lcET6O9a7jF5NDA3w5oNdN00BW0X7ksw3eGvMmN4iAVv
         IPJTW3vBweY463qXeEMbiUcYWz3Ge+Zn5GN9ZdDLS+iEAXkLnBKigA9mtVVe0iPmHT/9
         HIfoGsl7xLunxJrwgoVyzkqCS1QH7hmlNRPFsL1uZKuEccnQq4wlLjkrsukuqlh8NNH1
         rMpg==
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Content-Language: en-US
In-Reply-To: <CALvZod5C3yWdgWr83EAdVUCH5PEK8ew7Q+FOt_zGOFOE9HVyQQ@mail.gmail.com>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
To: Shakeel Butt <shakeelb@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, David Ahern <dsahern@kernel.org>, Yosry Ahmed <yosryahmed@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Yu Zhao <yuzhao@google.com>, Kefeng Wang <wangkefeng.wang@huawei.com>, Yafang Shao <laoar.shao@gmail.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, Martin KaFai Lau <martin.lau@kernel.org>, Breno Leitao <leitao@debian.org>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, David Howells <dhowells@redhat.com>, Jason Xing <kernelxing@tencent.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, ope

On 8/15/23 4:18 AM, Shakeel Butt wrote:
> On Mon, Aug 14, 2023 at 12:09=E2=80=AFAM Abel Wu <wuyun.abel@bytedance.co=
m> wrote:
>>
>> Now there are two indicators of socket memory pressure sit inside
>> struct mem_cgroup, socket_pressure and tcpmem_pressure, indicating
>> memory reclaim pressure in memcg->memory and ->tcpmem respectively.
>>
>> When in legacy mode (cgroupv1), the socket memory is charged into
>> ->tcpmem which is independent of ->memory, so socket_pressure has
>> nothing to do with socket's pressure at all. Things could be worse
>> by taking socket_pressure into consideration in legacy mode, as a
>> pressure in ->memory can lead to premature reclamation/throttling
>> in socket.
>>
>> While for the default mode (cgroupv2), the socket memory is charged
>> into ->memory, and ->tcpmem/->tcpmem_pressure are simply not used.
>>
>> So {socket,tcpmem}_pressure are only used in default/legacy mode
>> respectively for indicating socket memory pressure. This patch fixes
>> the pieces of code that make mixed use of both.
>>
>> Fixes: 8e8ae645249b ("mm: memcontrol: hook up vmpressure to socket press=
ure")
>> Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
>=20
> So, this is undoing the unintended exposure of v2 functionality for

Exactly.

> the v1. I wonder if someone might have started depending upon that
> behavior but I am more convinced that no one is using v1's tcpmem
> accounting due to performance impact. So, this looks good to me.

Agreed. The performance impact is not negligible. While not accounting
tcpmem is also undesired for Resource Manager to do provision properly.
So we have to migrate to cgroupv2, and now we encountered a new issue.
Some discussion with Roman can be found here:

https://lore.kernel.org/netdev/29de901f-ae4c-a900-a553-17ec4f096f0e@bytedan=
ce.com/

It would be great if you can shed some light on this!

>=20
> Acked-by: Shakeel Butt <shakeelb@google.com>

Thanks!
	Abel

>=20
> I do think we should start the deprecation process of v1's tcpmem account=
ing.

