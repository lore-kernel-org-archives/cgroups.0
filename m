From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 2/4] bdi: Add bdi->id
Date: Sat, 3 Aug 2019 08:39:08 -0700
Message-ID: <20190803153908.GA932@bombadil.infradead.org>
References: <20190803140155.181190-1-tj@kernel.org>
 <20190803140155.181190-3-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=I1NrYHa+YaTrMj4UyPPBH/9wAm+dfInLgj5QDmyuYaQ=; b=KaJpknF6oyKuFSUS8QpoeQZ0+
        oO5lkFotXCzO34i1rtC888bSh5w4VMe2rdcZBVoXwym+9Z2lnOXcg7ahfBEQgWj2kRSUeUDo5wJl9
        HSLC4OoX/h7Z9Cn5OLIexQxK0GxaECorGHjmgRx8p/vDhIndP9vCdDwrVq65o6FYbdXLU5+ns974a
        Ch4goXJuQGZ1Lu88yLYcUIUx9TcU4+kY3/EfLCjDFs2A6onYOsSm+vJbUG8F+Zhq/fbGwjG5IfqnI
        Sawk07uOmPsZ28vxchbJ+ghXjXuRAP1ztosFlofvodsJeD162SaAT4XcqMyY9YqKHDJix3Ky8Mv4f
Content-Disposition: inline
In-Reply-To: <20190803140155.181190-3-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, jack@suse.cz, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, guro@fb.com, akpm@linux-foundation.org

On Sat, Aug 03, 2019 at 07:01:53AM -0700, Tejun Heo wrote:
> There currently is no way to universally identify and lookup a bdi
> without holding a reference and pointer to it.  This patch adds an
> non-recycling bdi->id and implements bdi_get_by_id() which looks up
> bdis by their ids.  This will be used by memcg foreign inode flushing.
> 
> I left bdi_list alone for simplicity and because while rb_tree does
> support rcu assignment it doesn't seem to guarantee lossless walk when
> walk is racing aginst tree rebalance operations.

This would seem like the perfect use for an allocating xarray.  That
does guarantee lossless walk under the RCU lock.  You could get rid of the
bdi_list too.

