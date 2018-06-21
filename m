From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v10 3/9] cpuset: Simulate auto-off of sched.domain_root at
 cgroup removal
Date: Thu, 21 Jun 2018 16:22:05 +0800
Message-ID: <6fffa761-a4ab-9974-c6b7-8c2af9d8a875@redhat.com>
References: <1529295249-5207-1-git-send-email-longman@redhat.com>
 <1529295249-5207-4-git-send-email-longman@redhat.com>
 <20180620141144.GI2494@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180620141144.GI2494@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On 06/20/2018 10:11 PM, Peter Zijlstra wrote:
> On Mon, Jun 18, 2018 at 12:14:02PM +0800, Waiman Long wrote:
>> @@ -1058,7 +1060,12 @@ static int update_reserved_cpumask(struct cpuset *cpuset,
>>  	 * Check if any CPUs in addmask or delmask are in the effective_cpus
>>  	 * of a sibling cpuset. The implied cpu_exclusive of a scheduling
>>  	 * domain root will ensure there are no overlap in cpus_allowed.
>> +	 *
>> +	 * This check is skipped if the cpuset is dying.
> Comments that state what the code does are mostly useless; please
> explain _why_ if anything.

I  am adding more restrictions on where the domain_root can be turned on
to make sure that there will be no surprise.

I have a script to test the new cpuset v2 functionality and found that
cgroup deletion may sometime failed if there was not enough time for the
previous operation to complete. That is the reason why I relax the
checking for dying cgroup to make my test script pass.

Cheers,
Longman

