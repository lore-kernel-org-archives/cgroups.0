From: Zhongkun He <hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH] cgroup/cpuset: Add a new isolated
 mems.policy type.
Date: Mon, 5 Sep 2022 18:30:55 +0800
Message-ID: <0e5f380b-9201-0f56-9144-ce8449491fc8@bytedance.com>
References: <20220904040241.1708-1-hezhongkun.hzk@bytedance.com>
 <YxWbBYZKDTrkmlOe@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=08C+VXVc0IMFZrrErYdVw4bP2ZSZwMhBjMLfYmODNYY=;
        b=5qJtR8o8q181yaW02Pelm8vTh5nB2r4JcZaAQf0dDH/GMDD0eJ3Idryy96VUutJSOz
         KQ5J9dfV/XmiSfy5EmB0QFQTPnznNeCLysW/MtuxyOf9or/9pCi7+kTulpJV0lqNPJaQ
         l+qYtBb67hvNTpaB8DY83GYE8wxcqjjYVCk6I1zxMATw+o/9r/pyKNIOVDLDTLlVpS0N
         mjwDdQQgRjmDm88FKrmPj0gSJ5pK7bPiwQ+N+4s+ZDrbz3QrdEkhWW4XHITKpitraDVS
         JxW2ocZ64qsQC7v9cRrVwhvjFX0BsZnzhBr9owyS4NVMexUpNLtQvfy3woNaTPNw5LTq
         1snw==
In-Reply-To: <YxWbBYZKDTrkmlOe-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

Hi Michal, thanks for your reply.

The current 'mempolicy' is hierarchically independent. The default value 
of the child is to inherit from the parent. The modification of the 
child policy will not be restricted by the parent.

Of course, there are other options, such as the child's policy mode must 
be the same as the parent's. node can be the subset of parent's, but the 
interleave type will be complicated, that's why hierarchy independence 
is used. It would be better if you have other suggestions?

Thanks.

> On Sun 04-09-22 12:02:41, hezhongkun wrote:
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
> 
> What is the hierarchical behavior of the policy? Say parent has a
> stronger requirement (say bind) than a child (prefer)?
>   
>> How to use the mempolicy interface:
>> 	echo prefer:2 > /sys/fs/cgroup/zz/cpuset.mems.policy
>> 	echo bind:1-3 > /sys/fs/cgroup/zz/cpuset.mems.policy
>>          echo interleave:0,1,2,3 >/sys/fs/cgroup/zz/cpuset.mems.policy
> 
> Am I just confused or did you really mean to combine all these
> together?
