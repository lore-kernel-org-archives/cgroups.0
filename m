From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 03/19] fs: release anon dev_t in deactivate_locked_super
Date: Tue, 26 Sep 2023 11:31:29 +0200
Message-ID: <20230926093129.GA13806@lst.de>
References: <20230913111013.77623-1-hch@lst.de> <20230913111013.77623-4-hch@lst.de> <20230913232712.GC800259@ZenIV> <20230914023705.GH800259@ZenIV> <20230914053843.GI800259@ZenIV> <20230914-zielt-einzog-00389009b293@brauner>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230914-zielt-einzog-00389009b293@brauner>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-fy+rA21nqHI@public.gmane.org

On Thu, Sep 14, 2023 at 09:56:57AM +0200, Christian Brauner wrote:
> > BTW, this part of commit message in 2c18a63b760a is rather confused:
> >     Recent rework moved block device closing out of sb->put_super() and into
> >     sb->kill_sb() to avoid deadlocks as s_umount is held in put_super() and
> >     blkdev_put() can end up taking s_umount again.
> > 
> > That was *NOT* what a recent rework had done.  Block device closing had never
> > been inside ->put_super() - at no point since that (closing, that is) had been
> > introduced back in 0.97 ;-)  ->put_super() predates it (0.95c+).
> 
> I think the commit message probably just isn't clear enough. The main
> block device of a superblock isn't closed in sb->put_super(). That's
> always been closed in kill_block_super() after generic_shutdown_super().

Yes.

> But afaict filesystem like ext4 and xfs may have additional block
> devices open exclusively and closed them in sb->put_super():
> 
> xfs_fs_put_super()
> -> xfs_close_devices()
>    -> xfs_blkdev_put()
>       -> blkdev_put()
> 
> ext4_put_super()
> -> ext4_blkdev_remove()
>    -> blkdev_put()

Yes.
