From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 0/8] memory recharging for offline memcgs
Date: Thu, 20 Jul 2023 13:33:49 -1000
Message-ID: <ZLnEXbeQJ_69xV23@slm.duckdns.org>
References: <20230720070825.992023-1-yosryahmed@google.com>
 <20230720153515.GA1003248@cmpxchg.org>
 <ZLmRlTej8Tm82kXG@slm.duckdns.org>
 <CAJD7tkYhu3g9u7HkUTFBtT3Q4edVZ2g1TWV1FDcyM9srrYCBLg@mail.gmail.com>
 <ZLmxLUNdxMi5s2Kq@slm.duckdns.org>
 <CAJD7tkZKo_oSZ-mQc-knMELP8kiY1N7taQhdV6tPsqN0tg=gog@mail.gmail.com>
 <ZLm1ptOYH6F8fGHT@slm.duckdns.org>
 <CABdmKX0JETkXpOSfCUZ3jaZv1JxRzbTP+Se4i3HMKjP3PNZ8Qg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689896031; x=1690500831;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QDyB0fNg8iWGoLzY4kcY3n9F15g3W1rTkoIJoBTRg3A=;
        b=p+DjGaqxAYYqPCdrR2BuBFrntop3OtvaJ9VPhfM4o2gjf3vqRJipbYIu7R0l45bmex
         qOYSyJjyvqVatCS3/cx/jCT624c+7E64DfOD4mxB7fVWiy9qgxpagCj5Oq7t63/bbEbd
         7XlvJpp22DUAqDFFOk1rUNh/4XL1OEyZ9/FICeZEWEvKrC3C2DaExZWPQbFmbi8btTih
         OdWniYrypHRj+r7hruEGoY+OT/ko57kNTp34phNCjotDBg6lkZQug5+DcQiRLL+PYgyn
         Urb767YbMH2gYYyExrPkfBmm/0ZwTrS0pZGlBY0dMuyw8WfHFCJ1y0ZDpbMza1FBy9MC
         D1mw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <CABdmKX0JETkXpOSfCUZ3jaZv1JxRzbTP+Se4i3HMKjP3PNZ8Qg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Zefan Li <lizefan.x@bytedance.com>, Yu Zhao <yuzhao@google.com>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Iurii Zaikin <yzaikin@google.com>, Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

Hello,

On Thu, Jul 20, 2023 at 04:24:02PM -0700, T.J. Mercier wrote:
> > Hmm... so, usually, the problems we see are resources that are persistent
> > across different instances of the same application as they may want to share
> > large chunks of memory like on-memory cache. I get that machines get
> > different dynamic jobs but unrelated jobs usually don't share huge amount of
> > memory at least in our case. The sharing across them comes down to things
> > like some common library pages which don't really account for much these
> > days.
> >
> This has also been my experience in terms of bytes of memory that are
> incorrectly charged (because they're charged to a zombie), but that is
> because memcg doesn't currently track the large shared allocations in
> my case (primarily dma-buf). The greater issue I've seen so far is the
> number of zombie cgroups that can accumulate over time. But my
> understanding is that both of these two problems are currently
> significant for Yosry's case.

memcg already does reparenting of slab pages to lower the number of dying
cgroups and maybe it makes sense to expand that to user memory too. One
related thing is that if those reparented pages are written to, that's gonna
break IO isolation w/ blk-iocost because iocost currently bypasses IOs from
intermediate cgroups to root but we can fix that. Anyways, that's something
pretty different from what's proposed here. Reparenting, I think, is a lot
less conroversial.

Thanks.

-- 
tejun
