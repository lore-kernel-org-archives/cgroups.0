From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 01/15] blk-cgroup: don't defer blkg_free to a workqueue
Date: Fri, 27 Jan 2023 08:07:54 +0100
Message-ID: <20230127070754.GB4180@lst.de>
References: <20230117081257.3089859-1-hch@lst.de> <20230117081257.3089859-2-hch@lst.de> <b4622942-67e7-969b-4439-0aea7c5bd165@suse.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b4622942-67e7-969b-4439-0aea7c5bd165-l3A5Bk7waGM@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jan 27, 2023 at 07:59:23AM +0100, Hannes Reinecke wrote:
> On 1/17/23 09:12, Christoph Hellwig wrote:
>> Now that blk_put_queue can be called from process context, ther is no
>> need for the asynchronous execution.
>>
> Can you clarify 'now'?
> IE point to the commit introducing the change?

49e4d04f0486117ac57a97890eb1db6d52bf82b3
Author: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date:   Fri Jan 6 10:34:10 2023 -1000

    block: Drop spurious might_sleep() from blk_put_queue()

