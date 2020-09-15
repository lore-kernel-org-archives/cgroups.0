From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: Re: [PATCH 0/5] Some improvements for blk-throttle
Date: Tue, 15 Sep 2020 16:59:26 +0800
Message-ID: <20200915085926.GA122937@VM20190228-100.tbsite.net>
References: <cover.1599458244.git.baolin.wang@linux.alibaba.com>
 <822998a7-4cc7-88ee-8b3f-e8e7660a5b0a@kernel.dk>
Reply-To: Baolin Wang <baolin.wang@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <822998a7-4cc7-88ee-8b3f-e8e7660a5b0a@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: tj@kernel.org, baolin.wang7@gmail.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Jens,

On Mon, Sep 14, 2020 at 07:37:53PM -0600, Jens Axboe wrote:
> On 9/7/20 2:10 AM, Baolin Wang wrote:
> > Hi All,
> > 
> > This patch set did some clean-ups, as well as removing some unnecessary
> > bps/iops limitation calculation when checking if can dispatch a bio or
> > not for a tg. Please help to review. Thanks.
> > 
> > Baolin Wang (5):
> >   blk-throttle: Fix some comments' typos
> >   blk-throttle: Use readable READ/WRITE macros
> >   blk-throttle: Define readable macros instead of static variables
> >   blk-throttle: Avoid calculating bps/iops limitation repeatedly
> >   blk-throttle: Avoid checking bps/iops limitation if bps or iops is    
> >     unlimited
> > 
> >  block/blk-throttle.c | 59 ++++++++++++++++++++++++++++++++--------------------
> >  1 file changed, 36 insertions(+), 23 deletions(-)
> 
> Looks reasonable to me, I've applied it.

Thanks.

> 
> Out of curiosity, are you using blk-throttle in production, or are these
> just fixes/cleanups that you came across?

Yes, we're using it in some old products, and I am trying to do some
cleanups and optimizaiton when testing it.

