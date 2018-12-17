From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3] block: fix blk-iolatency accounting underflow
Date: Mon, 17 Dec 2018 09:09:01 -0700
Message-ID: <bd74dbe2-0f96-a2aa-043a-6f570c4ffb12@kernel.dk>
References: <20181217160351.27903-1-dennis@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BiDli7F0txU5ick/R2/Q+rEuWA8agdQj9UBE5AUcla4=;
        b=gMUxH25b/TACB7yGz5SXD6wx3k6GTCTt9raDAcc7w6WQ6yHpqh5at20LdcVO6VGdbF
         Q5RPTPPuMVIFxTfc+3UMNs9XyoVT9nSRR6RNd7rrdenQ4C/CRbAd5nTfLPMArd15fqeu
         XhgFlUrABIUwFhUwszTHhs2peFvTiOnjx+rL/SNyqE8XXmqkEnhdk+2Sd9Sox44USXhj
         v/RUTTZqfUVxd1bNEeuO3bhgGZirCoqUoUmRTSBfaPpfnWDH1jRJrivjZ2l30kwOgwXv
         LcmF4k5sMYA4wbkDC6FJ2v6xjVCk/0B8nlUgStL/+Ip2SwvM6sHwI5x3BtCx2QotBnqQ
         +bWg==
In-Reply-To: <20181217160351.27903-1-dennis@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 12/17/18 9:03 AM, Dennis Zhou wrote:
> The blk-iolatency controller measures the time from rq_qos_throttle() to
> rq_qos_done_bio() and attributes this time to the first bio that needs
> to create the request. This means if a bio is plug-mergeable or
> bio-mergeable, it gets to bypass the blk-iolatency controller.
> 
> The recent series [1], to tag all bios w/ blkgs undermined how iolatency
> was determining which bios it was charging and should process in
> rq_qos_done_bio(). Because all bios are being tagged, this caused the
> atomic_t for the struct rq_wait inflight count to underflow and result
> in a stall.
> 
> This patch adds a new flag BIO_TRACKED to let controllers know that a
> bio is going through the rq_qos path. blk-iolatency now checks if this
> flag is set to see if it should process the bio in rq_qos_done_bio().
> 
> Overloading BLK_QUEUE_ENTERED works, but makes the flag rules confusing.
> BIO_THROTTLED was another candidate, but the flag is set for all bios
> that have gone through blk-throttle code. Overloading a flag comes with
> the burden of making sure that when either implementation changes, a
> change in setting rules for one doesn't cause a bug in the other. So
> here, we unfortunately opt for adding a new flag.

I think this is better than (ab)using QUEUE_ENTERED, but this is an area
that needs some love and cleanup in the future.

-- 
Jens Axboe

