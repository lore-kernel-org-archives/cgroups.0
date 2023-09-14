From: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 03/19] fs: release anon dev_t in deactivate_locked_super
Date: Thu, 14 Sep 2023 17:58:05 +0100
Message-ID: <20230914165805.GJ800259@ZenIV>
References: <20230913111013.77623-1-hch@lst.de>
 <20230913111013.77623-4-hch@lst.de>
 <20230913232712.GC800259@ZenIV>
 <20230914023705.GH800259@ZenIV>
 <20230914053843.GI800259@ZenIV>
 <20230914-munkeln-pelzmantel-3e3a761acb72@brauner>
Mime-Version: 1.0
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OegaqNYe7r/8g+jxupTPdfeZq9KJj2OTDDvHBPIaVRM=; b=RaDan93BbmgqvP/klzEFdds2eX
        b7IkvPoHF6e1c3Qwa5SEuXQNKpqse3rk12yT18ICKdfI7a3VckJMEILdWLlbPuVYu2ikn++I4wXvt
        w+i7SX8a1a6dW7cMTedrWSnk40HFt49t9T/tHHEsDSZTulc9VAD6mfnRu95MdKXU6o+4gx8ccOYCl
        tzR3nVCHyShKKJCvDGpl2tGT/4EnlVLt+glK08TUPmS5nCJyZcU67evdh1flfJb6C4+28BCONKdlH
        o2QcR8W9m9qZ3e3/lEoYnSGID6WJVx2XavJ6wJ2qDN3BMDjs3iQqHL/hIjEVtRJN3bEfYNC532EZP
        98mkJSUw==;
Content-Disposition: inline
In-Reply-To: <20230914-munkeln-pelzmantel-3e3a761acb72@brauner>
Sender: Al Viro <viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TaqPxH82wqD4g@public.gmane.org

On Thu, Sep 14, 2023 at 04:02:25PM +0200, Christian Brauner wrote:

> Yes, you're right that making the superblock and not the filesytem type
> the bd_holder changes the logic and we are aware of that of course. And
> it requires changes such as moving additional block device closing from
> where some callers currently do it.

Details, please?

> But the filesytem type is not a very useful holder itself and has other
> drawbacks. The obvious one being that it requires us to wade through all
> superblocks on the system trying to find the superblock associated with
> a given block device continously grabbing and dropping sb_lock and
> s_umount. None of that is very pleasant nor elegant and it is for sure
> not very easy to understand (Plus, it's broken for btrfs freezing and
> syncing via block level ioctls.).

"Constantly" is a bit of a stretch - IIRC, we grabbed sb_lock once, then
went through the list comparing ->s_bdev (without any extra locking),
then bumped ->s_count on the found superblock, dropped sb_lock,
grabbed ->s_umount on the sucker and verified it's still alive.

Repeated grabbing of any lock happened only on a race with fs shutdown;
normal case is one spin_lock, one spin_unlock, one down_read().

Oh, well...

> Using the superblock as holder makes this go away and is overall a lot
> more useful and intuitive and can be extended to filesystems with
> multiple devices (Of which we apparently are bound to get more.).
>
> So I think this change is worth the pain.
> 
> It's a fair point that these lifetime rules should be documented in
> Documentation/filesystems/. The old lifetime documentation is too sparse
> to be useful though.

What *are* these lifetime rules?  Seriously, you have 3 chunks of
fs-dependent actions at the moment:
	* the things needed to get rid of internal references pinning
inodes/dentries + whatever else we need done before generic_shutdown_super()
	* the stuff to be done between generic_shutdown_super() and
making the sucker invisible to sget()/sget_fc()
	* the stuff that must be done after we are sure that sget
callbacks won't be looking at this instance.

Note that Christoph's series has mashed (2) and (3) together, resulting
in UAF in a bunch of places.  And I'm dead serious about
Documentation/filesystems/porting being the right place; any development
tree of any filesystem (in-tree one or not) will have to go through the
changes and figure out WTF to do with their existing code.  We are
going to play whack-a-mole for at least several years as development
branches get rebased and merged.

Incidentally, I'm going to add a (belated by 10 years) chunk in porting.rst
re making sure that anything in superblock that might be needed by methods
called in RCU mode should *not* be freed without an RCU delay...  Should've
done that back in 3.12 merge window when RCU'd vfsmounts went in; as it
is, today we have several filesystems with exact same kind of breakage.
hfsplus and affs breakage had been there in 3.13 (missed those two), exfat
and ntfs3 - introduced later, by initial merges of filesystems in question.
Missed on review...

Hell knows - perhaps Documentation/filesystems/whack-a-mole might be a good
idea...
