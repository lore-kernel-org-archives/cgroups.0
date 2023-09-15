From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 03/19] fs: release anon dev_t in deactivate_locked_super
Date: Fri, 15 Sep 2023 11:44:55 +0200
Message-ID: <20230915-elstern-etatplanung-906c6780af19@brauner>
References: <20230913111013.77623-1-hch@lst.de>
 <20230913111013.77623-4-hch@lst.de>
 <20230913232712.GC800259@ZenIV>
 <20230914023705.GH800259@ZenIV>
 <20230914053843.GI800259@ZenIV>
 <20230914-munkeln-pelzmantel-3e3a761acb72@brauner>
 <20230914165805.GJ800259@ZenIV>
Mime-Version: 1.0
Return-path: <linux-usb+bounces-128-glug-linux-usb=m.gmane-mx.org-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1694771103;
	bh=S1BwYDOPxFQM2OWQ2AqApQaGICqwuhOVxXD8qmxE9S4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mURAPfRa9T3jtCGyciJ8MEx6GxAXXErYK/nk44LIiNuhQs4hAslmdKcbJGnwNr9yr
	 khjb/5RMcscuYstsLOI6NvWil24K0+ArclzY0efQjxn9PUH99SSUAaSmkq9xXRww33
	 D/cJpPY6TQqbwxENu6oH38/2UMU7Iwfy2g28OUoDDGr/wtOISoK8VDOzHT3yuzXToy
	 FJN0vch/sUeVsu8AlKNt4MAYtCuBryfyrHC1PPfKKoq3NDzwvQ6be1KBhyl8BCnp5T
	 nXMCa9awTrv7+HcgRXW454HBbFjCW3+Jd6AjiAAKeJDz/1GJ9aQ9+yAN7I9Dxewp8z
	 TkuylnV+nQKEg==
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:linux-usb+subscribe-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Unsubscribe: <mailto:linux-usb+unsubscribe-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230914165805.GJ800259@ZenIV>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-hardening-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ja

On Thu, Sep 14, 2023 at 05:58:05PM +0100, Al Viro wrote:
> On Thu, Sep 14, 2023 at 04:02:25PM +0200, Christian Brauner wrote:
> 
> > Yes, you're right that making the superblock and not the filesytem type
> > the bd_holder changes the logic and we are aware of that of course. And
> > it requires changes such as moving additional block device closing from
> > where some callers currently do it.
> 
> Details, please?

Filesystems like xfs and ext4 that closed additional block devices (For
example, the logdev= mount option for xfs.) in put_super() could go
through stuff like:

blkdev_put()
-> bdev->bd_disk->fops->release() == lo_release()
   -> __loop_clr_fd()
      -> disk_force_media_change()
         -> __invalidate_device()
            -> get_super()

which wouldn't have been a problem before because get_super() matched on
sb->s_bdev which obviously doesn't work because a log device or rt
device or whatever isn't the main block device. So we couldn't have
deadlocked.

But the fact that it is called in that manner from that place in the
first place is wildly adventurous especially considering that there
isn't __a single comment__ in that code why that is safe. So good luck
figuring this all out.

Now that we don't have to do that s_bdev matching thing anymore because
we directly associate the superblock with the block device we can go
straight from block device to superblock. But now calling blkdev_put()
under put_super() which holds s_umount could deadlock. So it's moved to
kill_sb where it should've always been called. Even without the
potential deadlock in the new scheme that's cleaner and easier to
understand imho and it just works for any block device.

> Note that Christoph's series has mashed (2) and (3) together, resulting
> in UAF in a bunch of places.  And I'm dead serious about

Yes, that I did fix as far as I'm aware. If the rules would've been
written down where when something was freed we would've had an easier
time figuring this out though. But they weren't so we missed it.

> Documentation/filesystems/porting being the right place; any development

Yes, agreed. I'll write a document for Christoph's next version.

I know that what you're saying is roughly that we shouldn't make the
same mistake as were done before but the fact that the old lifetime
rules weren't documented in any meaningful way and now we get grumbled
at in turn makes me grumble a bit. :) But overall point duly taken.

> tree of any filesystem (in-tree one or not) will have to go through the
> changes and figure out WTF to do with their existing code.  We are
> going to play whack-a-mole for at least several years as development
> branches get rebased and merged.

Let me write something up.

> 
> Incidentally, I'm going to add a (belated by 10 years) chunk in porting.rst
> re making sure that anything in superblock that might be needed by methods
> called in RCU mode should *not* be freed without an RCU delay...  Should've
> done that back in 3.12 merge window when RCU'd vfsmounts went in; as it
> is, today we have several filesystems with exact same kind of breakage.
> hfsplus and affs breakage had been there in 3.13 (missed those two), exfat
> and ntfs3 - introduced later, by initial merges of filesystems in question.
> Missed on review...

Cool, thanks for adding that.

