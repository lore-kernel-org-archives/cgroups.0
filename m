From: Matthew Wilcox <willy@infradead.org>
Subject: Re: remove dead bdi congestion leftovers
Date: Wed, 1 Jul 2020 18:57:47 +0100
Message-ID: <20200701175747.GT25523@casper.infradead.org>
References: <20200701090622.3354860-1-hch@lst.de>
 <20200701164103.GC27063@redhat.com>
Mime-Version: 1.0
Return-path: <linux-raid-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8kyCo/WSMKeeAKesOT9xH1U/NJ4187Xum7g6Zpk6+6o=; b=DX6Up1hK4j7u/eeWojDc7hevxy
        wGh0015OTYtpoabI255K6NZIE64Z68TzDG4SOrA1F4dXHrGlMebBB/cJ5cpOAeT7pwK/2FiGw6Oh7
        Mv3iu5QVYvd1DBikfjYv8GgwwXuzPRSZHjb9pXA9sOk5jlD7M1H6dzDYNXNiFg6kQNok6+/IEOaqb
        FFt6dxn9U/NsxifskbHIrz81wgpRiFgOdRQExiNVWvSlB4WxBk9JsPGRtyvoOVIcxayMTbo6E8vFx
        Zpf76pAZIiQ3AFmVOtFpRG+DWmRX8meXqSAxeAujR83ovaWeyvcRks8ddXMT50N3+6Ei0mTWAXq8d
        QJ1taOjA==;
Content-Disposition: inline
In-Reply-To: <20200701164103.GC27063@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, linux-mm@kvack.org, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, drbd-dev@tron.linbit.com, dm-devel@redhat.com, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-btrfs@vger.kernel.org

On Wed, Jul 01, 2020 at 12:41:03PM -0400, Mike Snitzer wrote:
> On Wed, Jul 01 2020 at  5:06am -0400,
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > Hi Jens,
> > 
> > we have a lot of bdi congestion related code that is left around without
> > any use.  This series removes it in preparation of sorting out the bdi
> > lifetime rules properly.
> 
> I could do some git archeology to see what the fs, mm and block core
> changes were to stop using bdi congested but a pointer to associated
> changes (or quick recap) would save me some time.
> 
> Also, curious to know how back-pressure should be felt back up the IO
> stack now? (apologies if these are well worn topics, I haven't been
> tracking this area of development).

It isn't.  Jens declared the implementation was broken, and broke it
more.  So we're just living with stupid broken timeouts.
