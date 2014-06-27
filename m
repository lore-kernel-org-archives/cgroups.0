From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v2 2/3] kernfs: introduce kernfs_pin_sb()
Date: Fri, 27 Jun 2014 10:48:52 -0700
Message-ID: <20140627174852.GA1653@kroah.com>
References: <53AD18D0.3090100@huawei.com>
 <53AD18F8.4050501@huawei.com>
 <20140627150141.GB4044@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140627150141.GB4044-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Jun 27, 2014 at 11:01:41AM -0400, Tejun Heo wrote:
> On Fri, Jun 27, 2014 at 03:10:48PM +0800, Li Zefan wrote:
> > kernfs_pin_sb() tries to get a refcnt of the superblock.
> > 
> > This will be used by cgroupfs.
> 
> Greg, this is pretty much cgroup specific due to the way cgroup
> dynamically manages multiple hierarchies.  Can I route this through
> cgroup/for-3.16-fixes w/ stable cc'd?

Please do:

Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
