From: Abel Wu <wuyun.abel@bytedance.com>
Subject: Re: Re: [RFC PATCH net-next] sock: Propose socket.urgent for sockmem
 isolation
Date: Tue, 13 Jun 2023 14:46:32 +0800
Message-ID: <b879d810-132b-38ab-c13d-30fabdc8954a@bytedance.com>
References: <20230609082712.34889-1-wuyun.abel@bytedance.com>
 <CANn89i+Qqq5nV0oRLh_KEHRV6VmSbS5PsSvayVHBi52FbB=sKA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1686638805; x=1689230805;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NHNXSDSAPdGJpNANCbsAPKFp2yaEgGD+KFXl6OMicdU=;
        b=N3xIpdGJflW3eOUqyzlLAk5abO21PLtlV9Mx6Umc9Y1/aUS6ZbK6xRXRwrBlCl8Hpt
         c4VFcfT/4bTwUNGcVg175+fbr1PAChggD6uVFx3lHagvhox0mUPosWozHs3j411OtiIg
         q1Z9LwzcFS02JAqJpGtU1gtlg9MoyXwZnR3qtAhSBZqlvB3neANc61YpQBDp8CqDL8LB
         zEmXHHS2jlaLBD/YUj1zWpzLM2mP/B13pd8pD5UXNt67O89fC37Inmaq9CEiTcuxvhdX
         fHhNFtYe96lllaquqJtuXVScNXSyTJXbWF6oVsGptmNDOdfS0LS+Pg89wOXHPW1dV3a+
         flmg==
Content-Language: en-US
In-Reply-To: <CANn89i+Qqq5nV0oRLh_KEHRV6VmSbS5PsSvayVHBi52FbB=sKA@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
To: Eric Dumazet <edumazet@google.com>
Cc: Tejun Heo <tj@kernel.org>, Christian Warloe <cwarloe@google.com>, Wei Wang <weiwan@google.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, David Ahern <dsahern@kernel.org>, Yosry Ahmed <yosryahmed@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Yu Zhao <yuzhao@google.com>, Vasily Averin <vasily.averin@linux.dev>, Kuniyuki Iwashima <kuniyu@amazon.com>, Martin KaFai Lau <martin.lau@kernel.org>, Xin Long <lucien.xin@gmail.com>, Jason

On 6/9/23 5:07 PM, Eric Dumazet wrote:
> On Fri, Jun 9, 2023 at 10:28=E2=80=AFAM Abel Wu <wuyun.abel@bytedance.com=
> wrote:
>>
>> This is just a PoC patch intended to resume the discussion about
>> tcpmem isolation opened by Google in LPC'22 [1].
>>
>> We are facing the same problem that the global shared threshold can
>> cause isolation issues. Low priority jobs can hog TCP memory and
>> adversely impact higher priority jobs. What's worse is that these
>> low priority jobs usually have smaller cpu weights leading to poor
>> ability to consume rx data.
>>
>> To tackle this problem, an interface for non-root cgroup memory
>> controller named 'socket.urgent' is proposed. It determines whether
>> the sockets of this cgroup and its descendants can escape from the
>> constrains or not under global socket memory pressure.
>>
>> The 'urgent' semantics will not take effect under memcg pressure in
>> order to protect against worse memstalls, thus will be the same as
>> before without this patch.
>>
>> This proposal doesn't remove protocal's threshold as we found it
>> useful in restraining memory defragment. As aforementioned the low
>> priority jobs can hog lots of memory, which is unreclaimable and
>> unmovable, for some time due to small cpu weight.
>>
>> So in practice we allow high priority jobs with net-memcg accounting
>> enabled to escape the global constrains if the net-memcg itselt is
>> not under pressure. While for lower priority jobs, the budget will
>> be tightened as the memory usage of 'urgent' jobs increases. In this
>> way we can finally achieve:
>>
>>    - Important jobs won't be priority inversed by the background
>>      jobs in terms of socket memory pressure/limit.
>>
>>    - Global constrains are still effective, but only on non-urgent
>>      jobs, useful for admins on policy decision on defrag.
>>
>> Comments/Ideas are welcomed, thanks!
>>
>=20
> This seems to go in a complete opposite direction than memcg promises.
>=20
> Can we fix memcg, so that :
>=20
> Each group can use the memory it was provisioned (this includes TCP buffe=
rs)

Yes, but might not be easy once memory gets over-committed (which is
common in modern data-centers). So as a tradeoff, we intend to put
harder constraint on memory allocation for low priority jobs. Or else
if every job can use its provisioned memory, than there will be more
memstalls blocking random jobs which could be the important ones.
Either way hurts performance, but the difference is whose performance
gets hurt.

Memory protection (memory.{min,low}) helps the important jobs less
affected by memstalls. But once low priority jobs use lots of kernel
memory like sockmem, the protection might become much less efficient.

>=20
> Global tcp_memory can disappear (set tcp_mem to infinity)
