From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] fscrypt: Copy the memcg information to the ciphertext
 page
Date: Sun, 29 Jan 2023 21:26:57 +0000
Message-ID: <Y9bkoasmAmtQ2nSV@casper.infradead.org>
References: <20230129121851.2248378-1-willy@infradead.org>
 <Y9a2m8uvmXmCVYvE@sol.localdomain>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bXKHXmqEaebxMzK8gnHyzoWXhX9Kr2E4BvSYUnQui+s=; b=IxMHpJnXGWl1mAd9RBC6Fzs9tN
        /g2C0765JWZhKFeJDvJac3rnrbux8FmFABeZaU67CqtwPrSCEYxMm37nwuy4iuy7sFMtF8J16OHQO
        AhoX3yt7iYvrcw/aIwYbNJrbKrOhPAVYpg3zqChpqv1rO0hTL3A9y8BmG7vBf+889jCkVVHMScdES
        K2jIJ4U2SkTozsLcoHUNIRdmhj3BtcHFfoExh40VIL8wXG89Gby/vBoMwKaVoUGeHyldtIXa4x+9o
        5q2v3Ke1jzOwYBGPBii/hIRmojfICe5/UAWHdOQ9NJILhSpLOmb8DWdZox/0LXt4/MP0T+9bygsP1
        S2t2wNrQ==;
Content-Disposition: inline
In-Reply-To: <Y9a2m8uvmXmCVYvE-8Kz7deQLoS0mYvmMESoHnA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Biggers <ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Theodore Y . Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fscrypt-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Sun, Jan 29, 2023 at 10:10:35AM -0800, Eric Biggers wrote:
> On Sun, Jan 29, 2023 at 12:18:51PM +0000, Matthew Wilcox (Oracle) wrote:
> > Both f2fs and ext4 end up passing the ciphertext page to
> > wbc_account_cgroup_owner().  At the moment, the ciphertext page appears
> > to belong to no cgroup, so it is accounted to the root_mem_cgroup instead
> > of whatever cgroup the original page was in.
> > 
> > It's hard to say how far back this is a bug.  The crypto code shared
> > between ext4 & f2fs was created in May 2015 with commit 0b81d0779072,
> > but neither filesystem did anything with memcg_data before then.  memcg
> > writeback accounting was added to ext4 in July 2015 in commit 001e4a8775f6
> > and it wasn't added to f2fs until January 2018 (commit 578c647879f7).
> 
> What is the actual effect of this bug?
> 
> The bounce pages are short-lived, so surely it doesn't really matter what memory
> cgroup they get charged to?

Ah, we don't want to charge the _memory_ of the bounce pages to the
cgroup.  We want to charge the _I/O_ to the cgroup.

Looking at the original commits, the effect will be that if you have
an unencrypted filesystem, writeback will be throttled according to
the cgroup's rules, but if you have an encrypted filesystem, it will
escape the cgroup I/O limits.

> I guess it's really more about the effect on cgroup writeback?  And that's also
> the reason why this is a problem here but not e.g. in dm-crypt?

I haven't looked at dm-crypt at all, but my assumption is that the fs
charges the I/O of the pagecache page to the cgroup, and there's no need
to do it again.

> > diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
> > index e78be66bbf01..a4e76f96f291 100644
> > --- a/fs/crypto/crypto.c
> > +++ b/fs/crypto/crypto.c
> > @@ -205,6 +205,9 @@ struct page *fscrypt_encrypt_pagecache_blocks(struct page *page,
> >  	}
> >  	SetPagePrivate(ciphertext_page);
> >  	set_page_private(ciphertext_page, (unsigned long)page);
> > +#ifdef CONFIG_MEMCG
> > +	ciphertext_page->memcg_data = page->memcg_data;
> > +#endif
> >  	return ciphertext_page;
> >  }
> 
> Nothing outside mm/ and include/linux/memcontrol.h does anything with memcg_data
> directly.  Are you sure this is the right thing to do here?

Nope ;-)  Happy to hear from people who know more about cgroups than I
do.  Adding some more ccs.

> Also, this patch causes the following:

Oops.  Clearly memcg_data needs to be set to NULL before we free it.
