From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -next v2 2/4] blk-throttle: fix wrong comparation while
 'carryover_ios/bytes' is negative
Date: Tue, 29 Aug 2023 12:18:44 -1000
Message-ID: <ZO5uxJSlHRxexZwk@slm.duckdns.org>
References: <20230816012708.1193747-1-yukuai1@huaweicloud.com>
 <20230816012708.1193747-3-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693347526; x=1693952326; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LT7SEszKRBMXUDd13cP5+4uGU9U+JYjqfeUfDZ3RsNQ=;
        b=JPfqk8f5jaQlxoxFPFpiH4aKLzDWZbfHu3TdXcY3byeE76PYwztTcQhtnIO0N63dpp
         Y4+OW8eGERKDKs1sCBjWAXscDPOdBF5D6mQuueasKk2XbaLfa0oq2UNMjwXXxT0Y/TAm
         3k9oVHme8uOdAb1mTXQ0Yycdq8DWguwpGWt0RTGIwwH1OK76fvUW8EO38UqKURsTcEPG
         B/BDarpKWfvoZWIXHnq/2oQsa+FL1Xinj02Mm8Tf4VLAay/g1EcxToOkkIPA7uRjSR9K
         D18/6MkvSsOfZEW8B56ZLmUDVWjf7iqxYasb62z3KGlyVdNkVD1tBwtKoRpCHmcrAT//
         AUbA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230816012708.1193747-3-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: josef@toxicpanda.com, axboe@kernel.dk, yukuai3@huawei.com, mkoutny@suse.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com

On Wed, Aug 16, 2023 at 09:27:06AM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> carryover_ios/bytes[] can be negative in the case that ios are
> dispatched in the slice in advance, and then configuration is updated.
> For example:
> 
> 1) set iops limit to 1000, and slice start is 0, slice end is 100ms;
> 2) current time is 0, and 100 ios are dispatched, those ios will not be
>    throttled, hence io_disp is 100;
> 3) still at current time 0, update iops limit to 100, then carryover_ios
>    is (0 - 100) = -100;
> 4) then, dispatch a new io at time 0, the expected result is that this
>    io will wait for 1s. The calculation in tg_within_iops_limit:
> 
>    io_disp = 0;
>    io_allowed = calculate_io_allowed + carryover_ios
> 	      = 10 + (-100) = -90;
>    io won't be throttled if (io_disp + 1 < io_allowed) passed.
> 
> Before this patch, in step 4) (io_disp + 1 < io_allowed) is passed,
> because -90 for unsigned value is very huge, and such io won't be
> throttled.
> 
> Fix this problem by checking if 'io/bytes_allowed' is negative first.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
