From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHSET 1/3 v2 block/for-4.1/core] writeback: cgroup writeback
 support
Date: Wed, 25 Mar 2015 11:40:22 -0400
Message-ID: <20150325154022.GC29728@redhat.com>
References: <1427086499-15657-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1427086499-15657-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Mon, Mar 23, 2015 at 12:54:11AM -0400, Tejun Heo wrote:
> 
> 
> How to test
> -----------
> 
> * Boot with kernel option "cgroup__DEVEL__legacy_files_on_dfl".
> 
> * umount /sys/fs/cgroup/memory
>   umount /sys/fs/cgroup/blkio
>   mkdir /sys/fs/cgroup/unified
>   mount -t cgroup -o __DEVEL__sane_behavior cgroup /sys/fs/cgroup/unified
>   echo +blkio > /sys/fs/cgroup/unified/cgroup.subtree_control
> 
> * Build the cgroup hierarchy (don't forget to enable blkio using
>   subtree_control) and put processes in cgroups and run tests on ext2
>   filesystems and blkio.throttle.* knobs.
> 

[..]
> This patchset is on top of
> 
>   block/for-4.1/core bfd343aa1718 ("blk-mq: don't wait in blk_mq_queue_enter() if __GFP_WAIT isn't set")
> + [1] [PATCH] writeback: fix possible underflow in write bandwidth calculation
> 
> and available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup-writeback-20150322
> 

Hi Tejun,

Great Work. I tried to do some basic testing and it seems to work.

I used "review-cgroup-writeback-switch-20150322" branch for my testing.

I have 32G of RAM on my system and I setup a write bandwidth of 1MB/s
on the disk and allowed a dd to run. That dd quickly consumed 5G of
page cache before it reached to a steady state. Sounds like too much
of cache consumption which will be drained at a speed of 1MB/s. Not
sure if this is expected or bdi back-pressure is not being applied soon
enough.

Thanks
Vivek
