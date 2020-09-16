From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [External] Re: [PATCH v5] mm: memcontrol: Add the missing
 numa_stat interface for cgroup v2
Date: Wed, 16 Sep 2020 10:40:57 -0400
Message-ID: <20200916144057.GA194430@cmpxchg.org>
References: <20200915171801.39761-1-songmuchun@bytedance.com>
 <20200915214845.GB189808@cmpxchg.org>
 <CAMZfGtXOR1Ed2PyB4TB5mq=1mh7p7La-4BsoZ8oYhtgc8ZcqLQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fKYfJDr6XxN79fp7RRW8vHbFzGf8aLsEG/U2ZaiDjdE=;
        b=x3fuQca0YO4vXhnbqTr/awp8cN0ZmiMYzYQ/wBG5yKnOrO8F+Nw+YZ0TuosHxJH//Y
         3iNLZoxNj3tgOeuQOZc/gGlF2FUljYQwnGuXvAJLuhARwn22qD/0LFjmb/NZ3tKLJ+of
         Gr1QMEfApz/Dx/Qro6daJdCGB5v8rMY7CZQp0JFUZHnZysVsMBjlc53pAUpu1lkR/jwA
         GaWH31lJFMfcLnxfjTsd2oFBxFLjxEuT2GZiX3v9V95vS6x+6VnHOOh1j46dEpnz3rOI
         gItFy9wcDwGEuqN9UCktG0P2Nk87Swobyq2yLNj8GLYSO0YGumg8dOshimjHMZL5xP8Q
         s4WA==
Content-Disposition: inline
In-Reply-To: <CAMZfGtXOR1Ed2PyB4TB5mq=1mh7p7La-4BsoZ8oYhtgc8ZcqLQ@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan@huawei.com>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <guro@fb.com>, Randy Dunlap <rdunlap@infradead.org>, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>

On Wed, Sep 16, 2020 at 12:14:49PM +0800, Muchun Song wrote:
> On Wed, Sep 16, 2020 at 5:50 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > On Wed, Sep 16, 2020 at 01:18:01AM +0800, Muchun Song wrote:
> > > In the cgroup v1, we have a numa_stat interface. This is useful for
> > > providing visibility into the numa locality information within an
> > > memcg since the pages are allowed to be allocated from any physical
> > > node. One of the use cases is evaluating application performance by
> > > combining this information with the application's CPU allocation.
> > > But the cgroup v2 does not. So this patch adds the missing information.
> > >
> > > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > > Suggested-by: Shakeel Butt <shakeelb@google.com>
> > > Reviewed-by: Shakeel Butt <shakeelb@google.com>
> >
> > Yup, that would be useful information to have. Just a few comments on
> > the patch below:
> >
> > > @@ -1368,6 +1368,78 @@ PAGE_SIZE multiple when read back.
> > >               collapsing an existing range of pages. This counter is not
> > >               present when CONFIG_TRANSPARENT_HUGEPAGE is not set.
> > >
> > > +  memory.numa_stat
> > > +     A read-only flat-keyed file which exists on non-root cgroups.
> >
> > It's a nested key file, not flat.
> 
> This is just copied from memory.stat documentation.Is the memory.stat
> also a nested key file?

No, memory.stat is a different format. From higher up in the document:

  Flat keyed

	KEY0 VAL0\n
	KEY1 VAL1\n
	...

  Nested keyed

	KEY0 SUB_KEY0=VAL00 SUB_KEY1=VAL01...
	KEY1 SUB_KEY0=VAL10 SUB_KEY1=VAL11...
	...

> > Otherwise, this looks reasonable to me.
> 
> OK. Will do that.

Thanks!
