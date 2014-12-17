From: Chintan Pandya <cpandya@codeaurora.org>
Subject: Re: [PATCH] memcg: Provide knob for force OOM into the memcg
Date: Wed, 17 Dec 2014 17:17:47 +0530
Message-ID: <54916D63.7060701@codeaurora.org>
References: <1418736335-30915-1-git-send-email-cpandya@codeaurora.org> <20141216133935.GK22914@dhcp22.suse.cz> <alpine.DEB.2.10.1412161430040.5142@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.10.1412161430040.5142@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, hannes@cmpxchg.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 12/17/2014 04:03 AM, David Rientjes wrote:
> On Tue, 16 Dec 2014, Michal Hocko wrote:
>
>>> We may want to use memcg to limit the total memory
>>> footprint of all the processes within the one group.
>>> This may lead to a situation where any arbitrary
>>> process cannot get migrated to that one  memcg
>>> because its limits will be breached. Or, process can
>>> get migrated but even being most recently used
>>> process, it can get killed by in-cgroup OOM. To
>>> avoid such scenarios, provide a convenient knob
>>> by which we can forcefully trigger OOM and make
>>> a room for upcoming process.
>>>
>>> To trigger force OOM,
>>> $ echo 1>  /<memcg_path>/memory.force_oom
>>
>> What would prevent another task deplete that memory shortly after you
>> triggered OOM and end up in the same situation? E.g. while the moving
>> task is migrating its charges to the new group...

Idea was to trigger an OOM until we can migrate any particular process 
onto desired cgroup.

>>
>> Why cannot you simply disable OOM killer in that memcg and handle it
>> from userspace properly?

Well, this can be done it seems. Let me explore around this. Thanks for 
this suggestion.

> It seems to be proposed as a shortcut so that the kernel will determine
> the best process to kill.  That information is available to userspace so
> it should be able to just SIGKILL the desired process (either in the
> destination memcg or in the source memcg to allow deletion), so this
> functionality isn't needed in the kernel.

Yes, this can be seen as a shortcut because we are off-loading some 
task-selection to be killed by OOM on kernel rather than userspace 
decides by itself.

-- 
Chintan Pandya

QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
