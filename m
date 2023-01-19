From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH -next v3 1/3] blk-cgroup: dropping parent refcount
 after pd_free_fn() is done
Date: Thu, 19 Jan 2023 17:41:30 +0100
Message-ID: <20230119164130.GA3332@lst.de>
References: <20230119110350.2287325-1-yukuai1@huaweicloud.com> <20230119110350.2287325-2-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230119110350.2287325-2-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Looks good,

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
