From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: CFQ idling kills I/O performance on ext4 with blkio cgroup
 controller
Date: Tue, 21 May 2019 12:48:14 -0400
Message-ID: <20190521164814.GC2591@mit.edu>
References: <8d72fcf7-bbb4-2965-1a06-e9fc177a8938@csail.mit.edu>
 <1812E450-14EF-4D5A-8F31-668499E13652@linaro.org>
 <20190518192847.GB14277@mit.edu>
 <20190520091558.GC2172@quack2.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190520091558.GC2172@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: Paolo Valente <paolo.valente@linaro.org>, "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>, linux-fsdevel@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, linux-ext4@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, jmoyer@redhat.com, amakhalov@vmware.com, anishs@vmware.com, srivatsab@vmware.com

On Mon, May 20, 2019 at 11:15:58AM +0200, Jan Kara wrote:
> But this makes priority-inversion problems with ext4 journal worse, doesn't
> it? If we submit journal commit in blkio cgroup of some random process, it
> may get throttled which then effectively blocks the whole filesystem. Or do
> you want to implement a more complex back-pressure mechanism where you'd
> just account to different blkio cgroup during journal commit and then
> throttle as different point where you are not blocking other tasks from
> progress?

Good point, yes, it can.  It depends in what cgroup the file system is
mounted (and hence what cgroup the jbd2 kernel thread is on).  If it
was mounted in the root cgroup, then jbd2 thread is going to be
completely unthrottled (except for the data=ordered writebacks, which
will be charged to the cgroup which write those pages) so the only
thing which is nuking us will be the slice_idle timeout --- both for
the writebacks (which could get charged to N different cgroups, with
disastrous effects --- and this is going to be true for any file
system on a syncfs(2) call as well) and switching between the jbd2
thread's cgroup and the writeback cgroup.

One thing the I/O scheduler could do is use the synchronous flag as a
hint that it should ix-nay on the idle-way.  Or maybe we need to have
a different way to signal this to the jbd2 thread, since I do
recognize that this issue is ext4-specific, *because* we do the
transaction handling in a separate thread, and because of the
data=ordered scheme, both of which are unique to ext4.  So exempting
synchronous writes from cgroup control doesn't make sense for other
file systems.

So maybe a special flag meaning "entangled writes", where the
sched_idle hacks should get suppressed for the data=ordered
writebacks, but we still charge the block I/O to the relevant CSS's?

I could also imagine if there was some way that file system could
track whether all of the file system modifications were charged to a
single cgroup, we could in that case charge it to that cgroup?

> Yeah. At least in some cases, we know there won't be any more IO from a
> particular cgroup in the near future (e.g. transaction commit completing,
> or when the layers above IO scheduler already know which IO they are going
> to submit next) and in that case idling is just a waste of time. But so far
> I haven't decided how should look a reasonably clean interface for this
> that isn't specific to a particular IO scheduler implementation.

The best I've come up with is some way of signalling that all of the
writes coming from the jbd2 commit are entangled, probably via a bio
flag.

If we don't have cgroup support, the other thing we could do is assume
that the jbd2 thread should always be in the root (unconstrained)
cgroup, and then force all writes, include data=ordered writebacks, to
be in the jbd2's cgroup.  But that would make the block cgroup
controls trivially bypassable by an application, which could just be
fsync-happy and exempt all of its buffered I/O writes from cgroup
control.  So that's probably not a great way to go --- but it would at
least fix this particular performance issue.  :-/

						- Ted
