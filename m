From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH v5 00/11] Use obj_cgroup APIs to charge the LRU pages
Date: Tue, 31 May 2022 15:29:27 +0800
Message-ID: <YpXD12Qa51/5EUdy@FVFYT0MHHV2J.usts.net>
References: <20220530074919.46352-1-songmuchun@bytedance.com>
 <1ecec7cb-035c-a4aa-3918-1a00ba48c6f9@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ynHr+f3HdbTV3fIx5fiKz75mjaU0slPzyjQUZFWsNNE=;
        b=3BSBjnH3ZVmWwEIVHzHXEhghdgZpFnAo+yvYtAzpgRfIXkbyBVhTXgf5d/xjNpaQHS
         sz0UFZvQzv5e5HRgAt9iGDSpGTZx9tTCiezIhnMbEdJOAJ7K+A0IMSH0rp5jdGF1tm8K
         EIrFKWV2qoxlzowMCVlAVqGHTETYK99rGlF5k+vSuVBHe/TdQ3E8MnxKfl9JfYEjOtJH
         gnrlRHJsGlcnnMfhwsuKx9xFyDr/GEvdyf13nvjHmdiDKABo1mgxQFAJZxSAAZaNhZhd
         NeqvDimuZDLbss4uGUDTImQXiGHwgXTn0NpL9vNjO1nvo7gCeAaXNnUrMKHbLulytSh2
         JmIg==
Content-Disposition: inline
In-Reply-To: <1ecec7cb-035c-a4aa-3918-1a00ba48c6f9-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

On Mon, May 30, 2022 at 10:41:30PM -0400, Waiman Long wrote:
> On 5/30/22 03:49, Muchun Song wrote:
> > This version is rebased on v5.18.
> > 
> > Since the following patchsets applied. All the kernel memory are charged
> > with the new APIs of obj_cgroup.
> > 
> > 	[v17,00/19] The new cgroup slab memory controller [1]
> > 	[v5,0/7] Use obj_cgroup APIs to charge kmem pages [2]
> > 
> > But user memory allocations (LRU pages) pinning memcgs for a long time -
> > it exists at a larger scale and is causing recurring problems in the real
> > world: page cache doesn't get reclaimed for a long time, or is used by the
> > second, third, fourth, ... instance of the same job that was restarted into
> > a new cgroup every time. Unreclaimable dying cgroups pile up, waste memory,
> > and make page reclaim very inefficient.
> > 
> > We can convert LRU pages and most other raw memcg pins to the objcg direction
> > to fix this problem, and then the LRU pages will not pin the memcgs.
> > 
> > This patchset aims to make the LRU pages to drop the reference to memory
> > cgroup by using the APIs of obj_cgroup. Finally, we can see that the number
> > of the dying cgroups will not increase if we run the following test script.
> > 
> > ```bash
> > #!/bin/bash
> > 
> > dd if=/dev/zero of=temp bs=4096 count=1
> > cat /proc/cgroups | grep memory
> > 
> > for i in {0..2000}
> > do
> > 	mkdir /sys/fs/cgroup/memory/test$i
> > 	echo $$ > /sys/fs/cgroup/memory/test$i/cgroup.procs
> > 	cat temp >> log
> > 	echo $$ > /sys/fs/cgroup/memory/cgroup.procs
> > 	rmdir /sys/fs/cgroup/memory/test$i
> > done
> > 
> > cat /proc/cgroups | grep memory
> > 
> > rm -f temp log
> > ```
> > 
> > [1] https://lore.kernel.org/linux-mm/20200623015846.1141975-1-guro-b10kYP2dOMg@public.gmane.org/
> > [2] https://lore.kernel.org/linux-mm/20210319163821.20704-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
> > 
> > v4: https://lore.kernel.org/all/20220524060551.80037-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
> > v3: https://lore.kernel.org/all/20220216115132.52602-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
> > v2: https://lore.kernel.org/all/20210916134748.67712-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
> > v1: https://lore.kernel.org/all/20210814052519.86679-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
> > RFC v4: https://lore.kernel.org/all/20210527093336.14895-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
> > RFC v3: https://lore.kernel.org/all/20210421070059.69361-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
> > RFC v2: https://lore.kernel.org/all/20210409122959.82264-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
> > RFC v1: https://lore.kernel.org/all/20210330101531.82752-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
> > 
> > v5:
> >   - Lots of improvements from Johannes, Roman and Waiman.
> >   - Fix lockdep warning reported by kernel test robot.
> >   - Add two new patches to do code cleanup.
> >   - Collect Acked-by and Reviewed-by from Johannes and Roman.
> >   - I didn't replace local_irq_disable/enable() to local_lock/unlock_irq() since
> >     local_lock/unlock_irq() takes an parameter, it needs more thinking to transform
> >     it to local_lock.  It could be an improvement in the future.
> 
> My comment about local_lock/unlock is just a note that
> local_irq_disable/enable() have to be eventually replaced. However, we need
> to think carefully where to put the newly added local_lock. It is perfectly
> fine to keep it as is and leave the conversion as a future follow-up.
>

Totally agree.
 
> Thank you very much for your work on this patchset.
>

Thanks.
