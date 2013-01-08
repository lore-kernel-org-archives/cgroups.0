From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 23/24] cfq-iosched: collect stats from dead cfqgs
Date: Tue, 8 Jan 2013 13:12:05 -0500
Message-ID: <20130108181205.GE29933@redhat.com>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
 <1356726946-26037-24-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1356726946-26037-24-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Fri, Dec 28, 2012 at 12:35:45PM -0800, Tejun Heo wrote:
> To support hierarchical stats, it's necessary to remember stats from
> dead children.  Add cfqg->dead_stats and make a dying cfqg transfer
> its stats to the parent's dead-stats.
> 
> The transfer happens form ->pd_offline_fn() and it is possible that
> there are some residual IOs completing afterwards.  Currently, we lose
> these stats.  Given that cgroup removal isn't a very high frequency
> operation and the amount of residual IOs on offline are likely to be
> nil or small, this shouldn't be a big deal and the complexity needed
> to handle residual IOs - another callback and rather elaborate
> synchronization to reach and lock the matching q - doesn't seem
> justified.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Acked-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Vivek
