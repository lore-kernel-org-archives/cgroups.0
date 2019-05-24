From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] mm: fix page cache convergence regression
Date: Fri, 24 May 2019 09:04:17 -0700
Message-ID: <20190524160417.GB1075@bombadil.infradead.org>
References: <20190524153148.18481-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=udHsjQBKP68t9TZ4H27l2j3R7dmm1NcGJYaKWehd8PE=; b=Ji/F2CZobt5eaIwXFU270PPtZ
        lWbro9qD58JzH3u5iSrGABrhavNQGlQG9qOowF/I85/KPNwLZ/LLPJ3k03wbqOSNrdWu7Vcl8p4KU
        bUFsA2uPdJWh2n12f6c/VJBEQA2R1g88Oc8wLksp4s/GZSbW6SV1861BU2uUfdKtbl1HxRwp8L6yb
        SFtMKbaNlRT/dD+kfvCgm+8cbrjk3onqOCJChb5H0SKJuXWv8jpQrNEtNSZGLej37oK//Zql4ElqN
        XfEldQJv31OFhsagwQYQolonLFHt5VjX4CxLIAY99YW1Ib0FJB/8j9g29HrB6scmWY36BOpf2/h1Q
Content-Disposition: inline
In-Reply-To: <20190524153148.18481-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Fri, May 24, 2019 at 11:31:48AM -0400, Johannes Weiner wrote:
> diff --git a/include/linux/xarray.h b/include/linux/xarray.h
> index 0e01e6129145..cbbf76e4c973 100644
> --- a/include/linux/xarray.h
> +++ b/include/linux/xarray.h
> @@ -292,6 +292,7 @@ struct xarray {
>  	spinlock_t	xa_lock;
>  /* private: The rest of the data structure is not to be used directly. */
>  	gfp_t		xa_flags;
> +	gfp_t		xa_gfp;
>  	void __rcu *	xa_head;
>  };

No.  I'm willing to go for a xa_flag which says to use __GFP_ACCOUNT, but
you can't add another element to the struct xarray.

We haven't even finished the discussion from yesterday.  I'm going to
go back to that thread and keep discussing there.
