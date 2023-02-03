From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 07/19] blk-cgroup: store a gendisk to throttle in
 struct task_struct
Date: Fri, 3 Feb 2023 09:06:46 +0100
Message-ID: <20230203080646.GB28639@lst.de>
References: <20230201134123.2656505-1-hch@lst.de> <20230201134123.2656505-8-hch@lst.de> <Y9xSs0Gf8Qcr9R7w@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Y9xSs0Gf8Qcr9R7w-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>

On Thu, Feb 02, 2023 at 02:17:55PM -1000, Tejun Heo wrote:
> The change looks fine to me but can you please separate out the dead disk
> test change to its own patch and explain why?

I'll just drop it.  All these dead checks got added only accidentally
due to how blk_get_queues worked, and I'm really not interested enough
to discuss the fine details of it.
