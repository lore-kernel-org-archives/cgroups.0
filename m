From: Andrea Righi <righi.andrea@gmail.com>
Subject: Re: [RFC PATCH 0/3] cgroup: fsio throttle controller
Date: Fri, 18 Jan 2019 20:02:27 +0100
Message-ID: <20190118190227.GC1535@xps-13>
References: <20190118103127.325-1-righi.andrea@gmail.com>
 <20190118163530.w5wpzpjkcnkektsp@macbook-pro-91.dhcp.thefacebook.com>
 <F576C256-A032-4E62-99EA-F60162B6E069@linaro.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1UMa4yCXmM3OK38bryfUjoNkHrVdY+842bxFOYwuFrA=;
        b=hLAJqvdqa5AmoAZ8dykKzHIvpLwfc/1enH5Qndq2pLDg3c0WHNnomUGTN6V8M/h03L
         wDSs5wP2dW+1ktrRparURlTqi4fwUyCW02xYH6j0Xydo9r9u/rX8DVlKeuAljhAVHRlq
         Z1IHAnvmvyGRMJJYYu6KSArZ/p1wbzjiLIplwznGq9ZzG7JH6yTmEu0tTjOo3vCS6iAA
         vMj5S58YJeklAQZiAQ/hn9k7Ac0BaEJcfb+LYKuGlQf9En0H1Xp58H6bvlc/X7xBQ1LR
         8+FaBdcMoGLfxmPnjWR8DRKYpukSxJIcmLAT1j+vMOaBE73QYxV5lNxz1aEMJj4DEWX/
         mZLg==
Content-Disposition: inline
In-Reply-To: <F576C256-A032-4E62-99EA-F60162B6E069@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente@linaro.org>
Cc: Josef Bacik <josef@toxicpanda.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>, Dennis Zhou <dennis@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

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
> Does your blk_cgroup_congested() stuff solves this issue?
> 
> Or simply I didn't get what Andrea meant at all :)
> 
> Thanks,
> Paolo

Yes, there is also this problem: provide fairness among processes
running inside the same cgroup.

This is a tough one, because once the I/O limit is reached whoever
process comes next gets punished, even if it hasn't done any I/O before.

Well, my proposal doesn't solve this problem. To solve this one in the
"throttling" scenario, we should probably save some information about
the previously generated I/O activity and apply a delay proportional to
that (like a dynamic weight for each process inside each cgroup).

AFAICS the io.max controller doesn't solve this problem either.

-Andrea
