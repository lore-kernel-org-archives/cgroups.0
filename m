From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -next 10/11] block, bfq: decrease
 'num_groups_with_pending_reqs' earlier
Date: Tue, 19 Apr 2022 11:49:55 +0200
Message-ID: <20220419094955.ucjxadnhdyonfjdo@quack3.lan>
References: <20220305091205.4188398-1-yukuai3@huawei.com>
 <20220305091205.4188398-11-yukuai3@huawei.com>
 <20220413112816.fwobg4cp6ttpnpk6@quack3.lan>
 <f3ed507a-7c85-cd69-3ad5-3e9c0e75c372@huawei.com>
 <ef7bad8c-b8dd-f625-330c-9a22e303844b@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1650361798; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J1deqUxc9C8D6lInkd2DloHcFrHOp4GMQ6s/PLFQPqA=;
        b=19W+p5kE2JN+9TJwKovFQQHYDzGXCipmtRiqv16MxNu2WAphcZeAaEeeZd13G8/XMcOXYR
        QlLrHgV7LR3mKgXduFGrmGMKuwYsa7v/2nxukCq3s90vAPazeKwbGFGzDnTt2CCiz7Vif9
        ydCaXqQAhEqqlAsgAHKloKj1BX52vno=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1650361798;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J1deqUxc9C8D6lInkd2DloHcFrHOp4GMQ6s/PLFQPqA=;
        b=iO8ylqwF5TMzf4SeDvp3qCGb8/Ge2WiU2xauMHrhCLNPzzESfu1Pgcwn+dfkQ/J32faC+T
        ALuphv9JSEHACgBw==
Content-Disposition: inline
In-Reply-To: <ef7bad8c-b8dd-f625-330c-9a22e303844b-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Fri 15-04-22 09:10:06, yukuai (C) wrote:
> 在 2022/04/13 19:40, yukuai (C) 写道:
> > 在 2022/04/13 19:28, Jan Kara 写道:
> > > On Sat 05-03-22 17:12:04, Yu Kuai wrote:
> > > > Currently 'num_groups_with_pending_reqs' won't be decreased when
> > > > the group doesn't have any pending requests, while some child group
> > > > still have pending requests. The decrement is delayed to when all the
> > > > child groups doesn't have any pending requests.
> > > > 
> > > > For example:
> > > > 1) t1 issue sync io on root group, t2 and t3 issue sync io on the same
> > > > child group. num_groups_with_pending_reqs is 2 now.
> > > > 2) t1 stopped, num_groups_with_pending_reqs is still 2. io from t2 and
> > > > t3 still can't be handled concurrently.
> > > > 
> > > > Fix the problem by decreasing 'num_groups_with_pending_reqs'
> > > > immediately upon the weights_tree removal of last bfqq of the group.
> > > > 
> > > > Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > > 
> > > So I'd find the logic easier to follow if you completely removed
> > > entity->in_groups_with_pending_reqs and did updates of
> > > bfqd->num_groups_with_pending_reqs like:
> > > 
> > >     if (!bfqg->num_entities_with_pending_reqs++)
> > >         bfqd->num_groups_with_pending_reqs++;
> > > 
> > Hi,
> > 
> > Indeed, this is an excellent idle, and much better than the way I did.
> > 
> > Thanks,
> > Kuai
> > 
> > > and similarly on the remove side. And there would we literally two places
> > > (addition & removal from weight tree) that would need to touch these
> > > counters. Pretty obvious and all can be done in patch 9.
> 
> I think with this change, we can count root_group while activating bfqqs
> that are under root_group, thus there is no need to modify
> for_each_entity(or fake bfq_sched_data) any more.

Sure, if you can make this work, it would be easier :)

> The special case is that weight racing bfqqs are not inserted into
> weights tree, and I think this can be handled by adding a fake
> bfq_weight_counter for such bfqqs.

Do you mean "weight raised bfqqs"? Yes, you are right they would need
special treatment - maybe bfq_weights_tree_add() is not the best function
to use for this and we should rather use insertion / removal from the
service tree for maintaining num_entities_with_pending_reqs counter?
I can even see we already have bfqg->active_entities so maybe we could just
somehow tweak that accounting and use it for our purposes?

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
