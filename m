From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH block/for-4.5-fixes] writeback: keep superblock pinned
 during cgroup writeback association switches
Date: Thu, 18 Feb 2016 14:20:45 +0100
Message-ID: <20160218132045.GD4338@quack.suse.cz>
References: <20160215210047.GN3965@htj.duckdns.org>
 <CAAeU0aNAd1Ra6LXmWwq8row4MD_BpVHiSXOwHx07m86UWREvHw@mail.gmail.com>
 <20160216182457.GO3741@mtj.duckdns.org>
 <20160217205721.GE14140@quack.suse.cz>
 <20160217210744.GA6479@mtj.duckdns.org>
 <20160217223009.GN14140@quack.suse.cz>
 <CAAeU0aOvSwPbLPU0=20D1RExNj8VsbB38hUnyso2L8xNSQC0XA@mail.gmail.com>
 <20160217230231.GC6479@mtj.duckdns.org>
 <20160218095538.GA4338@quack.suse.cz>
 <20160218130033.GE6479@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160218130033.GE6479@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Tahsin Erdogan <tahsin@google.com>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Nauman Rafique <nauman@google.com>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>, Al Viro <viro@ZenIV.linux.org.uk>

Hi Tejun,

On Thu 18-02-16 08:00:33, Tejun Heo wrote:
> On Thu, Feb 18, 2016 at 10:55:38AM +0100, Jan Kara wrote:
> > I'm not sure I understand the question. Do you mean why both s_active and
> > s_umount rwsem exist? s_active is a reference count keeping superblock
> 
> Yes.
> 
> > alive - e.g. if the filesystem is mounted in more places, we need a
> > reference for each mountpoint. s_umount is used when we want to block any
> 
> I could be mistaken but I *think* we used to reject umounts based on
> s_active and s_umount is the mechanism to delay umounts rather than
> failing them and probably with bind mounts the behavior changed.
> 
> > umount operation until we are done. For example sync(2) is using it to make
> > sure superblock doesn't disappear and so that we don't keep superblock
> > alive after admin called umount(2).
> 
> So, the question is why aren't we just using s_active and draining it
> on umount of the last mountpoint.  Because, right now, the behavior is
> weird in that we allow umounts to proceed but then let the superblock
> hang onto the block device till s_active is drained.  This really
> should be synchronous.

Hum, I'm not sure. I guess Al can give you more qualified answer than me.
Added to CC...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
