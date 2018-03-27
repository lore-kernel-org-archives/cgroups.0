From: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH v6 2/2] cpuset: Add cpuset.sched_load_balance to v2
Date: Tue, 27 Mar 2018 08:54:12 +0200
Message-ID: <1522133652.5996.2.camel@gmx.de>
References: <1521649309-26690-1-git-send-email-longman@redhat.com>
         <1521649309-26690-3-git-send-email-longman@redhat.com>
         <20180322084120.GE7231@localhost.localdomain>
         <e754e128-0a93-800e-e71b-2c8dc316ba8a@redhat.com>
         <20180323075952.GA4763@localhost.localdomain>
         <a8860a42-31b5-4620-7b23-b7515ee11d7d@redhat.com>
         <20180326124711.GE5942@localhost.localdomain>
         <bf79b45e-7716-65af-03ca-7112dc367371@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <bf79b45e-7716-65af-03ca-7112dc367371@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Waiman Long <longman@redhat.com>, Juri Lelli <juri.lelli@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

On Mon, 2018-03-26 at 16:28 -0400, Waiman Long wrote:
> 
> The sched_load_balance flag isn't something that is passed to the
> scheduler. It only only affects the CPU topology of the system. So I
> suspect that a process in the root cgroup will be load balanced among
> the CPUs in the one of the child cgroups. 

Yes, among CPUs that remain part of topology (and intersect affinity).

> That doesn't look right unless
> we enforce that no process can be in the root cgroup in this case.

caveat: quite a few kthreads are nailed to the floor of root.

	-Mike


