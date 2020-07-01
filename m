From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: remove dead bdi congestion leftovers
Date: Wed, 1 Jul 2020 12:41:03 -0400
Message-ID: <20200701164103.GC27063@redhat.com>
References: <20200701090622.3354860-1-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593625350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wobg33Jd/mLzwVfLH+qw23dgCxhuXQvI8VYke7pyLt8=;
        b=PRzGm0c1rXHn/qNPwxz/BOJMt7y0gIewcLkBsWBqyFh+ZhrfeT4OdmF/uqhRBsVkWONTXs
        WFtWmz2gCvv/yKDpLSnvO3j9WDn3F88E3QTb3vYEnYzKPzLaX549IFdRzjL4W3KVU02zv6
        ewD8hmWoWOegpYL1OkU8S+scBAy/RDw=
Content-Disposition: inline
In-Reply-To: <20200701090622.3354860-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, linux-mm@kvack.org, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, drbd-dev@tron.linbit.com, dm-devel@redhat.com, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-btrfs@vger.kernel.org

On Wed, Jul 01 2020 at  5:06am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Hi Jens,
> 
> we have a lot of bdi congestion related code that is left around without
> any use.  This series removes it in preparation of sorting out the bdi
> lifetime rules properly.

I could do some git archeology to see what the fs, mm and block core
changes were to stop using bdi congested but a pointer to associated
changes (or quick recap) would save me some time.

Also, curious to know how back-pressure should be felt back up the IO
stack now? (apologies if these are well worn topics, I haven't been
tracking this area of development).

Thanks,
Mike

