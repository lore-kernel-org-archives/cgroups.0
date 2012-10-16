From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: [PATCH 1/2] block: lift the initial queue bypass mode on
 blk_register_queue() instead of blk_init_allocated_queue()
Date: Tue, 16 Oct 2012 21:00:30 +1100
Message-ID: <CAOzFzEiCWazLEfjo=w8c+7qCce98Q6faW1uwGm-tRmCNPJUztw@mail.gmail.com>
References: <CAOzFzEhf2LfT0BCNPAgPgxZ3=pj2KvJ4Z6kP7XF8nnxag1dfvg@mail.gmail.com>
	<CAOzFzEiC4313K4H9393ffzNyBo398BPYSxTk7ZEmuH4GfW5qtw@mail.gmail.com>
	<CAOzFzEhWk_7oQFOyW6Ri_9Cvsshj2s3pa=Oo-p8uL6r340MoTw@mail.gmail.com>
	<20120919194231.GF31860@redhat.com>
	<20120920183153.GI28934@google.com>
	<20120920184219.GH4681@redhat.com>
	<20120920191716.GI4681@redhat.com>
	<20120920192038.GJ28934@google.com>
	<20120920195759.GK4681@redhat.com>
	<20120920201815.GB7264@google.com>
	<20120920210852.GC7264@google.com>
	<505C6AD4.6030206@kernel.dk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <505C6AD4.6030206-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 21 September 2012 23:25, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org> wrote:
> On 09/20/2012 11:08 PM, Tejun Heo wrote:
>> b82d4b197c ("blkcg: make request_queue bypassing on allocation") made
>> request_queues bypassed on allocation to avoid switching on and off
>> bypass mode on a queue being initialized.  Some drivers allocate and
>> then destroy a lot of queues without fully initializing them and
>> incurring bypass latency overhead on each of them could add upto
>> significant overhead.
>>
>> Unfortunately, blk_init_allocated_queue() is never used by queues of
>> bio-based drivers, which means that all bio-based driver queues are in
>> bypass mode even after initialization and registration complete
>> successfully.
>>
>> Due to the limited way request_queues are used by bio drivers, this
>> problem is hidden pretty well but it shows up when blk-throttle is
>> used in combination with a bio-based driver.  Trying to configure
>> (echoing to cgroupfs file) blk-throttle for a bio-based driver hangs
>> indefinitely in blkg_conf_prep() waiting for bypass mode to end.
>>
>> This patch moves the initial blk_queue_bypass_end() call from
>> blk_init_allocated_queue() to blk_register_queue() which is called for
>> any userland-visible queues regardless of its type.
>>
>> I believe this is correct because I don't think there is any block
>> driver which needs or wants working elevator and blk-cgroup on a queue
>> which isn't visible to userland.  If there are such users, we need a
>> different solution.
>>
>> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Reported-by: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
>> Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> ---
>> Jens, while these are fixes, I think it isn't extremely urgent and
>> routing these through 3.7-rc1 should be enough.
>
> Agree, I'll shove them into for-3.7/core
>
> --
> Jens Axboe
>

Hi,

Has this patch been marked for stable?
This is still currently broken on 3.6.2 (and I would assume other
stable kernels since 3.5)

Joseph.

-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
