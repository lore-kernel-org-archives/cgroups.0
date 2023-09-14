From: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 03/19] fs: release anon dev_t in deactivate_locked_super
Date: Thu, 14 Sep 2023 06:38:43 +0100
Message-ID: <20230914053843.GI800259@ZenIV>
References: <20230913111013.77623-1-hch@lst.de>
 <20230913111013.77623-4-hch@lst.de>
 <20230913232712.GC800259@ZenIV>
 <20230914023705.GH800259@ZenIV>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RmUYqF8wwggq/9y9Fc7orMwmqO8RbpvM81PaCv8SZQM=; b=C6Dr0C1U8pj+4fMEBibEuICDhE
        EEkjg/MijmAsizo0zcioXNtd4W36c9mdnd0D2zVFTw1TtapnOBvqUb0vSnDBFJrCmDfpvOcOHONne
        cbQFyqeH9CCEfvuTIGraM2Hn1ukGaDmyEoVKqTlKg3th4e10i2SpPoAiTy38YK2trc+CoNIrPrQV4
        K0oeDAvm57/3q8xZeBv5OlwDsHVPFMz59m8XSYjqo9e4HqV33cx972kX4mV9uO3c30QWCKQcVDJG8
        jsGCjoM8olig+SQBNMkZp5uKci8dDFRUTLEne7SsmOttj+ApgnNyMCXaO1Qg8iqGCwTMtlWa9kvki
        ClVVewHA==;
Content-Disposition: inline
In-Reply-To: <20230914023705.GH800259@ZenIV>
Sender: Al Viro <viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s39

On Thu, Sep 14, 2023 at 03:37:05AM +0100, Al Viro wrote:
> On Thu, Sep 14, 2023 at 12:27:12AM +0100, Al Viro wrote:
> > On Wed, Sep 13, 2023 at 08:09:57AM -0300, Christoph Hellwig wrote:
> > > Releasing an anon dev_t is a very common thing when freeing a
> > > super_block, as that's done for basically any not block based file
> > > system (modulo the odd mtd special case).  So instead of requiring
> > > a special ->kill_sb helper and a lot of boilerplate in more complicated
> > > file systems, just release the anon dev_t in deactivate_locked_super if
> > > the super_block was using one.
> > > 
> > > As the freeing is done after the main call to kill_super_notify, this
> > > removes the need for having two slightly different call sites for it.
> > 
> > Huh?  At this stage in your series freeing is still in ->kill_sb()
> > instances, after the calls of kill_anon_super() you've turned into
> > the calls of generic_shutdown_super().
> > 
> > You do split it off into a separate method later in the series, but
> > at this point you are reopening the same UAF that had been dealt with
> > in dc3216b14160 "super: ensure valid info".
> > 
> > Either move the introduction of ->free_sb() before that one, or
> > split it into lifting put_anon_bdev() (left here) and getting rid
> > of kill_anon_super() (after ->free_sb() introduction).
> 
> Actually, looking at the final stage in the series, you still have
> kill_super_notify() done *AFTER* ->free_sb() call.  So the problem
> persists until the very end...

It's worse - look at the rationale for 2c18a63b760a "super: wait until
we passed kill super".  Basically, "don't remove from the lists
until after block device closing".  IOW, we have

* stuff that needs to be done before generic_shutdown_super() (things
like pinned dentries on ramfs, etc.)
* generic_shutdown_super() itself (dentry/inode eviction, optionally
->put_super())
* stuff that needs to be done before eviction from the lists (block
device closing, since 2c18a63b760a)
* eviction from the lists
* stuff that needs to be done *after* eviction from the lists.

BTW, this part of commit message in 2c18a63b760a is rather confused:
    Recent rework moved block device closing out of sb->put_super() and into
    sb->kill_sb() to avoid deadlocks as s_umount is held in put_super() and
    blkdev_put() can end up taking s_umount again.

That was *NOT* what a recent rework had done.  Block device closing had never
been inside ->put_super() - at no point since that (closing, that is) had been
introduced back in 0.97 ;-)  ->put_super() predates it (0.95c+).

The race is real, but the cause is not some kind of move of blkdev_put().
Your 2ea6f68932f7 "fs: use the super_block as holder when mounting file
systems" is where it actually came from.

Christoph, could you explain what the hell do we need that for?  It does
create the race in question and AFAICS 2c18a63b760a (and followups trying
to plug holes in it) had been nothing but headache.

Old logics: if mount attempt with a different fs type happens, -EBUSY
is precisely corrent - we would've gotten just that if mount() came
before umount().  If the type matches, we might
	1) come before deactivate_locked_super() by umount(2).
No problem, we succeed.
	2) come after the beginning of shutdown, but before the
removal from the list; fine, we'll wait for the sucker to be
unlocked (which happens in the end of generic_shutdown_super()),
notice it's dead and create a new superblock.  Since the only
part left on the umount side is closing the device, we are
just fine.
	3) come after the removal from the list.  So we won't
wait for the old superblock to be unlocked, other than that
it's exactly the same as (2).  It doesn't matter whether we
open the device before or after close by umount - same owner
anyway, no -EBUSY.

Your "owner shall be the superblock" breaks that...

If you want to mess with _three_-way split of ->kill_sb(),
please start with writing down the rules re what should
go into each of those parts; such writeup should go into
Documentation/filesystems/porting anyway, even if the
split is a two-way one, BTW.
