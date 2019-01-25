From: =?UTF-8?Q?Arkadiusz_Mi=c5=9bkiewicz?= <a.miskiewicz@gmail.com>
Subject: Re: pids.current with invalid value for hours [5.0.0 rc3 git]
Date: Fri, 25 Jan 2019 20:47:57 +0100
Message-ID: <a95d004a-4358-7efc-6d21-12aac4411b32@gmail.com>
References: <df806a77-3327-9db5-8be2-976fde1c84e5@gmail.com>
 <20190117122535.njcbqhlmzozdkncw@mikami>
 <1d36b181-cbaf-6694-1a31-2f7f55d15675@gmail.com>
 <96ef6615-a5df-30af-b4dc-417a18ca63f1@gmail.com>
 <1cdbef13-564d-61a6-95f4-579d2cad243d@gmail.com>
 <20190125163731.GJ50184@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PaL/Nm/0v0Ytkgf6OpFItlBs3opiEJwSabaR9s9+cdA=;
        b=MSrBMA+DumtrsUm/pQTTTpC1N1PaTbo58IFFJQCNsIHblpupPe11ThukCc4LHwPB9x
         hFQR6vD0Q0n/vEiBaxxBdXR1sMO2KCZh4vjS8ItJpSEjBWVtmwGkdK3XX+416m2xZaZJ
         YNcV2OkvHcfrQMGTMuf4962U7Yp+Xbs4WuMDmodHT0VmmxfIdWszOrWEMVztr4Plf75M
         MN8DxaivndxdcG1Li3uzBJnkOrDRrBaHjM/SeoUWHVijxrR7VC2y9xp2PcRV+wuxAgO3
         oD2FaW7qhnBfgegGRYYQ1hp72rSAJ/mt+dTMf9Ve/TCIVJ+hJSqBz+nVY1wFXyrwJR5X
         JnFw==
In-Reply-To: <20190125163731.GJ50184@devbig004.ftw2.facebook.com>
Content-Language: pl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, Aleksa Sarai <asarai@suse.de>, Jay Kamat <jgkamat@fb.com>, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org

On 25/01/2019 17:37, Tejun Heo wrote:
> On Fri, Jan 25, 2019 at 08:52:11AM +0100, Arkadiusz Miśkiewicz wrote:
>> On 24/01/2019 12:21, Arkadiusz Miśkiewicz wrote:
>>> On 17/01/2019 14:17, Arkadiusz Miśkiewicz wrote:
>>>> On 17/01/2019 13:25, Aleksa Sarai wrote:
>>>>> On 2019-01-17, Arkadiusz Miśkiewicz <a.miskiewicz@gmail.com> wrote:
>>>>>> Using kernel 4.19.13.
>>>>>>
>>>>>> For one cgroup I noticed weird behaviour:
>>>>>>
>>>>>> # cat pids.current
>>>>>> 60
>>>>>> # cat cgroup.procs
>>>>>> #
>>>>>
>>>>> Are there any zombies in the cgroup? pids.current is linked up directly
>>>>> to __put_task_struct (so exit(2) won't decrease it, only the task_struct
>>>>> actually being freed will decrease it).
>>>>>
>>>>
>>>> There are no zombie processes.
>>>>
>>>> In mean time the problem shows on multiple servers and so far saw it
>>>> only in cgroups that were OOMed.
>>>>
>>>> What has changed on these servers (yesterday) is turning on
>>>> memory.oom.group=1 for all cgroups and changing memory.high from 1G to
>>>> "max" (leaving memory.max=2G limit only).
>>>>
>>>> Previously there was no such problem.
>>>>
>>>
>>> I'm attaching reproducer. This time tried on different distribution
>>> kernel (arch linux).
>>>
>>> After 60s pids.current still shows 37 processes even if there are no
>>> processes running (according to ps aux).
>>
>>
>> The same test on 5.0.0-rc3-00104-gc04e2a780caf and it's easy to
>> reproduce bug. No processes in cgroup but pids.current reports 91.
> 
> Can you please see whether the problem can be reproduced on the
> current linux-next?
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

I can reproduce on next (5.0.0-rc3-next-20190125), too:

[root@xps test]# python3 cg.py
Created cgroup: /sys/fs/cgroup/test_2501
Start: pids.current: 0
Start: cgroup.procs:
0: pids.current: 65
0: cgroup.procs:
1: pids.current: 44
1: cgroup.procs:
2: pids.current: 44
2: cgroup.procs:
3: pids.current: 44
3: cgroup.procs:
4: pids.current: 44
4: cgroup.procs:
5: pids.current: 44
5: cgroup.procs:
6: pids.current: 44
6: cgroup.procs:
7: pids.current: 44
7: cgroup.procs:
8: pids.current: 44
8: cgroup.procs:
9: pids.current: 44
9: cgroup.procs:
10: pids.current: 44
10: cgroup.procs:
11: pids.current: 44
11: cgroup.procs:
[root@xps test]# uname -a
Linux xps 5.0.0-rc3-next-20190125 #2 SMP PREEMPT Fri Jan 25 19:11:40 CET
2019 x86_64 Intel(R)_Core(TM)_i9-8950HK_CPU_@_2.90GHz PLD Linux
[root@xps test]# mount |grep cgroup2
cgroup2 on /sys/fs/cgroup type cgroup2 (rw,nosuid,nodev,noexec,relatime)


I'm booting kernel with cgroup_no_v1=all

-- 
Arkadiusz Miśkiewicz, arekm / ( maven.pl | pld-linux.org )
