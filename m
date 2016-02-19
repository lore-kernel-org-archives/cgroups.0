From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH block/for-4.5-fixes] writeback: keep superblock pinned
 during cgroup writeback association switches
Date: Fri, 19 Feb 2016 17:15:12 -0500
Message-ID: <20160219221512.GO13177@mtj.duckdns.org>
References: <20160217205721.GE14140@quack.suse.cz>
 <20160217210744.GA6479@mtj.duckdns.org>
 <20160217223009.GN14140@quack.suse.cz>
 <CAAeU0aOvSwPbLPU0=20D1RExNj8VsbB38hUnyso2L8xNSQC0XA@mail.gmail.com>
 <20160217230231.GC6479@mtj.duckdns.org>
 <20160218095538.GA4338@quack.suse.cz>
 <20160218130033.GE6479@mtj.duckdns.org>
 <20160219201805.GZ17997@ZenIV.linux.org.uk>
 <20160219205147.GN13177@mtj.duckdns.org>
 <20160219215811.GA17997@ZenIV.linux.org.uk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=nncxICAxQAhyBQ54sNtenZBpKOEgSiUQom+IOqYf6t8=;
        b=ZPHOcYA6VCPsNITw+wknUMeq38S2g0/GhtGJuQfsMWfoV/f3Yw2mdrfbmaX7JXKQ31
         HtbdpamsoPcLAz4HEqBluonYUpGBPyRoapYeHIfx/Ey43KGzN/GSrUpeoSxv423hVMY2
         /rkAaYFq546giQSg5N/Ca60cnBq9kRKiG3d9OWtmMO7RbYcIdkacDhTtBTGZVkFHfoWq
         Z7H3pBZ+dYSm8ikBbiK+RAcZSXLIojlTJVwp1011LdOFFIformQ5IU2LAFR75jUXSmYg
         lJ+RnDNnu+eRSz5dn5hDOH31JQE19wPyrTB+fHfTfnm78JcL0P77B3Mp2db6B3QOwHPU
         TPjw==
Content-Disposition: inline
In-Reply-To: <20160219215811.GA17997-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Nauman Rafique <nauman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>

Hello,

On Fri, Feb 19, 2016 at 09:58:11PM +0000, Al Viro wrote:
> Um...  What ordering requirements do you have?  You obviously shouldn't
> let it continue past the shutdown - as the matter of fact, you *can't* let
> it continue past generic_shutdown_super(), since any inode references
> held at evict_inodes() time will make it very unhappy.  Attempts to do
> any IO after that will make things a lot worse than unhappy - data structures
> needed to do it might be gone (and if you hold a bit longer, filesystem
> driver itself might very well be gone, along with the functions you were
> going to call).

It can be thought of as an extension of fs writeback operation and
it'd be ideal if it can hold off sb shutdown as on-going writeback
does through holding s_umount.  Unfortunately, that doesn't seem
possible because there's no way to transfer rwsem ownership.

It doesn't generate any IO.  The reason it's done asynchronously is
because the operation requires an RCU grace period.  After the grace
period, it accesses only the generic inode and address_space and the
only time it ends up accessing sb is through the iput call.
Everything else AFAICS doesn't really care whether the underlying sb
is shut down or not.

> Grabbing ->s_active is a seriously bad idea for another reason - in
> a situation when there's only one mount of given fs, plain umount() should
> _not_ return 0 before fs shutdown is over.  Sure, it is possible that there's
> a binding somewhere, or that it's a lazy umount, etc., but those are "you've
> asked for it" situations; having plain umount of e.g. ext3 on a USB stick
> return success before it is safe to pull that stick out is a Bloody Bad Idea,
> for obvious usability reasons.

I see.

> IOW, while fs shutdown may be async, making it *always* async would be a bad
> bug.  And bumping ->s_active does just that.
> 
> I'd go for trylock inside that work + making generic_shutdown_super()
> kill all such works.  I assume that it *can* be abandoned in situation
> when we know that sync_filesystem() is about to be called and that
> said sync_filesystem() won't, in turn, schedule any such works, of course...

I'll make generic_shutdown_super() to kill all such work items.  I
don't think the work item itself would need further locking tho.  Can
you please elaborate why you thought adding trylock to the work would
be necessary?

Thanks.

-- 
tejun
