From: Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [PATCH] mm: avoid bothering interrupted task when charge memcg in softirq
Date: Mon, 16 Jul 2018 09:49:37 +0800
Message-ID: <CALOAHbAnVvKR2AQ4TAkwUuC8XVK5UaD3vt80OC_M4OK2j6b_Yg@mail.gmail.com>
References: <1531557122-12540-1-git-send-email-laoar.shao@gmail.com>
 <CALvZod57QFRVQ7kM4LSNQJACQ+dGC_otJkqK-5+i-0b53Zq5aA@mail.gmail.com>
 <CALOAHbDV73+X-y7V2Z4nX1C7uCY6yzBPTPZhEvTpN3f7_qWwUw@mail.gmail.com>
 <CALvZod5d37v8fv=VCFLa7g+ntPvaT-h8jRQw1+iry2dxb=yXxQ@mail.gmail.com>
 <CALOAHbBQurMrE6ZCLLsdmbqFrUX3vFVpZtFLvvL_WGnPoF0OSA@mail.gmail.com>
 <CALvZod6F4vM_U0obH1aU3iJqRs-3JEfR4cHKZoB9JVLTgdSmSQ@mail.gmail.com>
 <CALOAHbByKH9t_c266Bi+Kv2r=07LLpa6UEQgsc7BNi2dZoeNhQ@mail.gmail.com> <CALvZod6SVJQz84sxMkvRY7K4iZ2_uzbmMq85URBznsu7+ZP9OA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=F3tn+sBKFOsK6edypcuY8Qe4Kz5RtkgR7vuGwPHNjsQ=;
        b=bbPllNd6w8j+fZjhln0iDcbNv//79yI1iRZwev+4X7dMvmLvQZZse2BVS5yZ533Ok1
         liTdeMudiJL7E9/JU4vAj8yCUiBScHQVTHHk4o2njXiIU0Scptf4RHM7eu37WraIfJiW
         SOZ3kuiPo0K0J4wLE80hiM7GbvcTm5BqMefxRVBkx5T49AP5lIMdl6wnMyIWZdRfVpvR
         QxUMPbQMqKCNaa3E7i7PGqDVrqoeWqWab20cXnEyF3WUI/VdD+T/ArQQdgApD2j6y/EQ
         a25QdySOOPipoUqBtMj8+Y8DIeSidmmU1P2XesyeeRW3slYnxVZBrmWhBweprsUT/jiQ
         1Wvg==
In-Reply-To: <CALvZod6SVJQz84sxMkvRY7K4iZ2_uzbmMq85URBznsu7+ZP9OA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Sun, Jul 15, 2018 at 11:04 PM, Shakeel Butt <shakeelb@google.com> wrote:
> On Sun, Jul 15, 2018 at 1:02 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>>
>> On Sun, Jul 15, 2018 at 2:34 PM, Shakeel Butt <shakeelb@google.com> wrote:
>> > On Sat, Jul 14, 2018 at 10:26 PM Yafang Shao <laoar.shao@gmail.com> wrote:
>> >>
>> >> On Sun, Jul 15, 2018 at 12:25 PM, Shakeel Butt <shakeelb@google.com> wrote:
>> >> > On Sat, Jul 14, 2018 at 7:10 PM Yafang Shao <laoar.shao@gmail.com> wrote:
>> >> >>
>> >> >> On Sat, Jul 14, 2018 at 11:38 PM, Shakeel Butt <shakeelb@google.com> wrote:
>> >> >> > On Sat, Jul 14, 2018 at 1:32 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>> >> >> >>
>> >> >> >> try_charge maybe executed in packet receive path, which is in interrupt
>> >> >> >> context.
>> >> >> >> In this situation, the 'current' is the interrupted task, which may has
>> >> >> >> no relation to the rx softirq, So it is nonsense to use 'current'.
>> >> >> >>
>> >> >> >
>> >> >> > Have you actually seen this occurring?
>> >> >>
>> >> >> Hi Shakeel,
>> >> >>
>> >> >> I'm trying to produce this issue, but haven't find it occur yet.
>> >> >>
>> >> >> > I am not very familiar with the
>> >> >> > network code but I can think of two ways try_charge() can be called
>> >> >> > from network code. Either through kmem charging or through
>> >> >> > mem_cgroup_charge_skmem() and both locations correctly handle
>> >> >> > interrupt context.
>> >> >> >
>> >> >>
>> >> >> Why do you say that mem_cgroup_charge_skmem() correctly hanle
>> >> >> interrupt context ?
>> >> >>
>> >> >> Let me show you why mem_cgroup_charge_skmem isn't hanling interrupt
>> >> >> context correctly.
>> >> >>
>> >> >> mem_cgroup_charge_skmem() is calling  try_charge() twice.
>> >> >> The first one is with GFP_NOWAIT as the gfp_mask, and the second one
>> >> >> is with  (GFP_NOWAIT |  __GFP_NOFAIL) as the gfp_mask.
>> >> >>
>> >> >> If page_counter_try_charge() failes at the first time, -ENOMEM is returned.
>> >> >> Then mem_cgroup_charge_skmem() will call try_charge() once more with
>> >> >> __GFP_NOFAIL set, and this time if If page_counter_try_charge() failes
>> >> >> again the '
>> >> >> force' label in  try_charge() will be executed and 0 is returned.
>> >> >>
>> >> >> No matter what, the 'current' will be used and touched, that is
>> >> >> meaning mem_cgroup_charge_skmem() isn't hanling the interrupt context
>> >> >> correctly.
>> >> >>
>> >> >
>> >> > Hi Yafang,
>> >> >
>> >> > If you check mem_cgroup_charge_skmem(), the memcg passed is not
>> >> > 'current' but is from the sock object i.e. sk->sk_memcg for which the
>> >> > network buffer is allocated for.
>> >> >
>> >>
>> >> That's correct, the memcg if from the sock object.
>> >> But the point is, in this situation why 'current' is used in try_charge() ?
>> >> As 'current' is not related with the memcg, which is just a interrupted task.
>> >>
>> >
>> > Hmm so you mean the behavior of memcg charging in the interrupt
>> > context depends on the state of the interrupted task.
>>
>> Yes.
>>
>> > As you have
>> > noted, mem_cgroup_charge_skmem() tries charging again with
>> > __GFP_NOFAIL and the charge succeeds. Basically the memcg charging by
>> > mem_cgroup_charge_skmem() will always succeed irrespective of the
>> > state of the interrupted task. However mem_cgroup_charge_skmem() can
>> > return true if the interrupted task was exiting or a fatal signal is
>> > pending or oom victim or reclaiming memory. Can you please explain why
>> > this is bad?
>> >
>>
>> Let me show you the possible issues cause by this behavoir.
>> 1.  In mem_cgroup_oom(), some  members in 'current' is set.
>>      That means an innocent task will be in  task_in_memcg_oom state.
>>      But this task may be in a different memcg, I mean the memcg of
>> the 'current' may be differenct with the sk->sk_memcg.
>>      Then when this innocent 'current' do try_charge it will hit  "if
>> (unlikely(task_in_memcg_oom(current)))" and  -ENOMEM is returned,
>> While there're maybe some free memory (or some memory could be freed )
>> in the memcg of the innocent 'task'.
>>
>
> No memory will be freed as try_charge() is in interrupt context.
>

I mean when this interrupted 'current' is running, that's in process context.
In process context it should call try_to_free_mem_cgroup_pages() to
free some memory,
but it will hit "if (unlikely(task_in_memcg_oom(current)))"  before as
it is set in the interrupt context.

That's an obviously issue. Do you understand ?

>> 2.  If the interrupted task was exiting or a fatal signal is  pending
>> or oom victim,
>>      it will directly goto force and 0 is returned, and then
>> mem_cgroup_charge_skmem() will return true.
>>      But mem_cgroup_charge_skmem() maybe need to try the second time
>> and return false.
>>
>> That are all unexpected behavoir.
>>
>
> Yes, this is inconsistent behavior. Can you explain how this will
> affect network traffic? Basically mem_cgroup_charge_skmem() was
> supposed to return false but sometime based on the interrupted task,
> mem_cgroup_charge_skmem() returns true. How is this behavior bad for
> network traffic?
>

You could see the funtion  __sk_mem_raise_allocated().
If mem_cgroup_charge_skmem() return false, it will goto
suppress_allocation and uncharge skmem,
while when mem_cgroup_charge_skmem() return true, it will charge skmem
sucessfully.

The consequence behavior is  sk_rmem_schedule may fail while it should sucess.
And then it will call  tcp_prune_queue() and tcp collapse may take a long time.

> Please note that I am not against this patch. I just want that the
> motivation/reason behind it is very clear.
>

As I have explained before, there're two motivations.
One is the random interrupted task may fail to charge when it is
scheduled to run.
The other one is it may take long time to receive this skb.

Thanks
Yafang
