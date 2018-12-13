From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2] block: fix iolat timestamp and restore accounting
 semantics
Date: Thu, 13 Dec 2018 12:59:03 -0700
Message-ID: <cbf1ca87-6a47-6c98-0c41-5cf495d6508b@kernel.dk>
References: <20181211230114.65967-1-dennis@kernel.org>
 <59500829-10f5-fa83-b2db-fcfa4a1cd11d@kernel.dk>
 <20181213195208.qgvfeb5ilbf3ttsf@MacBook-Pro-91.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9HwpeAASKDoLDycZu15Kfrt0tmVJZsz205csfagvOvA=;
        b=geZHGCDbgfLinIkbNb/845U5nz2zHshC+5XD62FCn9wqH7jasLCgvWT1ef6Mr9ZhYo
         scMP/6d/l6T2uz19pF395AmlNc8EJYmdflBe9okVZGBHXmjVdPAbb22Yf3I1zoAOSe82
         U2Q5HxQV7oOVPEFI95aHF3osdFdYL4deyB06ljjNyiWqY+jITFGo+gDKliW4RXeLytBs
         H+28YeHddtTW7s6xsWTBhTJtUhItRK2LHl0/bGzJ6yGDNisoJbzUfJsaqMMENW8DJ92e
         fAAsO3X57jFXcgXFkp0cQMBSZ/XTFvVyIaaDc0UNm8hizr6JyjplEfCxmR46tXBXK6Kg
         zWmw==
In-Reply-To: <20181213195208.qgvfeb5ilbf3ttsf@MacBook-Pro-91.local>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Josef Bacik <josef@toxicpanda.com>
Cc: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 12/13/18 12:52 PM, Josef Bacik wrote:
> On Thu, Dec 13, 2018 at 12:48:11PM -0700, Jens Axboe wrote:
>> On 12/11/18 4:01 PM, Dennis Zhou wrote:
>>> The blk-iolatency controller measures the time from
>>> rq_qos_throttle() to rq_qos_done_bio() and attributes this time to
>>> the first bio that needs to create the request. This means if a bio
>>> is plug-mergeable or bio-mergeable, it gets to bypass the
>>> blk-iolatency controller.
>>>
>>> The recent series, to tag all bios w/ blkgs in [1] changed the
>>> timing incorrectly as well. First, the iolatency controller was
>>> tagging bios and using that information if it should process it in
>>> rq_qos_done_bio().  However, now that all bios are tagged, this
>>> caused the atomic_t for the struct rq_wait inflight count to
>>> underflow resulting in a stall. Second, now the timing was using the
>>> duration a bio from generic_make_request() rather than the timing
>>> mentioned above.
>>>
>>> This patch fixes these issues by reusing the BLK_QUEUE_ENTERED flag
>>> to determine if a bio has entered the request layer and is
>>> responsible for starting a request. Stacked drivers don't recurse
>>> through blk_mq_make_request(), so the overhead of using time between
>>> generic_make_request() and the blk_mq_get_request() should be
>>> minimal.  blk-iolatency now checks if this flag is set to determine
>>> if it should process the bio in rq_qos_done_bio().
>>
>> I'm having a hard time convincing myself that this is correct...
>> Maybe we should just add a new flag for this specific use case? Or
>> feel free to convince me otherwise.
>>
> 
> I mean it'll work for now, but then when somebody else wants to do
> something similar *cough*io.weight*cough* it'll need a new flag.  I
> kind of hate adding a new flag for every controller, but then again
> it's not like there's thousands of these things.  I'm having a hard
> time coming up with a solution other than a per-tracker flag.  As for
> this specific version, I still think it needs to be in iolatency
> itself, trying to make it generic just means it'll get fucked up again
> later down the line.  Thanks,

We definitely don't have that many flags, and I'd hate to add a
per-whatever flag for this.

But do we need that? We really just need single flag for this, my main
worry was overloading ENTERED. Especially since we're adding different
clearing and setting for it. If we had a specific one, if it's set, we
would need to disallow merging for it, I guess.

And there's already BIO_THROTTLED...

-- 
Jens Axboe

