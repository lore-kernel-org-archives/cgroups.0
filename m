From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2] block: fix iolat timestamp and restore accounting
 semantics
Date: Thu, 13 Dec 2018 12:48:11 -0700
Message-ID: <59500829-10f5-fa83-b2db-fcfa4a1cd11d@kernel.dk>
References: <20181211230114.65967-1-dennis@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vO0PVlC/h/TD8mOKDcNOZghona65qVLNu9TgC87CmsI=;
        b=0d8wMK6WrqJrVzfELihclsJcuETB5BnN3+Arx/NlwWZIkj/puRhien7VXSOJzfYbZk
         7765Fzp6yB+Pcn2BhLUD4zsM397yly3SvQFucCDiwr30DMMJEtdbWQ7Xq9J5YLhyNKq5
         BcW1CX4L7b2SZdQ9OWMjBeOn7x+H0VCgI5uAIl8++xgHeqsSLgwvMqdPblGq1s+I6YLc
         Y5uqbp6wzckfuuypl4tdT0jU71CFgFMGzfzdHXdehhODUwGOh+0yD1YFRzanLF03kmJP
         72XnekOd/HSkK+LrkmfKsgbkzWbpuqOnRoMAH+tgC4slWNZbCYI+0sVUhPrnkfk166F4
         LYQA==
In-Reply-To: <20181211230114.65967-1-dennis@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 12/11/18 4:01 PM, Dennis Zhou wrote:
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
> This patch fixes these issues by reusing the BLK_QUEUE_ENTERED flag to
> determine if a bio has entered the request layer and is responsible for
> starting a request. Stacked drivers don't recurse through
> blk_mq_make_request(), so the overhead of using time between
> generic_make_request() and the blk_mq_get_request() should be minimal.
> blk-iolatency now checks if this flag is set to determine if it should
> process the bio in rq_qos_done_bio().

I'm having a hard time convincing myself that this is correct... Maybe
we should just add a new flag for this specific use case? Or feel free
to convince me otherwise.

-- 
Jens Axboe

