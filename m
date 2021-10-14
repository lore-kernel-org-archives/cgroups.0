From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [sparc64] kernel OOPS (was: [PATCH 4/5] block: move the bdi
 from the request_queue to the gendisk)
Date: Thu, 14 Oct 2021 16:32:43 +0200
Message-ID: <20211014143243.GA25700@lst.de>
References: <20210809141744.1203023-1-hch@lst.de> <20210809141744.1203023-5-hch@lst.de> <20211014143123.GA22126@u164.east.ru>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20211014143123.GA22126-DK4qA7C3Vp/Dd9xlW2Tctw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Anatoly Pugachev <matorola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Sparc kernel list <sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Anatoly,

please try this patchset:

https://lore.kernel.org/linux-block/CAHj4cs8tYY-ShH=QdrVirwXqX4Uze6ewZAGew_oRKLL_CCLNJg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/T/#m6591be7882bf30f3538a8baafbac1712f0763ebb


