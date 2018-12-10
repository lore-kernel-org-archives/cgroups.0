From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: fix iolat timestamp and restore accounting
 semantics
Date: Mon, 10 Dec 2018 09:58:13 -0700
Message-ID: <f698e396-2577-b0d9-e300-f65d4f062986@kernel.dk>
References: <20181210163510.58985-1-dennis@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kJ0Uh/sz9+ZfwHuRQutOjBLD6AcNatJC4J4LKf97Spw=;
        b=ootPNiaXJohTA5J3F8DAZAYMKokXrJm+GhTQrrlKJNHsQFKjr6fJ3lC6DyiQKJSVVc
         qPRVJmV6ckg/V45QIigFJe2TXPw40fKYI0zn1sCwPG9CsLc2lXIDW8HY9sA5hhn2xmUR
         W9n5f/wlrB8fcdfl4cMqkZF55VFrEAWG++nA/haOxg42h3V00jxV7cUQ9tWK2SbSebf0
         OfW2FlgydOCVhXSLyuK7LbLeT1dYdrLzI/xmPvid4sEuDxEtyJQa89J70D+v8NP/ovZo
         H036TJOvPRmOeC4cR3ryggXUYGeDXAVCG1ng8AO8Nq9Yk78iR9Y1qccOn2Q93Dnz+jA5
         HOAA==
In-Reply-To: <20181210163510.58985-1-dennis@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 12/10/18 9:35 AM, Dennis Zhou wrote:
> The blk-iolatency controller measures the time from rq_qos_throttle() to
> rq_qos_done_bio() and attributes this time to the first bio that needs
> to create the request. This means if a bio is plug-mergeable or
> bio-mergeable, it gets to bypass the blk-iolatency controller.
> 
> The recent series, to tag all bios w/ blkgs in [1] changed the timing
> incorrectly as well. First, the iolatency controller was tagging bios
> and using that information if it should process it in rq_qos_done_bio().
> However, now that all bios are tagged, this caused the atomic_t for the
> struct rq_wait inflight count to underflow resulting in a stall. Second,
> now the timing was using the duration a bio from generic_make_request()
> rather than the timing mentioned above.
> 
> This patch fixes the errors by accounting time separately in a bio
> adding the field bi_start. If this field is set, the bio should be
> processed by blk-iolatency in rq_qos_done_bio().
> 
> [1] https://lore.kernel.org/lkml/20181205171039.73066-1-dennis@kernel.org/

Looks reasonable to me, but it needs a Fixes tag as well.

-- 
Jens Axboe

