From: Mukesh Ojha <quic_mojha-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
Subject: Re: Query regarding deadlock involving cgroup_threadgroup_rwsem and
 cpu_hotplug_lock
Date: Fri, 12 Aug 2022 15:57:00 +0530
Message-ID: <dc0cff0e-b744-9d5d-e727-70d1c31b2a74@quicinc.com>
References: <8245b710-8acb-d8e6-7045-99a5f71dad4e@oracle.com>
 <26d0e4cc-be0e-2c12-6174-dfbb1edb1ed6@oracle.com>
 <bbc01477-231b-3dbb-3e09-9338f5413f06@oracle.com>
 <ba48eac5-8ef7-251b-11fe-8163bb7a2d54@quicinc.com>
 <224b19f3-912d-b858-7af4-185b8e55bc66@quicinc.com>
 <YthDz4BnfYHce1od@slm.duckdns.org> <YuGTBLkFerUboctl@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=ZzPNjrNBak90pV4hdaFyMYkL83XF79pJEP5ke2LniWs=;
 b=V+UW1v4ECFm6kVBHUaix40abLgIczL54Q7Kd7JY3c6gfer9o1SzXeUVW/f1uHyLobVoL
 MYIAiP+/jSQN46saUHo9WCNe2dpuoaMDwzs3eptgJ+rr8cllQ1phTiCkJR/83W39BXUE
 mPZ1Vyi+QdH3xgPVW3EqJznVqjUg/pqo3y7rWahf/hP6A8C3v6zKoksY9EER8FR2PSal
 MuPGNy3VCDZtEEydknqelzw5N6JtHHsGKcvMK91n8e5ilZFOQMEYm8J9DMMRgPre0+fj
 DO9oWY9NcWW3x1sJRjRQw4Njjy9ojNG0uuVbHxY69Gt371d9E7rcle1wPHShNcMuRABE zQ== 
Content-Language: en-US
In-Reply-To: <YuGTBLkFerUboctl-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Imran Khan <imran.f.khan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, steven.price-5wv7dgnIgG8@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Tejun,


On 7/28/2022 1:03 AM, Tejun Heo wrote:
> On Wed, Jul 20, 2022 at 08:05:03AM -1000, Tejun Heo wrote:
>> On Wed, Jul 20, 2022 at 05:31:51PM +0530, Mukesh Ojha wrote:
>>> Looks like these patches are the fixes.
>>>
>>> https://lore.kernel.org/all/YtDvN0wJ6CKaEPN8-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org/#r
>>>
>>> Would let Tejun confirm this .
>>
>> Yeah, looks like the same issue. I'll write up a patch later this week /
>> early next unless someone beats me to it.
> 
> https://lore.kernel.org/lkml/20220705123705.764-1-xuewen.yan-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org/ is
> the thread with the same issue. Let's follow up there.

Since, i am not part of the above thread, is the reason i am commenting 
here.

The original patch of yours [1]  and the revert of [2] is fixing the 
issue and it is also confirmed here [3].
Can we get proper fix merge on your tree?

[1] https://lore.kernel.org/lkml/YuGbYCfAG81mZBnN-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org/

[2] 
https://lore.kernel.org/all/20220121101210.84926-1-zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/

[3] 
https://lore.kernel.org/lkml/CAB8ipk-72V-bYRfL-VcSRSyXTeQqkBVj+1d5MHSVV5CTar9a0Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/

-Mukesh

> 
> Thanks.
> 
