From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 0/4] Charge loop device i/o to issuing cgroup
Date: Tue, 5 May 2020 16:41:14 +1000
Message-ID: <20200505064114.GI2005@dread.disaster.area>
References: <20200428161355.6377-1-schatzberg.dan@gmail.com>
 <20200428214653.GD2005@dread.disaster.area>
 <20200429102540.GA12716@quack2.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200429102540.GA12716@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: Dan Schatzberg <schatzberg.dan@gmail.com>, Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, Amir Goldstein <amir73il@gmail.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Yang Shi <yang.shi@linux.alibaba.com>, Ingo Molnar <mingo@kernel.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andrea Arcangeli <aarcange@red>

On Wed, Apr 29, 2020 at 12:25:40PM +0200, Jan Kara wrote:
> On Wed 29-04-20 07:47:34, Dave Chinner wrote:
> > On Tue, Apr 28, 2020 at 12:13:46PM -0400, Dan Schatzberg wrote:
> > > The loop device runs all i/o to the backing file on a separate kworker
> > > thread which results in all i/o being charged to the root cgroup. This
> > > allows a loop device to be used to trivially bypass resource limits
> > > and other policy. This patch series fixes this gap in accounting.
> > 
> > How is this specific to the loop device? Isn't every block device
> > that offloads work to a kthread or single worker thread susceptible
> > to the same "exploit"?
> > 
> > Or is the problem simply that the loop worker thread is simply not
> > taking the IO's associated cgroup and submitting the IO with that
> > cgroup associated with it? That seems kinda simple to fix....
> > 
> > > Naively charging cgroups could result in priority inversions through
> > > the single kworker thread in the case where multiple cgroups are
> > > reading/writing to the same loop device.
> > 
> > And that's where all the complexity and serialisation comes from,
> > right?
> > 
> > So, again: how is this unique to the loop device? Other block
> > devices also offload IO to kthreads to do blocking work and IO
> > submission to lower layers. Hence this seems to me like a generic
> > "block device does IO submission from different task" issue that
> > should be handled by generic infrastructure and not need to be
> > reimplemented multiple times in every block device driver that
> > offloads work to other threads...
> 
> Yeah, I was thinking about the same when reading the patch series
> description. We already have some cgroup workarounds for btrfs kthreads if
> I remember correctly, we have cgroup handling for flush workers, now we are
> adding cgroup handling for loopback device workers, and soon I'd expect
> someone comes with a need for DM/MD worker processes and IMHO it's getting
> out of hands because the complexity spreads through the kernel with every
> subsystem comming with slightly different solution to the problem and also
> the number of kthreads gets multiplied by the number of cgroups. So I
> agree some generic solution how to approach IO throttling of kthreads /
> workers would be desirable.

Yup, that's pretty much what I was thinking: it's yet another
special snowflake for cgroup-aware IO....

> OTOH I don't have a great idea how the generic infrastructure should look
> like...

I haven't given it any thought - it's not something I have any
bandwidth to spend time on.  I'll happily review a unified
generic cgroup-aware kthread-based IO dispatch mechanism, but I
don't have the time to design and implement that myself....

OTOH, I will make time to stop people screwing up filesystems and
block devices with questionable complexity and unique, storage
device dependent userspace visible error behaviour. This sort of
change is objectively worse for users than not supporting the
functionality in the first place.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
