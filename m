From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH-block v2] bdi, blk-cgroup: Fix potential UAF of blkcg
Date: Wed, 30 Nov 2022 14:39:46 +0200
Message-ID: <Y4dPEtGuQ2A3L+Ww@smile.fi.intel.com>
References: <20221129203400.1456100-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669811993; x=1701347993;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iPuUqicRuUklAlC5NV44CDz/ub4ZDmFDWBmSCxl3Jkw=;
  b=VmD+Tld7VK+TKKsOLApG+zWmnWS7mdPl+tG1U9gyyz5MrCD5MqP0+i/W
   Mz5Qj5MvCTxwwUNyeK30kW31itd+mXLM6k+oAeK3vkFFxpDE+HMewrjQF
   VXh9LlvGqtNmddQfYCuMQAWCxFRXTq+7EgvCqhniM6Z5PNfNJeNmhqJ8g
   aDcy538050krtABGERsZGLNCIBxrLSL6ihxp5GzYeAMXIKKKNwJjUS1gf
   cw1jmsBa3hJJmZkzcQ5oFs7ysCv7XnyEPyyI4sSIXyYLW2tzKk1jcPfWq
   QvzhtCpAu6Ylp2JZ8u3McEZ7VoKxQuux8SjEcSmE1xEgLllhMaQt8k3kI
   w==;
Content-Disposition: inline
In-Reply-To: <20221129203400.1456100-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>, Chaitanya Kulkarni <chaitanyak-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Yi Zhang <yi.zhang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Tue, Nov 29, 2022 at 03:34:00PM -0500, Waiman Long wrote:
> Commit 59b57717fff8 ("blkcg: delay blkg destruction until after
> writeback has finished") delayed call to blkcg_destroy_blkgs() to
> cgwb_release_workfn(). However, it is done after a css_put() of blkcg
> which may be the final put that causes the blkcg to be freed as RCU
> read lock isn't held.
> 
> By adding a css_tryget() into blkcg_destroy_blkgs() and warning its
> failure, the following stack trace was produced in a test system on
> bootup.
> 
> [   34.254240] RIP: 0010:blkcg_destroy_blkgs+0x16a/0x1a0
>       :
> [   34.339943] Call Trace:
> [   34.342395]  <TASK>
> [   34.344510]  blkcg_unpin_online+0x38/0x60
> [   34.348523]  cgwb_release_workfn+0x6a/0x200
> [   34.352708]  process_one_work+0x1e5/0x3b0
> [   34.356742]  ? rescuer_thread+0x390/0x390
> [   34.360758]  worker_thread+0x50/0x3a0
> [   34.364425]  ? rescuer_thread+0x390/0x390
> [   34.368447]  kthread+0xd9/0x100
> [   34.371592]  ? kthread_complete_and_exit+0x20/0x20
> [   34.376386]  ret_from_fork+0x22/0x30
> [   34.379982]  </TASK>

https://www.kernel.org/doc/html/latest/process/submitting-patches.html#backtraces-in-commit-messages


> This confirms that a potential UAF situation can happen.
> 
> Fix that by delaying the css_put() until after the blkcg_unpin_online()
> call. Also use css_tryget() in blkcg_destroy_blkgs() and issue a warning
> if css_tryget() fails with no RCU read lock held.
> 
> The reproducing system can no longer produce a warning with this patch.
> All the runnable block/0* tests including block/027 were run successfully
> without failure.

-- 
With Best Regards,
Andy Shevchenko


