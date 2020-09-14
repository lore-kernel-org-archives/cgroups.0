From: Muchun Song <songmuchun@bytedance.com>
Subject: Re: [External] Re: [PATCH v3] mm: memcontrol: Add the missing
 numa_stat interface for cgroup v2
Date: Mon, 14 Sep 2020 11:28:09 +0800
Message-ID: <CAMZfGtVGRDCNm0oOpco+-uPjsx6+VyVrCwVRS4dKV2ZTbY-e+w@mail.gmail.com>
References: <20200913070010.44053-1-songmuchun@bytedance.com>
 <20200913170913.GB2239582@chrisdown.name> <CAMZfGtVBFCodKuNKzG8TxKjeuC1_hF_YKdqMTmX5ENE_FfDmzw@mail.gmail.com>
 <91184891-6a12-87a2-5a82-099a637b072f@huawei.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4kHmejXTIo1BBSLRENZgyqFfGzb/ylHsGPtQU3ORsGY=;
        b=qSowdt5PMPNIuUtYyjjVxXOB007fAprML0D9RLG01hggiBoUvwOyNQT+CB+AUUb69C
         Pc6o7Mnk2vhKMTjLgNpanvxjhxy12n3MbsrZ/gqVlxBp2pO+LF73GR00DawWKvKDEQsv
         INJmnpgtznXFsTnRJ8tPl4m3KAttaAVb/5EBaSasg3mXATRb/qHyV5IFUeU2QrDAOVbu
         QZNs8r67pQqpSQsotruFc6agNZUIRsmSIkmzxe1hrZWD8YD0gAfCg7B+Hp3gnZqSNQg8
         1wR3DvI5i/2fNqtA75uiMcFkcXEoRE0qzVYmtLhPvo7zAXgkliZi0O7BUNBe2LhOOGEn
         U0lQ==
In-Reply-To: <91184891-6a12-87a2-5a82-099a637b072f@huawei.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan@huawei.com>
Cc: Chris Down <chris@chrisdown.name>, tj@kernel.org, Johannes Weiner <hannes@cmpxchg.org>, corbet@lwn.net, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <guro@fb.com>, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, kernel test robot <lkp@intel.com>

On Mon, Sep 14, 2020 at 11:19 AM Zefan Li <lizefan@huawei.com> wrote:
>
> On 2020/9/14 11:10, Muchun Song wrote:
> > On Mon, Sep 14, 2020 at 1:09 AM Chris Down <chris@chrisdown.name> wrote:
> >>
> >> Muchun Song writes:
> >>> In the cgroup v1, we have a numa_stat interface. This is useful for
> >>> providing visibility into the numa locality information within an
> >>> memcg since the pages are allowed to be allocated from any physical
> >>> node. One of the use cases is evaluating application performance by
> >>> combining this information with the application's CPU allocation.
> >>> But the cgroup v2 does not. So this patch adds the missing information.
> >>>
> >>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> >>> Suggested-by: Shakeel Butt <shakeelb@google.com>
> >>> Reported-by: kernel test robot <lkp@intel.com>
> >>
> >> This is a feature patch, why does this have LKP's Reported-by?
> >
> > In the v2 version, the kernel test robot reported a compiler error
> > on the powerpc architecture. So I added that. Thanks.
> >
>
> You should remove this reported-by, and then add v2->v3 changelog:

Got it. I see Andrew has done it for me, thank him very much for
his work. He also added this patch to the -mm tree.

>
> ...original changelog...
>
> v3:
> - fixed something reported by test rebot

I already added that in the changelog. Thanks.


--
Yours,
Muchun
