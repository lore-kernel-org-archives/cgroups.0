From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: fix page cache convergence regression
Date: Thu, 30 May 2019 13:58:00 -0400
Message-ID: <20190530175800.GA10941@cmpxchg.org>
References: <20190524153148.18481-1-hannes@cmpxchg.org>
 <20190524160417.GB1075@bombadil.infradead.org>
 <20190524173900.GA11702@cmpxchg.org>
 <20190530161548.GA8415@cmpxchg.org>
 <20190530171356.GA19630@bombadil.infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UdtCpjjQ91i6JdeO1o6cmQH2Jj5NVts/neyKdRuf9u0=;
        b=V8J8o0JH07x2wsBm99n7DGytzSCB9uQ7i73/R7tiHi2EW+jlFvc9gPYtl/fH4Vtxfk
         8+4Cfa4e63aA5rrFDRaRFWVlXZO4x+21PiB/3o4FZZJOF0sMkYhr4qoWdTzCynaKwyPZ
         kBcIAAH67jJTafpsCBQrUe1ANdMKdiKshInIwRJ+BUPz/kaCKBTlvGwLD0vk0Cy79OFL
         pQV8FyejxTWwBSkNkb2i0W+gU4dNKH5fQz3CURzx8VpGqok0gIMOvcEsrvCSRBvJK1VB
         UpIQ+Vac+NqKi2v6odcKj9Za3/R+Om3zqq5+o43oUOnVrotaFmWZapzBt60tB2lW5z7V
         S6vQ==
Content-Disposition: inline
In-Reply-To: <20190530171356.GA19630@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, May 30, 2019 at 10:13:56AM -0700, Matthew Wilcox wrote:
> On Thu, May 30, 2019 at 12:15:48PM -0400, Johannes Weiner wrote:
> > Are there any objections or feedback on the proposed fix below? This
> > is kind of a serious regression.
> 
> I'll drop it into the xarray tree for merging in a week, if that's ok
> with you?

That sounds great, thank you.
