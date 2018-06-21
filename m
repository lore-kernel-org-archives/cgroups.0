From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v10 6/9] cpuset: Make generate_sched_domains() recognize
 reserved_cpus
Date: Thu, 21 Jun 2018 16:14:07 +0800
Message-ID: <df4e36b1-f386-88e9-8179-fce7530f4554@redhat.com>
References: <1529295249-5207-1-git-send-email-longman@redhat.com>
 <1529295249-5207-8-git-send-email-longman@redhat.com>
 <20180620141730.GK2494@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180620141730.GK2494@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On 06/20/2018 10:17 PM, Peter Zijlstra wrote:
> On Mon, Jun 18, 2018 at 12:14:06PM +0800, Waiman Long wrote:
>> The generate_sched_domains() function is modified to make it work
>> correctly with the newly introduced reserved_cpus mask for schedule
>> domains generation.
> Why isn't this (and the previous) patch part of the patch that
> introduces reserved_cpus? It seems weird to have this broken
> intermediate state.

I was trying to break the reserved cpu patch into smaller meaningful
pieces that will be easier to review. The individual patches can be
compiled cleanly one-by-one, though I didn't check if they are
functional if not all of them are applied.

Cheers,
Longman

