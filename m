From: Breno Leitao <leitao-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] blk-iocost: Pass disk queue to ioc_refresh_params
Date: Mon, 27 Feb 2023 14:52:15 +0000
Message-ID: <2e8c8937-b027-8b20-a16b-3dfed8217ad2@debian.org>
References: <20230227135610.501884-1-leitao@debian.org>
 <20230227140847.GA18644@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20230227140847.GA18644-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: leit-M8Ki61LpUEw@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, aherrmann-l3A5Bk7waGM@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leit-b10kYP2dOMg@public.gmane.org

Hello Christoph,

On 27/02/2023 14:08, Christoph Hellwig wrote:
> Hi Breno,
> 
> and sorry for the late reply.  This looks correct to me, but I'd
> be much happier if the disk was passed in instead of the request_queue
> as that's where we're generally heading.  If you don't have time to
> respin I could live with this version for a fix, though.

No worries, I can definitely do a respin passing the disk instead of
request_queue.

I hope to send a v3 in the next few hours.

