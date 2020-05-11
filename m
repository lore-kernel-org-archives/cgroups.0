From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH] doc: cgroup: update note about conditions when oom killer
 is invoked
Date: Mon, 11 May 2020 12:34:00 +0300
Message-ID: <0ddb8e58-5bfd-7754-6979-4276acf5b4c8@yandex-team.ru>
References: <158894738928.208854.5244393925922074518.stgit@buzz>
 <20200511083904.GB29153@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1589189642; bh=MGEF9xP5Qv6FPGCxjbJhWxmWFx6dPI6oeezhHBsf+rc=;
        h=In-Reply-To:Message-ID:From:Date:References:To:Subject:Cc;
        b=mwS7DMSvBj3jlt9a2sJJCwLOkbkP58CsD+3SORjXLPm3zW7gkn/BKPM+pVY/cY8Kd
         KtQfD44pPGcoG4Unlp3e9zHUPnnQ/juS1UrcPZfdE1r+UuTCYen3qntrUl4pCIQLdR
         ftmD1pKYDy0WojoV1lcmwF07jbHqD+hRwG1y/XHw=
In-Reply-To: <20200511083904.GB29153@dhcp22.suse.cz>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, Roman Gushchin <guro@fb.com>



On 11/05/2020 11.39, Michal Hocko wrote:
> On Fri 08-05-20 17:16:29, Konstantin Khlebnikov wrote:
>> Starting from v4.19 commit 29ef680ae7c2 ("memcg, oom: move out_of_memory
>> back to the charge path") cgroup oom killer is no longer invoked only from
>> page faults. Now it implements the same semantics as global OOM killer:
>> allocation context invokes OOM killer and keeps retrying until success.
>>
>> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> 
> Acked-by: Michal Hocko <mhocko@suse.com>
> 
>> ---
>>   Documentation/admin-guide/cgroup-v2.rst |   17 ++++++++---------
>>   1 file changed, 8 insertions(+), 9 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
>> index bcc80269bb6a..1bb9a8f6ebe1 100644
>> --- a/Documentation/admin-guide/cgroup-v2.rst
>> +++ b/Documentation/admin-guide/cgroup-v2.rst
>> @@ -1172,6 +1172,13 @@ PAGE_SIZE multiple when read back.
>>   	Under certain circumstances, the usage may go over the limit
>>   	temporarily.
>>   
>> +	In default configuration regular 0-order allocation always
>> +	succeed unless OOM killer choose current task as a victim.
>> +
>> +	Some kinds of allocations don't invoke the OOM killer.
>> +	Caller could retry them differently, return into userspace
>> +	as -ENOMEM or silently ignore in cases like disk readahead.
> 
> I would probably add -EFAULT but the less error codes we document the
> better.

Yeah, EFAULT was a most obscure result of memory shortage.
Fortunately with new behaviour this shouldn't happens a lot.

Actually where it is still possible? THP always fallback to 0-order.
I mean EFAULT could appear inside kernel only if task is killed so
nobody would see it.

> 
>> +
>>   	This is the ultimate protection mechanism.  As long as the
>>   	high limit is used and monitored properly, this limit's
>>   	utility is limited to providing the final safety net.
>> @@ -1228,17 +1235,9 @@ PAGE_SIZE multiple when read back.
>>   		The number of time the cgroup's memory usage was
>>   		reached the limit and allocation was about to fail.
>>   
>> -		Depending on context result could be invocation of OOM
>> -		killer and retrying allocation or failing allocation.
>> -
>> -		Failed allocation in its turn could be returned into
>> -		userspace as -ENOMEM or silently ignored in cases like
>> -		disk readahead.  For now OOM in memory cgroup kills
>> -		tasks iff shortage has happened inside page fault.
>> -
>>   		This event is not raised if the OOM killer is not
>>   		considered as an option, e.g. for failed high-order
>> -		allocations.
>> +		allocations or if caller asked to not retry attempts.
>>   
>>   	  oom_kill
>>   		The number of processes belonging to this cgroup
> 
