From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 4/4] block, bfq: update pos_root for idle bfq_queue in
 bfq_bfqq_move()
Date: Wed, 22 Dec 2021 15:17:22 +0100
Message-ID: <20211222141722.GC685@quack2.suse.cz>
References: <20211221032135.878550-1-yukuai3@huawei.com>
 <20211221032135.878550-5-yukuai3@huawei.com>
 <20211221115001.GD24748@quack2.suse.cz>
 <6ca1e924-47fa-b94e-598c-69a9549eb68e@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1640182648; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=idiSby8trVHShWK13Y0N9hJM/pCoT2M/uIPXzb4ZYSA=;
        b=XDsNO3+6DoHh9p+11+8PK6Gn9zpjZeUbct6b6ph3OmJRYuyc9lSQprir/4vmItc06j8BtB
        XOEVxllFEWsgILJ8W7Nr+s/AAWK/QhZCWFoz7vYeG3K0SuXxsuHodfbKv1NpYkQ55dlK48
        CrCYotIwo+k+loQFNJJz2LZNfYBOBWo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1640182648;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=idiSby8trVHShWK13Y0N9hJM/pCoT2M/uIPXzb4ZYSA=;
        b=gqT1jGNfT+HgU3YyxXQ1XixhKQerBZcrY72CDNrrn+PaBGBW7lhNdsvIge7o/1p7kZMKkL
        1Q1dAFAsOMJg56Aw==
Content-Disposition: inline
In-Reply-To: <6ca1e924-47fa-b94e-598c-69a9549eb68e-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, fchecconi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Wed 22-12-21 11:12:45, yukuai (C) wrote:
> 在 2021/12/21 19:50, Jan Kara 写道:
> > On Tue 21-12-21 11:21:35, Yu Kuai wrote:
> > > During code review, we found that if bfqq is not busy in
> > > bfq_bfqq_move(), bfq_pos_tree_add_move() won't be called for the bfqq,
> > > thus bfqq->pos_root still points to the old bfqg. However, the ref
> > > that bfqq hold for the old bfqg will be released, so it's possible
> > > that the old bfqg can be freed. This is problematic because the freed
> > > bfqg can still be accessed by bfqq->pos_root.
> > > 
> > > Fix the problem by calling bfq_pos_tree_add_move() for idle bfqq
> > > as well.
> > > 
> > > Fixes: e21b7a0b9887 ("block, bfq: add full hierarchical scheduling and cgroups support")
> > > Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > 
> > I'm just wondering, how can it happen that !bfq_bfqq_busy() queue is in
> > pos_tree? Because bfq_remove_request() takes care to remove bfqq from the
> > pos_tree...
> 
> Hi,
> 
> It's right this is not a problem in common case. The problem seems to
> relate to queue merging and task migration. Because I once reporduced
> it with the same reporducer for the problem that offlined bfqg can be
> inserted into service tree. The uaf is exactly in
> bfq_remove_request->rb_rease(). However I didn't save the stack...
> 
> I guess this is because bfq_del_bfqq_busy() is called from
> bfq_release_process_ref(), and queue merging prevert sunch bfqq to be
> freed, thus such bfqq is not in service tree, and it's pos_root can
> point to the old bfqg after bfq_bic_update_cgroup->bfq_bfqq_move.
> 
> I haven't confirmed this, however, this patch itself only cleared
> bfqq->pos_root for idle bfqq, there should be no harm.

Well, I agree this patch does no harm but in my opinion it is just papering
over the real problem which is that we leave bfqq without any request in
the pos_tree which can have also other unexpected consequences. I don't
think your scenario with bfq_release_process_ref() calling
bfq_del_bfqq_busy() really answers my question because we call
bfq_del_bfqq_busy() only if RB_EMPTY_ROOT(&bfqq->sort_list) (i.e., bfqq has
no requests) and when sort_list was becoming empty, bfq_remove_request()
should have removed bfqq from the pos_tree. So I think proper fix lies
elsewhere and I would not merge this patch until we better understand what
is happening in this case.

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
