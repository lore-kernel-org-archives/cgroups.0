From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v4] cpuset: Enable cpuset controller in default hierarchy
Date: Fri, 9 Mar 2018 13:20:22 -0500
Message-ID: <55809fe4-98ba-5566-86ed-457acfef0e1c@redhat.com>
References: <1520609707-16582-1-git-send-email-longman@redhat.com>
 <1520613285.12489.36.camel@gmx.de>
 <1c3fe7b0-2600-c46d-1527-d3aaf024bb91@redhat.com>
 <1520619426.27998.18.camel@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1520619426.27998.18.camel@gmx.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mike Galbraith <efault@gmx.de>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

On 03/09/2018 01:17 PM, Mike Galbraith wrote:
> On Fri, 2018-03-09 at 12:45 -0500, Waiman Long wrote:
>> On 03/09/2018 11:34 AM, Mike Galbraith wrote:
>>> On Fri, 2018-03-09 at 10:35 -0500, Waiman Long wrote:
>>>> Given the fact that thread mode had been merged into 4.14, it is now
>>>> time to enable cpuset to be used in the default hierarchy (cgroup v2)
>>>> as it is clearly threaded.
>>>>
>>>> The cpuset controller had experienced feature creep since its
>>>> introduction more than a decade ago. Besides the core cpus and mems
>>>> control files to limit cpus and memory nodes, there are a bunch of
>>>> additional features that can be controlled from the userspace. Some of
>>>> the features are of doubtful usefulness and may not be actively used.
>>> One rather important features is the ability to dynamically partition a
>>> box and isolate critical loads.  How does one do that with v2?
>>>
>>> In v1, you create two or more exclusive sets, one for generic
>>> housekeeping, and one or more for critical load(s), RT in my case,
>>> turning off load balancing in the critical set(s) for obvious reasons.
>> This patch just serves as a foundation for cpuset support in v2. I am
>> not excluding the fact that more v1 features will be added in future
>> patches. We want to start with a clean slate and add on it after careful
>> consideration. There are some v1 cpuset features that are not used or
>> rarely used. We certainly want to get rid of them, if possible.
> If v2 is to ever supersede v1, as is the normal way of things, core
> functionality really should be on the v2 boat when it sails.  What you
> left standing on the dock is critical core cpuset functionality.
>
> 	-Mike

From your perspective, what are core functionality that should be
included in cpuset v2 other than the ability to restrict cpus and memory
nodes.

Cheers,
Longman

