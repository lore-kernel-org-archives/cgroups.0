From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/5] cgroup: replace cftype->write_string() with
 cftype->write()
Date: Thu, 8 May 2014 15:35:36 -0400
Message-ID: <20140508193536.GA15449@redhat.com>
References: <1399380266-3324-1-git-send-email-tj@kernel.org>
 <1399380266-3324-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1399380266-3324-3-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Tue, May 06, 2014 at 08:44:23AM -0400, Tejun Heo wrote:
> Convert all cftype->write_string() users to the new cftype->write()
> which maps directly to kernfs write operation and has full access to
> kernfs and cgroup contexts.  The conversions are mostly mechanical.
> 
> * @css and @cft are accessed using of_css() and of_cft() accessors
>   respectively instead of being specified as arguments.
> 
> * Should return @nbytes on success instead of 0.
> 
> * @buf is not trimmed automatically.  Trim if necessary.  Note that
>   blkcg doesn't need this as blkg_conf_prep() can already handle
>   whitespaces.
> 
> cftype->write_string() has no user left after the conversions and
> removed.
> 
> While at it, remove unnecessary local variable @p in
> cgroup_subtree_control_write() and stale comment about
> CGROUP_LOCAL_BUFFER_SIZE in cgroup_freezer.c.
> 
> This patch doesn't introduce any visible behavior changes.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Cc: Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  block/blk-throttle.c      | 32 ++++++++++++++++----------------
>  block/cfq-iosched.c       | 28 ++++++++++++++--------------

Ack to blk-throttle.c and cfq-iosched.c changes.

thanks
Vivek
