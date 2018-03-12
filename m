From: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH v4] cpuset: Enable cpuset controller in default hierarchy
Date: Mon, 12 Mar 2018 16:21:25 +0100
Message-ID: <1520868085.9178.1.camel@gmx.de>
References: <1520609707-16582-1-git-send-email-longman@redhat.com>
         <1520613285.12489.36.camel@gmx.de>
         <1c3fe7b0-2600-c46d-1527-d3aaf024bb91@redhat.com>
         <1520619426.27998.18.camel@gmx.de>
         <55809fe4-98ba-5566-86ed-457acfef0e1c@redhat.com>
         <1520624424.27998.76.camel@gmx.de>
         <53de9683-01b7-bac4-8b70-dc1f93ede600@redhat.com>
         <20180309221736.GB5926@hirez.programming.kicks-ass.net>
         <f0fca497-e4e7-3dbd-1e5c-a7f502c05dcb@redhat.com>
         <20180310131647.GB4043@hirez.programming.kicks-ass.net>
         <12ef7f60-5b14-8e09-2478-1453a3071f21@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <12ef7f60-5b14-8e09-2478-1453a3071f21@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Waiman Long <longman@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

On Mon, 2018-03-12 at 10:20 -0400, Waiman Long wrote:
> On 03/10/2018 08:16 AM, Peter Zijlstra wrote:
> 
> > The equivalent of isolcpus=xxx is a cgroup setup like:
> >
> >         root
> > 	/  \
> >   system    other
> >
> > Where other has the @xxx cpus and system the remainder and
> > root.sched_load_balance = 0.
> 
> I saw in the kernel-parameters.txt file that the isolcpus option was
> deprecated - use cpusets instead. However, there doesn't seem to have
> document on the right way to do it.

I use cset shield (cpuset package) in a script to create a set and
migrate everything that's permitted into the system set.

setup:
cset shield --userset=rtcpus --cpu=4-63 --kthread=on
<poke this/that>

teardown:
cset shield --userset=rtcpus --reset
<un-poke this/that>

Non-sexy, but works for simple stuff.

	-Mike
