From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [RFC PATCH 0/3] cgroup: fsio throttle controller
Date: Fri, 18 Jan 2019 11:35:31 -0500
Message-ID: <20190118163530.w5wpzpjkcnkektsp@macbook-pro-91.dhcp.thefacebook.com>
References: <20190118103127.325-1-righi.andrea@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=goW1Z0jvHsdrb1efjgnzxYsLnKmpr74zaTtESzdE3TE=;
        b=tIjSoPl2crufU7iL8VGWE+B4GzYPKI0nj9xPJyPBwBD3uKkJgxSCf7N1JalfxM+MCk
         jCNr0/9IYpsKBKcA4neuOLYyfeeSVev1PmMDF84r3m+CCjrWKySXmbciaHcGw/GxYV17
         85wSekhP2/vApxYqtdicAWqvm1sjMXah7j2aEAL1o3tbW4ZJMW5ZTBjbXHGpjMfhI5tN
         xV6x0QEnwqoOI10bK1I/zLjkitKKE3DShOLxws8zyiDow4XDIV98e3ejM2hez+sWsnBO
         PcnjjZZm81DjPD3IMiRVcTa8SnMUSAkRye5BzIbMkqSbjoSftjRmHezAgSWOp0deLwHT
         G60Q==
Content-Disposition: inline
In-Reply-To: <20190118103127.325-1-righi.andrea@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>, Josef Bacik <josef@toxicpanda.com>, Dennis Zhou <dennis@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jan 18, 2019 at 11:31:24AM +0100, Andrea Righi wrote:
> This is a redesign of my old cgroup-io-throttle controller:
> https://lwn.net/Articles/330531/
> 
> I'm resuming this old patch to point out a problem that I think is still
> not solved completely.
> 
> = Problem =
> 
> The io.max controller works really well at limiting synchronous I/O
> (READs), but a lot of I/O requests are initiated outside the context of
> the process that is ultimately responsible for its creation (e.g.,
> WRITEs).
> 
> Throttling at the block layer in some cases is too late and we may end
> up slowing down processes that are not responsible for the I/O that
> is being processed at that level.

How so?  The writeback threads are per-cgroup and have the cgroup stuff set
properly.  So if you dirty a bunch of pages, they are associated with your
cgroup, and then writeback happens and it's done in the writeback thread
associated with your cgroup and then that is throttled.  Then you are throttled
at balance_dirty_pages() because the writeout is taking longer.

I introduced the blk_cgroup_congested() stuff for paths that it's not easy to
clearly tie IO to the thing generating the IO, such as readahead and such.  If
you are running into this case that may be something worth using.  Course it
only works for io.latency now but there's no reason you can't add support to it
for io.max or whatever.

> 
> = Proposed solution =
> 
> The main idea of this controller is to split I/O measurement and I/O
> throttling: I/O is measured at the block layer for READS, at page cache
> (dirty pages) for WRITEs, and processes are limited while they're
> generating I/O at the VFS level, based on the measured I/O.
> 

This is what blk_cgroup_congested() is meant to accomplish, I would suggest
looking into that route and simply changing the existing io controller you are
using to take advantage of that so it will actually throttle things.  Then just
sprinkle it around the areas where we indirectly generate IO.  Thanks,

Josef
