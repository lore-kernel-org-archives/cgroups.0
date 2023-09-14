From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 03/19] fs: release anon dev_t in deactivate_locked_super
Date: Thu, 14 Sep 2023 09:56:57 +0200
Message-ID: <20230914-zielt-einzog-00389009b293@brauner>
References: <20230913111013.77623-1-hch@lst.de>
 <20230913111013.77623-4-hch@lst.de>
 <20230913232712.GC800259@ZenIV>
 <20230914023705.GH800259@ZenIV>
 <20230914053843.GI800259@ZenIV>
Mime-Version: 1.0
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694678225;
        bh=2ufj/dkiu5C9aI9VOV15kVL199L5WrTgWHf+hb5IyTg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hdT4bhltQEOObibgTe1UKoo0kHa563R3jH6g3lldaEO0pdCibFT6JexrMfgtDyCjk
         zWnF1cZsnmanR82cmHDXMGSqoqzYSLjFimV+8MBgTjsf58thSdJRO1TL63bZFye3vI
         Fq3vqyV2Gzlz9hgnCQg1LR82MZbcAYco0OJREyjZmjBfuF8MzK2j1pRjiNhmBwIeep
         pf1flpeoFzmd5MmAWO8OnNcMygN3mvKK/8R0xkUDSTI9AcJAeZ8tmXBDsCVpZ/0lKE
         1fssy50g3jgAFaXpAilGNljeBDWEcS/vXnpzk5sUIKRaOtQlOBi2hO0OTQ+6B3XV7Q
         3FXzrKtuu/G/g==
Content-Disposition: inline
In-Reply-To: <20230914053843.GI800259@ZenIV>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TaqPxH82wqD4g@public.gmane.org

> BTW, this part of commit message in 2c18a63b760a is rather confused:
>     Recent rework moved block device closing out of sb->put_super() and into
>     sb->kill_sb() to avoid deadlocks as s_umount is held in put_super() and
>     blkdev_put() can end up taking s_umount again.
> 
> That was *NOT* what a recent rework had done.  Block device closing had never
> been inside ->put_super() - at no point since that (closing, that is) had been
> introduced back in 0.97 ;-)  ->put_super() predates it (0.95c+).

I think the commit message probably just isn't clear enough. The main
block device of a superblock isn't closed in sb->put_super(). That's
always been closed in kill_block_super() after generic_shutdown_super().

But afaict filesystem like ext4 and xfs may have additional block
devices open exclusively and closed them in sb->put_super():

xfs_fs_put_super()
-> xfs_close_devices()
   -> xfs_blkdev_put()
      -> blkdev_put()

ext4_put_super()
-> ext4_blkdev_remove()
   -> blkdev_put()
