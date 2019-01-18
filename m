From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [RFC PATCH 0/3] cgroup: fsio throttle controller
Date: Fri, 18 Jan 2019 12:12:01 -0500
Message-ID: <20190118171200.bxpvzeuwwiwpviet@macbook-pro-91.dhcp.thefacebook.com>
References: <20190118103127.325-1-righi.andrea@gmail.com>
 <20190118163530.w5wpzpjkcnkektsp@macbook-pro-91.dhcp.thefacebook.com>
 <F576C256-A032-4E62-99EA-F60162B6E069@linaro.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Yy+kA1vOcpZaoYU+BJnjwo66nMUhjetEBGne753c72A=;
        b=Th71br3ZIWXqVzix6cgs4EeSsv+xZXidib55aVqQUFpIORoaL9eEyI+jdw9DYNy2Vm
         dMd+CEYfN4qH6+bf9keQ9WSuYj4dBThoBqp5TJ/r54ikGiDXX/7l9ibumrPShSvu2+7W
         ABGAi58TH1HWfI8RHeBrRZjfw3xTQZPv0l1ElSyrepx4kE6QyEUkYLFBgokvNoFZQeCn
         IicncPHrv/+NmxcS5xH1F5Rebp7X3IesmBhbTulPF2Xh6vOL1wwrXj9XNdq9N8BfWLKB
         sPWUi5x+0hcdUaA0UJcauRrws7VwpN2Bb+UaeSyt2QyoW6JhUZS1rrKAXr1IIJSLeAhn
         gxbA==
Content-Disposition: inline
In-Reply-To: <F576C256-A032-4E62-99EA-F60162B6E069@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente@linaro.org>
Cc: Josef Bacik <josef@toxicpanda.com>, Andrea Righi <righi.andrea@gmail.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>, Dennis Zhou <dennis@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jan 18, 2019 at 06:07:45PM +0100, Paolo Valente wrote:
> 
> 
> > Il giorno 18 gen 2019, alle ore 17:35, Josef Bacik <josef@toxicpanda.com> ha scritto:
> > 
> > On Fri, Jan 18, 2019 at 11:31:24AM +0100, Andrea Righi wrote:
> >> This is a redesign of my old cgroup-io-throttle controller:
> >> https://lwn.net/Articles/330531/
> >> 
> >> I'm resuming this old patch to point out a problem that I think is still
> >> not solved completely.
> >> 
> >> = Problem =
> >> 
> >> The io.max controller works really well at limiting synchronous I/O
> >> (READs), but a lot of I/O requests are initiated outside the context of
> >> the process that is ultimately responsible for its creation (e.g.,
> >> WRITEs).
> >> 
> >> Throttling at the block layer in some cases is too late and we may end
> >> up slowing down processes that are not responsible for the I/O that
> >> is being processed at that level.
> > 
> > How so?  The writeback threads are per-cgroup and have the cgroup stuff set
> > properly.  So if you dirty a bunch of pages, they are associated with your
> > cgroup, and then writeback happens and it's done in the writeback thread
> > associated with your cgroup and then that is throttled.  Then you are throttled
> > at balance_dirty_pages() because the writeout is taking longer.
> > 
> 
> IIUC, Andrea described this problem: certain processes in a certain group dirty a
> lot of pages, causing write back to start.  Then some other blameless
> process in the same group experiences very high latency, in spite of
> the fact that it has to do little I/O.
> 

In that case the io controller isn't doing it's job and needs to be fixed (or
reconfigured).  io.latency guards against this, I assume io.max would keep this
from happening if it were configured properly.

> Does your blk_cgroup_congested() stuff solves this issue?
> 
> Or simply I didn't get what Andrea meant at all :)
> 

I _think_ Andrea is talking about the fact that we can generate IO indirectly
and never get throttled for it, which is what blk_cgroup_congested() is meant to
address.  I added it specifically because some low prio task was just allocating
all of the memory on the system and causing a lot of pressure because of
swapping, but there was no direct feedback loop there.  blk_cgroup_congested()
provides that feedback loop.

Course I could be wrong too and we're all just talking past each other ;).
Thanks,

Josef
