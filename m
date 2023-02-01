From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 05/15] blk-cgroup: store a gendisk to throttle in
 struct task_struct
Date: Wed, 1 Feb 2023 09:06:35 +0100
Message-ID: <20230201080635.GA8112@lst.de>
References: <20230124065716.152286-1-hch@lst.de> <20230124065716.152286-6-hch@lst.de> <Y9Rg0GuNAmJPlDri@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Y9Rg0GuNAmJPlDri-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>

On Fri, Jan 27, 2023 at 01:40:00PM -1000, Tejun Heo wrote:
> So, we're shifting the dead test from schedule to the actual throttle path,
> which makes sense but I think this should at least be mentioned in the
> description if not put in its own patch.

That's what I tried to say with:

"Move the check for the dead disk to the latest place now that is is
 unbundled from the reference grab."

what else would you want me to write?
