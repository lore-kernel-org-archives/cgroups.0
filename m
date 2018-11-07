From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v14 05/12] cpuset: Add an error state to
 cpuset.sched.partition
Date: Wed, 7 Nov 2018 18:13:26 -0500
Message-ID: <3542ae87-5e58-93cb-8f95-04b6101f1a33@redhat.com>
References: <1539635377-22335-1-git-send-email-longman@redhat.com>
 <1539635377-22335-6-git-send-email-longman@redhat.com>
 <20181106114017.GM22431@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181106114017.GM22431@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Tom Hromatka <tom.hromatka@oracle.com>

On 11/06/2018 06:40 AM, Peter Zijlstra wrote:
> On Mon, Oct 15, 2018 at 04:29:30PM -0400, Waiman Long wrote:
>> +				spin_lock_irq(&callback_lock);
>> +				clear_bit(CS_CPU_EXCLUSIVE, &cp->flags);
>> +				spin_unlock_irq(&callback_lock);
> A single atomic bitop wrapped in a spinlock..  maybe it is correct, but
> it looks suspicous.

Yes, you are right. The spin_lock() should not be needed in this case.

Thanks,
Longman

