From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 0/3] block, bfq: minor cleanup and fix
Date: Fri, 14 Jan 2022 10:59:50 +0100
Message-ID: <20220114095950.fa3gofecmryztivs@quack3.lan>
References: <20211231032354.793092-1-yukuai3@huawei.com>
 <5696c767-8248-09a4-f04e-ac93138d30ef@huawei.com>
 <1cdb99ba-ed52-c755-fec4-86ee5f9bc61d@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1642154391; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qmwbDXCD1IYxhc8Rn4/92BZfIPK0fFdxSVgthJ5taA4=;
        b=J4BVfOXcoK+w1RCl2Zw4sZxvBV7m3oaac6fwGpQXId2pL+KIV+ughVxTxQ2zeit4y/cv0k
        6RGNq6gHnAVqsCAHjqgmOfRRuSumWxuEWMrajJ5Rh7hvcmCILmaG2n+qCTD+0gJruobjkP
        Jje0H/AIsgcT22TnebB7nLPWxCJtEaM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1642154391;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qmwbDXCD1IYxhc8Rn4/92BZfIPK0fFdxSVgthJ5taA4=;
        b=puAmxENJ+nE7lagW0XsW5t1PTGbkxEpFb9sBE4MLPvZEWOdNSvddqAQV1h7jvkwy1BGs0C
        6k5WF/eEsv6GEkBQ==
Content-Disposition: inline
In-Reply-To: <1cdb99ba-ed52-c755-fec4-86ee5f9bc61d-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: jack-AlSwsSmVLrQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Fri 14-01-22 16:23:36, yukuai (C) wrote:
> 在 2022/01/11 9:40, yukuai (C) 写道:
> > 在 2021/12/31 11:23, Yu Kuai 写道:
> > > Chagnes in v2:
> > >   - add comment in patch 2
> > >   - remove patch 4, since the problem do not exist.
> > > 
> > friendly ping ...
> 
> Hi, Jens
> 
> Can this patchset be applied?

Maybe Jens is waiting for Paolo's ack as a BFQ maintainer. Paolo, what do
you think about the cleanups? They seem mostly obvious to me...

								Honza

> 
> Thanks
> > > Yu Kuai (3):
> > >    block, bfq: cleanup bfq_bfqq_to_bfqg()
> > >    block, bfq: avoid moving bfqq to it's parent bfqg
> > >    block, bfq: don't move oom_bfqq
> > > 
> > >   block/bfq-cgroup.c  | 16 +++++++++++++++-
> > >   block/bfq-iosched.c |  4 ++--
> > >   block/bfq-iosched.h |  1 -
> > >   block/bfq-wf2q.c    | 15 ---------------
> > >   4 files changed, 17 insertions(+), 19 deletions(-)
> > > 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
