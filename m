From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH block/for-linus] writeback: flush inode cgroup wb
 switches instead of pinning super_block
Date: Mon, 29 Feb 2016 21:06:15 +0000
Message-ID: <20160229210614.GC17997@ZenIV.linux.org.uk>
References: <CAAeU0aNAd1Ra6LXmWwq8row4MD_BpVHiSXOwHx07m86UWREvHw@mail.gmail.com>
 <20160216182457.GO3741@mtj.duckdns.org>
 <20160217205721.GE14140@quack.suse.cz>
 <20160217210744.GA6479@mtj.duckdns.org>
 <20160217223009.GN14140@quack.suse.cz>
 <CAAeU0aOvSwPbLPU0=20D1RExNj8VsbB38hUnyso2L8xNSQC0XA@mail.gmail.com>
 <20160217230231.GC6479@mtj.duckdns.org>
 <20160229204724.GV3965@htj.duckdns.org>
 <20160229205428.GB17997@ZenIV.linux.org.uk>
 <20160229205837.GX3965@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160229205837.GX3965-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Nauman Rafique <nauman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>

On Mon, Feb 29, 2016 at 03:58:37PM -0500, Tejun Heo wrote:
> On Mon, Feb 29, 2016 at 08:54:28PM +0000, Al Viro wrote:
> > > This patch removes the problematic super_block pinning and instead
> > > makes generic_shutdown_super() flush in-flight wb switches.  wb
> > > switches are now executed on a dedicated isw_wq so that they can be
> > > flushed and isw_nr_in_flight keeps track of the number of in-flight wb
> > > switches so that flushing can be avoided in most cases.
> > 
> > Wait a bloody minute.  What's to prevent shrink_dcache_for_umount() from
> > dirtying more inodes, triggering more of the same?
> 
> Hmmm?  The flushing is done after shrink_dcache_for_umount() and
> sync_filesystems().  Aren't inodes supposed to stay clean after that?

s/shrink_dcache_for_umount/fsnotify_unmount_inodes/ - sorry.
