From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET 1/3 v2 block/for-4.1/core] writeback: cgroup writeback
 support
Date: Wed, 25 Mar 2015 12:01:15 -0400
Message-ID: <20150325160115.GR3880@htj.duckdns.org>
References: <1427086499-15657-1-git-send-email-tj@kernel.org>
 <20150325154022.GC29728@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=AKhJveImQBNDG8SxZWc2FZbtgt2sI3CdCLWKVKMXOH0=;
        b=VVtn1qMUfAxYE2m/fC5Tv7MVflYCiL6wQsrV9uD2FAb6rcRAqXnHByZwgY4ypvoS+H
         Kkdj1yMCnTzWykcA90Au2BHsoDk4IDYf3WQ/c26qJrO9nAwHailxBCS1R/Tjp4Z62sH0
         TqqQ3AalZ5MFHJxwtul3GdjPHb5HTrPCsJCvlwTt4r3iSbk8gLUHep34G69LoCJhP79r
         aJHkuYOo3fmV00dQP8SqKGnfoJG6QoExV2ZUUXVBTYN7Ano7Qv7ijoPCm533qwptrYcw
         CLtTIz4EgDR8Jo33a+G1nGq9GMR/CLy+wqhg84Bnn09PPVsEk/JggoOiW82Bv1UrXWPP
         gJjA==
Content-Disposition: inline
In-Reply-To: <20150325154022.GC29728-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Hello, Vivek.

On Wed, Mar 25, 2015 at 11:40:22AM -0400, Vivek Goyal wrote:
> I have 32G of RAM on my system and I setup a write bandwidth of 1MB/s
> on the disk and allowed a dd to run. That dd quickly consumed 5G of
> page cache before it reached to a steady state. Sounds like too much
> of cache consumption which will be drained at a speed of 1MB/s. Not
> sure if this is expected or bdi back-pressure is not being applied soon
> enough.

Ooh, the system will happily dirty certain amount of memory regardless
of the writeback speed.  The default is bg_thresh 10% and thresh 20%
which puts the target ratio at 15%.  On a 32G system this is ~4.8G, so
sounds about right.  This is intentional as otherwise we may end up
threshing worloads which can perfectly fit in the memory due to slow
backing device.  e.g. a workload which has 4G dirty footprint would
work perfectly fine in the above setup regardless of the speed of the
backing device.  If we capped dirty memory at, say, 120s of write
bandwidth, which is 120MB in this case, that workload would suffer
horribly for no good reason.

The proportional distribution of dirty pages is really just
proportional.  If you don't have higher bw backing device active on
the system, whatever is active, however slow that may be, get to
consume the entirety of the allowable dirty memory.  This doesn't
necessarily make sense for things like USB sticks, so we have per-bdi
max_ratio which can be set from userland for devices which aren't
supposed to host those sort of workloads (as you aren't gonna run a DB
workload on your thumbdrive).

So, that's where that 5G amount came from, but while you're
excercising cgroup writeback path, it isn't really doing anything
differently from before if you don't configure memcg limits.  This is
the same behavior which would happen in the global case.  Try to
configure different cgroups w/ different memory limits and write to
devices with differing write speeds.  They all will converge to ~15%
of the allowable memory in each cgroup and the dirty pages in each
cgroup will be distributed according to each device's writeback speed
in that cgroup.

Thanks.

-- 
tejun
