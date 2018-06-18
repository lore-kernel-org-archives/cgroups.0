From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v10 0/9] cpuset: Enable cpuset controller in default
 hierarchy
Date: Mon, 18 Jun 2018 16:20:36 +0200
Message-ID: <20180618142036.GA13097@localhost.localdomain>
References: <1529295249-5207-1-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1529295249-5207-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Patrick Bellasi <patrick.bellasi@arm.com>

Hi,

On 18/06/18 12:13, Waiman Long wrote:
> v10:
>  - Remove the cpuset.sched.load_balance patch for now as it may not
>    be that useful.
>  - Break the large patch 2 into smaller patches to make them a bit
>    easier to review.
>  - Test and fix issues related to changing "cpuset.cpus" and cpu
>    online/offline in a domain root.
>  - Rename isolated_cpus to reserved_cpus as this cpumask holds CPUs
>    reserved for child sched domains.
>  - Rework the scheduling domain debug printing code in the last patch.
>  - Document update to the newly moved
>    Documentation/admin-guide/cgroup-v2.rst.

There seem to be two (similar but different) 6/9 in the set. Something
went wrong?

Also I can't seem to be able to create a subgroup with an isolated
domain root. I think that, when doing the following

 # mount -t cgroup2 none /sys/fs/cgroup
 # echo "+cpuset" >/sys/fs/cgroup/cgroup.subtree_control 
 # mkdir /sys/fs/cgroup/g1
 # echo 0-1 >/sys/fs/cgroup/g1/cpuset.cpus
 # echo 1 >/sys/fs/cgroup/g1/cpuset.sched.domain_root

rebuild_sched_domains_locked exits early, since
top_cpuset.effective_cpus != cpu_active_mask. (effective_cpus being 2-3
at this point since I'm testing this on a 0-3 system)

In your v9 this [1] was adding a special condition to make rebuilding of
domains happen. Was the change intentional?

Thanks,

- Juri

[1] https://marc.info/?l=linux-kernel&m=152760142531222&w=2
