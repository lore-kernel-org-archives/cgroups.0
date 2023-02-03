From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 03/19] blk-cgroup: improve error unwinding in blkg_alloc
Date: Fri, 3 Feb 2023 09:04:17 +0100
Message-ID: <20230203080417.GA28639@lst.de>
References: <20230201134123.2656505-1-hch@lst.de> <20230201134123.2656505-4-hch@lst.de> <Y9xQ33MtLhoxtPNv@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Y9xQ33MtLhoxtPNv-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Feb 02, 2023 at 02:10:07PM -1000, Tejun Heo wrote:
> This is fine but is this necessarily better? If it's needed for future
> changes, maybe that should be mentioned?

It avoids dealing with partially constructed blkgs outside of blkg_alloc,
which is mostly useful for code clarity.  It also micro-optimized the
free fast path a bit by avoiding two pointless (but mostly confusing)
branches.

I've updated the commit log a bit.
