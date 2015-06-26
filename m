From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/6] blkcg: move io_service_bytes and io_serviced stats
 into blkcg_gq
Date: Fri, 26 Jun 2015 12:01:42 -0400
Message-ID: <20150626160142.GA24554@redhat.com>
References: <1435268337-1738-1-git-send-email-tj@kernel.org>
 <1435268337-1738-6-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1435268337-1738-6-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, Jun 25, 2015 at 05:38:56PM -0400, Tejun Heo wrote:
> Currently, both cfq-iosched and blk-throttle keep track of
> io_service_bytes and io_serviced stats.  While keeping track of them
> separately may be useful during development, it doesn't make much
> sense otherwise.  Also, blkcg stats are collected at different points
> and ignoring blk_do_io_stat() which can lead to subtly different
> results which are more confusing than helpful.
> 
> This patch adds ->stat_bytes and ->stat_ios to blkg (blkcg_gq),
> removes the counterparts from cfq-iosched and blk-throttle and let
> them print from the common blkg counters.
> 
> The outputs are still filtered by whether the policy has
> blkg_policy_data on a given blkg, so cfq's output won't show up if it
> has never been used for a given blkg.  The only times when the outputs
> would differ significantly are when policies are attached on the fly
> or elevators are switched back and forth.  Those are quite exceptional
> operations and I don't think they warrant keeping separate counters.
> 

Hi Tejun,

I have some questions and concerns.

- Previously throttling policy was calculating number of IOs in terms of
  number of bios while CFQ was calculating it in terms of number of
  requests. I think this will be a behavior change now? IIUC, now even
  throttling policy will report number of requests and number of bios.

- Looks like completion and stat is now lined to request. I am wondering
  what will happen to bio based targets. One can put a throttling policy
  on any of the stacked dm devices. I suspect we will be broken there?

- Can you please also update the blkio-controller.txt. Specifically
  blkio.throttle.io_serviced.

Thanks
Vivek
