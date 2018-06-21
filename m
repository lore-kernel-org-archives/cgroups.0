From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v10 5/9] cpuset: Make sure that domain roots work properly
 with CPU hotplug
Date: Thu, 21 Jun 2018 11:09:22 +0800
Message-ID: <b22149a1-61dc-82d1-6529-b70575e405c7@redhat.com>
References: <1529295249-5207-1-git-send-email-longman@redhat.com>
 <1529295249-5207-6-git-send-email-longman@redhat.com>
 <20180620141538.GJ2494@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180620141538.GJ2494@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On 06/20/2018 10:15 PM, Peter Zijlstra wrote:
> On Mon, Jun 18, 2018 at 12:14:04PM +0800, Waiman Long wrote:
>> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
>> index 5ee5e77..6ef3516 100644
>> --- a/Documentation/admin-guide/cgroup-v2.rst
>> +++ b/Documentation/admin-guide/cgroup-v2.rst
>> @@ -1626,6 +1626,13 @@ Cpuset Interface Files
>>  	2) No CPU that has been distributed to child scheduling domain
>>  	   roots is deleted.
>>  
>> +	When all the CPUs allocated to a scheduling domain are offlined,
>> +	that scheduling domain will be temporaily gone and all the
>> +	tasks in that scheduling domain will migrate to another one that
>> +	belongs to the parent of the scheduling domain root.  When any
>> +	of those offlined CPUs is onlined again, a new scheduling domain
>> +	will be re-created and the tasks will be migrated back.
>> +
> You should mention that this is a destructive operation. If any of the
> tasks had an affinity smaller than the original cgroup, that will be
> gone.

Thanks for the information. Will update the documentation to mention that.

Cheers,
Longman

