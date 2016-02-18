From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH block/for-4.5-fixes] writeback: keep superblock pinned
 during cgroup writeback association switches
Date: Thu, 18 Feb 2016 10:55:38 +0100
Message-ID: <20160218095538.GA4338@quack.suse.cz>
References: <CAAeU0aNCq7LGODvVGRU-oU_o-6enii5ey0p1c26D1ZzYwkDc5A@mail.gmail.com>
 <20160215210047.GN3965@htj.duckdns.org>
 <CAAeU0aNAd1Ra6LXmWwq8row4MD_BpVHiSXOwHx07m86UWREvHw@mail.gmail.com>
 <20160216182457.GO3741@mtj.duckdns.org>
 <20160217205721.GE14140@quack.suse.cz>
 <20160217210744.GA6479@mtj.duckdns.org>
 <20160217223009.GN14140@quack.suse.cz>
 <CAAeU0aOvSwPbLPU0=20D1RExNj8VsbB38hUnyso2L8xNSQC0XA@mail.gmail.com>
 <20160217230231.GC6479@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160217230231.GC6479@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Tahsin Erdogan <tahsin@google.com>, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Nauman Rafique <nauman@google.com>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>

On Wed 17-02-16 18:02:31, Tejun Heo wrote:
> On Wed, Feb 17, 2016 at 02:41:25PM -0800, Tahsin Erdogan wrote:
> > With this patch, I am starting to have issues running fsck immediately
> > after umount.
> > 
> > *** fsck.ext4 output ***
> > fsck from util-linux-ng 2.17.2
> > e2fsck 1.42.12-gg3 (9-Sep-2014)
> > Warning!  /dev/sdb3 is in use.
> > Pass 1: Checking inodes, blocks, and sizes
> > Deleted inode 62346243 has zero dtime.  Fix? no
> 
> Yeah, that'd be one of the side effects.  Will think more about it.
> Jan, do you know why we have both s_active and the rwsem at this
> point?  I can't tell why both are needed.

I'm not sure I understand the question. Do you mean why both s_active and
s_umount rwsem exist? s_active is a reference count keeping superblock
alive - e.g. if the filesystem is mounted in more places, we need a
reference for each mountpoint. s_umount is used when we want to block any
umount operation until we are done. For example sync(2) is using it to make
sure superblock doesn't disappear and so that we don't keep superblock
alive after admin called umount(2).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
