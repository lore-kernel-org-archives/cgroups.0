From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH RFC] block, bfq: switch 'bfqg->ref' to use atomic
 refcount apis
Date: Mon, 2 Jan 2023 12:22:58 +0100
Message-ID: <20230102112258.3fixhuialamu6pkd@quack3>
References: <20221227031541.2595647-1-yukuai1@huaweicloud.com>
 <ba5e74a6-b3de-844d-16b8-84eb429c7058@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1672658578; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VqwR+u//1iVHsLjS8ecEfHM3m/I8nXvJ9KjV1eh5WXs=;
        b=QhMvVVMsVf6x5AViodhwkQFpoKLW/PYRa0Ijf7o3mskGYh6S4+61ZECF9G3TYScuIp7trv
        mK8+RjALUdvmq5ZNuTg5/Tz5jodjLfufzWzjON0Kq+iFv13oOJ9np0a2VmyjWDhzfGRKVI
        EWhorYbh0tj61v8YqB35xiUgkTRvk6A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1672658578;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VqwR+u//1iVHsLjS8ecEfHM3m/I8nXvJ9KjV1eh5WXs=;
        b=K0tV4Q/xIo8tj99PVm3YZoJHBPvz4Lgq/VAnMDEUg/pj96U16eNquZmpyyQjnPO+/riu1/
        l4ZdCXpQqX/S11Cw==
Content-Disposition: inline
In-Reply-To: <ba5e74a6-b3de-844d-16b8-84eb429c7058-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: jack-AlSwsSmVLrQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Tue 27-12-22 14:09:40, Yu Kuai wrote:
> Hi, Jan!
> 
> 在 2022/12/27 11:15, Yu Kuai 写道:
> > From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > 
> > The updating of 'bfqg->ref' should be protected by 'bfqd->lock', however,
> > during code review, we found that bfq_pd_free() update 'bfqg->ref'
> > without holding the lock, which is problematic:
> > 
> > 1) bfq_pd_free() triggered by removing cgroup is called asynchronously;
> > 2) bfqq will grab bfqg reference, and exit bfqq will drop the reference,
> > which can concurrenty with 1).
> > 
> > Unfortunately, 'bfqd->lock' can't be held here because 'bfqd' might already
> > be freed in bfq_pd_free(). Fix the problem by using atomic refcount apis.
> > 
> > Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > ---
> >   block/bfq-cgroup.c  | 8 +++-----
> >   block/bfq-iosched.h | 2 +-
> >   2 files changed, 4 insertions(+), 6 deletions(-)
> > 
> > diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
> > index 1b2829e99dad..aa9c4f02e3a3 100644
> > --- a/block/bfq-cgroup.c
> > +++ b/block/bfq-cgroup.c
> > @@ -316,14 +316,12 @@ struct bfq_group *bfqq_group(struct bfq_queue *bfqq)
> >   static void bfqg_get(struct bfq_group *bfqg)
> >   {
> > -	bfqg->ref++;
> > +	refcount_inc(&bfqg->ref);
> >   }
> >   static void bfqg_put(struct bfq_group *bfqg)
> >   {
> > -	bfqg->ref--;
> > -
> > -	if (bfqg->ref == 0)
> > +	if (refcount_dec_and_test(bfqg->ref))
> Sorry that here should be '&bfqg->ref'.
> 
> Anyway, I'll wait for you, and send a new version if you think this
> patch make sense.

Yes, the patch makes sense to me so feel free to send fixed version.

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
