From: =?UTF-8?Q?Arkadiusz_Mi=c5=9bkiewicz?= <a.miskiewicz@gmail.com>
Subject: Re: pids.current with invalid value for hours [5.0.0 rc3 git]
Date: Fri, 25 Jan 2019 08:52:11 +0100
Message-ID: <1cdbef13-564d-61a6-95f4-579d2cad243d@gmail.com>
References: <df806a77-3327-9db5-8be2-976fde1c84e5@gmail.com>
 <20190117122535.njcbqhlmzozdkncw@mikami>
 <1d36b181-cbaf-6694-1a31-2f7f55d15675@gmail.com>
 <96ef6615-a5df-30af-b4dc-417a18ca63f1@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=S/PecIcQc1kFgYlonoFxz1E4IJONkcf4aGIUu1zvd08=;
        b=vMFBqrK63eVtVNZj0Q/vwZC4cCnruJWwIClI0a5m7ZShYCSrcLdZl8CXhFmEz27nv1
         qbt0icT+fv9/IPCBXvVL4SVgAmP/248fNBpn2LfTAVzFLKT4mIHLmD1qeV+l6AKhOFAC
         xojX7hMo3rfgBcVNeQRHsTDLHCBwiLXo6uPpcepX9K16FYASuc9hc3rAkmU0RdZpo8gZ
         kQhRWZ+fOLbQ/5ynd9aZ+9Q7r4l1ZYtHXw205ivFQoJNr1jLqRmRbSu/2keIBIeJYIo5
         htWEeZG4BOQLVfEp9nDPBODwYcO2MD6pYE+Lv+gFrtOIilXkaXnheS+xDnqgecs7QCK8
         WPtw==
In-Reply-To: <96ef6615-a5df-30af-b4dc-417a18ca63f1@gmail.com>
Content-Language: pl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: cgroups@vger.kernel.org
Cc: Aleksa Sarai <asarai@suse.de>, Jay Kamat <jgkamat@fb.com>, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org

On 24/01/2019 12:21, Arkadiusz Miśkiewicz wrote:
> On 17/01/2019 14:17, Arkadiusz Miśkiewicz wrote:
>> On 17/01/2019 13:25, Aleksa Sarai wrote:
>>> On 2019-01-17, Arkadiusz Miśkiewicz <a.miskiewicz@gmail.com> wrote:
>>>> Using kernel 4.19.13.
>>>>
>>>> For one cgroup I noticed weird behaviour:
>>>>
>>>> # cat pids.current
>>>> 60
>>>> # cat cgroup.procs
>>>> #
>>>
>>> Are there any zombies in the cgroup? pids.current is linked up directly
>>> to __put_task_struct (so exit(2) won't decrease it, only the task_struct
>>> actually being freed will decrease it).
>>>
>>
>> There are no zombie processes.
>>
>> In mean time the problem shows on multiple servers and so far saw it
>> only in cgroups that were OOMed.
>>
>> What has changed on these servers (yesterday) is turning on
>> memory.oom.group=1 for all cgroups and changing memory.high from 1G to
>> "max" (leaving memory.max=2G limit only).
>>
>> Previously there was no such problem.
>>
> 
> I'm attaching reproducer. This time tried on different distribution
> kernel (arch linux).
> 
> After 60s pids.current still shows 37 processes even if there are no
> processes running (according to ps aux).


The same test on 5.0.0-rc3-00104-gc04e2a780caf and it's easy to
reproduce bug. No processes in cgroup but pids.current reports 91.

memory.oom.group=0 - everything works fine, pids are counted properly
memory.oom.group=1 - bug becomes visible

[root@xps test]# python3 cg.py
Created cgroup: /sys/fs/cgroup/test_5277
Start: pids.current: 0
Start: cgroup.procs:
0: pids.current: 103
0: cgroup.procs:
1: pids.current: 91
1: cgroup.procs:
2: pids.current: 91
2: cgroup.procs:
3: pids.current: 91
3: cgroup.procs:
4: pids.current: 91
4: cgroup.procs:
5: pids.current: 91
5: cgroup.procs:
6: pids.current: 91
6: cgroup.procs:
7: pids.current: 91
7: cgroup.procs:
8: pids.current: 91
8: cgroup.procs:
9: pids.current: 91
9: cgroup.procs:
10: pids.current: 91
10: cgroup.procs:
11: pids.current: 91
11: cgroup.procs:
[root@xps test]# uname -a
Linux xps 5.0.0-rc3-00104-gc04e2a780caf #288 SMP PREEMPT Thu Jan 24
19:00:32 CET 2019 x86_64 Intel(R)_Core(TM)_i9-8950HK_CPU_@_2.90GHz PLD Linux


cc relevant people

script is here: https://www.spinics.net/lists/cgroups/msg21330.html

> 
> [root@warm ~]# uname -a
> Linux warm 4.20.3-arch1-1-ARCH #1 SMP PREEMPT Wed Jan 16 22:38:58 UTC
> 2019 x86_64 GNU/Linux
> [root@warm ~]# python3 cg.py
> Created cgroup: /sys/fs/cgroup/test_26207
> Start: pids.current: 0
> Start: cgroup.procs:
> 0: pids.current: 62
> 0: cgroup.procs:
> 1: pids.current: 37
> 1: cgroup.procs:
> 2: pids.current: 37
> 2: cgroup.procs:
> 3: pids.current: 37
> 3: cgroup.procs:
> 4: pids.current: 37
> 4: cgroup.procs:
> 5: pids.current: 37
> 5: cgroup.procs:
> 6: pids.current: 37
> 6: cgroup.procs:
> 7: pids.current: 37
> 7: cgroup.procs:
> 8: pids.current: 37
> 8: cgroup.procs:
> 9: pids.current: 37
> 9: cgroup.procs:
> 10: pids.current: 37
> 10: cgroup.procs:
> 11: pids.current: 37
> 11: cgroup.procs:
> 


-- 
Arkadiusz Miśkiewicz, arekm / ( maven.pl | pld-linux.org )
