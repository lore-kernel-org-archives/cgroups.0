From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v11 7/9] cpuset: Expose cpus.effective and mems.effective
 on cgroup v2 root
Date: Tue, 3 Jul 2018 08:41:31 +0800
Message-ID: <bc59aa0a-70fd-583f-452d-9a947757cb69@redhat.com>
References: <1529825440-9574-1-git-send-email-longman@redhat.com>
 <1529825440-9574-8-git-send-email-longman@redhat.com>
 <20180702165322.GI533219@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180702165322.GI533219@devbig577.frc2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On 07/03/2018 12:53 AM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Sun, Jun 24, 2018 at 03:30:38PM +0800, Waiman Long wrote:
>> Because of the fact that setting the "cpuset.sched.partition" in
>> a direct child of root can remove CPUs from the root's effective CPU
>> list, it makes sense to know what CPUs are left in the root cgroup for
>> scheduling purpose. So the "cpuset.cpus.effective" control file is now
>> exposed in the v2 cgroup root.
> So, effective changing when enabling partition on a child feels wrong
> to me.  It's supposed to contain what's actually allowed to the cgroup
> from its parent and that shouldn't change regardless of how those
> resources are used.  It's still given to the cgroup from its parent.

Another way to work around this issue is to expose the reserved_cpus in
the parent for holding CPUs that can taken by a chid partition. That
will require adding one more cpuset file for those cgroups that are
partition roots.

> It's a bit different because the way partition behaves is different
> from other resource konbs in that it locks away those cpus so that
> they can't be taken back.
>
> What do people think about restricting partition to the first level
> children for now at least?  That way we aren't locked into the special
> semantics and we can figure out how to this down the hierarchy later.
> Given that we ignore the regular cpuset settings when the set goes
> empty (which also is a special condition which only exists for cpuset)
> and inherits the parent's, I think the consistent thing to do is doing
> the same for partition - if it can't be satisfied, ignore it, but
> maybe there is a better way.

I don't mind restricting that to the first level children for now. That
does restrict where we can put the container root if we want a separate
partition for a container. Let's hear if others have any objection about
that.

Cheers,
Longman



