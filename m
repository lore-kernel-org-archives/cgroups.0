From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH] mm/memcontrol: update documentation about invoking oom
 killer
Date: Sat, 2 Nov 2019 19:14:51 +0300
Message-ID: <5c85a690-4ed7-91bb-30b5-c40174534a27@yandex-team.ru>
References: <157270779336.1961.6528158720593572480.stgit@buzz>
 <20191102160252.GA19103@freebsd.familie-tometzki.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1572711292; bh=Yd0CleJdEZRkBuzs0TYF6lmKdD5XxhQPGhQbqlbh1rs=;
        h=In-Reply-To:References:Date:Message-ID:From:To:Subject;
        b=Hmd1SS8FaLYfXLialvxaRuDNR9z0cBETtPVQqrm55xgu7uifS0HC/9FbkK/S66nMS
         tdEfmITpnkRcvh1IeWvmV4LHVLiCeitt98Sacehrrtv06CdILIuXHfYN5YP71JEnkV
         DSJPImoOysWZL0BvYUYmBzfnHJmLy1K01HpixnW8=
In-Reply-To: <20191102160252.GA19103@freebsd.familie-tometzki.de>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Michal Hocko <mhocko@suse.com>



On 02/11/2019 19.02, Damian Tometzki wrote:
> On Sat, 02. Nov 18:16, Konstantin Khlebnikov wrote:
>> Since commit 29ef680ae7c2 ("memcg, oom: move out_of_memory back to the
>> charge path") memcg invokes oom killer not only for user page-faults.
>> This means 0-order allocation will either succeed or task get killed.
>>
>> Fixes: 8e675f7af507 ("mm/oom_kill: count global and memory cgroup oom kills")
>> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
>> ---
>>   Documentation/admin-guide/cgroup-v2.rst |    9 +++++++--
>>   1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
>> index 5361ebec3361..eb47815e137b 100644
>> --- a/Documentation/admin-guide/cgroup-v2.rst
>> +++ b/Documentation/admin-guide/cgroup-v2.rst
>> @@ -1219,8 +1219,13 @@ PAGE_SIZE multiple when read back.
>>   
>>   		Failed allocation in its turn could be returned into
>>   		userspace as -ENOMEM or silently ignored in cases like
>> -		disk readahead.  For now OOM in memory cgroup kills
>> -		tasks iff shortage has happened inside page fault.
>> +		disk readahead.
>> +
>> +		Before 4.19 OOM in memory cgroup killed tasks iff
> Hello Konstantin,
> 
> iff --> if :-)
> 

This "iff" is shortened "if and only if".
https://en.wikipedia.org/wiki/If_and_only_if

> Best regards
> Damian
> 
> 
>> +		shortage has happened inside page fault, random
>> +		syscall may fail with ENOMEM or EFAULT. Since 4.19
>> +		failed memory cgroup allocation invokes oom killer and
>> +		keeps retrying until it succeeds.
>>   
>>   		This event is not raised if the OOM killer is not
>>   		considered as an option, e.g. for failed high-order
>>
