From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/2] block, bfq: minor cleanups
Date: Wed, 14 Dec 2022 16:57:50 +0100
Message-ID: <20221214155750.ivc43jgkfvxlp6y4@quack3>
References: <20221214033155.3455754-1-yukuai1@huaweicloud.com>
 <79d587ef-66c3-e84d-0904-41da2c8e7146@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1671033470; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B4OheqqFLoHea6X9Q+7CKodDyXD/mYyUFNDiEKU1Y5I=;
        b=gM4CtN/H82jW/oj+L6LHZBSQM+xE8svPLl+esaPN/+znII72XqlZuXtzN6I1VjHphNJbpv
        SY9r/eNd2pP+aatAc50bRAnumdhVsD654mDL9oxtED4JTWzWmz3o8gaxnS5zEXN2JILnFA
        6GH8jLaXg7OjDsL0vDtaS/4pDYI/zBk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1671033470;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B4OheqqFLoHea6X9Q+7CKodDyXD/mYyUFNDiEKU1Y5I=;
        b=pqf2UoRr2rrqpTMHTqmuFmGlDOxvQL89y779TNDsxBWmGUrKnocMzBcNQ7gL0FN/4ggy2c
        fIG1BshGhkAotNAw==
Content-Disposition: inline
In-Reply-To: <79d587ef-66c3-e84d-0904-41da2c8e7146@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Jan Kara <jack@suse.cz>, paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org, josef@toxicpanda.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

On Wed 14-12-22 11:14:49, Yu Kuai wrote:
> Hi, Jan
> 
> Sorry that I forgot to cc you.

Both patches look good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Thanks,
> Kuai
> 
> 在 2022/12/14 11:31, Yu Kuai 写道:
> > From: Yu Kuai <yukuai3@huawei.com>
> > 
> > Yu Kuai (2):
> >    block, bfq: don't return bfqg from __bfq_bic_change_cgroup()
> >    block, bfq: replace 0/1 with false/true in bic apis
> > 
> >   block/bfq-cgroup.c  | 16 +++++++---------
> >   block/bfq-iosched.c |  4 ++--
> >   2 files changed, 9 insertions(+), 11 deletions(-)
> > 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
