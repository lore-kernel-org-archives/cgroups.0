From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] blk-iocost: Pass disk queue to ioc_refresh_params
Date: Mon, 27 Feb 2023 15:08:47 +0100
Message-ID: <20230227140847.GA18644@lst.de>
References: <20230227135610.501884-1-leitao@debian.org>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20230227135610.501884-1-leitao@debian.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Breno Leitao <leitao@debian.org>
Cc: axboe@kernel.dk, tj@kernel.org, josef@toxicpanda.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, aherrmann@suse.de, mkoutny@suse.com, linux-kernel@vger.kernel.org, hch@lst.de, leit@fb.com

Hi Breno,

and sorry for the late reply.  This looks correct to me, but I'd
be much happier if the disk was passed in instead of the request_queue
as that's where we're generally heading.  If you don't have time to
respin I could live with this version for a fix, though.
