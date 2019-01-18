From: Andrea Righi <righi.andrea@gmail.com>
Subject: Re: [RFC PATCH 0/3] cgroup: fsio throttle controller
Date: Fri, 18 Jan 2019 19:44:03 +0100
Message-ID: <20190118184403.GB1535@xps-13>
References: <20190118103127.325-1-righi.andrea@gmail.com>
 <20190118163530.w5wpzpjkcnkektsp@macbook-pro-91.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=npe1ieDjm263/B2NTZOjdeR5wj0sxGNNGEfjAzD1woc=;
        b=BBN4i9jvq4T9ua/h6BIwPQ6Tas91zEMg8YA3pqH2l8xC6HXoFmIP84Kbx1KLdS4P20
         8BVOdZitziQH8R4fm+wQPWoa8+PHLH+ETWUrlcgOzPuU/4dSzCW+ObjBs89T/3LAernF
         LNjaYox9ts1aicVguoKMGHLOR4d8n7rrM4syQsvJKh9s5U12r9syV97T9P3r8wufaNla
         pEL/TeTGTaxe4oGhJxy3M5bMvqQ4QIZk0W0SAs0ouyIYNNGW6Hu30YBoe5demoXLz7aJ
         ZWT2Vt9dxkt0BQLVb0y9t8wE9HGi/RUk7VIWGW+3SqSVrouABvf9k3sblEeJHcUcjmZF
         jvVA==
Content-Disposition: inline
In-Reply-To: <20190118163530.w5wpzpjkcnkektsp@macbook-pro-91.dhcp.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josef Bacik <josef@toxicpanda.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>, Dennis Zhou <dennis@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jan 18, 2019 at 11:35:31AM -0500, Josef Bacik wrote:
> On Fri, Jan 18, 2019 at 11:31:24AM +0100, Andrea Righi wrote:
> > This is a redesign of my old cgroup-io-throttle controller:
> > https://lwn.net/Articles/330531/
> > 
> > I'm resuming this old patch to point out a problem that I think is still
> > not solved completely.
> > 
> > = Problem =
> > 
> > The io.max controller works really well at limiting synchronous I/O
> > (READs), but a lot of I/O requests are initiated outside the context of
> > the process that is ultimately responsible for its creation (e.g.,
> > WRITEs).
> > 
> > Throttling at the block layer in some cases is too late and we may end
> > up slowing down processes that are not responsible for the I/O that
> > is being processed at that level.
> 
> How so?  The writeback threads are per-cgroup and have the cgroup stuff set
> properly.  So if you dirty a bunch of pages, they are associated with your
> cgroup, and then writeback happens and it's done in the writeback thread
> associated with your cgroup and then that is throttled.  Then you are throttled
> at balance_dirty_pages() because the writeout is taking longer.

Right, writeback is per-cgroup and slowing down writeback affects only
that specific cgroup, but, there are cases where other processes from
other cgroups may require to wait on that writeback to complete before
doing I/O (for example an fsync() to a file shared among different
cgroups). In this case we may end up blocking cgroups that shouldn't be
blocked, that looks like a priority-inversion problem. This is the
problem that I'm trying to address.

> 
> I introduced the blk_cgroup_congested() stuff for paths that it's not easy to
> clearly tie IO to the thing generating the IO, such as readahead and such.  If
> you are running into this case that may be something worth using.  Course it
> only works for io.latency now but there's no reason you can't add support to it
> for io.max or whatever.

IIUC blk_cgroup_congested() is used in readahead I/O (and swap with
memcg), something like this: if the cgroup is already congested don't
generate extra I/O due to readahead. Am I right?

> 
> > 
> > = Proposed solution =
> > 
> > The main idea of this controller is to split I/O measurement and I/O
> > throttling: I/O is measured at the block layer for READS, at page cache
> > (dirty pages) for WRITEs, and processes are limited while they're
> > generating I/O at the VFS level, based on the measured I/O.
> > 
> 
> This is what blk_cgroup_congested() is meant to accomplish, I would suggest
> looking into that route and simply changing the existing io controller you are
> using to take advantage of that so it will actually throttle things.  Then just
> sprinkle it around the areas where we indirectly generate IO.  Thanks,

Absolutely, I can probably use blk_cgroup_congested() as a method to
determine when a cgroup should be throttled (instead of doing my own
I/O measuring), but to prevent the "slow writeback slowing down other
cgroups" issue I still need to apply throttling when pages are dirtied
in page cache.

Thanks,
-Andrea
