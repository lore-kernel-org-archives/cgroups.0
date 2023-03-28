From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: move bio cgroup punting into btrfs
Date: Wed, 29 Mar 2023 01:34:48 +0200
Message-ID: <20230328233448.GA5486@lst.de>
References: <20230327004954.728797-1-hch@lst.de> <512eaacf-3ff6-f4f9-c856-a0e03c027501@meta.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <512eaacf-3ff6-f4f9-c856-a0e03c027501-M8Ki61LpUEw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Mason <clm-M8Ki61LpUEw@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Mar 28, 2023 at 05:18:43PM -0400, Chris Mason wrote:
> Is btrfs really the only place using worker threads to submit IO, or are
> we just the only ones looking for the priority inversions w/resource
> control in place?

btrfs is the only place offloading writes from the per-cgroup writeback
to it's own not cgroup aware workqueues.

Offloading from one writeback thread to another threadpool to just
offload back to another thread to not deadlock is obviously not
an actual smart thing to do, and fortunately no one else is doing
this.

For btrfs it is on it's way out by not doing the offload just for
checksumming in a little bit, and even for compression the right fix
is just to allow more than one thread per device and cgroup.  I plan
to look into that, but there's plenty higher priority work right now.
