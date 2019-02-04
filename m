From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v6 0/5] sched/deadline: fix cpusets bandwidth accounting
Date: Mon, 4 Feb 2019 13:45:03 -0500
Message-ID: <90ece065-8634-7a6c-7852-e04f6d727a13@redhat.com>
References: <20190117084739.17078-1-juri.lelli@redhat.com>
 <20190118161739.GE50184@devbig004.ftw2.facebook.com>
 <20190118164642.GC26615@localhost.localdomain>
 <20190204090211.GA10449@localhost.localdomain>
 <20190204121825.GE17550@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190204121825.GE17550@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>
Cc: mingo@redhat.com, rostedt@goodmis.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org, tj@kernel.org

On 02/04/2019 07:18 AM, Peter Zijlstra wrote:
> On Mon, Feb 04, 2019 at 10:02:11AM +0100, Juri Lelli wrote:
>> On 18/01/19 17:46, Juri Lelli wrote:
>>> On 18/01/19 08:17, Tejun Heo wrote:
>>>> On Thu, Jan 17, 2019 at 09:47:34AM +0100, Juri Lelli wrote:
>>>>> Hi,
>>>>>
>>>>> v6 of a series of patches, originally authored by Mathieu, with the intent
>>>>> of fixing a long standing issue of SCHED_DEADLINE bandwidth accounting.
>>>>> As originally reported by Steve [1], when hotplug and/or (certain)
>>>>> cpuset reconfiguration operations take place, DEADLINE bandwidth
>>>>> accounting information is lost since root domains are destroyed and
>>>>> recreated.
>>>>>
>>>>> Mathieu's approach is based on restoring bandwidth accounting info on
>>>>> the newly created root domains by iterating through the (DEADLINE) tasks
>>>>> belonging to the configured cpuset(s).
>>>>>
>>>>> Apart from some minor refactoring needed to rebase the set on top of
>>>>> Waiman Long's cpuset for cgroup series (now mainline), two changes worth
>>>>> of notice:
>>>> Generally looks good to me but can you please ask Waiman to take a
>>>> look?
>>> Argh! I should have cc-ed him in the first instance.
>>>
>>> Thanks for reviewing.
>>>
>>> Waiman, do you see anything wrong with this series? Thanks!
>>>
>>> https://lore.kernel.org/lkml/20190117084739.17078-1-juri.lelli@redhat.com/
>> Ping?
> Basically looks OK to me; wlthough I think I prefer the callback_lock /
> rq->lock ordering to be the other way around.
>
> Waiman, you OK with this one?

Sorry for the late reply. I reviewed the patchset and don't see anything
wrong with it. However, my knowledge of the internal operation of the
deadline scheduler is limited.

Cheers,
Longman

