From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v15 12/12] cpuset: Expose cpuset.cpus.subpartitions with
 cgroup_debug
Date: Thu, 8 Nov 2018 13:59:43 -0500
Message-ID: <5e3df063-251b-b6e0-fbc5-25e7a8b6efb5@redhat.com>
References: <1541689726-20088-1-git-send-email-longman@redhat.com>
 <1541689726-20088-13-git-send-email-longman@redhat.com>
 <20181108154617.GX9761@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181108154617.GX9761@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Tom Hromatka <tom.hromatka@oracle.com>

On 11/08/2018 10:46 AM, Peter Zijlstra wrote:
> On Thu, Nov 08, 2018 at 10:08:46AM -0500, Waiman Long wrote:
>> For debugging purpose, it will be useful to expose the content of the
>> subparts_cpus as a read-only file to see if the code work correctly.
>> However, subparts_cpus will not be used at all in most use cases. So
>> adding a new cpuset file that clutters the cgroup directory may not be
>> desirable.  This is now being done by using the hidden "cgroup_debug"
>> kernel command line option to expose a new "cpuset.cpus.subpartitions"
>> file.
> One thought I had; would it make sense to make these debug files hidden
> ("." prefix) ?


These debug files will only appear when the cgroup_debug command line
option is used. So I don't think we really need to add an extra "."
prefix as it will break the naming convention.

Cheers,
Longman

