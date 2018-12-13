From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v2] block: fix iolat timestamp and restore accounting
 semantics
Date: Thu, 13 Dec 2018 14:52:09 -0500
Message-ID: <20181213195208.qgvfeb5ilbf3ttsf@MacBook-Pro-91.local>
References: <20181211230114.65967-1-dennis@kernel.org>
 <59500829-10f5-fa83-b2db-fcfa4a1cd11d@kernel.dk>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wG32gjmYR+a6LxqRxyUJWOp8mEIFyeCoi+kK4CZX3lI=;
        b=xeC6aVZvumVToIPgil8TGwOsN4gaAa9Y9qVaKadLoI7wlG/JBeTj4R6fOpqIB8ji0k
         EY1K40aDMqGQCHizT3YSF+RcWA6oMxCgFdni9RbgF6KuExXuFprkRkc/jbj9SFi/L8yw
         rYvqn1HHNRtftSIW4FzJYWr4vbi2Fje+yiljImbMfSfxhV/2qVWjsNdLQvb7uwCri4wB
         zacNQ9OTyB6rJIqIi1Z9/db7bDLRVFac+fWF8qv2NRtcC4Fy9LV/bJNNVKBx0mLVsQEL
         dKyMRA7jp6xjssBSCCLUwNPBQSXI2iBefF3jv3gQ+atP45R/7RLu92Olt56ar2CfY/Hi
         mxWg==
Content-Disposition: inline
In-Reply-To: <59500829-10f5-fa83-b2db-fcfa4a1cd11d@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Dec 13, 2018 at 12:48:11PM -0700, Jens Axboe wrote:
> On 12/11/18 4:01 PM, Dennis Zhou wrote:
> > The blk-iolatency controller measures the time from rq_qos_throttle() to
> > rq_qos_done_bio() and attributes this time to the first bio that needs
> > to create the request. This means if a bio is plug-mergeable or
> > bio-mergeable, it gets to bypass the blk-iolatency controller.
> > 
> > The recent series, to tag all bios w/ blkgs in [1] changed the timing
> > incorrectly as well. First, the iolatency controller was tagging bios
> > and using that information if it should process it in rq_qos_done_bio().
> > However, now that all bios are tagged, this caused the atomic_t for the
> > struct rq_wait inflight count to underflow resulting in a stall. Second,
> > now the timing was using the duration a bio from generic_make_request()
> > rather than the timing mentioned above.
> > 
> > This patch fixes these issues by reusing the BLK_QUEUE_ENTERED flag to
> > determine if a bio has entered the request layer and is responsible for
> > starting a request. Stacked drivers don't recurse through
> > blk_mq_make_request(), so the overhead of using time between
> > generic_make_request() and the blk_mq_get_request() should be minimal.
> > blk-iolatency now checks if this flag is set to determine if it should
> > process the bio in rq_qos_done_bio().
> 
> I'm having a hard time convincing myself that this is correct... Maybe
> we should just add a new flag for this specific use case? Or feel free
> to convince me otherwise.
>

I mean it'll work for now, but then when somebody else wants to do something
similar *cough*io.weight*cough* it'll need a new flag.  I kind of hate adding a
new flag for every controller, but then again it's not like there's thousands of
these things.  I'm having a hard time coming up with a solution other than a
per-tracker flag.  As for this specific version, I still think it needs to be in
iolatency itself, trying to make it generic just means it'll get fucked up again
later down the line.  Thanks,

Josef 
