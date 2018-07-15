From: Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [PATCH] mm: avoid bothering interrupted task when charge memcg in softirq
Date: Sun, 15 Jul 2018 13:25:25 +0800
Message-ID: <CALOAHbBQurMrE6ZCLLsdmbqFrUX3vFVpZtFLvvL_WGnPoF0OSA@mail.gmail.com>
References: <1531557122-12540-1-git-send-email-laoar.shao@gmail.com>
 <CALvZod57QFRVQ7kM4LSNQJACQ+dGC_otJkqK-5+i-0b53Zq5aA@mail.gmail.com>
 <CALOAHbDV73+X-y7V2Z4nX1C7uCY6yzBPTPZhEvTpN3f7_qWwUw@mail.gmail.com> <CALvZod5d37v8fv=VCFLa7g+ntPvaT-h8jRQw1+iry2dxb=yXxQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=QW17LzTKLHMlIiGKf4STqLTs13MMTL942LYGFPuVZMs=;
        b=gsfuxnNZDAHzAckT+84CKifnK1H6CjeiwwVqmDCh4AEcJxLtb+NKczlxkm6bB/enwe
         UQYgimzDW4iol9c2ZJ/MQQSuByGTW4xEGfe2fg/767BVzLcJqErlDIDJwsBNHqloCvhL
         ZzUStoMcCOhVTHIsxDFLO+tWqztC/tpkZq/zy6XoogUapdWEm8a8hmQ5e0opbKMWM/4c
         e+cQ8c3cdY1uQOkMTV0VUhpTiMJLZoSGfag0+8GZep3Q78x45rD5AjHL+EJLgZ8ss9E9
         sQgGNR+07oHVddAoCUXr8tp0fdI5MJ09khQguO/8Z8ItYMc0C1uFez2aMVmqStkdpJJd
         DmtA==
In-Reply-To: <CALvZod5d37v8fv=VCFLa7g+ntPvaT-h8jRQw1+iry2dxb=yXxQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Sun, Jul 15, 2018 at 12:25 PM, Shakeel Butt <shakeelb@google.com> wrote:
> On Sat, Jul 14, 2018 at 7:10 PM Yafang Shao <laoar.shao@gmail.com> wrote:
>>
>> On Sat, Jul 14, 2018 at 11:38 PM, Shakeel Butt <shakeelb@google.com> wrote:
>> > On Sat, Jul 14, 2018 at 1:32 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>> >>
>> >> try_charge maybe executed in packet receive path, which is in interrupt
>> >> context.
>> >> In this situation, the 'current' is the interrupted task, which may has
>> >> no relation to the rx softirq, So it is nonsense to use 'current'.
>> >>
>> >
>> > Have you actually seen this occurring?
>>
>> Hi Shakeel,
>>
>> I'm trying to produce this issue, but haven't find it occur yet.
>>
>> > I am not very familiar with the
>> > network code but I can think of two ways try_charge() can be called
>> > from network code. Either through kmem charging or through
>> > mem_cgroup_charge_skmem() and both locations correctly handle
>> > interrupt context.
>> >
>>
>> Why do you say that mem_cgroup_charge_skmem() correctly hanle
>> interrupt context ?
>>
>> Let me show you why mem_cgroup_charge_skmem isn't hanling interrupt
>> context correctly.
>>
>> mem_cgroup_charge_skmem() is calling  try_charge() twice.
>> The first one is with GFP_NOWAIT as the gfp_mask, and the second one
>> is with  (GFP_NOWAIT |  __GFP_NOFAIL) as the gfp_mask.
>>
>> If page_counter_try_charge() failes at the first time, -ENOMEM is returned.
>> Then mem_cgroup_charge_skmem() will call try_charge() once more with
>> __GFP_NOFAIL set, and this time if If page_counter_try_charge() failes
>> again the '
>> force' label in  try_charge() will be executed and 0 is returned.
>>
>> No matter what, the 'current' will be used and touched, that is
>> meaning mem_cgroup_charge_skmem() isn't hanling the interrupt context
>> correctly.
>>
>
> Hi Yafang,
>
> If you check mem_cgroup_charge_skmem(), the memcg passed is not
> 'current' but is from the sock object i.e. sk->sk_memcg for which the
> network buffer is allocated for.
>

That's correct, the memcg if from the sock object.
But the point is, in this situation why 'current' is used in try_charge() ?
As 'current' is not related with the memcg, which is just a interrupted task.


> If the network buffers is allocated through kmem interface, the
> charging is bypassed altogether (through memcg_kmem_bypass()) for
> interrupt context.
>

Yes.

Thanks
Yafang
