From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/6] blkcg: add blkg_[rw]stat->aux_cnt and replace
 cfq_group->dead_stats with it
Date: Fri, 26 Jun 2015 09:27:02 -0400
Message-ID: <20150626132702.GA14803@redhat.com>
References: <1435268337-1738-1-git-send-email-tj@kernel.org>
 <1435268337-1738-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1435268337-1738-3-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, Jun 25, 2015 at 05:38:53PM -0400, Tejun Heo wrote:

[..]
> It's planned that the core stats will be moved to blkcg_gq, so we want
> to move the mechanism for keeping track of the stats of dead children
> from cfq to blkcg core.  This patch adds blkg_[rw]stat->aux_cnt which
> are atomic64_t's keeping track of auxiliary counts which are excluded
> when reading local counts but included for recursive.

Hi Tejun,

So aux_cnt is atomic64_t as updation is not the hot path hence there is
not much value in keeping it as per cpu?

Thanks
Vivek
