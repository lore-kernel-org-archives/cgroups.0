From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] writeback, blkio: add documentation for cgroup
 writeback support
Date: Wed, 17 Jun 2015 14:52:37 -0400
Message-ID: <20150617185237.GL22637@mtj.duckdns.org>
References: <1434146254-26220-1-git-send-email-tj@kernel.org>
 <1434146254-26220-4-git-send-email-tj@kernel.org>
 <20150615172823.GA5783@redhat.com>
 <20150615182345.GB18517@mtj.duckdns.org>
 <20150615233519.GB30059@thunk.org>
 <20150616215436.GE22637@mtj.duckdns.org>
 <20150617031540.GB4076@thunk.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5kmha4clnKo/wv5/u3Af1DLEPvZ/K5Z3xAweyXwfh0k=;
        b=E0LCYVZy0KDP099i7bTh/UhlqqQOZ9EP7wC+WMJhLyQ3rOIDYBLxy8bOD8njaizFm0
         kf/YoaiZQnYaBy7XtOT1MoQVI7pRPeAKkTY+M9n4k8hqsjWq6O9YeCVvmUFCaIFWNj8f
         vmthqX9MOy3/vPMXx9RfZ+otZFRvVGy7hJVDvdKZVBjUxsWBHGj45B12XJWnTnRe2hux
         0KN0UR7WxOPw9Dn14Wj4Ji5G2zoh36BF+zssb2V4J06isn/A62icdjwnkJszF64D/1IS
         2cHvVyHOd/q/zyJXcU3Ddwrkfbw4hKkXeTesmN63t/D47ItUOB2QgNX4MZm8twX1MifI
         FF6g==
Content-Disposition: inline
In-Reply-To: <20150617031540.GB4076-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Tue, Jun 16, 2015 at 11:15:40PM -0400, Theodore Ts'o wrote:
> Hmm, while we're at it, there's another priority inversion that can be
> painful.  If a block directory has been pushed out of memory (possibly
> because it was initially accessed by a cgroup with a very tiny amount
> of memory allocated to its cgroup) and a process with a cgroup tries

At scale, this is self-correcting to certain extent in that if the
inode is actually something shared across cgroups, it'll most likely
end up in a cgroup which has enough resource to keep it in memory.
This doesn't prevent one-off hiccups but it at least shouldn't develop
into a systematic and chronic issue.

> to do a lookup in that directory, it will issue the read with such a
> tightly constrained disk time that it might take minutes for the read
> to complete.  The problem is that the VFS has locked the directory's
> i_mutex *before* calling ext4_lookup().
> 
> If a high priority process then tries to read the same directory, or
> in fact any VFS operation which requires taking the directory's
> i_mutex first, including renaming the directory, the high priority
> process will end up blocking until the read is completed --- which can
> be minutes if the low priority process has a tiny amount of disk time
> allocated to it.
> 
> There is a related problem where if a read for a particular block is
> issued with a very low amount of amount of disk time, and that same
> block is required by a high priority process, we can also get hit with
> a very similar priority inversion problem.
> 
> To date the answer has always been, "Doctor, Doctor it hurts when I do
> that...."  The only way I can think of fixing the directory mutex

In a lot of use cases, the directories accessed by different cgroups
are fairly segregated so this hopefully shouldn't happen too often but
yeah it can be painful on sharing cases.

> problem is by returning an error code to the VFS layer which instructs
> it to unlock the directory, and then have it wait on some wait channel
> so it ends up calling the lookup after the directory block has been
> read into memory (and we can hope that due to a tight memory cgroup
> the block doesn't end up getting ejected from memory right away).
> 
> As another solution for another part of the problem, if a high
> priority process attempts a read and the I/O is already queued up, but
> it's at the back of the bus because it was originally posted by a low
> priority cgroup, the rest of the fix would be to elevate the priority
> of said I/O request and then resort the queue.
>
> As far as the filemap_fdatawait() call is concerned, if it's being
> called by fsync() run by a low priority process, or from the writeback
> thread, then it can certainly take place at a low prority.  But if the
> filemap_fdatawait() is being done by a high priority process, such as
> a jbd/jbd2 thread, then there needs to be a way that we can set a flag
> in the wbc structure indicating that the writes should be submitted as
> if it was issued from the kernel thread, and not based on who
> originally dirtied the page.

Hmmm... so, overriding things *before* an bio is issued shouldn't be
too difficult and as long as this sort of operations aren't prevalent
we might be able to get away with just charging them against root.
Especially if it's to avoid getting blocked on the journal which we
already consider a shared overhead which is charged to root.  If this
becomes large enough to require exacting charges, it'll be more
complex but still way better than trying to raise priority on a bio
which is already issued, which is likely to be excruciatingly painful
if possible at all.

> It's going to be a number of point solutions, which is a bit ugly, but
> I think that is much more likely to be successful than trying to
> implement, say, a generalized priority inheritance scheme for block
> I/O requests and related locks.   :-)

I agree that generalized priority inheritance mechanism would be a
massive overkill.  I think as long as we can avoid boosting bio's
which already have been issued, things should be relatively sane.
Hopefully, we'd be able to figure out solutions for the worst
offenders within these constraints.

Thanks.

-- 
tejun
