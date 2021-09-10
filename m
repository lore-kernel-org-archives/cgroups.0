From: "taoyi.ty" <escape@linux.alibaba.com>
Subject: Re: [RFC PATCH 1/2] add pinned flags for kernfs node
Date: Fri, 10 Sep 2021 10:14:28 +0800
Message-ID: <3d871bd0-dab5-c9ca-61b9-6aa137fa9fdf@linux.alibaba.com>
References: <cover.1631102579.git.escape@linux.alibaba.com>
 <e753e449240bfc43fcb7aa26dca196e2f51e0836.1631102579.git.escape@linux.alibaba.com>
 <YTiuBaiVZhe3db9O@kroah.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <YTiuBaiVZhe3db9O@kroah.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Greg KH <gregkh@linuxfoundation.org>
Cc: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, mcgrof@kernel.org, keescook@chromium.org, yzaikin@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, shanpeic@linux.alibaba.com


On 2021/9/8 下午8:35, Greg KH wrote:
> Why are kernfs changes needed for this?  kernfs creation is not
> necessarily supposed to be "fast", what benchmark needs this type of
> change to require the addition of this complexity?

The implementation of the cgroup pool should have nothing

to do with kernfs, but during the development process,

I found that when there is a background cpu load, it takes

a very significant time for a process to get the mutex from

being awakened to starting execution.

To create 400 cgroups concurrently, if there is no background

cpu load, it takes about 80ms, but if the cpu usage rate is

40%, it takes about 700ms. If you reduce

sched_wakeup_granularity_ns, the time consumption will also

be reduced. If you change mutex to spinlock, the situation

will be very much improved.

So to solve this problem, mutex should not be used. The

cgroup pool relies on kernfs_rename which uses

kernfs_mutex, so I need to bypass kernfs_mutex and

add a pinned flag for this.

Because the lock mechanism of kernfs_rename has been

changed, in order to maintain data consistency, the creation

and deletion of kernfs have also been changed accordingly

I admit that this is really not a very elegant design, but I don’t

know how to make it better, so I throw out the problem and

try to seek help from the community.


thanks,


Yi Tao

