From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/5] writeback: bdi_writeback iteration must not skip
 dying ones
Date: Fri, 2 Oct 2015 14:19:10 -0400
Message-ID: <20151002181910.GA8983@mtj.duckdns.org>
References: <1443545274-18787-1-git-send-email-tj@kernel.org>
 <1443545274-18787-4-git-send-email-tj@kernel.org>
 <20151002141212.GA17746@quack.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Jm903CDUNb7nummeC6Gsazv/s6wnrMZKrvT4q8foYEI=;
        b=q+57sFCHwSgUKDGHX0TeJIF0BYR7f7X6GdyjXI5yF3Zw+qB9ZSHs7sTCak7wF7IC7z
         uoQteyHv0zblmmHMKhqiCcwEz0ffl66EZ98SbJudadd9bzb+Otu8uOxrq/5WxgUqPIwE
         XKf0xWBiPI3WIlrM/9LEWmhXHgwCM5H8g2AwxclDGwTvmVbKfnamXHAtjEvNNV5lffiI
         zvZxmMj9ipbX/XGMniBbJqW1htlux1W94YzBVBZMSFaSKYCVuvPmWdRfyiAblWD0LZkw
         7IU+2G2QLC/Pgj3ICq6BQBEMD7J/ui7Zp/vob1Trk4JfQLrHzG72mammiLThvL3dLWjQ
         g0lQ==
Content-Disposition: inline
In-Reply-To: <20151002141212.GA17746-+0h/O2h83AeN3ZZ/Hiejyg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Oct 02, 2015 at 04:12:12PM +0200, Jan Kara wrote:
> > +		if (last_wb) {
> > +			wb_put(last_wb);
> > +			last_wb = NULL;
> > +		}
> 
> But you seem to forget to drop last_wb reference in case this was the last
> wb in the list, don't you?

You're right.  Will update the patch.

> > @@ -686,6 +691,9 @@ static void cgwb_bdi_destroy(struct backing_dev_info *bdi)
> >  	radix_tree_for_each_slot(slot, &bdi->cgwb_tree, &iter, 0)
> >  		cgwb_kill(*slot);
> >  
> > +	/* wb may get released after @bdi is freed, sever list head */
> > +	list_del(&bdi->wb_list);
> > +
> 
> But we wait for bdi->usage_cnt to drop to 0 which means there's no wb,
> don't we? What am I missing?

And I forgot that we were doing that.  This isn't necessary.

> > @@ -764,15 +772,22 @@ static void cgwb_bdi_destroy(struct backing_dev_info *bdi) { }
> >  
> >  int bdi_init(struct backing_dev_info *bdi)
> >  {
> > +	int ret;
> > +
> >  	bdi->dev = NULL;
> >  
> >  	bdi->min_ratio = 0;
> >  	bdi->max_ratio = 100;
> >  	bdi->max_prop_frac = FPROP_FRAC_BASE;
> >  	INIT_LIST_HEAD(&bdi->bdi_list);
> > +	INIT_LIST_HEAD(&bdi->wb_list);
> >  	init_waitqueue_head(&bdi->wb_waitq);
> >  
> > -	return cgwb_bdi_init(bdi);
> > +	ret = cgwb_bdi_init(bdi);
> > +
> > +	list_add_tail_rcu(&bdi->wb.bdi_node, &bdi->wb_list);
> 
> Won't this be more logical in cgwb_bdi_init()?

bdi->wb_list exists whether cgwb is enabled or not, so if we move this
to cgwb_bdi_init(), we'll be duplicating it in both paths.

Thanks.

-- 
tejun
