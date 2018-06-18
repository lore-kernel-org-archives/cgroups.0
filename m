From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v10 0/9] cpuset: Enable cpuset controller in default
 hierarchy
Date: Mon, 18 Jun 2018 23:07:16 +0800
Message-ID: <dc91e2ad-239d-3144-0814-c5da181f4ac6@redhat.com>
References: <1529295249-5207-1-git-send-email-longman@redhat.com>
 <20180618142036.GA13097@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180618142036.GA13097@localhost.localdomain>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Juri Lelli <juri.lelli@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On 06/18/2018 10:20 PM, Juri Lelli wrote:
> Hi,
>
> On 18/06/18 12:13, Waiman Long wrote:
>> v10:
>>  - Remove the cpuset.sched.load_balance patch for now as it may not
>>    be that useful.
>>  - Break the large patch 2 into smaller patches to make them a bit
>>    easier to review.
>>  - Test and fix issues related to changing "cpuset.cpus" and cpu
>>    online/offline in a domain root.
>>  - Rename isolated_cpus to reserved_cpus as this cpumask holds CPUs
>>    reserved for child sched domains.
>>  - Rework the scheduling domain debug printing code in the last patch.
>>  - Document update to the newly moved
>>    Documentation/admin-guide/cgroup-v2.rst.
> There seem to be two (similar but different) 6/9 in the set. Something
> went wrong?

The isolated_cpus patch is old, I forgot to remove it before sending out
the patch.


> Also I can't seem to be able to create a subgroup with an isolated
> domain root. I think that, when doing the following
>
>  # mount -t cgroup2 none /sys/fs/cgroup
>  # echo "+cpuset" >/sys/fs/cgroup/cgroup.subtree_control 
>  # mkdir /sys/fs/cgroup/g1
>  # echo 0-1 >/sys/fs/cgroup/g1/cpuset.cpus
>  # echo 1 >/sys/fs/cgroup/g1/cpuset.sched.domain_root
>
> rebuild_sched_domains_locked exits early, since
> top_cpuset.effective_cpus != cpu_active_mask. (effective_cpus being 2-3
> at this point since I'm testing this on a 0-3 system)
>
> In your v9 this [1] was adding a special condition to make rebuilding of
> domains happen. Was the change intentional?

Can you reply to the relevant patch to pinpoint what condition are you
talking about? I do try to eliminate domain rebuild as much as possible,
but I am just not sure which condition you have question about.

Cheers,
Longman



