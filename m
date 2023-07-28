From: Abel Wu <wuyun.abel@bytedance.com>
Subject: Re: [PATCH RESEND net-next 1/2] net-memcg: Scopify the indicators of
 sockmem pressure
Date: Fri, 28 Jul 2023 20:45:00 +0800
Message-ID: <e2929fb0-35e6-b213-0ba1-15fa7282e3f4@bytedance.com>
References: <20230711124157.97169-1-wuyun.abel@bytedance.com>
 <ZLsg1wklldKkVI2Z@P9FQF9L96D.corp.robot.car>
 <58e75f44-16e3-a40a-4c8a-0f61bbf393f9@bytedance.com>
 <ZMCLTQgVT68jwbVh@P9FQF9L96D>
 <29de901f-ae4c-a900-a553-17ec4f096f0e@bytedance.com>
 <ZMG39B6B41yLAu9r@P9FQF9L96D>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev+bounces-22279-gl-netdev-2=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1690548313; x=1691153113;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dZhd6Z+1TRytPTwd9c5Pl7JGaMAas8iSnbHYztoIY+I=;
        b=TgN5QPu9YYBwRx1weOr/WieWPm5UErXX8Yl2ZnYRnuydyDECUF4gTKm/YstmY5l56B
         +wnzxryDqAXht0H4tNvFivjOPlHsYMJXJT16Ya4FZKhXjvLU+tu2ANlM2Hnggey8OizN
         kDKwNfr3/H1DGnnb8CFZ3Da0gxp96slSEQTjWN+YY002DAwTEY+vBkU5qAN2XCWJu/gT
         esYhuHCDSJ7t6D7godXKexmEfaiKr8p6lUWl2qVGZEu58BKWOAgb1Dxwj7NUCNOh0esu
         0woAXuC1jDCs0SqpMA1m8vH5WR568aWfDh6ShMuQiWhHo8Rn/ZYpvSR8Y3tRNJRX9GW7
         st9A==
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Content-Language: en-US
In-Reply-To: <ZMG39B6B41yLAu9r@P9FQF9L96D>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, David Ahern <dsahern@kernel.org>, Yosry Ahmed <yosryahmed@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Yu Zhao <yuzhao@google.com>, Kefeng Wang <wangkefeng.wang@huawei.com>, Yafang Shao <laoar.shao@gmail.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, Martin KaFai Lau <martin.lau@kernel.org>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, Breno Leitao <leitao@debian.org>, David Howells <dhowells@redhat.com>, Jason Xing <kernelxing@tencent.com>, Xin Long <lucien.xin@gmail.com>, Michal Hocko <mhocko@suse.com>, Alexei Starovoitov <>

On 7/27/23 8:19 AM, Roman Gushchin wrote:
> On Wed, Jul 26, 2023 at 04:44:24PM +0800, Abel Wu wrote:
>> On 7/26/23 10:56 AM, Roman Gushchin wrote:
>>> On Mon, Jul 24, 2023 at 11:47:02AM +0800, Abel Wu wrote:
>>>> Hi Roman, thanks for taking time to have a look!
>>>>>
>>>>> Overall I think it's a good idea to clean these things up and thank you
>>>>> for working on this. But I wonder if we can make the next step and leave only
>>>>> one mechanism for both cgroup v1 and v2 instead of having this weird setup
>>>>> where memcg->socket_pressure is set differently from different paths on cgroup
>>>>> v1 and v2.
>>>>
>>>> There is some difficulty in unifying the mechanism for both cgroup
>>>> designs. Throttling socket memory allocation when memcg is under
>>>> pressure only makes sense when socket memory and other usages are
>>>> sharing the same limit, which is not true for cgroupv1. Thoughts?
>>>
>>> I see... Generally speaking cgroup v1 is considered frozen, so we can leave it
>>> as it is, except when it creates an unnecessary complexity in the code.
>>
>> Are you suggesting that the 2nd patch can be ignored and keep
>> ->tcpmem_pressure as it is? Or keep the 2nd patch and add some
>> explanation around as you suggested in last reply?
> 
> I suggest to split a code refactoring (which is not expected to bring any
> functional changes) and an actual change of the behavior on cgroup v1.
> Re the refactoring: I see a lot of value in adding comments and make the
> code more readable, I don't see that much value in merging two variables.
> But if it comes organically with the code simplification - nice.

I see, thanks for the clarification!

> 
>>> I'm curious, was your work driven by some real-world problem or a desire to clean
>>> up the code? Both are valid reasons of course.
>>
>> We (a cloud service provider) are migrating users to cgroupv2,
>> but encountered some problems among which the socket memory
>> really puts us in a difficult situation. There is no specific
>> threshold for socket memory in cgroupv2 and relies largely on
>> workloads doing traffic control themselves.
>>
>> Say one workload behaves fine in cgroupv1 with 10G of ->memory
>> and 1G of ->tcpmem, but will suck (or even be OOMed) in cgroupv2
>> with 11G of ->memory due to burst memory usage on socket.
>>
>> It's rational for the workloads to build some traffic control
>> to better utilize the resources they bought, but from kernel's
>> point of view it's also reasonable to suppress the allocation
>> of socket memory once there is a shortage of free memory, given
>> that performance degradation is better than failure.
> 
> Yeah, I can see it. But Idk if it's too workload-specific to have
> a single-policy-fits-all-cases approach.
> E.g. some workloads might prefer to have a portion of pagecache
> being reclaimed.
> What do you think?

Now the memcg is considered to be under pressure if the number of
pages reclaimed is much less than desired. I doubt it could be a
win in such case to spend more time on reclaiming while letting
socket continue to allocate memory (which could make things worse),
compared to relieving reclaim pressure and putting time on its real
work.

Best,
	Abel

