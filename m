From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH -next v5 4/8] blk-throttle: fix io hung due to config
 updates
Date: Thu, 23 Jun 2022 18:26:20 +0200
Message-ID: <20220623162620.GB16004@blackbody.suse.cz>
References: <20220528064330.3471000-1-yukuai3@huawei.com>
 <20220528064330.3471000-5-yukuai3@huawei.com>
 <20220622172621.GA28246@blackbody.suse.cz>
 <f5165488-2461-8946-593f-14154e404850@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1656001582; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BfdpS31BTnx0upscG9ltmSRSibzpIJMh1VIKXZtFzy8=;
        b=LufHh/PdbNvvhLTzX1RWsvnJuM3y52l0dG9D43ioTReJGZFKFYUG8gZr79KxgrXTi8h0Ja
        kjyYipDKbiTR3dQZjA2un27ED1YROrmJUCX2pHkcRRpIFenPpA2klysDHKFknPxpHr7ke0
        Q99rJXpqTNuxDeCSsIfc/Wvik9/VqqM=
Content-Disposition: inline
In-Reply-To: <f5165488-2461-8946-593f-14154e404850@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3@huawei.com>
Cc: tj@kernel.org, axboe@kernel.dk, ming.lei@redhat.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

On Thu, Jun 23, 2022 at 08:27:11PM +0800, Yu Kuai <yukuai3@huawei.com> wrote:
> > Here we may allow to dispatch a bio above current slice's
> > calculate_bytes_allowed() if bytes_skipped is already >0.
> 
> Hi, I don't expect that to happen. For example, if a bio is still
> throttled, then old slice is keeped with proper 'bytes_skipped',
> then new wait time is caculated based on (bio_size - bytes_skipped).
> 
> After the bio is dispatched(I assum that other bios can't preempt),

With this assumptions it adds up as you write. I believe we're in
agreement.

It's the same assumption I made below (FIFO everywhere, i.e. no
reordering). So the discussed difference shouldn't really be negative
(and if the assumption didn't hold, so the modular arithmetic yields
corerct bytes_skipped value).

Michal
