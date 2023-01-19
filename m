From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: switch blk-cgroup to work on gendisk
Date: Thu, 19 Jan 2023 18:05:26 +0100
Message-ID: <20230119170526.GA5050@lst.de>
References: <20230117081257.3089859-1-hch@lst.de> <Y8l34/qeHPLV4rKJ@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Y8l34/qeHPLV4rKJ-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jan 19, 2023 at 07:03:31AM -1000, Tejun Heo wrote:
> On Tue, Jan 17, 2023 at 09:12:42AM +0100, Christoph Hellwig wrote:
> > blk-cgroup works on only on live disks and "file system" I/O from bios.
> > This all the information should be in the gendisk, and not the
> > request_queue that also exists for pure passthrough request based
> > devices.
> 
> Can't blk-throttle be used w/ bio based ones tho? I always thought that was
> the reason why we didn't move it into rq-qos framework.

Yes, it can.  Not sure if my sentence was unclear, but:

 - everything doing non-passthrough I/O only should be in the gendisk
 - everything related to blk-mq, including infrastruture for passthrough
   should remain in the request_queue

The idea that the request_queue will eventually become a blk-mq only
data structure and not exist (or just have a very leight weight stub)
for bio based drivers.
