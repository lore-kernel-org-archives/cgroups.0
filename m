From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 2/4] block, bfq: avoid moving bfqq to it's parent bfqg
Date: Tue, 21 Dec 2021 12:52:47 +0100
Message-ID: <20211221115247.GE24748@quack2.suse.cz>
References: <20211221032135.878550-1-yukuai3@huawei.com>
 <20211221032135.878550-3-yukuai3@huawei.com>
 <20211221101659.GB24748@quack2.suse.cz>
 <d1c91a5f-33f3-ffad-e1ad-fb91482eb864@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1640087568; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SCgxXcO/BZlBAUPu/jU/ISxCVbf1DpLofk5IlL3lQL0=;
        b=AwOnU2FEPfu6mm17FwEKXn7vFLAM4F0SfFny4EAt8FaQO4BICBQwT3fhV37/GN7dVPiSHq
        4l17UTn1xFdJBTXlqotg5IFAtFQp97PxtSFKmxnO9CymhXd0WFXxdkDxFPQqpYMGghUsmi
        gXHZ7VcxkNW1SQbhPtA4js+l2DyTMZY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1640087568;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SCgxXcO/BZlBAUPu/jU/ISxCVbf1DpLofk5IlL3lQL0=;
        b=n8cmMnrBkFYeFhPOzJnGCilZY/ecndMZhBa8W0rTV9rJ+ESd8Xpgiigt4GB7GieARcNpDw
        IRXWG93OA8y8V5Bg==
Content-Disposition: inline
In-Reply-To: <d1c91a5f-33f3-ffad-e1ad-fb91482eb864-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, fchecconi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Tue 21-12-21 19:08:44, yukuai (C) wrote:
> 在 2021/12/21 18:16, Jan Kara 写道:
> > On Tue 21-12-21 11:21:33, Yu Kuai wrote:
> > > Moving bfqq to it's parent bfqg is pointless.
> > > 
> > > Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > 
> > Did you notice that this is happening often enough that the check is worth
> > it? Where do we do this?
> > 
> 
> I noticed that this will happend when root group is offlined:
> 
> bfq_pd_offline
>  bfq_put_async_queues
>   __bfq_put_async_bfqq
>    bfq_bfqq_move
> 
> I'm not sure if there are other situations. I think bfq_bfqq_move()
> is not happening often itself, thus the checking won't affect
> performance.

Yeah, OK, I was just wondering. I guess there's no harm in doing this
check. Maybe add a comment that this can sometimes happen when dealing with
the root cgroup. And then feel free to add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza

-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
