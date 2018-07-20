From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v11 7/9] cpuset: Expose cpus.effective and mems.effective
 on cgroup v2 root
Date: Fri, 20 Jul 2018 11:57:18 -0400
Message-ID: <b7649676-b9cf-8b78-da84-ca0b7ed03a38@redhat.com>
References: <20180702165322.GI533219@devbig577.frc2.facebook.com>
 <bc59aa0a-70fd-583f-452d-9a947757cb69@redhat.com>
 <20180703155823.GS533219@devbig577.frc2.facebook.com>
 <20180719135224.GE2494@hirez.programming.kicks-ass.net>
 <1107494a-9667-df58-dcac-9366e969dc3a@redhat.com>
 <20180719153045.GT72677@devbig577.frc2.facebook.com>
 <de6f931d-613a-3e6a-2a4d-0e49b3bfe2e5@redhat.com>
 <20180719165201.GU72677@devbig577.frc2.facebook.com>
 <20180720113121.GJ2476@hirez.programming.kicks-ass.net>
 <20180720114549.GY72677@devbig577.frc2.facebook.com>
 <20180720154454.GR2494@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180720154454.GR2494@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On 07/20/2018 11:44 AM, Peter Zijlstra wrote:
> On Fri, Jul 20, 2018 at 04:45:49AM -0700, Tejun Heo wrote:
>
>>>> Hmm... so a given ancestor must be able to both
>>>>
>>>> 1. control which cpus are moved into a partition in all of its
>>>>    subtree.
>>> By virtue of the partition file being owned by the parent, this is
>>> already achived, no?
>> The currently proposed implementation is somewhere in the middle.  It
>> kinda gets there by restricting a partition to be a child of another
>> partition, which may be okay but it does make the whole delegation
>> mechanism less useful.
> So the implementation does not set ownership of the 'partition' file to
> that of the parent directory? Because _that_ is what I understood from
> Waiman (many versions ago). And that _does_ allow delegation to work
> nicely.
>
>>>> 2. take away any given cpu from ist subtree.
>>> I really hate this obsession of yours and doubly so for partitions. But
>>> why would this currently not be allowed?
>> Well, sorry that you hate it.  It's a fundamental architectural
>> constraint.  If it can't satisfy that, it should't be in cgroup.
> So is hierarchical behaviour; but you seem willing to forgo that.
>
> Still, the question was, how is this (dispicable or not) behaviour not
> allowed by the current implementation?

The taking CPUs away part is not functioning yet in the current
patchset. It is certainly doable. I just need more time to work on that.

The current patchset is fine if partition is restricted to the first
level children as CPU online/offline is properly handled by the
patchset. It is in the non-root level that taking CPUs away from a
partition can be problematic.

Cheers,
Longman


