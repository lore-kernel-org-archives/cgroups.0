From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v8 0/2] Directed kmem charging
Date: Fri, 17 Aug 2018 09:04:25 -0400
Message-ID: <20180817130425.GA12351@cmpxchg.org>
References: <20180627191250.209150-1-shakeelb@google.com>
 <20180815152511.3ea63aa54c5fac0bfe9370da@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aac5Gm9TQQkSyYqATQFmTCaoOMMkRsihgXdj1y0MZos=;
        b=OtiZsblMVy9ij4AVKGz73RvZsz9fpyEfp91t6viXYTzJ16rSUShEoEi70GV/2AG1NL
         rnz0tbi/zojUEc8iq06IMBkcEt4USlvY13ivlB6BesauDPUzgIfHkun/9Wy82ty8RSGp
         Y/lp/nQ6VeW154zdoQvhOHqqBzwEYW0rCFWO080EVbm23XmI+AXF3qLmq/cR1kqYg5GV
         YqwfLCiijolLFX6OFTKjE8fp7VVlVClG9gcDqXLLKWP1oxQVkhK50cyPpAcQhgCfZg4c
         FdkJxhqOQoQNMxkC5a7GbehJUNhojPjbMNXZL1IeICyXY4YjpPpcftysqpnqFDjKWV4m
         mGIw==
Content-Disposition: inline
In-Reply-To: <20180815152511.3ea63aa54c5fac0bfe9370da@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeelb@google.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jan Kara <jack@suse.com>, Greg Thelen <gthelen@google.com>, Amir Goldstein <amir73il@gmail.com>, Roman Gushchin <guro@fb.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Wed, Aug 15, 2018 at 03:25:11PM -0700, Andrew Morton wrote:
> On Wed, 27 Jun 2018 12:12:48 -0700 Shakeel Butt <shakeelb@google.com> wrote:
> 
> > The Linux kernel's memory cgroup allows limiting the memory usage of
> > the jobs running on the system to provide isolation between the jobs.
> > All the kernel memory allocated in the context of the job and marked
> > with __GFP_ACCOUNT will also be included in the memory usage and be
> > limited by the job's limit.
> > 
> > The kernel memory can only be charged to the memcg of the process in
> > whose context kernel memory was allocated. However there are cases where
> > the allocated kernel memory should be charged to the memcg different
> > from the current processes's memcg. This patch series contains two such
> > concrete use-cases i.e. fsnotify and buffer_head.
> > 
> > The fsnotify event objects can consume a lot of system memory for large
> > or unlimited queues if there is either no or slow listener. The events
> > are allocated in the context of the event producer. However they should
> > be charged to the event consumer. Similarly the buffer_head objects can
> > be allocated in a memcg different from the memcg of the page for which
> > buffer_head objects are being allocated.
> > 
> > To solve this issue, this patch series introduces mechanism to charge
> > kernel memory to a given memcg. In case of fsnotify events, the memcg of
> > the consumer can be used for charging and for buffer_head, the memcg of
> > the page can be charged. For directed charging, the caller can use the
> > scope API memalloc_[un]use_memcg() to specify the memcg to charge for
> > all the __GFP_ACCOUNT allocations within the scope.
> 
> This patchset is not showing signs of having been well reviewed at
> this time.  Could people please take another look?

I don't have the mailing list archives for this anymore, but the
series as it stands in mmots looks good to me and incorporates all the
feedback I remember giving.

[ My only gripe really is that it applies current->active_memcg only
  to kmem charges, not others as well. Right now it doesn't matter,
  but I can see this costing a kernel developer implementing remote
  charges for something other than kmem some time to realize. ]

Anyway, please feel free to add

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

for 1/2 and 2/2 plus their two fixlets.
