From: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg, oom: unmark under_oom after the oom killer is
 done
Date: Tue, 26 Sep 2023 22:39:11 +0800
Message-ID: <fe80b246-3f92-2a83-6e50-3b923edce27c@shopee.com>
References: <20230922070529.362202-1-haifeng.xu@shopee.com>
 <ZRE9fAf1dId2U4cu@dhcp22.suse.cz>
 <6b7af68c-2cfb-b789-4239-204be7c8ad7e@shopee.com>
 <ZRFxLuJp1xqvp4EH@dhcp22.suse.cz>
 <94b7ed1d-9ca8-7d34-a0f4-c46bc995a3d2@shopee.com>
 <ZRF/CTk4MGPZY6Tc@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1695739156; x=1696343956; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ZMXF8YIgmXq287DcMIVtUFj6/ih+HVnxZvIQtNcrEY=;
        b=BmPvVBWl2/BiKFAr7R5TsYv4Sy45WtOL+zQldw1nBLVlYJn/PgQ0KBqqWXG/2x/Qqw
         eebMzmxQ172VDe/sSEfqx+rhiUh6mZUcqKH+9rpXZao0DGHZXrNEj8d9wu+AW4c4KPQf
         t/rrAL+fzdy7rqrOXqKOdM8+x8W/jEkReCMRT/L4qSzjaNpq0e0cE3Z8XOx1PoM9a2/H
         /gUaRH8w8mqXxNpIIq1SniCVROuPGnpflqT70eAkR0+Q1LBhkWzYteuEUEexL38NqNqs
         pLdYn82c/BIdK8HTJ8vhYsEUmGmtTkiPLp0tkZ2GVRzuSOyfIDtMHZ5HhXb9DWeJhjYc
         hVQg==
In-Reply-To: <ZRF/CTk4MGPZY6Tc-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org



On 2023/9/25 20:37, Michal Hocko wrote:
> On Mon 25-09-23 20:28:02, Haifeng Xu wrote:
>>
>>
>> On 2023/9/25 19:38, Michal Hocko wrote:
>>> On Mon 25-09-23 17:03:05, Haifeng Xu wrote:
>>>>
>>>>
>>>> On 2023/9/25 15:57, Michal Hocko wrote:
>>>>> On Fri 22-09-23 07:05:28, Haifeng Xu wrote:
>>>>>> When application in userland receives oom notification from kernel
>>>>>> and reads the oom_control file, it's confusing that under_oom is 0
>>>>>> though the omm killer hasn't finished. The reason is that under_oom
>>>>>> is cleared before invoking mem_cgroup_out_of_memory(), so move the
>>>>>> action that unmark under_oom after completing oom handling. Therefore,
>>>>>> the value of under_oom won't mislead users.
>>>>>
>>>>> I do not really remember why are we doing it this way but trying to track
>>>>> this down shows that we have been doing that since fb2a6fc56be6 ("mm:
>>>>> memcg: rework and document OOM waiting and wakeup"). So this is an
>>>>> established behavior for 10 years now. Do we really need to change it
>>>>> now? The interface is legacy and hopefully no new workloads are
>>>>> emerging.
>>>>>
>>>>> I agree that the placement is surprising but I would rather not change
>>>>> that unless there is a very good reason for that. Do you have any actual
>>>>> workload which depends on the ordering? And if yes, how do you deal with
>>>>> timing when the consumer of the notification just gets woken up after
>>>>> mem_cgroup_out_of_memory completes?
>>>>
>>>> yes, when the oom event is triggered, we check the under_oom every 10 seconds. If it
>>>> is cleared, then we create a new process with less memory allocation to avoid oom again.
>>>
>>> OK, I do understand what you mean and I could have made myself
>>> more clear previously. Even if the state is cleared _after_
>>> mem_cgroup_out_of_memory then you won't get what you need I am
>>> afraid. The memcg stays under OOM until a memory is freed (uncharged)
>>> from that memcg. mem_cgroup_out_of_memory itself doesn't really free
>>> any memory on its own. It relies on the task to wake up and die or
>>> oom_reaper to do the work on its behalf. All of that is time dependent.
>>> under_oom would have to be reimplemented to be cleared when a memory is
>>> unchanrged to meet your demands. Something that has never really been
>>> the semantic.
>>>
>>
>> yes, but at least before we create the new process, it has more chance to get some memory freed.
> 
> The time window we are talking about is the call of
> mem_cgroup_out_of_memory which, depending on the number of evaluated
> processes, could be a very short time. So what kind of practical
> difference does this have on your workload? Is this measurable in any
> way.

The oom events in this group seems less than before.

> 
>>> Btw. is this something new that you are developing on top of v1? And if
>>> yes, why don't you use v2?
>>>
>>
>> yes, v2 doesn't have the "cgroup.event_control" file.
> 
> Yes, it doesn't. But why is it necessary? Relying on v1 just for this is
> far from ideal as v1 is deprecated and mostly frozen. Why do you need to
> rely on the oom notifications (or oom behavior in general) in the first
> place? Could you share more about your workload and your requirements?
> 

for example, we want to run processes in the group but those parametes related to 
memory allocation is hard to decide, so use the notifications to inform us that we
need to adjust the paramters automatically and we don't need to create the new processes
manually.
