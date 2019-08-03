From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/4] bdi: Add bdi->id
Date: Sat, 3 Aug 2019 08:53:49 -0700
Message-ID: <20190803155349.GD136335@devbig004.ftw2.facebook.com>
References: <20190803140155.181190-1-tj@kernel.org>
 <20190803140155.181190-3-tj@kernel.org>
 <20190803153908.GA932@bombadil.infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wr1/jf7OC4N1CyD2pZrJRAsqKQhTrW81tkA/dMeoZYU=;
        b=E4xysODT5QEs0YiJh/6lyT4EBx4B7Mz7IMg6xczGcQ0G9Qk2AtE4TXZ+GCBgFJDEi1
         lLnFymeOoSvdAYvHJIdCSSrgbeDE4a17sW8u6K0mHvhTIQr7wv8IU/Sst4zTTu0Ui9p9
         jfnV5m2JmluBR+fiHIHyCypa6MemIx71M5jmKx6vtYPIEIc/gtcjHdvjaf5qkicR216B
         vr2TNHeSv9J9+fUNK7YQ/gOyrhWAGf5rfXuyH6O/uIOIbbVZkbs1h8vugk98ksEkGk+E
         kSQOd/o+FqbgLWKvjIyIdPT1Sa9ivX+Vce/lqYQCUaRKFWaUnKiHZKnPlvGognn7X6L+
         Xw7Q==
Content-Disposition: inline
In-Reply-To: <20190803153908.GA932@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: axboe@kernel.dk, jack@suse.cz, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, guro@fb.com, akpm@linux-foundation.org

Hey, Matthew.

On Sat, Aug 03, 2019 at 08:39:08AM -0700, Matthew Wilcox wrote:
> On Sat, Aug 03, 2019 at 07:01:53AM -0700, Tejun Heo wrote:
> > There currently is no way to universally identify and lookup a bdi
> > without holding a reference and pointer to it.  This patch adds an
> > non-recycling bdi->id and implements bdi_get_by_id() which looks up
> > bdis by their ids.  This will be used by memcg foreign inode flushing.
> > 
> > I left bdi_list alone for simplicity and because while rb_tree does
> > support rcu assignment it doesn't seem to guarantee lossless walk when
> > walk is racing aginst tree rebalance operations.
> 
> This would seem like the perfect use for an allocating xarray.  That
> does guarantee lossless walk under the RCU lock.  You could get rid of the
> bdi_list too.

It definitely came to mind but there's a bunch of downsides to
recycling IDs or using radix tree for non-compacting allocations.

Thanks.

-- 
tejun
