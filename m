From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH block/for-linus] writeback: flush inode cgroup wb
 switches instead of pinning super_block
Date: Mon, 29 Feb 2016 20:54:28 +0000
Message-ID: <20160229205428.GB17997@ZenIV.linux.org.uk>
References: <CAAeU0aNCq7LGODvVGRU-oU_o-6enii5ey0p1c26D1ZzYwkDc5A@mail.gmail.com>
 <20160215210047.GN3965@htj.duckdns.org>
 <CAAeU0aNAd1Ra6LXmWwq8row4MD_BpVHiSXOwHx07m86UWREvHw@mail.gmail.com>
 <20160216182457.GO3741@mtj.duckdns.org>
 <20160217205721.GE14140@quack.suse.cz>
 <20160217210744.GA6479@mtj.duckdns.org>
 <20160217223009.GN14140@quack.suse.cz>
 <CAAeU0aOvSwPbLPU0=20D1RExNj8VsbB38hUnyso2L8xNSQC0XA@mail.gmail.com>
 <20160217230231.GC6479@mtj.duckdns.org>
 <20160229204724.GV3965@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160229204724.GV3965-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Nauman Rafique <nauman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>

On Mon, Feb 29, 2016 at 03:47:24PM -0500, Tejun Heo wrote:
> If cgroup writeback is in use, inodes can be scheduled for
> asynchronous wb switching.  Before 5ff8eaac1636 ("writeback: keep
> superblock pinned during cgroup writeback association switches"), this
> could race with umount leading to super_block being destroyed while
> inodes are pinned for wb switching.  5ff8eaac1636 fixed it by bumping
> s_active while wb switches are in flight; however, this allowed
> in-flight wb switches to make umounts asynchronous when the userland
> expected synchronosity - e.g. fsck immediately following umount may
> fail because the device is still busy.
> 
> This patch removes the problematic super_block pinning and instead
> makes generic_shutdown_super() flush in-flight wb switches.  wb
> switches are now executed on a dedicated isw_wq so that they can be
> flushed and isw_nr_in_flight keeps track of the number of in-flight wb
> switches so that flushing can be avoided in most cases.

Wait a bloody minute.  What's to prevent shrink_dcache_for_umount() from
dirtying more inodes, triggering more of the same?

> -	if (!atomic_inc_not_zero(&inode->i_sb->s_active))
> -		goto out_unlock;

This would've failed for inodes on superblock in the middle of shutdown;
what's to do the same for the new variant?
