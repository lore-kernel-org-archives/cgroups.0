From: Abel Wu <wuyun.abel@bytedance.com>
Subject: Re: [RFC PATCH net-next] sock: Propose socket.urgent for sockmem
 isolation
Date: Fri, 16 Jun 2023 15:27:24 +0800
Message-ID: <42285da4-ea80-78ca-4c71-6562170614c8@bytedance.com>
References: <20230609082712.34889-1-wuyun.abel@bytedance.com>
 <CANn89i+Qqq5nV0oRLh_KEHRV6VmSbS5PsSvayVHBi52FbB=sKA@mail.gmail.com>
 <b879d810-132b-38ab-c13d-30fabdc8954a@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev+bounces-11311-gl-netdev-2=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1686900456; x=1689492456;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9nn1acQnmBrxxKtKr0fIyJP3cG1pp8tJvpkDo6e+3KI=;
        b=VRySI+g5OyhFq3+xJSt3XxtxCawIas+z+Lic4uM27Z/udSbrXCTBXMbmW3AmwIUo/g
         +j64SzyuI3pM64/QBgs69XNPGhOiAnEjKd6QtJiH1liw/ezSt6iX9shVnsA95OXnchOh
         9JvQ6UQRi5s4QwwA7Ua701jbMXoPDsn53P3dOg+psguoZBsLTojgzvwwyEy8UdhAuk71
         ojp4elmyT5+Dm/h2WqZsUNvIm63ZHNQ2j7KP4DKglGusmxmVk8EFDp2wFt7xMuAuKHbj
         IRMA0WEPlxSgbgehJyNbJGm9KVDEcvEkN2yP5QuROXtcc5BpmvVpV0ZDyvA8ehpR3gUI
         s+ZQ==
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Content-Language: en-US
In-Reply-To: <b879d810-132b-38ab-c13d-30fabdc8954a@bytedance.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Eric Dumazet <edumazet@google.com>, Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>, Christian Warloe <cwarloe@google.com>, Wei Wang <weiwan@google.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, David Ahern <dsahern@kernel.org>, Yosry Ahmed <yosryahmed@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Yu Zhao <yuzhao@google.com>, Vasily Averin <vasily.averin@linux.dev>, Kuniyuki Iwashima <kuniyu@amazon.com>, Martin KaFai Lau <martin.lau@kernel.org>, Xin Long <lucien.xin@gmail.com>, Jason Xing <kernelxing@tencent.com>, Michal Hocko <mhocko@suse.com>, Alexei Starovoitov <ast@kernel.org>, open list <linux-kernel@vger.kernel.org>, open list:NETWORKING [GENERAL

Gentle ping :)

Any suggestions for memory over-committed scenario?

Thanks,
	Abel

On 6/13/23 2:46 PM, Abel Wu wrote:
> On 6/9/23 5:07 PM, Eric Dumazet wrote:
>> On Fri, Jun 9, 2023 at 10:28 AM Abel Wu <wuyun.abel@bytedance.com> wrote:
>>>
>>> This is just a PoC patch intended to resume the discussion about
>>> tcpmem isolation opened by Google in LPC'22 [1].
>>>
>>> We are facing the same problem that the global shared threshold can
>>> cause isolation issues. Low priority jobs can hog TCP memory and
>>> adversely impact higher priority jobs. What's worse is that these
>>> low priority jobs usually have smaller cpu weights leading to poor
>>> ability to consume rx data.
>>>
>>> To tackle this problem, an interface for non-root cgroup memory
>>> controller named 'socket.urgent' is proposed. It determines whether
>>> the sockets of this cgroup and its descendants can escape from the
>>> constrains or not under global socket memory pressure.
>>>
>>> The 'urgent' semantics will not take effect under memcg pressure in
>>> order to protect against worse memstalls, thus will be the same as
>>> before without this patch.
>>>
>>> This proposal doesn't remove protocal's threshold as we found it
>>> useful in restraining memory defragment. As aforementioned the low
>>> priority jobs can hog lots of memory, which is unreclaimable and
>>> unmovable, for some time due to small cpu weight.
>>>
>>> So in practice we allow high priority jobs with net-memcg accounting
>>> enabled to escape the global constrains if the net-memcg itselt is
>>> not under pressure. While for lower priority jobs, the budget will
>>> be tightened as the memory usage of 'urgent' jobs increases. In this
>>> way we can finally achieve:
>>>
>>>    - Important jobs won't be priority inversed by the background
>>>      jobs in terms of socket memory pressure/limit.
>>>
>>>    - Global constrains are still effective, but only on non-urgent
>>>      jobs, useful for admins on policy decision on defrag.
>>>
>>> Comments/Ideas are welcomed, thanks!
>>>
>>
>> This seems to go in a complete opposite direction than memcg promises.
>>
>> Can we fix memcg, so that :
>>
>> Each group can use the memory it was provisioned (this includes TCP 
>> buffers)
> 
> Yes, but might not be easy once memory gets over-committed (which is
> common in modern data-centers). So as a tradeoff, we intend to put
> harder constraint on memory allocation for low priority jobs. Or else
> if every job can use its provisioned memory, than there will be more
> memstalls blocking random jobs which could be the important ones.
> Either way hurts performance, but the difference is whose performance
> gets hurt.
> 
> Memory protection (memory.{min,low}) helps the important jobs less
> affected by memstalls. But once low priority jobs use lots of kernel
> memory like sockmem, the protection might become much less efficient.
> 
>>
>> Global tcp_memory can disappear (set tcp_mem to infinity)

