From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH block/for-4.5-fixes] writeback: keep superblock pinned
 during cgroup writeback association switches
Date: Fri, 19 Feb 2016 21:58:11 +0000
Message-ID: <20160219215811.GA17997@ZenIV.linux.org.uk>
References: <20160216182457.GO3741@mtj.duckdns.org>
 <20160217205721.GE14140@quack.suse.cz>
 <20160217210744.GA6479@mtj.duckdns.org>
 <20160217223009.GN14140@quack.suse.cz>
 <CAAeU0aOvSwPbLPU0=20D1RExNj8VsbB38hUnyso2L8xNSQC0XA@mail.gmail.com>
 <20160217230231.GC6479@mtj.duckdns.org>
 <20160218095538.GA4338@quack.suse.cz>
 <20160218130033.GE6479@mtj.duckdns.org>
 <20160219201805.GZ17997@ZenIV.linux.org.uk>
 <20160219205147.GN13177@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160219205147.GN13177-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Nauman Rafique <nauman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>

On Fri, Feb 19, 2016 at 03:51:47PM -0500, Tejun Heo wrote:

> I see, I suppose that's what distinguishes s_active and s_umount
> usages - whether pinning should block umounting?

???

->s_active is plain and simple count of "I hold a long-term reference to
this superblock, don't you shut it down until I drop that".

->s_umount is held across some of the transitions in struct super_block
life cycle, including the actual process of shutdown.

> > If you need details on s_active/s_umount/etc., I can give you a braindump,
> > but I suspect your real question is a lot more specific.  Details, please...
> 
> So, the problem is that cgroup writeback path sometimes schedules a
> work item to change the cgroup an inode is associated.  Currently,
> only the inode was pinned and the underlying sb may go away while the
> work item is still pending.  The work item performs iput() at the end
> and that explodes if the underlying sb is already gone.
> 
> As writeback path relies on s_umount for synchronization anyway, I
> think that'd be the most natural way to hold onto the sb but
> unfortunately there's no way to pass on the down_read to the async
> execution context, so I made it grap s_active, which worked fine but
> it made the sb hang around until such work items are finished.  It's
> an unlikely race to hit but still broken.
> 
> The last option would be canceling / flushing these work items from sb
> shutdown path which is likely more involved.
> 
> What should it be doing?

Um...  What ordering requirements do you have?  You obviously shouldn't
let it continue past the shutdown - as the matter of fact, you *can't* let
it continue past generic_shutdown_super(), since any inode references
held at evict_inodes() time will make it very unhappy.  Attempts to do
any IO after that will make things a lot worse than unhappy - data structures
needed to do it might be gone (and if you hold a bit longer, filesystem
driver itself might very well be gone, along with the functions you were
going to call).

Grabbing ->s_active is a seriously bad idea for another reason - in
a situation when there's only one mount of given fs, plain umount() should
_not_ return 0 before fs shutdown is over.  Sure, it is possible that there's
a binding somewhere, or that it's a lazy umount, etc., but those are "you've
asked for it" situations; having plain umount of e.g. ext3 on a USB stick
return success before it is safe to pull that stick out is a Bloody Bad Idea,
for obvious usability reasons.

IOW, while fs shutdown may be async, making it *always* async would be a bad
bug.  And bumping ->s_active does just that.

I'd go for trylock inside that work + making generic_shutdown_super()
kill all such works.  I assume that it *can* be abandoned in situation
when we know that sync_filesystem() is about to be called and that
said sync_filesystem() won't, in turn, schedule any such works, of course...
