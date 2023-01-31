From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] fscrypt: Copy the memcg information to the ciphertext
 page
Date: Tue, 31 Jan 2023 11:27:44 -1000
Message-ID: <Y9mH0PCcZoGPryXw@slm.duckdns.org>
References: <20230129121851.2248378-1-willy@infradead.org>
 <Y9a2m8uvmXmCVYvE@sol.localdomain>
 <Y9bkoasmAmtQ2nSV@casper.infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AzK7zbHqMHdeBmanV3yZyUjocxSjOS0P2zK4GlPV5fg=;
        b=D6wvD2En7fL/J4jxZGOIQBNq1r2srmO4HOmSSPNUtrliYfnfu+LBoGk5BxIcMiuq2I
         +zwJ+mRwxgYtBtoDsGT1p7nE5JifYqFUf8hP1sgEtkOKyHfWhW4umWi9ewBl4h6lpann
         1FKRMTut+C+QYs/Mg9T/XGdMWHxAvc4vm7coGsd3WvOgoQt73PDTLpV3MfO+X+lC2HD/
         QNpAi6vLbe5SEo1NIxJIxqYOYG4hgDKEIE7e8sbyQhb8Yes6j5hPRgz/GjUPNoMDssZL
         IfTNvheB70L2NHCzBcWcOzJp3YlrWN80ciuNtnhhN2fCo38Ky5KInmRB9oeQm46P5CX+
         WVnQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Y9bkoasmAmtQ2nSV-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Eric Biggers <ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Theodore Y . Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fscrypt-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Sun, Jan 29, 2023 at 09:26:57PM +0000, Matthew Wilcox wrote:
> > > diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
> > > index e78be66bbf01..a4e76f96f291 100644
> > > --- a/fs/crypto/crypto.c
> > > +++ b/fs/crypto/crypto.c
> > > @@ -205,6 +205,9 @@ struct page *fscrypt_encrypt_pagecache_blocks(struct page *page,
> > >  	}
> > >  	SetPagePrivate(ciphertext_page);
> > >  	set_page_private(ciphertext_page, (unsigned long)page);
> > > +#ifdef CONFIG_MEMCG
> > > +	ciphertext_page->memcg_data = page->memcg_data;
> > > +#endif
> > >  	return ciphertext_page;
> > >  }
> > 
> > Nothing outside mm/ and include/linux/memcontrol.h does anything with memcg_data
> > directly.  Are you sure this is the right thing to do here?
> 
> Nope ;-)  Happy to hear from people who know more about cgroups than I
> do.  Adding some more ccs.
> 
> > Also, this patch causes the following:
> 
> Oops.  Clearly memcg_data needs to be set to NULL before we free it.

These can usually be handled by explicitly associating the bio's to the
desired cgroups using one of bio_associate_blkg*() or
bio_clone_blkg_association(). It is possible to go through memcg ownership
too using set_active_memcg() so that the page is owned by the target cgroup;
however, the page ownership doesn't directly map to IO ownership as the
relationship depends on the type of the page (e.g. IO ownership for
pagecache writeback is determined per-inode, not per-page). If the in-flight
pages are limited, it probably is better to set bio association directly.

Thanks.

-- 
tejun
