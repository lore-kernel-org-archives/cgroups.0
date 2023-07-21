From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC PATCH 0/8] memory recharging for offline memcgs
Date: Fri, 21 Jul 2023 16:44:08 -0400
Message-ID: <20230721204408.GA1033322@cmpxchg.org>
References: <20230720070825.992023-1-yosryahmed@google.com>
 <20230720153515.GA1003248@cmpxchg.org>
 <ZLmRlTej8Tm82kXG@slm.duckdns.org>
 <CAJD7tkYhu3g9u7HkUTFBtT3Q4edVZ2g1TWV1FDcyM9srrYCBLg@mail.gmail.com>
 <ZLmxLUNdxMi5s2Kq@slm.duckdns.org>
 <CAJD7tkZKo_oSZ-mQc-knMELP8kiY1N7taQhdV6tPsqN0tg=gog@mail.gmail.com>
 <ZLm1ptOYH6F8fGHT@slm.duckdns.org>
 <CAJD7tkbDxw-hqG8i85NhnjxmXFMbR5OaSW5dHDVYfdA=ZnPAEw@mail.gmail.com>
 <ZLrN1BE42Tsybm6j@slm.duckdns.org>
 <CAJD7tkatz1JhKVj_iP9J0H7fPJnUSurZkCT1iJTJ=+qRen_nLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20221208.gappssmtp.com; s=20221208; t=1689972250; x=1690577050;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tEshZgxJu/wBZMZ7+AtLkJHqS7609jEJDv2p0gloftc=;
        b=5hAajZX29mBiOPuUXN0gJdiJQTDXp7oyiK0PE9JoornRTaNyZJhhteqbrpVFU4f4bZ
         y8xH5CKnTiuIM+YS5OgrMUAx3smz9SHvL3Rv1rnrG/LRq6Z2II71YIH/nCzn5j93rMkn
         yhgVintKzHo7qPI4NNFEw8rtKqkoGY/AhPnczh5A9ORL9epMzWr8anD9S3h/9cNfPTUM
         Zem1aR1Xb4PsxWQKl54wYJyP63CTDJCfWZRcmPf98zGrIn1LAQp0Dk/qExa5bdvCnve/
         7o+H9RD2hsD+yb/3hwpSOSsg9CGV3bE7ORPPUWBaCqgs0YbD7db5MS1AJ9FT6jy6lLOS
         ktjg==
Content-Disposition: inline
In-Reply-To: <CAJD7tkatz1JhKVj_iP9J0H7fPJnUSurZkCT1iJTJ=+qRen_nLQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Zefan Li <lizefan.x@bytedance.com>, Yu Zhao <yuzhao@google.com>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Iurii Zaikin <yzaikin@google.com>, "T.J. Mercier" <tjmercier@google.com>, Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Fri, Jul 21, 2023 at 11:47:49AM -0700, Yosry Ahmed wrote:
> On Fri, Jul 21, 2023 at 11:26 AM Tejun Heo <tj@kernel.org> wrote:
> >
> > Hello,
> >
> > On Fri, Jul 21, 2023 at 11:15:21AM -0700, Yosry Ahmed wrote:
> > > On Thu, Jul 20, 2023 at 3:31 PM Tejun Heo <tj@kernel.org> wrote:
> > > > memory at least in our case. The sharing across them comes down to things
> > > > like some common library pages which don't really account for much these
> > > > days.
> > >
> > > Keep in mind that even a single page charged to a memcg and used by
> > > another memcg is sufficient to result in a zombie memcg.
> >
> > I mean, yeah, that's a separate issue or rather a subset which isn't all
> > that controversial. That can be deterministically solved by reparenting to
> > the parent like how slab is handled. I think the "deterministic" part is
> > important here. As you said, even a single page can pin a dying cgroup.
> 
> There are serious flaws with reparenting that I mentioned above. We do
> it for kernel memory, but that's because we really have no other
> choice. Oftentimes the memory is not reclaimable and we cannot find an
> owner for it. This doesn't mean it's the right answer for user memory.
> 
> The semantics are new compared to normal charging (as opposed to
> recharging, as I explain below). There is an extra layer of
> indirection that we did not (as far as I know) measure the impact of.
> Parents end up with pages that they never used and we have no
> observability into where it came from. Most importantly, over time
> user memory will keep accumulating at the root, reducing the accuracy
> and usefulness of accounting, effectively an accounting leak and
> reduction of capacity. Memory that is not attributed to any user, aka
> system overhead.

Reparenting has been the behavior since the first iteration of cgroups
in the kernel. The initial implementation would loop over the LRUs and
reparent pages synchronously during rmdir. This had some locking
issues, so we switched to the current implementation of just leaving
the zombie memcg behind but neutralizing its controls.

Thanks to Roman's objcg abstraction, we can now go back to the old
implementation of directly moving pages up to avoid the zombies.

However, these were pure implementation changes. The user-visible
semantics never varied: when you delete a cgroup, any leftover
resources are subject to control by the remaining parent cgroups.
Don't remove control domains if you still need to control resources.
But none of this is new or would change in any way! Neutralizing
controls of a zombie cgroup results in the same behavior and
accounting as linking the pages to the parent cgroup's LRU!

The only thing that's new is the zombie cgroups. We can fix that by
effectively going back to the earlier implementation, but thanks to
objcg without the locking problems.

I just wanted to address this, because your description/framing of
reparenting strikes me as quite wrong.
