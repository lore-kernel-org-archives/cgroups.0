From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/14] dm: use bio_uninit instead of bio_disassociate_blkg
Date: Wed, 8 Jul 2020 10:02:54 -0400
Message-ID: <20200708140254.GA7539@redhat.com>
References: <20200627073159.2447325-1-hch@lst.de>
 <20200627073159.2447325-2-hch@lst.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594220663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cCfFQ9unhV8AALYAbnlDEYp86FEPgYE4PEBMEl3tJ+k=;
        b=CG4COg6xclwjEypPnhQtXV6DUNMAczbN/JgdbKn8fC7f6HCvgw8b8O0IOIKZV/+RNDcggb
        sRhQtnvWezBfEZYeZeljLHpPTjVJhcDGhfUNHXWsJWdSCZFdeq7kEUSuEIFf1anZ97CwKR
        m43qinSj3RxIaW8/PSWCZ50I8nUig0g=
Content-Disposition: inline
In-Reply-To: <20200627073159.2447325-2-hch-jcswGhMUV9g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Sat, Jun 27 2020 at  3:31am -0400,
Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:

> bio_uninit is the proper API to clean up a BIO that has been allocated
> on stack or inside a structure that doesn't come from the BIO allocator.
> Switch dm to use that instead of bio_disassociate_blkg, which really is
> an implementation detail.  Note that the bio_uninit calls are also moved
> to the two callers of __send_empty_flush, so that they better pair with
> the bio_init calls used to initialize them.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

I've picked this up as a fix for 5.8

Thanks,
Mike

