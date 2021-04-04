From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 00/14] bfq: introduce bfq.ioprio for cgroup
Date: Sun, 4 Apr 2021 12:09:29 -0400
Message-ID: <YGnkuWYKeK7C8/Za@mtj.duckdns.org>
References: <cover.1616649216.git.brookxu@tencent.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+IdKWx2ZVFrKT8K7Fl0vAas4WcyOSUW1ErabAnFzPiY=;
        b=jX96hJMhziC36OYDoWoeDNXvIA7cggPk7CorJz2BxjjrMbtNIlwlpylAvnWF+ZOTyX
         R7O0Tb1FjmEEOmOFKybqkuX8uLYt2kbD46H7Y9fQHbW5Kw+U3x2WI3624GWsb+cyX1Qm
         cJvWe7RpsV9BTo+zcEeHuunv76O9aeTVuLBEnsy91UoYI9wl35bYLsG/WBzjtikXWIVS
         s3A+KOz6W63YHWWmCPXPcHspclrqJ5KPq1reYAn/NMAUpaawH35cptaHti0MVdvLFkFj
         TCHTZmHAnWMdCuEb7ak9yytBgKRMd0BPNOVa3yfL8Ywmf86oBtWf6FmATEivJzIPJXX6
         O0uw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <cover.1616649216.git.brookxu@tencent.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brookxu <brookxu.cn@gmail.com>
Cc: paolo.valente@linaro.org, axboe@kernel.dk, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Thu, Mar 25, 2021 at 02:57:44PM +0800, brookxu wrote:
> INTERFACE:
> 
> The bfq.ioprio interface now is available for cgroup v1 and cgroup
> v2. Users can configure the ioprio for cgroup through this
> interface, as shown below:
> 
> echo "1 2"> blkio.bfq.ioprio
> 
> The above two values respectively represent the values of ioprio
> class and ioprio for cgroup.
> 
> EXPERIMENT:
> 
> The test process is as follows:
> # prepare data disk
> mount /dev/sdb /data1
> 
> # prepare IO scheduler
> echo bfq > /sys/block/sdb/queue/scheduler
> echo 0 > /sys/block/sdb/queue/iosched/low_latency
> echo 1 > /sys/block/sdb/queue/iosched/better_fairness
> 
> It is worth noting here that nr_requests limits the number of
> requests, and it does not perceive priority. If nr_requests is
> too small, it may cause a serious priority inversion problem.
> Therefore, we can increase the size of nr_requests based on
> the actual situation.
> 
> # create cgroup v1 hierarchy
> cd /sys/fs/cgroup/blkio
> mkdir rt be0 be1 be2 idle
> 
> # prepare cgroup
> echo "1 0" > rt/blkio.bfq.ioprio
> echo "2 0" > be0/blkio.bfq.ioprio
> echo "2 4" > be1/blkio.bfq.ioprio
> echo "2 7" > be2/blkio.bfq.ioprio
> echo "3 0" > idle/blkio.bfq.ioprio

Here are some concerns:

* The main benefit of bfq compared to cfq at least was that the behavior
  model was defined in a clearer way. It was possible to describe what the
  control model was in a way which makes semantic sense. The main problem I
  see with this proposal is that it's an interface which grew out of the
  current implementation specifics and I'm having a hard time understanding
  what the end results should be with different configuration combinations.

* While this might work around some scheduling latency issues but I have a
  hard time imagining it being able to address actual QoS issues. e.g. on a
  lot of SSDs, without absolute throttling, device side latencies can spike
  by multiple orders of magnitude and no prioritization on the scheduler
  side is gonna help once such state is reached. Here, there's no robust
  mechanisms or measurement/control units defined to address that. In fact,
  the above direction to increase nr_requests limit will make priority
  inversions on the device and post-elevator side way more likely and
  severe.

So, maybe it helps with specific scenarios on some hardware, but given the
ad-hoc nature, I don't think it justifies all the extra interface additions.
My suggestion would be slimming it down to bare essentials and making the
user interface part as minimal as possible.

Thanks.

-- 
tejun
