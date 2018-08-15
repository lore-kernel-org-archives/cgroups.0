From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v8 0/2] Directed kmem charging
Date: Wed, 15 Aug 2018 15:25:11 -0700
Message-ID: <20180815152511.3ea63aa54c5fac0bfe9370da@linux-foundation.org>
References: <20180627191250.209150-1-shakeelb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180627191250.209150-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jan Kara <jack@suse.com>, Greg Thelen <gthelen@google.com>, Amir Goldstein <amir73il@gmail.com>, Roman Gushchin <guro@fb.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Wed, 27 Jun 2018 12:12:48 -0700 Shakeel Butt <shakeelb@google.com> wrote:

> The Linux kernel's memory cgroup allows limiting the memory usage of
> the jobs running on the system to provide isolation between the jobs.
> All the kernel memory allocated in the context of the job and marked
> with __GFP_ACCOUNT will also be included in the memory usage and be
> limited by the job's limit.
> 
> The kernel memory can only be charged to the memcg of the process in
> whose context kernel memory was allocated. However there are cases where
> the allocated kernel memory should be charged to the memcg different
> from the current processes's memcg. This patch series contains two such
> concrete use-cases i.e. fsnotify and buffer_head.
> 
> The fsnotify event objects can consume a lot of system memory for large
> or unlimited queues if there is either no or slow listener. The events
> are allocated in the context of the event producer. However they should
> be charged to the event consumer. Similarly the buffer_head objects can
> be allocated in a memcg different from the memcg of the page for which
> buffer_head objects are being allocated.
> 
> To solve this issue, this patch series introduces mechanism to charge
> kernel memory to a given memcg. In case of fsnotify events, the memcg of
> the consumer can be used for charging and for buffer_head, the memcg of
> the page can be charged. For directed charging, the caller can use the
> scope API memalloc_[un]use_memcg() to specify the memcg to charge for
> all the __GFP_ACCOUNT allocations within the scope.

This patchset is not showing signs of having been well reviewed at
this time.  Could people please take another look?

