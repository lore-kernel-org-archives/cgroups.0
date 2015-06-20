From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] writeback, blkio: add documentation for cgroup
 writeback support
Date: Sat, 20 Jun 2015 16:00:10 -0400
Message-ID: <20150620200010.GA16686@mtj.duckdns.org>
References: <1434146254-26220-1-git-send-email-tj@kernel.org>
 <1434146254-26220-4-git-send-email-tj@kernel.org>
 <20150615172823.GA5783@redhat.com>
 <20150615182345.GB18517@mtj.duckdns.org>
 <20150615233519.GB30059@thunk.org>
 <20150616215436.GE22637@mtj.duckdns.org>
 <20150617031540.GB4076@thunk.org>
 <20150617185237.GL22637@mtj.duckdns.org>
 <20150617214852.GE4076@thunk.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=X3TUOb5++TOxM6T0qDgZnquLfOdF8+Ym3/cIYo9oHU4=;
        b=fcF6d0+nSR63ZMKFqfEJW8/GbworvWdYTTG3A5+0dyoDYJdfJNWm4C6D3zVeiIc/OG
         5SsB6Uem8lKEvpLBs/YnmufalLz+HOgGuhSDudZoIU0GG2Pkc+9SnvvABT9WLKkGSWcJ
         v9BzWbjaJQqzL15bBjBMK0CcGDyTiUfZviNp8R1mRoV3TVSDWzbtDvUbhfWkPkXEYjNm
         HWnmSgfXw5++cvRsx7Y5AYHsMPKHodO/P2MuIR3D6rWRx7UqC2VK8ziK9TsC9i+yN6TE
         Xliw/ri4fiCm9AI0kIXAh8gG7l+3FGOfbd68kMLZKwRKRqjiYsqkoJyeZtyfEE2qmwDC
         d7ag==
Content-Disposition: inline
In-Reply-To: <20150617214852.GE4076-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hey, Ted.

On Wed, Jun 17, 2015 at 05:48:52PM -0400, Theodore Ts'o wrote:
> On Wed, Jun 17, 2015 at 02:52:37PM -0400, Tejun Heo wrote:
> > 
> > Hmmm... so, overriding things *before* an bio is issued shouldn't be
> > too difficult and as long as this sort of operations aren't prevalent
> > we might be able to get away with just charging them against root.
> > Especially if it's to avoid getting blocked on the journal which we
> > already consider a shared overhead which is charged to root.  If this
> > becomes large enough to require exacting charges, it'll be more
> > complex but still way better than trying to raise priority on a bio
> > which is already issued, which is likely to be excruciatingly painful
> > if possible at all.
> 
> Yeah, just charging the overhead to root seems good enough.

I think the easiest way to achieve this bypass would be making jbd
mark the inode while waiting in fdatawait so that writeback path can
skip attaching the writeback bios for the inode.  This isn't perfect
but should be able to work around stalls from priority inversion to
certain extent.

However, I can't come up with a workload to test it.  AFAICS, the
fdatawait stall path in jbd2 is journal_finish_inode_data_buffers()
but the path doesn't trigger reliabley with mixed load of overwriting
dd, a bunch of file creations and chmods and different cgroups stay
pretty well isolated.

Can you please suggest a workload for testing the datawait path?

Thanks.

-- 
tejun
