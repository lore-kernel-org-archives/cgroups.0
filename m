From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block/for-4.5-fixes] writeback: keep superblock pinned
 during cgroup writeback association switches
Date: Fri, 19 Feb 2016 15:51:47 -0500
Message-ID: <20160219205147.GN13177@mtj.duckdns.org>
References: <CAAeU0aNAd1Ra6LXmWwq8row4MD_BpVHiSXOwHx07m86UWREvHw@mail.gmail.com>
 <20160216182457.GO3741@mtj.duckdns.org>
 <20160217205721.GE14140@quack.suse.cz>
 <20160217210744.GA6479@mtj.duckdns.org>
 <20160217223009.GN14140@quack.suse.cz>
 <CAAeU0aOvSwPbLPU0=20D1RExNj8VsbB38hUnyso2L8xNSQC0XA@mail.gmail.com>
 <20160217230231.GC6479@mtj.duckdns.org>
 <20160218095538.GA4338@quack.suse.cz>
 <20160218130033.GE6479@mtj.duckdns.org>
 <20160219201805.GZ17997@ZenIV.linux.org.uk>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=qhSfkfOj8DkYlRStK0GaWJXOfTjawy5xmLyG0Fhh1LY=;
        b=UdK+ZO94Ksukb4foVZwiFdjFGfnemaB0tV7r1wk6/+yuqUOzlKSZmpLjxYxDM0+Drm
         3HGvdkdp7UAMvaKiLmCNv03Sk5ZHoxeakVXx51kH2YslTzLxaKpGcfAbDXckaxEg+Qn3
         xtOqBMP9paIRN7SfhvHnQpQmhd0YdJYPXj3mQDFqkgGfMrwI+Pxmp/c9lJG+uWeaIBl0
         +74Lf8VxBhxbkmpQ5UMYfvAWkyswA3/1kMKJuHLro2ed10GKSMH295yl7wWpJgtUhULj
         Cp4unr2RZ5ZbTUF4w/bvNe1T0LVl4JoS755As3XHYp6E0znb43O/LvtXkI/CShA90LoF
         iG6Q==
Content-Disposition: inline
In-Reply-To: <20160219201805.GZ17997@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, Tahsin Erdogan <tahsin@google.com>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Nauman Rafique <nauman@google.com>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>

Hello, Al.

On Fri, Feb 19, 2016 at 08:18:06PM +0000, Al Viro wrote:
> On Thu, Feb 18, 2016 at 08:00:33AM -0500, Tejun Heo wrote:
> > So, the question is why aren't we just using s_active and draining it
> > on umount of the last mountpoint.  Because, right now, the behavior is
> > weird in that we allow umounts to proceed but then let the superblock
> > hang onto the block device till s_active is drained.  This really
> > should be synchronous.
> 
> This really should not.  First of all, umount -l (or exit of the last
> namespace user, for that matter) can leave you with actual fs shutdown
> postponed until some opened files get closed.  Nothing synchronous about
> that.

I see, I suppose that's what distinguishes s_active and s_umount
usages - whether pinning should block umounting?

> If you need details on s_active/s_umount/etc., I can give you a braindump,
> but I suspect your real question is a lot more specific.  Details, please...

So, the problem is that cgroup writeback path sometimes schedules a
work item to change the cgroup an inode is associated.  Currently,
only the inode was pinned and the underlying sb may go away while the
work item is still pending.  The work item performs iput() at the end
and that explodes if the underlying sb is already gone.

As writeback path relies on s_umount for synchronization anyway, I
think that'd be the most natural way to hold onto the sb but
unfortunately there's no way to pass on the down_read to the async
execution context, so I made it grap s_active, which worked fine but
it made the sb hang around until such work items are finished.  It's
an unlikely race to hit but still broken.

The last option would be canceling / flushing these work items from sb
shutdown path which is likely more involved.

What should it be doing?

Thanks!

-- 
tejun
