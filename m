From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC - TAKE TWO - 00/12] New version of the BFQ I/O
	Scheduler
Date: Wed, 4 Jun 2014 10:50:53 -0400
Message-ID: <20140604145053.GE5004@htj.dyndns.org>
References: <538926F6.7080409@kernel.dk>
	<20140531051635.GA19925@mtj.dyndns.org>
	<538C8A47.1050502@kernel.dk> <20140602172454.GA8912@htj.dyndns.org>
	<538CB515.3090700@kernel.dk> <20140602174250.GC8912@htj.dyndns.org>
	<538CB87C.7030600@kernel.dk> <20140602185138.GD8912@htj.dyndns.org>
	<20140602205713.GB8357@kernel.dk>
	<20140604143136.GA1920@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=r9PqSW814HxW/YKzWmx3hl1nRTqCD5qIR4oQUSnhVfE=;
	b=puDV1L9zpDGJ4/9EuO7tjSY4D5RTf8aNrwn/M6Pv0z5z3SNih68P7qmbq5yt+gM3HW
	Q23vBfTLVTg1xkY6xs/ZK0mnPrOtcvk7YwM1h4jfpQFM/AIGC0gd5J7HNcFQ2kAp8PWG
	mCSfuWSxCce3vpz+CFESMt6lnFQt3Ko06x/HLf2mr15bI5VHHkndUV3AllsJ9AGZPaxs
	PKBInLYdeytMW/i+X/gSSg3eRdz/lJPifTZnIbyHWe5eeMTur7ylwW1x3EhMG49ragOB
	opnr1gtpoD/cHT6DOdjLjfNooFDoKrda/O4dOYkYvA56Nen4cJ92jvEKYyBApoIUkflF
	RUoA==
Content-Disposition: inline
In-Reply-To: <20140604143136.GA1920-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Paolo Valente <paolo.valente-rcYM44yAMweonA0d6jMUrA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Fabio Checconi <fchecconi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paolo Valente <posta_paolo-whZMOeQn8C0@public.gmane.org>

Hey, Christoph.

On Wed, Jun 04, 2014 at 07:31:36AM -0700, Christoph Hellwig wrote:
> I don't really think there's anything inherently counter productive
> to spinning rust (at least for somewhat modern spinning rust and
> infrastructure) in blk-mq.  I'd really like to get rid of the old
> request layer in a reasonable amount of time, and for SCSI I'm very
> reluctant to add more integration between the old and new code.  I'd
> really planning on not maintaining the old request based SCSI code
> for a long time once we get positive reports in from users of various
> kinds of older hardware.

Hmmm... the biggest thing is ioscheds.  They heavily rely on being
strongly synchronized and are pretty important for rotating rusts.
Maybe they can be made to work with blk-mq by forcing single queue or
something but do we wnat that?

Thanks.

-- 
tejun
