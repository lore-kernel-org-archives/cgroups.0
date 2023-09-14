From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 03/19] fs: release anon dev_t in deactivate_locked_super
Date: Thu, 14 Sep 2023 16:02:25 +0200
Message-ID: <20230914-munkeln-pelzmantel-3e3a761acb72@brauner>
References: <20230913111013.77623-1-hch@lst.de>
 <20230913111013.77623-4-hch@lst.de>
 <20230913232712.GC800259@ZenIV>
 <20230914023705.GH800259@ZenIV>
 <20230914053843.GI800259@ZenIV>
Mime-Version: 1.0
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694700153;
        bh=UbILtaDX6YaX9dgq96QTqXtymCmpeldgjR+T2oK3xaM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PNO+aHUgNDxHMtKVOjlzcOL7tLf+z9y1Iq9XnBkmWBc2p/Apxp3ZmIFvKQ7+UYpIj
         vGqVGuRuqwz0WOI8F1gzCKpdQPNfFHmxOHmz3dSp8GqSj3cE46pwgm94yOyHfEGDiv
         t9y7eUZSydl/+7e2w+r2yGmTZg5C3zcJTsLzrZROns45s7RhKOT5/mOoOYhEY9tIY0
         aW5X29QrkwlJ6PisxRbW4j8ftjNKzQ2NS5JZkV/8+DbW86yP6ME2DQBOHUELgyT2nn
         rGGSMchIIOuzQfCiLakKwcTxGR0UeiFBwERYJSLsssW7J/ySM61igFF7UL6hlSMHj2
         OLKep8D3SXHCA==
Content-Disposition: inline
In-Reply-To: <20230914053843.GI800259@ZenIV>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TaqPxH82wqD4g@public.gmane.org

> Christoph, could you explain what the hell do we need that for?  It does
> create the race in question and AFAICS 2c18a63b760a (and followups trying
> to plug holes in it) had been nothing but headache.
> 
> Old logics: if mount attempt with a different fs type happens, -EBUSY
> is precisely corrent - we would've gotten just that if mount() came
> before umount().  If the type matches, we might
> 	1) come before deactivate_locked_super() by umount(2).
> No problem, we succeed.
> 	2) come after the beginning of shutdown, but before the
> removal from the list; fine, we'll wait for the sucker to be
> unlocked (which happens in the end of generic_shutdown_super()),
> notice it's dead and create a new superblock.  Since the only
> part left on the umount side is closing the device, we are
> just fine.
> 	3) come after the removal from the list.  So we won't
> wait for the old superblock to be unlocked, other than that
> it's exactly the same as (2).  It doesn't matter whether we
> open the device before or after close by umount - same owner
> anyway, no -EBUSY.
> 
> Your "owner shall be the superblock" breaks that...
> 
> If you want to mess with _three_-way split of ->kill_sb(),
> please start with writing down the rules re what should
> go into each of those parts; such writeup should go into
> Documentation/filesystems/porting anyway, even if the
> split is a two-way one, BTW.

Hm, I think that characterization of Christoph's changes is a bit harsh.

Yes, you're right that making the superblock and not the filesytem type
the bd_holder changes the logic and we are aware of that of course. And
it requires changes such as moving additional block device closing from
where some callers currently do it.

But the filesytem type is not a very useful holder itself and has other
drawbacks. The obvious one being that it requires us to wade through all
superblocks on the system trying to find the superblock associated with
a given block device continously grabbing and dropping sb_lock and
s_umount. None of that is very pleasant nor elegant and it is for sure
not very easy to understand (Plus, it's broken for btrfs freezing and
syncing via block level ioctls.).

Using the superblock as holder makes this go away and is overall a lot
more useful and intuitive and can be extended to filesystems with
multiple devices (Of which we apparently are bound to get more.).

So I think this change is worth the pain.

It's a fair point that these lifetime rules should be documented in
Documentation/filesystems/. The old lifetime documentation is too sparse
to be useful though.
