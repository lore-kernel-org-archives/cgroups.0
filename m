From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 15/49] writeback: move backing_dev_info->wb_lock and
 ->worklist into bdi_writeback
Date: Mon, 20 Apr 2015 14:17:07 -0400
Message-ID: <20150420181707.GD4206@htj.duckdns.org>
References: <1428350318-8215-1-git-send-email-tj@kernel.org>
 <1428350318-8215-16-git-send-email-tj@kernel.org>
 <20150420153224.GD17020@quack.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=n0KIv5gZ0Hg1JVEKjyHV/9DP9GDt2aQ/qmx043a66ZA=;
        b=Byat0CPrhpopV9c7mmAj5kgTpIdq69GfaWjHoPlhu704xSzTOhNrjG+/o6PXj5frhD
         0sutsdemoNK/IVYwrInVJfaVB9ev8pQ74Te91Epj9aCnA28YaJaK6VaK8qwfkG0iavdk
         4ALAm74N/LktGuYR5FyZgce259s8rlMGVRCxj8kA5GZIDDAts0b8reE2BzBKKUgGJYFu
         MbSi8B45/CHbhSIG1sb6RZY05kCr+uNe9BQYTHd+YnHimy+5Ja4z1f9mZMd33qB6c3Uy
         QmFIIri/PgBadoaO/pmJWSFmfo03MixX+oLS1z0fyAPY88t7fWPaVtzUf7qlfujsmMlU
         cJOQ==
Content-Disposition: inline
In-Reply-To: <20150420153224.GD17020@quack.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com

Hello, Jan.

On Mon, Apr 20, 2015 at 05:32:24PM +0200, Jan Kara wrote:
> > @@ -454,9 +451,9 @@ EXPORT_SYMBOL(bdi_init);
> >  
> >  void bdi_destroy(struct backing_dev_info *bdi)
> >  {
> > -	bdi_wb_shutdown(bdi);
> > -
> > -	WARN_ON(!list_empty(&bdi->work_list));
> > +	/* make sure nobody finds us on the bdi_list anymore */
> > +	bdi_remove_from_list(bdi);
> > +	wb_shutdown(&bdi->wb);
> >  
> >  	if (bdi->dev) {
> >  		bdi_debug_unregister(bdi);
>   But if someone ends up calling bdi_destroy() on unregistered bdi,
> bdi_remove_from_list() will be corrupting memory, won't it? And if I

bdi_init() does INIT_LIST_HEAD() on it, so it should be fine, no?

> remember right there were some corner cases where this really happened.
> Previously we were careful and checked WB_registered. I guess we could
> check for !list_empty(&bdi->bdi_list) and also reinit bdi_list in
> bdi_remove_from_list() after synchronize_rcu_expedited().

But we can't call bdi_destroy() more than once no matter what.  We'd
be doing double frees.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
