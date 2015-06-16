From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 1/4] kernfs: make kernfs_get_inode() public
Date: Tue, 16 Jun 2015 13:58:21 -0700
Message-ID: <20150616205821.GA2535@kroah.com>
References: <1434481817-32001-1-git-send-email-tj@kernel.org>
 <1434481817-32001-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1434481817-32001-2-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Jun 16, 2015 at 03:10:14PM -0400, Tejun Heo wrote:
> Move kernfs_get_inode() prototype from fs/kernfs/kernfs-internal.h to
> include/linux/kernfs.h.  It obtains the matching inode for a
> kernfs_node.
> 
> It will be used by cgroup for inode based permission checks for now
> but is generally useful.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> ---
> Hello, Greg.
> 
> Given that cgroup will be the first and only, for now, user, I think
> it'd be the eaiest to route this with the related cgroup patches
> through the cgroup tree.  What do you think?

That's fine with me, feel free to add:

Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>

to it.
