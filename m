From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: CFQ idling kills I/O performance on ext4 with blkio cgroup
 controller
Date: Tue, 21 May 2019 15:10:33 -0400
Message-ID: <20190521191033.GA4855@mit.edu>
References: <8d72fcf7-bbb4-2965-1a06-e9fc177a8938@csail.mit.edu>
 <1812E450-14EF-4D5A-8F31-668499E13652@linaro.org>
 <20190518192847.GB14277@mit.edu>
 <20190520091558.GC2172@quack2.suse.cz>
 <20190521164814.GC2591@mit.edu>
 <20190521181952.4vpruone2mzbczpw@MacBook-Pro-91.local>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190521181952.4vpruone2mzbczpw@MacBook-Pro-91.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josef Bacik <josef@toxicpanda.com>
Cc: Jan Kara <jack@suse.cz>, Paolo Valente <paolo.valente@linaro.org>, "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>, linux-fsdevel@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, linux-ext4@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, jmoyer@redhat.com, amakhalov@vmware.com, anishs@vmware.com, srivatsab@vmware.com

On Tue, May 21, 2019 at 02:19:53PM -0400, Josef Bacik wrote:
> Chris is adding a REQ_ROOT (or something) flag that means don't throttle me now,
> but the the blkcg attached to the bio is the one that is responsible for this
> IO.  Then for io.latency we'll let the io go through unmolested but it gets
> counted to the right cgroup, and if then we're exceeding latency guarantees we
> have the ability to schedule throttling for that cgroup in a safer place.  This
> would eliminate the data=ordered issue for ext4, you guys keep doing what you
> are doing and we'll handle throttling elsewhere, just so long as the bio's are
> tagged with the correct source then all is well.  Thanks,

Great, it sounds like Chris also came up with the the entangled writes
flag idea (although with probably a better name than I did :-).  So
now all we need to do is to plumb a flag through the writeback code so
that file systems (or the VFS player) implementing syncfs(2) or
fsync(2) can arrange to have that flag set if necessary.

Speaking of syncfs(2), something which we considered doing at Google
many years ago (but never did) was to implement a hack so that someone
calling syncfs(2) or sync(2) when they were not root, would make that
sys call be a no-op.  The reason for this was on heavy loaded
machines, an SRE logged in as a non-root user might absent-mindly type
"sync", and that would cause a storm of I/O traffic that would really
mess up the machine.  The jobs that were in the low latency bucket
would be protected (since we didn't run with journalling), but those
that were in the best efforts bucket would be really unhappy.

If we have a "don't throttle me now" REQ_ROOT flag combined with
journalling, then someone running "sync", even if it's by accident,
could really ruin a low-latency job's day, and in a container
environment, there really is no reason for a non-root user to be
wanting to request a syncfs(2) or sync(2).  So maybe we should have a
way to make it be a no-op (or return an error, but that might surprise
some applications) for non-privileged users.  Maybe as a per-mount
flag/option, or via some other tunable?

						- Ted
