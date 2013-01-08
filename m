From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/24] cfq-iosched: convert cfq_group_slice() to use
 cfqg->vfraction
Date: Tue, 8 Jan 2013 11:42:26 -0500
Message-ID: <20130108164226.GE29635@redhat.com>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
 <1356726946-26037-15-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1356726946-26037-15-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Fri, Dec 28, 2012 at 12:35:36PM -0800, Tejun Heo wrote:
> cfq_group_slice() calculates slice by taking a fraction of
> cfq_target_latency according to the ratio of cfqg->weight against
> service_tree->total_weight.  This currently works only because all
> cfqgs are treated to be at the same level.
> 
> To prepare for proper hierarchy support, convert cfq_group_slice() to
> base the calculation on cfqg->vfraction.  As cfqg->vfraction is always
> a fraction of 1 and represents the fraction allocated to the cfqg with
> hierarchy considered, the slice can be simply calculated by
> multiplying cfqg->vfraction to cfq_target_latency (with fixed point
> shift factored in).
> 
> As vfraction calculation currently treats all non-root cfqgs as
> children of the root cfqg, this patch doesn't introduce noticeable
> behavior difference.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Acked-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Vivek
