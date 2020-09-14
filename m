From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: Re: [PATCH 0/5] Some improvements for blk-throttle
Date: Mon, 14 Sep 2020 13:32:00 +0800
Message-ID: <20200914053200.GA128318@VM20190228-100.tbsite.net>
References: <cover.1599458244.git.baolin.wang@linux.alibaba.com>
Reply-To: Baolin Wang <baolin.wang@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1599458244.git.baolin.wang@linux.alibaba.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, axboe@kernel.dk
Cc: baolin.wang7@gmail.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Tejun and Jens,

On Mon, Sep 07, 2020 at 04:10:12PM +0800, Baolin Wang wrote:
> Hi All,
> 
> This patch set did some clean-ups, as well as removing some unnecessary
> bps/iops limitation calculation when checking if can dispatch a bio or
> not for a tg. Please help to review. Thanks.

Any comments for this patch set?

> 
> Baolin Wang (5):
>   blk-throttle: Fix some comments' typos
>   blk-throttle: Use readable READ/WRITE macros
>   blk-throttle: Define readable macros instead of static variables
>   blk-throttle: Avoid calculating bps/iops limitation repeatedly
>   blk-throttle: Avoid checking bps/iops limitation if bps or iops is    
>     unlimited
> 
>  block/blk-throttle.c | 59 ++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 36 insertions(+), 23 deletions(-)
> 
> -- 
> 1.8.3.1
