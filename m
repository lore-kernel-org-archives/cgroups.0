From: =?UTF-8?Q?Arkadiusz_Mi=c5=9bkiewicz?= <a.miskiewicz@gmail.com>
Subject: Re: pids.current with invalid value for hours [5.0.0 rc3 git]
Date: Sat, 26 Jan 2019 03:28:10 +0100
Message-ID: <38f5f498-0a0f-aa9e-c2b0-88c4d3f2e2fb@gmail.com>
References: <df806a77-3327-9db5-8be2-976fde1c84e5@gmail.com>
 <20190117122535.njcbqhlmzozdkncw@mikami>
 <1d36b181-cbaf-6694-1a31-2f7f55d15675@gmail.com>
 <96ef6615-a5df-30af-b4dc-417a18ca63f1@gmail.com>
 <1cdbef13-564d-61a6-95f4-579d2cad243d@gmail.com>
 <20190125163731.GJ50184@devbig004.ftw2.facebook.com>
 <a95d004a-4358-7efc-6d21-12aac4411b32@gmail.com>
 <20190126014055.GA25864@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FqYq2DCR5ZjVkJR8Ig60cpqxTOec9pvrU8lo75E6znE=;
        b=n3FqbnR5RecGJmjuI2lCRCCb25AHqevsbD2XbzHc/Tsn25JzhtV+2d96h+jUh8lGVD
         wVt4e7jnj1T8nBz+ocBDqYNgkAvn3poUSlG3GBnGndUKzd8/89kht0XpHfxZkxyYJ1mU
         Y3dM8Qfhci/6X6znUtsTdw5O+I0n0IZpWo+vGKn7BepCFXSE5jylXt6R+NC7g7QWx3Qj
         4eVPaDt6TKA0mNKQA6tSjwCCziAC9DO5rjVWEpCpAE3o7S4sItR4mlO8km9Q986DM8Xx
         uML1cRIfH67uLaElMhB6p+fBbiHdK/iHd54SBU5dZh4G1F0KYagpeewF1H843DjnyO0r
         TD7A==
In-Reply-To: <20190126014055.GA25864@castle.DHCP.thefacebook.com>
Content-Language: pl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Aleksa Sarai <asarai@suse.de>, Jay Kamat <jgkamat@fb.com>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 26/01/2019 02:41, Roman Gushchin wrote:
> On Fri, Jan 25, 2019 at 08:47:57PM +0100, Arkadiusz Miśkiewicz wrote:
>> On 25/01/2019 17:37, Tejun Heo wrote:
>>> On Fri, Jan 25, 2019 at 08:52:11AM +0100, Arkadiusz Miśkiewicz wrote:
>>>> On 24/01/2019 12:21, Arkadiusz Miśkiewicz wrote:
>>>>> On 17/01/2019 14:17, Arkadiusz Miśkiewicz wrote:
>>>>>> On 17/01/2019 13:25, Aleksa Sarai wrote:
>>>>>>> On 2019-01-17, Arkadiusz Miśkiewicz <a.miskiewicz@gmail.com> wrote:
>>>>>>>> Using kernel 4.19.13.
>>>>>>>>
>>>>>>>> For one cgroup I noticed weird behaviour:
>>>>>>>>
>>>>>>>> # cat pids.current
>>>>>>>> 60
>>>>>>>> # cat cgroup.procs
>>>>>>>> #
>>>>>>>
>>>>>>> Are there any zombies in the cgroup? pids.current is linked up directly
>>>>>>> to __put_task_struct (so exit(2) won't decrease it, only the task_struct
>>>>>>> actually being freed will decrease it).
>>>>>>>
>>>>>>
>>>>>> There are no zombie processes.
>>>>>>
>>>>>> In mean time the problem shows on multiple servers and so far saw it
>>>>>> only in cgroups that were OOMed.
>>>>>>
>>>>>> What has changed on these servers (yesterday) is turning on
>>>>>> memory.oom.group=1 for all cgroups and changing memory.high from 1G to
>>>>>> "max" (leaving memory.max=2G limit only).
>>>>>>
>>>>>> Previously there was no such problem.
>>>>>>
>>>>>
>>>>> I'm attaching reproducer. This time tried on different distribution
>>>>> kernel (arch linux).
>>>>>
>>>>> After 60s pids.current still shows 37 processes even if there are no
>>>>> processes running (according to ps aux).
>>>>
>>>>
>>>> The same test on 5.0.0-rc3-00104-gc04e2a780caf and it's easy to
>>>> reproduce bug. No processes in cgroup but pids.current reports 91.
>>>
>>> Can you please see whether the problem can be reproduced on the
>>> current linux-next?
>>>
>>>  git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>>
>> I can reproduce on next (5.0.0-rc3-next-20190125), too:
> 
> How reliably you can reproduce it? I've tried to run your reproducer
> several times with different parameters, but wasn't lucky so far.

Hmm, I'm able to reproduce each time using that python3 script.


> What's yours cpu number and total ram size?

On different machines:

1) old pc, 1 x intel E6600, 4GB of ram (arch linux 4.20.3 distro
kernel), using python script

2) virtualbox vm, 1 cpu with 2 cores, 8GB of ram (pld kernel and custom
built kernels like 5.0rc3 and 5.0rc3 next), using python script

3) server with 2 x intel E5405, 32GB of ram (4.19.13), with real life
scenario

4) server with 1 x intel E5-2630 v2, 64GB of ram (4.19.15), with real
life scenario
> 
> Can you, please, provide the corresponding dmesg output?

From my virtualbox vm, after 60s pids.current reports 7 despite no
processes:

http://ixion.pld-linux.org/~arekm/cgroup-oom-1.txt

kernel config:
http://ixion.pld-linux.org/~arekm/cgroup-oom-kernelconf-1.txt

Using 5.0.0-rc3-next-20190125 on that vm.

> I've checked the code again, and my wild guess is that these missing
> tasks are waiting (maybe hopelessly) for the OOM reaper. Dmesg output
> might be very useful here.



> 
> Thanks!
> 


-- 
Arkadiusz Miśkiewicz, arekm / ( maven.pl | pld-linux.org )
