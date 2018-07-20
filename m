From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v11 7/9] cpuset: Expose cpus.effective and mems.effective
 on cgroup v2 root
Date: Fri, 20 Jul 2018 12:19:29 -0400
Message-ID: <4857a9db-ebf5-24f8-c42d-d795f5c75854@redhat.com>
References: <bc59aa0a-70fd-583f-452d-9a947757cb69@redhat.com>
 <20180703155823.GS533219@devbig577.frc2.facebook.com>
 <20180719135224.GE2494@hirez.programming.kicks-ass.net>
 <1107494a-9667-df58-dcac-9366e969dc3a@redhat.com>
 <20180719153045.GT72677@devbig577.frc2.facebook.com>
 <de6f931d-613a-3e6a-2a4d-0e49b3bfe2e5@redhat.com>
 <20180719165201.GU72677@devbig577.frc2.facebook.com>
 <20180720113121.GJ2476@hirez.programming.kicks-ass.net>
 <20180720114549.GY72677@devbig577.frc2.facebook.com>
 <20180720154454.GR2494@hirez.programming.kicks-ass.net>
 <20180720155613.GB1934745@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180720155613.GB1934745@devbig577.frc2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On 07/20/2018 11:56 AM, Tejun Heo wrote:
> Hello, Peter.
>
> On Fri, Jul 20, 2018 at 05:44:54PM +0200, Peter Zijlstra wrote:
>>> The currently proposed implementation is somewhere in the middle.  It
>>> kinda gets there by restricting a partition to be a child of another
>>> partition, which may be okay but it does make the whole delegation
>>> mechanism less useful.
>> So the implementation does not set ownership of the 'partition' file to
>> that of the parent directory? Because _that_ is what I understood from
>> Waiman (many versions ago). And that _does_ allow delegation to work
>> nicely.
> So, that part isn't the problem.  The problem is that if we allow
> partitioning nested further away from ancestor, the descendant would
> be able to take away reources from the removed ancestor.  Waiman
> avoids this problem by only allowing partitions to nest but then it's
> kinda weird cuz it's just a separate tree.

The rationale behind the current design is that a parent is allowed to
create a child partition if it fully owns all the cpus it has. That is
true only if it is a partition itself. IOW, making a cpuset a partition
won't affect any ancestors other than the parent.


>>>>> 2. take away any given cpu from ist subtree.
>>>> I really hate this obsession of yours and doubly so for partitions. But
>>>> why would this currently not be allowed?
>>> Well, sorry that you hate it.  It's a fundamental architectural
>>> constraint.  If it can't satisfy that, it should't be in cgroup.
>> So is hierarchical behaviour; but you seem willing to forgo that.
> Well, we do have root or first-level only things.  Things just need to
> be properly delegatable when they're hierarchical (and things should
> be hierarchical only when that actually means something).  While not
> desirable, considering the history, accomodating this specific usage
> that way seems acceptable to me.

I am not against the idea of making it hierarchical eventually. I am
just hoping to get thing going by merging the patchset in its current
form and then we can make it hierarchical in a followup patch.

Cheers,
Longman

