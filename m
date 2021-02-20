From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [BUG] page allocation failure reading procfs ipv6 configuration
 files with cgroups
Date: Sat, 20 Feb 2021 17:36:05 +0000
Message-ID: <20210220173605.GD2858050@casper.infradead.org>
References: <d2d3e617-17bf-8d43-f4a2-e4a7a2d421bd@gmail.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ncte2IIQTeBtTyvUJS/06d8GB/UyYxf4MK1I86Ykfdg=; b=WHSmTU/+aeltzFU2z1bHDTHrOX
        x+6nt/0qPi5tEnpS2rLDQR7aG25ogU50uzXjlDuFqObweO3e66UnWdTwzc/VeCUoDnsR0Yg05IUVz
        qKja4x36gCYsSIkMjxs3K0eCChqiLjBKDTSyoMDzKNxTSjp+Jzfr5p8VvISV5KUuhRPe+YtgAhIql
        kJf6C/FZopt3SHEpq9xNPi3JJ6m299a50q92TuVifbZ+M5EfN9VJVLNHgKYBsU8HyM2wRnwa5zhbJ
        AQjCHFQjF8Tskgm9rvY6ZnLR9ypqhcrzk1QkHGyktm3AdSe4gFZE9Q4fQ4/bEgPAw+PlFWeu0anNd
        Wfk8BSyQ==;
Content-Disposition: inline
In-Reply-To: <d2d3e617-17bf-8d43-f4a2-e4a7a2d421bd@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Geis <pgwipeout@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Alexey Dobriyan <adobriyan@gmail.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Sat, Feb 20, 2021 at 12:29:18PM -0500, Peter Geis wrote:
> Good Afternoon,
> 
> I have been tracking down a regular bug that triggers when running OpenWRT in a lxd container.
> Every ten minutes I was greeted with the following splat in the kernel log:
> 
> [2122311.383389] warn_alloc: 3 callbacks suppressed
> [2122311.383403] cat: page allocation failure: order:5, mode:0x40dc0(GFP_KERNEL|__GFP_COMP|__GFP_ZERO), nodemask=(null),cpuset=lxc.payload.openwrt,mems_allowed=0

You want this patch:

https://lore.kernel.org/linux-fsdevel/6345270a2c1160b89dd5e6715461f388176899d1.1612972413.git.josef@toxicpanda.com/
