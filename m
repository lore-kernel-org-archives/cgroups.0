From: Abel Wu <wuyun.abel@bytedance.com>
Subject: Re: Re: [PATCH net-next v5 2/3] sock: Always take memcg pressure into
 consideration
Date: Mon, 5 Jun 2023 11:44:55 +0800
Message-ID: <6f67c3ca-5e73-d7ac-f32a-42a21d3ea576@bytedance.com>
References: <20230602081135.75424-1-wuyun.abel@bytedance.com>
 <20230602081135.75424-3-wuyun.abel@bytedance.com>
 <20230602204159.vo7fmuvh3y2pdfi5@google.com>
 <CAF=yD-LFQRreWq1RMkvLw9Nj3NQpJwbDSCfECUhh-aVchR-jsg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685936706; x=1688528706;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X4SSVnlC4IwShHocep9s7ywh2nFdFJx4NP0mnzsxLtQ=;
        b=As6EY1mjueMRZ7v0/kgCl2t91e15oNTmUA0m6RVlAOyhhApKue6wdKlKzvvava5Fcd
         7bZlp0aFbor4T+wPcVB7EOsdXcZqEey4q983dLSdBzROsSVwnxGW1k2POoACXCndxFV5
         jSTTeEVl43/bU4MYq8IlqIKpo6Z/kEFBPKMZWkj58lzSahNq5GkSQ/+j0IUvnyYmZVQ1
         QcWOn71C3ALjIheNI740qF//drYAQpKWahvI3cPkZtsYHoE0W3WNF3tU2OWgzT71NEYM
         knrOlEANyLAfubq+jUVTXFE11Cn7dEIw1kVc1JqQgJmORJYkQDRbzHG0pf5bFi2O+h+2
         CUBA==
Content-Language: en-US
In-Reply-To: <CAF=yD-LFQRreWq1RMkvLw9Nj3NQpJwbDSCfECUhh-aVchR-jsg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>, Shakeel Butt <shakeelb@google.com>, Paolo Abeni <pabeni@redhat.com>
Cc: "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Muchun Song <muchun.song@linux.dev>, Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 6/4/23 6:36 PM, Willem de Bruijn wrote:
> On Fri, Jun 2, 2023 at 10:42=E2=80=AFPM Shakeel Butt <shakeelb@google.com=
> wrote:
>>
>> On Fri, Jun 02, 2023 at 04:11:34PM +0800, Abel Wu wrote:
>>> The sk_under_memory_pressure() is called to check whether there is
>>> memory pressure related to this socket. But now it ignores the net-
>>> memcg's pressure if the proto of the socket doesn't care about the
>>> global pressure, which may put burden on its memcg compaction or
>>> reclaim path (also remember that socket memory is un-reclaimable).
>>>
>>> So always check the memcg's vm status to alleviate memstalls when
>>> it's in pressure.
>>>
>>
>> This is interesting. UDP is the only protocol which supports memory
>> accounting (i.e. udp_memory_allocated) but it does not define
>> memory_pressure. In addition, it does have sysctl_udp_mem. So
>> effectively UDP supports a hard limit and ignores memcg pressure at the
>> moment. This patch will change its behavior to consider memcg pressure
>> as well. I don't have any objection but let's get opinion of UDP
>> maintainer.
>=20
> Others have more experience with memory pressure on UDP, for the
> record. Paolo worked on UDP memory pressure in
> https://lore.kernel.org/netdev/cover.1579281705.git.pabeni@redhat.com/
>=20
> It does seem odd to me to modify sk_under_memory_pressure only. See
> for instance its use in __sk_mem_raise_allocated:
>=20
>          if (sk_has_memory_pressure(sk)) {
>                  u64 alloc;
>=20
>                  if (!sk_under_memory_pressure(sk))
>                          return 1;
>=20
> This is not even reached as sk_has_memory_pressure is false for UDP.

I intended to make __sk_mem_raise_allocated() be aware of net-memcg
pressure instead of just this bit [1][2].

[1]=20
https://lore.kernel.org/lkml/20230523094652.49411-5-wuyun.abel@bytedance.co=
m/
[2]=20
https://lore.kernel.org/lkml/20230523094652.49411-6-wuyun.abel@bytedance.co=
m/

And TBH I am wondering why considering memcg's pressure here, as the
main part in this if statement is to allow the sockets that are below
average memory usage to raise from a *global* memory view, which seems
nothing to do with memcg.

> So this commit only affects the only other protocol-independent
> caller, __sk_mem_reduce_allocated, to possibly call
> sk_leave_memory_pressure if now under the global limit.
>=20
> What is the expected behavioral change in practice of this commit?

Be more conservative on sockmem alloc if under memcg pressure, to
avoid worse memstall/latency.

>=20
>=20
>>> Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
>>> ---
>>>   include/net/sock.h | 6 ++----
>>>   1 file changed, 2 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/include/net/sock.h b/include/net/sock.h
>>> index 3f63253ee092..ad1895ffbc4a 100644
>>> --- a/include/net/sock.h
>>> +++ b/include/net/sock.h
>>> @@ -1411,13 +1411,11 @@ static inline bool sk_has_memory_pressure(const=
 struct sock *sk)
>>>
>>>   static inline bool sk_under_memory_pressure(const struct sock *sk)
>>>   {
>>> -     if (!sk->sk_prot->memory_pressure)
>>> -             return false;
>>> -
>>>        if (mem_cgroup_under_socket_pressure(sk->sk_memcg))
>>>                return true;
>>>
>>> -     return !!*sk->sk_prot->memory_pressure;
>>> +     return sk->sk_prot->memory_pressure &&
>>> +             *sk->sk_prot->memory_pressure;
>>>   }
>>>
>>>   static inline long
>>> --
>>> 2.37.3
>>>
