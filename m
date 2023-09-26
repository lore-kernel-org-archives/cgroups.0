From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 03/19] fs: release anon dev_t in deactivate_locked_super
Date: Tue, 26 Sep 2023 11:41:30 +0200
Message-ID: <20230926094130.GC13806@lst.de>
References: <20230913111013.77623-1-hch@lst.de> <20230913111013.77623-4-hch@lst.de> <20230913232712.GC800259@ZenIV> <20230914023705.GH800259@ZenIV> <20230914053843.GI800259@ZenIV>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230914053843.GI800259@ZenIV>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-k

On Thu, Sep 14, 2023 at 06:38:43AM +0100, Al Viro wrote:
> It's worse - look at the rationale for 2c18a63b760a "super: wait until
> we passed kill super".  Basically, "don't remove from the lists
> until after block device closing".  IOW, we have

As of this stage we don't even touch anything related to block devices..

> That was *NOT* what a recent rework had done.  Block device closing had never
> been inside ->put_super() - at no point since that (closing, that is) had been
> introduced back in 0.97 ;-)  ->put_super() predates it (0.95c+).
> 
> The race is real, but the cause is not some kind of move of blkdev_put().
> Your 2ea6f68932f7 "fs: use the super_block as holder when mounting file
> systems" is where it actually came from.
> 
> Christoph, could you explain what the hell do we need that for?  It does
> create the race in question and AFAICS 2c18a63b760a (and followups trying
> to plug holes in it) had been nothing but headache.

Because it allows us to actually get from the bdev to the holder directly,
someting we've badly neeed for a while.
