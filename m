From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -next v2 2/5] block, bfq: add fake weight_counter for
 weight-raised queue
Date: Mon, 25 Apr 2022 18:26:08 +0200
Message-ID: <20220425162608.feya66a5amdnsr4e@quack3.lan>
References: <20220416093753.3054696-1-yukuai3@huawei.com>
 <20220416093753.3054696-3-yukuai3@huawei.com>
 <20220425094856.qgkhba2klguduxot@quack3.lan>
 <a27b8c79-867f-9253-84db-1d39c964b3ed@huawei.com>
 <4048cc0c-adc8-8097-4a40-762137c4c282@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1650903968; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VUB+heCNyeRFdPDI1DhMrxZcGuxVYUwZDE80GwpHJU8=;
        b=pdXu4C9WWm9PwhxJ4kncFBH/N6LpW+See8N92WAtqIGuzAwMFB2MW2lwZkGZStmGNMJT/S
        Oql8ZjWpYrf8ogzL8VQ3cIPkfW8AWk8h4BuJHKGZWzp0ignZcWNfNucjWTl9vFEEoDD+tN
        dJo8wa5/oF7v9fgW10I9mAzX1xSkm/g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1650903968;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VUB+heCNyeRFdPDI1DhMrxZcGuxVYUwZDE80GwpHJU8=;
        b=kj1ovTZoxRmdmq25y5rwYeLhZBg+ACRAbP3a30Yt/bDVvCkDIQOoWuoBrgv7Mip8r98v41
        2lUqmZqKseXVKkDg==
Content-Disposition: inline
In-Reply-To: <4048cc0c-adc8-8097-4a40-762137c4c282-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Mon 25-04-22 21:55:46, yukuai (C) wrote:
> 在 2022/04/25 21:34, yukuai (C) 写道:
> > 在 2022/04/25 17:48, Jan Kara 写道:
> > > On Sat 16-04-22 17:37:50, Yu Kuai wrote:
> > > > Weight-raised queue is not inserted to weights_tree, which makes it
> > > > impossible to track how many queues have pending requests through
> > > > weights_tree insertion and removel. This patch add fake weight_counter
> > > > for weight-raised queue to do that.
> > > > 
> > > > Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > > 
> > > This is a bit hacky. I was looking into a better place where to hook to
> > > count entities in a bfq_group with requests and I think
> > > bfq_add_bfqq_busy()
> > > and bfq_del_bfqq_busy() are ideal for this. It also makes better sense
> > > conceptually than hooking into weights tree handling.
> > > 
> > Hi,
> > 
> > bfq_del_bfqq_busy() will be called when all the reqs in the bfqq are
> > dispatched, however there might still some reqs are't completed yet.
> > 
> > Here what we want to track is how many bfqqs have pending reqs,
> > specifically if the bfqq have reqs are't complted.
> > 
> > Thus I think bfq_del_bfqq_busy() is not the right place to do that.
> 
> BTW, there is a counter 'dispatched' in bfqq, how about we rename it
> to 'inflight', and inc when adding req to bfqq, dec the same as
> 'dispatched' ?
> 
> This way we can count bfqq when adding 'inflight' from 0 to 1, and
> stop when decreasing 'inflight' from 1 to 0.

Well, but 'dispatched' is used in quite a few places and it would require
quite some thinking to decide which impact using 'inflight' has there...
But we also have 'bfqq->entity.allocated' which is number of requests in
some state associated with bfqq and we could use that. But as I wrote in my
previous email, I'm not convinced it is really necessary...

								Honza

-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
