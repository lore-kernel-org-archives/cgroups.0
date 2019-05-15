From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v4 5/7] mm: rework non-root kmem_cache lifecycle management
Date: Wed, 15 May 2019 07:11:30 -0700
Message-ID: <CALvZod5dMM50pZWuOR5SN7aPPG8Zsp-+U3Y+q-UHTNo=Dgz-Nw@mail.gmail.com>
References: <20190514213940.2405198-1-guro@fb.com> <20190514213940.2405198-6-guro@fb.com>
 <0100016abbcb13b1-a1f70846-1d8c-4212-8e74-2b9be8c32ce7-000000@email.amazonses.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DkABSB9+ocVSEDM1acJkspFNCkj7bZrir9llBRZBZbk=;
        b=diNffEIXfA/QFvQ4JDN4yWPbBFk9QYgBHQ4+BVJ1NfD0TF6g+5vVE0YSL1BnVjtejf
         CrAeQK4hrTmj1WQuMCeXacIymo+qMfuKsRMkXThtVIfdGWD3UWU68tOQie85EkAx3kZA
         YA78rnXPrmWhtTDNmjqohIlpLATlRKpAgbVUzdHZ/0oIWDRCWeJPe4MkeQfL4NNPlAhb
         5gw18O/g48n/nZ7gRYd6s2xdXe7fCpmxbuVDtTd8Fhd7nK4blg8+HLxt6MmLicorJV+J
         ANLAPFx1lNLWprZ3HdLcTYYUg1gfx/xT6ADtn2L5nwfSQpvrZp2SEK2dbyUh8ZEYZ9Xq
         UKcQ==
In-Reply-To: <0100016abbcb13b1-a1f70846-1d8c-4212-8e74-2b9be8c32ce7-000000@email.amazonses.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christopher Lameter <cl@linux.com>
Cc: Roman Gushchin <guro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <kernel-team@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Cgroups <cgroups@vger.kernel.org>

From: Christopher Lameter <cl@linux.com>
Date: Wed, May 15, 2019 at 7:00 AM
To: Roman Gushchin
Cc: Andrew Morton, Shakeel Butt, <linux-mm@kvack.org>,
<linux-kernel@vger.kernel.org>, <kernel-team@fb.com>, Johannes Weiner,
Michal Hocko, Rik van Riel, Vladimir Davydov,
<cgroups@vger.kernel.org>

> On Tue, 14 May 2019, Roman Gushchin wrote:
>
> > To make this possible we need to introduce a new percpu refcounter
> > for non-root kmem_caches. The counter is initialized to the percpu
> > mode, and is switched to atomic mode after deactivation, so we never
> > shutdown an active cache. The counter is bumped for every charged page
> > and also for every running allocation. So the kmem_cache can't
> > be released unless all allocations complete.
>
> Increase refcounts during each allocation? Looks to be quite heavy
> processing.

Not really, it's a percpu refcnt. Basically the memcg's
percpu_ref_tryget* is replaced with kmem_cache's percpu_ref_tryget,
so, no additional processing.
