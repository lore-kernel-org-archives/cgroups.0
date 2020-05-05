From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v5 0/4] Charge loop device i/o to issuing cgroup
Date: Tue, 5 May 2020 16:29:46 +1000
Message-ID: <20200505062946.GH2005@dread.disaster.area>
References: <20200428161355.6377-1-schatzberg.dan@gmail.com>
 <20200428214653.GD2005@dread.disaster.area>
 <20200429022732.GA401038@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200429022732.GA401038-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tho

On Tue, Apr 28, 2020 at 10:27:32PM -0400, Johannes Weiner wrote:
> On Wed, Apr 29, 2020 at 07:47:34AM +1000, Dave Chinner wrote:
> > On Tue, Apr 28, 2020 at 12:13:46PM -0400, Dan Schatzberg wrote:
> > > This patch series does some
> > > minor modification to the loop driver so that each cgroup can make
> > > forward progress independently to avoid this inversion.
> > > 
> > > With this patch series applied, the above script triggers OOM kills
> > > when writing through the loop device as expected.
> > 
> > NACK!
> > 
> > The IO that is disallowed should fail with ENOMEM or some similar
> > error, not trigger an OOM kill that shoots some innocent bystander
> > in the head. That's worse than using BUG() to report errors...
> 
> Did you actually read the script?

Of course I did. You specifically mean this bit:

echo 64M > $CGROUP/memory.max;
mount -t tmpfs -o size=512m tmpfs /tmp;
truncate -s 512m /tmp/backing_file
losetup $LOOP_DEV /tmp/backing_file
dd if=/dev/zero of=$LOOP_DEV bs=1M count=256;

And with this patch set the dd gets OOM killed because the
/tmp/backing_file usage accounted to the cgroup goes over 64MB and
so tmpfs OOM kills the IO...

As I said: that's very broken behaviour from a storage stack
perspective.

> It's OOMing because it's creating 256M worth of tmpfs pages inside a
> 64M cgroup. It's not killing an innocent bystander, it's killing in
> the cgroup that is allocating all that memory - after Dan makes sure
> that memory is accounted to its rightful owner.

What this example does is turn /tmp into thinly provisioned storage
for $CGROUP via a restricted quota. It has a device size of 512MB,
but only has physical storage capacity of 64MB, as constrained by
the cgroup memory limit.  You're dealing with management of -storage
devices- and -IO error reporting- here, not memory management.

When thin provisioned storage runs out of space - for whatever
reason - and it cannot resolve the issue by blocking, then it *must*
return ENOSPC to the IO submitter to tell it the IO has failed. This
is no different to if we set a quota on /tmp/backing_file and it is
exhausted at 64MB of data written - we fail the IO with ENOSPC or
EDQUOT, depending on which quota we used.

IOWs, we have solid expectations on how block devices report
unsolvable resource shortages during IO because those errors have to
be handled correctly by whatever is submitting the IO. We do not use
the OOM-killer to report or resolve ENOSPC errors.

Indeed, once you've killed the dd, that CGROUP still consumes 64MB
of tmpfs space in /tmp/backing_file, in which case any further IO to
$LOOP_DEV is also going to OOM kill. These are horrible semantics
for reporting errors to userspace.

And if the OOM-killer actually frees the 64MB of data written to
/tmp/backing_file through the $LOOP_DEV, then you're actually
corrupting the storage and ensuring that nobody can read the data
that was written to $LOOP_DEV.

So now lets put a filesystem on $LOOP_DEV in the above example, and
write out data to the filesystem which does IO to $LOOP_DEV. Just by
chance, the filesystem does some metadata writes iin the context of
the user process doing the writes (because journalling, etc) and
that metadata IO is what pushes the loop device over the cgroup's
memory limit.

You kill the user application even though it wasn't directly
responsible for going over the 64MB limit of space in $LOOP_DEV.
What happens now to the filesystem's metadata IO?  Did $LOOP_DEV
return an error, or after the OOM kill did the IO succeed?  What
happens if all the IO being generated from the user application is
metadata and that starts failing - killing the user application
doesn't help anything - the filesystem IO is failing and that's
where the errors need to be reported.

And if the answer is "metadata IO isn't accounted to the $CGROUP"
then what happens when the tmpfs actually runs out of it's 512MB of
space because of all the metadata the filesystem wrote (e.g. create
lots of zero length files)? That's an ENOSPC error, and we'll get
that from $LOOP_DEV just fine.

So why should the same error - running out of tmpfs space vs running
out of CGROUP quota space on tmpfs be handled differently? Either
they are both ENOSPC IO errors, or they are both OOM kill vectors
because tmpfs space has run out...

See the problem here? We report storage resource shortages
(whatever the cause) by IO errors, not by killing userspace
processes. Userspace may be able to handle the IO error sanely; it
has no warning or choice when you use OOM kill to report ENOSPC
errors...

> As opposed to before this series, where all this memory isn't
> accounted properly and goes to the root cgroup - where, ironically, it
> could cause OOM and kill an actually innocent bystander.

Johannes, I didn't question the need for the functionality. I
questioned the implementation and pointed out fundamental problems
it has as well as the architectural questions raised by needing
special kthread-based handling for correct accounting of
cgroup-aware IO.

It's a really bad look to go shoot the messenger when it's clear you
haven't understood the message that was delivered.

-Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
