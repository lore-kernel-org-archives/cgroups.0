From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: CFQ idling kills I/O performance on ext4 with blkio cgroup
 controller
Date: Sat, 18 May 2019 15:28:47 -0400
Message-ID: <20190518192847.GB14277@mit.edu>
References: <8d72fcf7-bbb4-2965-1a06-e9fc177a8938@csail.mit.edu>
 <1812E450-14EF-4D5A-8F31-668499E13652@linaro.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1812E450-14EF-4D5A-8F31-668499E13652@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente@linaro.org>
Cc: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>, linux-fsdevel@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, linux-ext4@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, jack@suse.cz, jmoyer@redhat.com, amakhalov@vmware.com, anishs@vmware.com, srivatsab@vmware.com

On Sat, May 18, 2019 at 08:39:54PM +0200, Paolo Valente wrote:
> I've addressed these issues in my last batch of improvements for
> BFQ, which landed in the upcoming 5.2. If you give it a try, and
> still see the problem, then I'll be glad to reproduce it, and
> hopefully fix it for you.

Hi Paolo, I'm curious if you could give a quick summary about what you
changed in BFQ?

I was considering adding support so that if userspace calls fsync(2)
or fdatasync(2), to attach the process's CSS to the transaction, and
then charge all of the journal metadata writes the process's CSS.  If
there are multiple fsync's batched into the transaction, the first
process which forced the early transaction commit would get charged
the entire journal write.  OTOH, journal writes are sequential I/O, so
the amount of disk time for writing the journal is going to be
relatively small, and especially, the fact that work from other
cgroups is going to be minimal, especially if hadn't issued an
fsync().

In the case where you have three cgroups all issuing fsync(2) and they
all landed in the same jbd2 transaction thanks to commit batching, in
the ideal world we would split up the disk time usage equally across
those three cgroups.  But it's probably not worth doing that...

That being said, we probably do need some BFQ support, since in the
case where we have multiple processes doing buffered writes w/o fsync,
we do charnge the data=ordered writeback to each block cgroup.  Worse,
the commit can't complete until the all of the data integrity
writebacks have completed.  And if there are N cgroups with dirty
inodes, and slice_idle set to 8ms, there is going to be 8*N ms worth
of idle time tacked onto the commit time.

If we charge the journal I/O to the cgroup, and there's only one
process doing the 

   dd if=/dev/zero of=/root/test.img bs=512 count=10000 oflags=dsync

then we don't need to worry about this failure mode, since both the
journal I/O and the data writeback will be hitting the same cgroup.
But that's arguably an artificial use case, and much more commonly
there will be multiple cgroups all trying to at least some file system
I/O.

						- Ted
