From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 03/19] fs: release anon dev_t in deactivate_locked_super
Date: Tue, 26 Sep 2023 11:38:34 +0200
Message-ID: <20230926093834.GB13806@lst.de>
References: <20230913111013.77623-1-hch@lst.de> <20230913111013.77623-4-hch@lst.de> <20230913232712.GC800259@ZenIV>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230913232712.GC800259@ZenIV>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-k

On Thu, Sep 14, 2023 at 12:27:12AM +0100, Al Viro wrote:
> On Wed, Sep 13, 2023 at 08:09:57AM -0300, Christoph Hellwig wrote:
> > Releasing an anon dev_t is a very common thing when freeing a
> > super_block, as that's done for basically any not block based file
> > system (modulo the odd mtd special case).  So instead of requiring
> > a special ->kill_sb helper and a lot of boilerplate in more complicated
> > file systems, just release the anon dev_t in deactivate_locked_super if
> > the super_block was using one.
> > 
> > As the freeing is done after the main call to kill_super_notify, this
> > removes the need for having two slightly different call sites for it.
> 
> Huh?  At this stage in your series freeing is still in ->kill_sb()
> instances, after the calls of kill_anon_super() you've turned into
> the calls of generic_shutdown_super().

The above refers to freeing the anon dev_t, which at this stage is done
right after the kill_super_notify in generic_shutdown_super.

> You do split it off into a separate method later in the series, but
> at this point you are reopening the same UAF that had been dealt with
> in dc3216b14160 "super: ensure valid info".

How?

Old sequence before his patch:

	deactivate_locked_super()
	  -> kill_anon_super()
	    -> generic_shutdown_super()
	    -> kill_super_notify()
	    -> free_anon_bdev()
	  -> kill_super_notify()

New sequence with this patch:

	deactivate_locked_super()
	  -> generic_shutdown_super()
	    -> kill_super_notify()
	    -> free_anon_bdev()

