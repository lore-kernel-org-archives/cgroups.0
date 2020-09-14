From: Muchun Song <songmuchun@bytedance.com>
Subject: Re: [External] Re: [PATCH v3] mm: memcontrol: Add the missing
 numa_stat interface for cgroup v2
Date: Mon, 14 Sep 2020 11:10:24 +0800
Message-ID: <CAMZfGtVBFCodKuNKzG8TxKjeuC1_hF_YKdqMTmX5ENE_FfDmzw@mail.gmail.com>
References: <20200913070010.44053-1-songmuchun@bytedance.com> <20200913170913.GB2239582@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NOjlPnEGfverOe/NjTfHJ965zGyyw9hgsDwthm8fBO8=;
        b=uWCczg2zelk3J2BSLQ0zws70nqO2Qrj0gvnO2vtQuHmsmUewjkzP6BOyKhWOf7bsi8
         UxCD19k7Z758PpS4M50tNgLTQwxa9bOY8iPkIfDyrjLrEFk4nSL8nUc3ffp6wzJc6nsb
         E03dGwR/aCB100q8leNRNfS4ITrdZTJe/8y1gqWskcEYHWYUhYK8GHzuPEWBD7TsiZyg
         kt40GXGfTlyabPEXkpvLvGwXQ3qPFXMzZ/uipyK3nqbnpikV+i+cl3SF6sBhLbbMLdyH
         7wQVgvUgWfQqg7oH4zJ5tY3mT6tIDnAqP4SAPXwI1/t1YyF1qL/qRE9vxh1J8fzllJG9
         vmmQ==
In-Reply-To: <20200913170913.GB2239582@chrisdown.name>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: tj@kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, corbet@lwn.net, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <guro@fb.com>, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, kernel test robot <lkp@intel.com>

On Mon, Sep 14, 2020 at 1:09 AM Chris Down <chris@chrisdown.name> wrote:
>
> Muchun Song writes:
> >In the cgroup v1, we have a numa_stat interface. This is useful for
> >providing visibility into the numa locality information within an
> >memcg since the pages are allowed to be allocated from any physical
> >node. One of the use cases is evaluating application performance by
> >combining this information with the application's CPU allocation.
> >But the cgroup v2 does not. So this patch adds the missing information.
> >
> >Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> >Suggested-by: Shakeel Butt <shakeelb@google.com>
> >Reported-by: kernel test robot <lkp@intel.com>
>
> This is a feature patch, why does this have LKP's Reported-by?

In the v2 version, the kernel test robot reported a compiler error
on the powerpc architecture. So I added that. Thanks.

-- 
Yours,
Muchun
