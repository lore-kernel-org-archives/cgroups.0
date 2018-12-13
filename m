From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v2] block: fix iolat timestamp and restore accounting
 semantics
Date: Thu, 13 Dec 2018 15:03:59 -0500
Message-ID: <20181213200358.e5zxe4tacrwylg32@MacBook-Pro-91.local>
References: <20181211230114.65967-1-dennis@kernel.org>
 <59500829-10f5-fa83-b2db-fcfa4a1cd11d@kernel.dk>
 <20181213195208.qgvfeb5ilbf3ttsf@MacBook-Pro-91.local>
 <cbf1ca87-6a47-6c98-0c41-5cf495d6508b@kernel.dk>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LsQvDYNVvVMADQnhj4E0GjqXnzhDyYwi5QAqBPP7YcU=;
        b=TKPU2U4hFtZTybA1n01ULvZDtRuf0PkZYMFN6SZyRsIShTGwulSIaV3NM3yI7QlZEL
         Dpxsra1UpGYtHGvnVpPMLEFPL6bHrsSRUeSSn4qn+OcoKJeNmtXnEYET9BbCIT1toB1V
         RdOk5HhiAkkmgcrdUNFm1JKRyf/q1BaoGm5CUCYL0DkXPJoCCG1BLS6olrjnYRQBbZI1
         Ey2GSqtjBRcyzhTC4oas8IO9PUZrGTVzQ3nSwAvfvNMOYSfiJ7TQz5z48UBVy2+tQoYr
         k1IRnw5GBn4nI1PWKu5YQwqscpfXkJHR9by6CgPDnAEyiAvYRMxquS/3txzUJ+3K7zMs
         X8Sw==
Content-Disposition: inline
In-Reply-To: <cbf1ca87-6a47-6c98-0c41-5cf495d6508b@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <josef@toxicpanda.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Dec 13, 2018 at 12:59:03PM -0700, Jens Axboe wrote:
> On 12/13/18 12:52 PM, Josef Bacik wrote:
> > On Thu, Dec 13, 2018 at 12:48:11PM -0700, Jens Axboe wrote:
> >> On 12/11/18 4:01 PM, Dennis Zhou wrote:
> >>> The blk-iolatency controller measures the time from
> >>> rq_qos_throttle() to rq_qos_done_bio() and attributes this time to
> >>> the first bio that needs to create the request. This means if a bio
> >>> is plug-mergeable or bio-mergeable, it gets to bypass the
> >>> blk-iolatency controller.
> >>>
> >>> The recent series, to tag all bios w/ blkgs in [1] changed the
> >>> timing incorrectly as well. First, the iolatency controller was
> >>> tagging bios and using that information if it should process it in
> >>> rq_qos_done_bio().  However, now that all bios are tagged, this
> >>> caused the atomic_t for the struct rq_wait inflight count to
> >>> underflow resulting in a stall. Second, now the timing was using the
> >>> duration a bio from generic_make_request() rather than the timing
> >>> mentioned above.
> >>>
> >>> This patch fixes these issues by reusing the BLK_QUEUE_ENTERED flag
> >>> to determine if a bio has entered the request layer and is
> >>> responsible for starting a request. Stacked drivers don't recurse
> >>> through blk_mq_make_request(), so the overhead of using time between
> >>> generic_make_request() and the blk_mq_get_request() should be
> >>> minimal.  blk-iolatency now checks if this flag is set to determine
> >>> if it should process the bio in rq_qos_done_bio().
> >>
> >> I'm having a hard time convincing myself that this is correct...
> >> Maybe we should just add a new flag for this specific use case? Or
> >> feel free to convince me otherwise.
> >>
> > 
> > I mean it'll work for now, but then when somebody else wants to do
> > something similar *cough*io.weight*cough* it'll need a new flag.  I
> > kind of hate adding a new flag for every controller, but then again
> > it's not like there's thousands of these things.  I'm having a hard
> > time coming up with a solution other than a per-tracker flag.  As for
> > this specific version, I still think it needs to be in iolatency
> > itself, trying to make it generic just means it'll get fucked up again
> > later down the line.  Thanks,
> 
> We definitely don't have that many flags, and I'd hate to add a
> per-whatever flag for this.
> 
> But do we need that? We really just need single flag for this, my main
> worry was overloading ENTERED. Especially since we're adding different
> clearing and setting for it. If we had a specific one, if it's set, we
> would need to disallow merging for it, I guess.
> 
> And there's already BIO_THROTTLED...
> 

Oh well I guess we only really want to know if we saw the BIO, which should be
able to be shared by all the rq_qos implementations.  I think I'd rather just
have a BIO_TRACKED to indicate it went through the normal rq_qos path.  Thanks,

Josef
