From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blkcg: handle dying request_queue when associating a blkg
Date: Wed, 12 Dec 2018 17:43:58 -0700
Message-ID: <217c7b15-d54a-b51d-8b1a-c2ad0d404721@kernel.dk>
References: <20181211230308.66276-1-dennis@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eGCL8CXk2DxsRI6RmIenE/gWHSpzzo3ICYl1Dkuy9FQ=;
        b=bT3XD8DTdeHNd1n7r1baIPUQ89GQKbMby4TiPYbrsR8kiaghg/YQFkWEgaHm+c2j9P
         1UlBC6u5KTkRSzIMxaI4/bTCiPyybRCDtR4h4F1NPUNNL21q6axIUJA8bVsJv7/hLPtL
         6IGHyRtjtkypXbam8yBKBp1wudltVrnCLUYqx2pWAFNP51kFRbgaFZm5dR5Ud64wBr4H
         F8vZlbH8atdbIjbB5oYO93hNDcMJtU96lpGvdkOpgzk6z062VLLiR9h2fbeZVgvt4fdd
         v25M1E6LcBI3mDeM6Sq5iG++4pXKEbNJfdUu0KAwhYxKQsp/d60f1PPPRUb6/IiUACCq
         ppig==
In-Reply-To: <20181211230308.66276-1-dennis@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>

On 12/11/18 4:03 PM, Dennis Zhou wrote:
> Between v3 [1] and v4 [2] of the blkg association series, the
> association point moved from generic_make_request_checks(), which is
> called after the request enters the queue, to bio_set_dev(), which is when
> the bio is formed before submit_bio(). When the request_queue goes away,
> the blkgs supporting the request_queue are destroyed and then the
> q->root_blkg is set to %NULL.
> 
> This patch adds a %NULL check to blkg_tryget_closest() to prevent the
> NPE caused by the above. It also adds a guard to see if the
> request_queue is dying when creating a blkg to prevent creating a blkg
> for a dead request_queue.

Applied, thanks Dennis.

-- 
Jens Axboe

