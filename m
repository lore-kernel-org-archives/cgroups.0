From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] writeback, blkio: add documentation for cgroup
 writeback support
Date: Tue, 16 Jun 2015 23:15:40 -0400
Message-ID: <20150617031540.GB4076@thunk.org>
References: <1434146254-26220-1-git-send-email-tj@kernel.org>
 <1434146254-26220-4-git-send-email-tj@kernel.org>
 <20150615172823.GA5783@redhat.com>
 <20150615182345.GB18517@mtj.duckdns.org>
 <20150615233519.GB30059@thunk.org>
 <20150616215436.GE22637@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=thunk.org; s=ef5046eb;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=vpyDnnKfFrdYs9oLGqZRc8MzkS4Fugmiz4VqM4xaEDE=;
	b=NsSzUJOSKMRw6ozboXyBl6qIVEXXB9rDHHTmZrNMxF+5j1zM0VSrhXTyh9sJ60ljo8f6sPQHzO91kLDfmixO86UHfTM/gk7nnOFg6GgGQ4gG2HTivE+RF+P/0BIve8n1pSOl6XmYZldKOFeL/bjrw0+k7rlFPlHDwkGJX3i+Kak=;
Content-Disposition: inline
In-Reply-To: <20150616215436.GE22637@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org

On Tue, Jun 16, 2015 at 05:54:36PM -0400, Tejun Heo wrote:
> Hello, Ted.
> 
> On Mon, Jun 15, 2015 at 07:35:19PM -0400, Theodore Ts'o wrote:
> > So if there is some way we can signal to any cgroup that that might be
> > throttling writeback or disk I/O that the jbd/jbd2 process should be
> > considered privileged, that would be a good since it would allow us to
> > avoid a potential priority inversion problem. 
> 
> I see.  In the long term, I think we might need to come up with a way
> to overcharge a slower cgroup to avoid blocking faster ones for cases
> where some IOs are depended upon by more than one cgroups.  That'd
> take quite a bit of work from blkcg side.  Will think more about it.

Hmm, while we're at it, there's another priority inversion that can be
painful.  If a block directory has been pushed out of memory (possibly
because it was initially accessed by a cgroup with a very tiny amount
of memory allocated to its cgroup) and a process with a cgroup tries
to do a lookup in that directory, it will issue the read with such a
tightly constrained disk time that it might take minutes for the read
to complete.  The problem is that the VFS has locked the directory's
i_mutex *before* calling ext4_lookup().

If a high priority process then tries to read the same directory, or
in fact any VFS operation which requires taking the directory's
i_mutex first, including renaming the directory, the high priority
process will end up blocking until the read is completed --- which can
be minutes if the low priority process has a tiny amount of disk time
allocated to it.

There is a related problem where if a read for a particular block is
issued with a very low amount of amount of disk time, and that same
block is required by a high priority process, we can also get hit with
a very similar priority inversion problem.

To date the answer has always been, "Doctor, Doctor it hurts when I do
that...."  The only way I can think of fixing the directory mutex
problem is by returning an error code to the VFS layer which instructs
it to unlock the directory, and then have it wait on some wait channel
so it ends up calling the lookup after the directory block has been
read into memory (and we can hope that due to a tight memory cgroup
the block doesn't end up getting ejected from memory right away).

As another solution for another part of the problem, if a high
priority process attempts a read and the I/O is already queued up, but
it's at the back of the bus because it was originally posted by a low
priority cgroup, the rest of the fix would be to elevate the priority
of said I/O request and then resort the queue.

As far as the filemap_fdatawait() call is concerned, if it's being
called by fsync() run by a low priority process, or from the writeback
thread, then it can certainly take place at a low prority.  But if the
filemap_fdatawait() is being done by a high priority process, such as
a jbd/jbd2 thread, then there needs to be a way that we can set a flag
in the wbc structure indicating that the writes should be submitted as
if it was issued from the kernel thread, and not based on who
originally dirtied the page.

It's going to be a number of point solutions, which is a bit ugly, but
I think that is much more likely to be successful than trying to
implement, say, a generalized priority inheritance scheme for block
I/O requests and related locks.   :-)

    	     					- Ted
