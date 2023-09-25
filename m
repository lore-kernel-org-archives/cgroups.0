From: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg, oom: unmark under_oom after the oom killer is
 done
Date: Mon, 25 Sep 2023 20:28:02 +0800
Message-ID: <94b7ed1d-9ca8-7d34-a0f4-c46bc995a3d2@shopee.com>
References: <20230922070529.362202-1-haifeng.xu@shopee.com>
 <ZRE9fAf1dId2U4cu@dhcp22.suse.cz>
 <6b7af68c-2cfb-b789-4239-204be7c8ad7e@shopee.com>
 <ZRFxLuJp1xqvp4EH@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1695644886; x=1696249686; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sa2JeZg/HCJGKJydYD0Nz2S/LzX+OYJQg4QuWBQON58=;
        b=MEpYnwf4Pl4Bj2krIsn3N9AxU4VlcmWsDxlkCuMHr3FXZp2tH1X7uRnBSr8sjWpmyQ
         W2mne8Jc54vRy069rzYM6CITgEU6T7tbQPJf03dujzOgofp8mrB+m/WhBZNds4gT0CBj
         dW/9g6fgjLZISmaH9AIZGyBviouTMP7a9ZThfOa3HzxmWy86u0bbo0ZOG4PBmM/O/D6y
         pCti5/CHQseAHHij6nO8vA72pnj6nFhIw5CECRx5QrRQewWvKDEdMvoNdlbZTI/Vp7ht
         yKfWuFTsE87GGQ+ckvLIWShTchnLcAUluQwD0fxrJWOMmYEQ1bdFmp4Fuyt2yrd4qVIE
         LLiw==
In-Reply-To: <ZRFxLuJp1xqvp4EH-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org



On 2023/9/25 19:38, Michal Hocko wrote:
> On Mon 25-09-23 17:03:05, Haifeng Xu wrote:
>>
>>
>> On 2023/9/25 15:57, Michal Hocko wrote:
>>> On Fri 22-09-23 07:05:28, Haifeng Xu wrote:
>>>> When application in userland receives oom notification from kernel
>>>> and reads the oom_control file, it's confusing that under_oom is 0
>>>> though the omm killer hasn't finished. The reason is that under_oom
>>>> is cleared before invoking mem_cgroup_out_of_memory(), so move the
>>>> action that unmark under_oom after completing oom handling. Therefore,
>>>> the value of under_oom won't mislead users.
>>>
>>> I do not really remember why are we doing it this way but trying to track
>>> this down shows that we have been doing that since fb2a6fc56be6 ("mm:
>>> memcg: rework and document OOM waiting and wakeup"). So this is an
>>> established behavior for 10 years now. Do we really need to change it
>>> now? The interface is legacy and hopefully no new workloads are
>>> emerging.
>>>
>>> I agree that the placement is surprising but I would rather not change
>>> that unless there is a very good reason for that. Do you have any actual
>>> workload which depends on the ordering? And if yes, how do you deal with
>>> timing when the consumer of the notification just gets woken up after
>>> mem_cgroup_out_of_memory completes?
>>
>> yes, when the oom event is triggered, we check the under_oom every 10 seconds. If it
>> is cleared, then we create a new process with less memory allocation to avoid oom again.
> 
> OK, I do understand what you mean and I could have made myself
> more clear previously. Even if the state is cleared _after_
> mem_cgroup_out_of_memory then you won't get what you need I am
> afraid. The memcg stays under OOM until a memory is freed (uncharged)
> from that memcg. mem_cgroup_out_of_memory itself doesn't really free
> any memory on its own. It relies on the task to wake up and die or
> oom_reaper to do the work on its behalf. All of that is time dependent.
> under_oom would have to be reimplemented to be cleared when a memory is
> unchanrged to meet your demands. Something that has never really been
> the semantic.
> 

yes, but at least before we create the new process, it has more chance to get some memory freed.

> Btw. is this something new that you are developing on top of v1? And if
> yes, why don't you use v2?
> 

yes, v2 doesn't have the "cgroup.event_control" file.
