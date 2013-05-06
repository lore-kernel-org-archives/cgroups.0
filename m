From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 29.5/32] blk-throttle: add throtl_qnode for dispatch
 fairness
Date: Mon, 6 May 2013 12:00:06 -0400
Message-ID: <20130506160006.GA11731@redhat.com>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
 <20130504005044.GF22860@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130504005044.GF22860-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, May 03, 2013 at 05:50:44PM -0700, Tejun Heo wrote:

[..]
> +	 * qnode_on_self is used when bios are directly queued to this
> +	 * throtl_grp so that local bios compete fairly with bios
> +	 * dispatched from children.  qnode_on_parent is used when bios are
> +	 * dispatched from this throtl_grp into its parent and will compete
> +	 * with the sibling qnode_on_parents and the parent's
> +	 * qnode_on_self.
> +	 */
> +	struct throtl_qnode qnode_on_self;
> +	struct throtl_qnode qnode_on_parent;

Do we need one throtl_qnode for each IO dir (read/write) so that we can
queue up the right direction throtl_node in right sq->queued[rw].

Thanks
Vivek
