From: Abel Wu <wuyun.abel@bytedance.com>
Subject: Re: Re: Re: [PATCH net-next v5 2/3] sock: Always take memcg pressure
 into consideration
Date: Mon, 5 Jun 2023 17:57:09 +0800
Message-ID: <806149cf-cc07-ad5a-267e-94a6bc3b4106@bytedance.com>
References: <20230602081135.75424-1-wuyun.abel@bytedance.com>
 <20230602081135.75424-3-wuyun.abel@bytedance.com>
 <20230602204159.vo7fmuvh3y2pdfi5@google.com>
 <CAF=yD-LFQRreWq1RMkvLw9Nj3NQpJwbDSCfECUhh-aVchR-jsg@mail.gmail.com>
 <6f67c3ca-5e73-d7ac-f32a-42a21d3ea576@bytedance.com>
 <727b1fb64d04deb8b2a9ae1fec4b51dafa1ff2b5.camel@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685959038; x=1688551038;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TyuCPt1vQNlaWH7tCffqZV2k/RtNlXHoU62GbJy8Xjk=;
        b=KKGiHDA+xwC+Nm4KS7WEjinOuCG1iVjs4z+FmI8SpBouzvSfV4RqeQidTBGyVkA19I
         Oh0TRdzdP3GJkcP6FekYo8ImlboVTxzu/vCtrxiT+dkG2TBAvOliU6hwgC3b5yQCwkZV
         ue8mOe5XCOP2vcouiSDq+wVpvmWTG/JDCIfoUa4Pyh87YXdvAXY7EDkQVKzI/nyoPaWV
         gWrnFcvLgMQqHdqUnwpFVXl7QK+x1EbdnB8dsjpgLIjIozZlTX8BW9drTjYqqlP7v9oY
         Igs9eoVOUVnNsUfVZM7CU8zm4TwVsb3znjj/lBNSD/l+EYn15Btp40XCSuplRIWpCx/E
         4jxg==
Content-Language: en-US
In-Reply-To: <727b1fb64d04deb8b2a9ae1fec4b51dafa1ff2b5.camel@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
To: Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>, Shakeel Butt <shakeelb@google.com>
Cc: "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Muchun Song <muchun.song@linux.dev>, Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 6/5/23 4:27 PM, Paolo Abeni wrote:
> On Mon, 2023-06-05 at 11:44 +0800, Abel Wu wrote:
>> On 6/4/23 6:36 PM, Willem de Bruijn wrote:
>>> On Fri, Jun 2, 2023 at 10:42=E2=80=AFPM Shakeel Butt <shakeelb@google.c=
om> wrote:
>>>>
>>>> On Fri, Jun 02, 2023 at 04:11:34PM +0800, Abel Wu wrote:
>>>>> The sk_under_memory_pressure() is called to check whether there is
>>>>> memory pressure related to this socket. But now it ignores the net-
>>>>> memcg's pressure if the proto of the socket doesn't care about the
>>>>> global pressure, which may put burden on its memcg compaction or
>>>>> reclaim path (also remember that socket memory is un-reclaimable).
>>>>>
>>>>> So always check the memcg's vm status to alleviate memstalls when
>>>>> it's in pressure.
>>>>>
>>>>
>>>> This is interesting. UDP is the only protocol which supports memory
>>>> accounting (i.e. udp_memory_allocated) but it does not define
>>>> memory_pressure. In addition, it does have sysctl_udp_mem. So
>>>> effectively UDP supports a hard limit and ignores memcg pressure at the
>>>> moment. This patch will change its behavior to consider memcg pressure
>>>> as well. I don't have any objection but let's get opinion of UDP
>>>> maintainer.
>=20
> Thanks for the head-up, I did not notice the side effect on UDP.
>=20
>>
>>> So this commit only affects the only other protocol-independent
>>> caller, __sk_mem_reduce_allocated, to possibly call
>>> sk_leave_memory_pressure if now under the global limit.
>>>
>>> What is the expected behavioral change in practice of this commit?
>>
>> Be more conservative on sockmem alloc if under memcg pressure, to
>> avoid worse memstall/latency.
>=20
> I guess the above is for TCP sockets only, right? Or at least not for
> UDP sockets?

Yes, I started off with TCP but wondering if it is applicable to the
others too as the 'problem' sounds really generic to me.

>=20
> If so, I think we should avoid change of behaviour for UDP - e.g.
> keeping the initial 'if (!sk->sk_prot->memory_pressure)' in
> sk_under_memory_pressure(), with some comments about the rationale for
> future memory. That should preserve the whole patchset effect for other
> protocols, right?

Keeping the if statement as it is would imply the prot pressure as a
master 'switch' to all kinds of pressure. IMHO this might hurt other
protocols with pressure enabled if they are all used in one memcg which
happens to be under vmpressure, IOW UDP allocations are given higher
priority than others.

>=20
> If instead you are also interested into UDP sockets under pressure, how
> that is going to work? UDP sockets can reclaim memory only at send and
> close time. A memcg under pressure could starve some sockets forever if
> the the ones keeping the memory busy are left untouched.

Yes.. And it starts to get me confused that why&when should the memcg
pressure be used given that we don't want to put harsh constrains on
sockmem even under memcg pressure.

Thanks!
	Abel
