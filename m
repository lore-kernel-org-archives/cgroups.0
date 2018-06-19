From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v10 0/9] cpuset: Enable cpuset controller in default
 hierarchy
Date: Tue, 19 Jun 2018 11:52:02 +0200
Message-ID: <20180619095202.GB13617@localhost.localdomain>
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

By removing the redundant 6/9 as advised, I could test that this is
working as expected (at least by me :): https://git.io/fURIC

I played a bit with creating and modifying domain root(s), both with
legacy and default hierarchies. Looks good to me, you can add

Tested-by: Juri Lelli <juri.lelli@redhat.com>

to the series.

Best,

- Juri
