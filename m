From: Abel Wu <wuyun.abel@bytedance.com>
Subject: Re: Re: [PATCH RESEND net-next 1/2] net-memcg: Scopify the indicators
 of sockmem pressure
Date: Wed, 26 Jul 2023 16:44:24 +0800
Message-ID: <29de901f-ae4c-a900-a553-17ec4f096f0e@bytedance.com>
References: <20230711124157.97169-1-wuyun.abel@bytedance.com>
 <ZLsg1wklldKkVI2Z@P9FQF9L96D.corp.robot.car>
 <58e75f44-16e3-a40a-4c8a-0f61bbf393f9@bytedance.com>
 <ZMCLTQgVT68jwbVh@P9FQF9L96D>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev+bounces-21260-gl-netdev-2=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1690361075; x=1690965875;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OaHVQJdsQFWkcZBsx/T38G+Lqdb6Whv+CYMlwTb7aHo=;
        b=W+EanSUlLb0IGwq3cqcllspMnd3tUPyj31OymLbNzWRw2Mib/39CPdtiQOifF0ZSc5
         5O6JPEAAkD+WNzZeYqwGtNprVuBi9/h5937q4EAzrX1aZUYbKYA0NjoqJpKJrQuRRdzY
         5tGTvyajdtHNdEk3h7retqoeRnvxvm+AJMyCmw8p1+tTmyD5odyJZ+PYWpF0tFDTLDrC
         D6QOv7OQxqA/isASWaSoMHqL711oBKs93+5SvEWbCnweovlFRX5fNI7Ug2RKJyM16PCl
         vpMqwLrx0LW3PypNKK5hzgqJuHdHBi8ZDc+oPWmdc5b9HcGFOPKuW/YtHz88IfXSvHTS
         t3ZQ==
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Content-Language: en-US
In-Reply-To: <ZMCLTQgVT68jwbVh@P9FQF9L96D>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, David Ahern <dsahern@kernel.org>, Yosry Ahmed <yosryahmed@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Yu Zhao <yuzhao@google.com>, Kefeng Wang <wangkefeng.wang@huawei.com>, Yafang Shao <laoar.shao@gmail.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, Martin KaFai Lau <martin.lau@kernel.org>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, Breno Leitao <leitao@debian.org>, David Howells <dhowells@redhat.com>, Jason Xing <kernelxing@tencent.com>, Xin Long <lucien.xin@gmail.com>, Michal Hocko <mhocko@suse.com>, Alexei Starovoitov <>

On 7/26/23 10:56 AM, Roman Gushchin wrote:
> On Mon, Jul 24, 2023 at 11:47:02AM +0800, Abel Wu wrote:
>> Hi Roman, thanks for taking time to have a look!
>>>
>>>> When in legacy mode aka. cgroupv1, the socket memory is charged
>>>> into a separate counter memcg->tcpmem rather than ->memory, so
>>>> the reclaim pressure of the memcg has nothing to do with socket's
>>>> pressure at all.
>>>
>>> But we still might set memcg->socket_pressure and propagate the pressure,
>>> right?
>>
>> Yes, but the pressure comes from memcg->socket_pressure does not mean
>> pressure in socket memory in cgroupv1, which might lead to premature
>> reclamation or throttling on socket memory allocation. As the following
>> example shows:
>>
>> 			->memory	->tcpmem
>> 	limit		10G		10G
>> 	usage		9G		4G
>> 	pressure	true		false
> 
> Yes, now it makes sense to me. Thank you for the explanation.

Cheers!

> 
> Then I'd organize the patchset in the following way:
> 1) cgroup v1-only fix to not throttle tcpmem based on the vmpressure
> 2) a formal code refactoring

OK, I will take a try to re-organize in next version.

>>>
>>> Overall I think it's a good idea to clean these things up and thank you
>>> for working on this. But I wonder if we can make the next step and leave only
>>> one mechanism for both cgroup v1 and v2 instead of having this weird setup
>>> where memcg->socket_pressure is set differently from different paths on cgroup
>>> v1 and v2.
>>
>> There is some difficulty in unifying the mechanism for both cgroup
>> designs. Throttling socket memory allocation when memcg is under
>> pressure only makes sense when socket memory and other usages are
>> sharing the same limit, which is not true for cgroupv1. Thoughts?
> 
> I see... Generally speaking cgroup v1 is considered frozen, so we can leave it
> as it is, except when it creates an unnecessary complexity in the code.

Are you suggesting that the 2nd patch can be ignored and keep
->tcpmem_pressure as it is? Or keep the 2nd patch and add some
explanation around as you suggested in last reply?

> 
> I'm curious, was your work driven by some real-world problem or a desire to clean
> up the code? Both are valid reasons of course.

We (a cloud service provider) are migrating users to cgroupv2,
but encountered some problems among which the socket memory
really puts us in a difficult situation. There is no specific
threshold for socket memory in cgroupv2 and relies largely on
workloads doing traffic control themselves.

Say one workload behaves fine in cgroupv1 with 10G of ->memory
and 1G of ->tcpmem, but will suck (or even be OOMed) in cgroupv2
with 11G of ->memory due to burst memory usage on socket.

It's rational for the workloads to build some traffic control
to better utilize the resources they bought, but from kernel's
point of view it's also reasonable to suppress the allocation
of socket memory once there is a shortage of free memory, given
that performance degradation is better than failure.

Currently the mechanism of net-memcg's pressure doesn't work as
we expected, please check the discussion in [1]. Besides this,
we are also working on mitigating the priority inversion issue
introduced by the net protocols' global shared thresholds [2],
which has something to do with the net-memcg's pressure. This
patchset and maybe some other are byproducts of the above work.

[1] 
https://lore.kernel.org/netdev/20230602081135.75424-1-wuyun.abel@bytedance.com/
[2] 
https://lore.kernel.org/netdev/20230609082712.34889-1-wuyun.abel@bytedance.com/

Thanks!
	Abel

