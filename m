From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 09/19] io_uring: convert to use vm_account
Date: Tue, 7 Feb 2023 10:55:48 -0400
Message-ID: <Y+JmdMJhPEGN0Zw+@nvidia.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
 <44e6ead48bc53789191b22b0e140aeb82459e75f.1675669136.git-series.apopple@nvidia.com>
 <52d41a7e-1407-e74f-9206-6dd583b7b6b5@kernel.dk>
 <87k00unusm.fsf@nvidia.com>
 <eff3cc48-7279-2fbf-fdbd-f35eff2124d0@kernel.dk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AaOLENurDLVnSrw9Yc9XhqQx5R/WT/mqqywhrEJHFYs=;
 b=cW3mr57zpmCOyfnsv4+t8Bc6KGhWTLkl5Y+K7yPicWsJ65N55CS5eTA3bKY2IP7sezTgcZyOhpd6KbY6t5ZzciFSN48VX3ReQAzKf2LY1zlDCbRK2QiDCOXTehdwOpwbBEpWLNKuBaGegJTJLCFQWciT9P0she8WQavTfod6f/VsJQZdHJ61PspI5IJ32cq1L3gc22HRqTQ9Y5G5uyf04Ao5egF2V2MNaK6mUnlrqrcfYg2LJtCNwIIrDvgS6PrNODQUFuZ7xZjm70zmCp8ln12+2bpQZ58btQBS4GeVM11CDJ4LoAN47ty/Kh3ubYSOw/vz+QI7PKQy+f7GaPQhkw==
Content-Disposition: inline
In-Reply-To: <eff3cc48-7279-2fbf-fdbd-f35eff2124d0-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Feb 07, 2023 at 07:28:56AM -0700, Jens Axboe wrote:

> Outside of that, we're now doubling the amount of memory associated with
> tracking this. That isn't necessarily a showstopper, but it is not
> ideal. I didn't take a look at the other conversions (again, because
> they were not sent to me), but seems like the task_struct and flags
> could just be passed in as they may very well be known to many/most
> callers?

For places doing the mm accounting type it cannot use the task struct
as the underlying mm can be replaced and keep the task, IIRC.

We just had a bug in VFIO related to this..

If we could go back from the mm to the task (even a from a destroyed
mm though) that might work to reduce storage?

Jason

