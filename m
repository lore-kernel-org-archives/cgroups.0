From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH-block] blk-cgroup: Use css_tryget() in
 blkcg_destroy_blkgs()
Date: Mon, 28 Nov 2022 21:11:35 +0200
Message-ID: <Y4UH56EZfcDyXuti@smile.fi.intel.com>
References: <20221128033057.1279383-1-longman@redhat.com>
 <d08a0059-7c0b-d65f-d184-5b0cb75c08ed@acm.org>
 <f89e922c-16d5-0bcf-7e7e-096f42793a36@kernel.dk>
 <Y4UG9H9QsMnCvN+D@smile.fi.intel.com>
 <0390c62d-11d9-5d89-ad88-db38526b74e6@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669662702; x=1701198702;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=nGzO+QrVInugh0e/lwUYUkj404LL7Ug3B9XyONtYbvY=;
  b=BQ950FFp2EksAiS9v62y3UPX1QZYebbBRjvvkL0OVByvk5WtgRPNhIZy
   en9IgztIzjaC80l5m1rfUUHhrwyj0Y5HuCM7zdDBfTPirkHFsl9BvbI1f
   YyO/SnBz3g2eb70AB02qXpraHM0UFks20SH4ed52HXP/6J5Y7VCxtPvH2
   h7swF8vzFXJ4HaTSqsee6907vVnwTD9MOX7qL6U5czxZ6ORx6edKXuuHG
   TNKYWLZ78E0cMX1wfKLbahcsk3F3GjaKpERR6I++51LR07RnC9WGpfCvK
   Zs1/QGRIbcmw4v2h3rS/dfJF+kkqGjuY0QFDanM2gF3918O4pLyrCuP7e
   Q==;
Content-Disposition: inline
In-Reply-To: <0390c62d-11d9-5d89-ad88-db38526b74e6@kernel.dk>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>, Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Hillf Danton <hdanton@sina.com>, Yi Zhang <yi.zhang@redhat.com>

On Mon, Nov 28, 2022 at 12:08:47PM -0700, Jens Axboe wrote:
> On 11/28/22 12:07 PM, Andy Shevchenko wrote:
> > On Mon, Nov 28, 2022 at 12:00:55PM -0700, Jens Axboe wrote:
> >> On 11/28/22 11:56 AM, Bart Van Assche wrote:
> >>> On 11/27/22 19:30, Waiman Long wrote:
> >>>> Fixes: 951d1e94801f ("blk-cgroup: Flush stats at blkgs destruction path")
> >>>
> >>> Has Jens' for-next branch perhaps been rebased? I see the following commit ID for that patch:
> >>>
> >>> dae590a6c96c ("blk-cgroup: Flush stats at blkgs destruction path")
> >>
> >> I don't know that sha is from, not from me. for-6.2/block has not been
> >> rebased, for-next gets rebased whenever I need to do so as linux-next is
> >> continually rebased anyway. But the sha for that commit would not change
> >> as a result.
> >>
> >> I don't even have that sha in my tree, so...
> > 
> > $ git tag --contains dae590a6c96c
> > next-20221117
> > next-20221118
> > next-20221121
> > next-20221122
> > next-20221123
> > next-20221124
> > next-20221125
> > next-20221128
> 
> That is the right sha, I'm talking about the fixes line in the
> patch you're replying to:
> 
> Fixes: 951d1e94801f ("blk-cgroup: Flush stats at blkgs destruction path")
> 
> which is certainly not from my tree.

Ah, I see. That one is local / wrong. I don't see it either.

-- 
With Best Regards,
Andy Shevchenko


