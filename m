From: Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [PATCH] mm: avoid bothering interrupted task when charge memcg in softirq
Date: Sun, 15 Jul 2018 16:01:26 +0800
Message-ID: <CALOAHbByKH9t_c266Bi+Kv2r=07LLpa6UEQgsc7BNi2dZoeNhQ@mail.gmail.com>
References: <1531557122-12540-1-git-send-email-laoar.shao@gmail.com>
 <CALvZod57QFRVQ7kM4LSNQJACQ+dGC_otJkqK-5+i-0b53Zq5aA@mail.gmail.com>
 <CALOAHbDV73+X-y7V2Z4nX1C7uCY6yzBPTPZhEvTpN3f7_qWwUw@mail.gmail.com>
 <CALvZod5d37v8fv=VCFLa7g+ntPvaT-h8jRQw1+iry2dxb=yXxQ@mail.gmail.com>
 <CALOAHbBQurMrE6ZCLLsdmbqFrUX3vFVpZtFLvvL_WGnPoF0OSA@mail.gmail.com> <CALvZod6F4vM_U0obH1aU3iJqRs-3JEfR4cHKZoB9JVLTgdSmSQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=FDkr1xXrcgRA3MDnhm3HSG/gwPS7w5PE7zMtaHnyLbk=;
        b=mO74vuxzav3hj1VgJcb5aHoeekKeWuzOCnaUK46j2dckpE429qyjbRZtunB+BzkZXw
         0qZ+dm4lUfBTNxPp7PucxNbKXi8ooViJFMm0dAFJ8dfAil0AexJQ2AwLwww/KVsiLC/S
         tXCukKMhTLFHG5PjkHJm3hT8/wjYnSOaH0UQPute/Zejav/nmKM1aqNi3wt90ibStM1i
         Yw+4osxlnRSEGcF/Issgu0ZrmLsa3X3S8ttW+uon/56IAFJ+GUdlae3RHd6fs7mI69Ur
         l0wjL0pGnGLqML7l6SrsKkNgOfq8oK/ubxIk4qTLsj8Oij/vSPLoYypEOPrJ/d6WITvj
         AbnA==
In-Reply-To: <CALvZod6F4vM_U0obH1aU3iJqRs-3JEfR4cHKZoB9JVLTgdSmSQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Sun, Jul 15, 2018 at 2:34 PM, Shakeel Butt <shakeelb@google.com> wrote:
> On Sat, Jul 14, 2018 at 10:26 PM Yafang Shao <laoar.shao@gmail.com> wrote:
>>
>> On Sun, Jul 15, 2018 at 12:25 PM, Shakeel Butt <shakeelb@google.com> wrote:
>> > On Sat, Jul 14, 2018 at 7:10 PM Yafang Shao <laoar.shao@gmail.com> wrote:
>> >>
>> >> On Sat, Jul 14, 2018 at 11:38 PM, Shakeel Butt <shakeelb@google.com> wrote:
>> >> > On Sat, Jul 14, 2018 at 1:32 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>> >> >>
>> >> >> try_charge maybe executed in packet receive path, which is in interrupt
>> >> >> context.
>> >> >> In this situation, the 'current' is the interrupted task, which may has
>> >> >> no relation to the rx softirq, So it is nonsense to use 'current'.
>> >> >>
>> >> >
>> >> > Have you actually seen this occurring?
>> >>
>> >> Hi Shakeel,
>> >>
>> >> I'm trying to produce this issue, but haven't find it occur yet.
>> >>
>> >> > I am not very familiar with the
>> >> > network code but I can think of two ways try_charge() can be called
>> >> > from network code. Either through kmem charging or through
>> >> > mem_cgroup_charge_skmem() and both locations correctly handle
>> >> > interrupt context.
>> >> >
>> >>
>> >> Why do you say that mem_cgroup_charge_skmem() correctly hanle
>> >> interrupt context ?
>> >>
>> >> Let me show you why mem_cgroup_charge_skmem isn't hanling interrupt
>> >> context correctly.
>> >>
>> >> mem_cgroup_charge_skmem() is calling  try_charge() twice.
>> >> The first one is with GFP_NOWAIT as the gfp_mask, and the second one
>> >> is with  (GFP_NOWAIT |  __GFP_NOFAIL) as the gfp_mask.
>> >>
>> >> If page_counter_try_charge() failes at the first time, -ENOMEM is returned.
>> >> Then mem_cgroup_charge_skmem() will call try_charge() once more with
>> >> __GFP_NOFAIL set, and this time if If page_counter_try_charge() failes
>> >> again the '
>> >> force' label in  try_charge() will be executed and 0 is returned.
>> >>
>> >> No matter what, the 'current' will be used and touched, that is
>> >> meaning mem_cgroup_charge_skmem() isn't hanling the interrupt context
>> >> correctly.
>> >>
>> >
>> > Hi Yafang,
>> >
>> > If you check mem_cgroup_charge_skmem(), the memcg passed is not
>> > 'current' but is from the sock object i.e. sk->sk_memcg for which the
>> > network buffer is allocated for.
>> >
>>
>> That's correct, the memcg if from the sock object.
>> But the point is, in this situation why 'current' is used in try_charge() ?
>> As 'current' is not related with the memcg, which is just a interrupted task.
>>
>
> Hmm so you mean the behavior of memcg charging in the interrupt
> context depends on the state of the interrupted task.

Yes.

> As you have
> noted, mem_cgroup_charge_skmem() tries charging again with
> __GFP_NOFAIL and the charge succeeds. Basically the memcg charging by
> mem_cgroup_charge_skmem() will always succeed irrespective of the
> state of the interrupted task. However mem_cgroup_charge_skmem() can
> return true if the interrupted task was exiting or a fatal signal is
> pending or oom victim or reclaiming memory. Can you please explain why
> this is bad?
>

Let me show you the possible issues cause by this behavoir.
1.  In mem_cgroup_oom(), some  members in 'current' is set.
     That means an innocent task will be in  task_in_memcg_oom state.
     But this task may be in a different memcg, I mean the memcg of
the 'current' may be differenct with the sk->sk_memcg.
     Then when this innocent 'current' do try_charge it will hit  "if
(unlikely(task_in_memcg_oom(current)))" and  -ENOMEM is returned,
While there're maybe some free memory (or some memory could be freed )
in the memcg of the innocent 'task'.

2.  If the interrupted task was exiting or a fatal signal is  pending
or oom victim,
     it will directly goto force and 0 is returned, and then
mem_cgroup_charge_skmem() will return true.
     But mem_cgroup_charge_skmem() maybe need to try the second time
and return false.

That are all unexpected behavoir.

At least we must judge that whether the memcg of 'current' is same
with sk->sk_memcg if we still want to use current here.

Thanks
Yafang
