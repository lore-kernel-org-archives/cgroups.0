From: Zhongkun He <hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [Phishing Risk] [External] Re: [PATCH] cgroup/cpuset: Add a new
 isolated mems.policy type.
Date: Mon, 5 Sep 2022 18:30:38 +0800
Message-ID: <c05bdeac-b354-0ac7-3233-27f8e5cbb38a@bytedance.com>
References: <20220902063303.1057-1-hezhongkun.hzk@bytedance.com>
 <YxT/liaotbiOod51@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=gtvu1sOWJAtKexo39ijvJL1dgptfKWjzICln4Ve7K/4=;
        b=a0S+cI5o4IcMxp8BPR8AUgnrlaVxXq0POxlWQ7zqp6D+VsbpNz9X/FqxXJq1bb3htf
         AI2Fb/m2tjO32ImNzN/g9EZ4QJ9uLhJrjyLjP2hyytCMZPkc8ZmSI62u8tKtDVp4r3Q2
         GB2+9fMem/RLmVYcmRp+VWgr9ZDHiUxkQWmiqNGZJ3o9e07vD2epHCS3LTnx1fojPMmC
         eU5/E6EcLmpxcqm6BYvWwNyiXy58q/gXG90uLX2JeH9QidVC5y3jLGZ9mVJ8PzCvFKEm
         1lBq2dvG9QwsH1mvnoxB/sf1hWsIAXXWBmBPgQfe0aaIZ6BYnWlIlh6MLeKtRWLObzI2
         BQzg==
In-Reply-To: <YxT/liaotbiOod51-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Tejun, thanks for your reply.

We usually use numactl to set the memory policy, but it cannot be 
changed dynamically. In addition, the mempolicy of cpuset can provide a 
more convenient interface for management and control panel.

Sorry,I don't quite understand the meaning of "don't enforce anything 
resource related". Does it mean mempolicy, such as "prefer:2" must 
specify node? Or "cpuset.mems.policy" need to specify a default value?
(cpuset.mems.policy does not require a default value.)

Thanks.


> Hello,
> 
> On Fri, Sep 02, 2022 at 02:33:03PM +0800, hezhongkun wrote:
>> From: Zhongkun He <hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
>>
>> Mempolicy is difficult to use because it is set in-process
>> via a system call. We want to make it easier to use mempolicy
>> in cpuset, and  we can control low-priority cgroups to
>> allocate memory in specified nodes. So this patch want to
>> adds the mempolicy interface in cpuset.
>>
>> The mempolicy priority of cpuset is lower than the task.
>> The order of getting the policy is:
>> 	1) vma mempolicy
>> 	2) task->mempolicy
>> 	3) cpuset->mempolicy
>> 	4) default policy.
>>
>> cpuset's policy is owned by itself, but descendants will
>> get the default mempolicy from parent.
>>
>> How to use the mempolicy interface:
>> 	echo prefer:2 > /sys/fs/cgroup/zz/cpuset.mems.policy
>> 	echo bind:1-3 > /sys/fs/cgroup/zz/cpuset.mems.policy
>>          echo interleave:0,1,2,3 >/sys/fs/cgroup/zz/cpuset.mems.policy
>> Show the policy:
>> 	cat /sys/fs/cgroup/zz/cpuset.mems.policy
>> 		prefer:2
>> 	cat /sys/fs/cgroup/zz/cpuset.mems.policy
>> 		bind:1-3
>> 	cat /sys/fs/cgroup/zz/cpuset.mems.policy
>> 		interleave:0-3
>> Clear the policy:
>> 	echo default > /sys/fs/cgroup/zz/cpuset.mems.policy
> 
> So, I'm a fan of adding cgroup functionalities which don't enforce anything
> resource related. What you're proposing can easily be achieved with userland
> tooling, right?
> 
> Thanks.
> 
