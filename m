From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH block/for-4.5-fixes] writeback: keep superblock pinned
 during cgroup writeback association switches
Date: Fri, 19 Feb 2016 20:18:06 +0000
Message-ID: <20160219201805.GZ17997@ZenIV.linux.org.uk>
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
Cc: Jan Kara <jack@suse.cz>, Tahsin Erdogan <tahsin@google.com>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Nauman Rafique <nauman@google.com>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>

On Thu, Feb 18, 2016 at 08:00:33AM -0500, Tejun Heo wrote:

> So, the question is why aren't we just using s_active and draining it
> on umount of the last mountpoint.  Because, right now, the behavior is
> weird in that we allow umounts to proceed but then let the superblock
> hang onto the block device till s_active is drained.  This really
> should be synchronous.

This really should not.  First of all, umount -l (or exit of the last
namespace user, for that matter) can leave you with actual fs shutdown
postponed until some opened files get closed.  Nothing synchronous about
that.

If you need details on s_active/s_umount/etc., I can give you a braindump,
but I suspect your real question is a lot more specific.  Details, please...
