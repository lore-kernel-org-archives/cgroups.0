From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v6 1/2] mm: memcontrol: Fix missing suffix of workingset_restore
Date: Wed, 16 Sep 2020 07:01:11 -0700
Message-ID: <CALvZod63j475FM1p_DLOEtKmjFZ=-RbGG0eL1zTH+j4VqCrAeg@mail.gmail.com>
References: <20200916100030.71698-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FRVhtc4HDJxT3tTI+nfU2Ow8g0YNTmg1aLTrLZ5GLkM=;
        b=IW54L6C4ApDTRtMrNEJ761WHUDzNh6f0cykv+LQNw3a0CjeHsQ5WSlC5Rdd1ExMO1N
         9cCPBei85IFqoJiNivM/NsFjjRh0jMmXkZvXl8+m0RgCRmfbb0TDaCnnF+l+ISliosij
         42xhIIF5dTIWSliQDXT+pkI5fyEf/ayHu3Oe+m5BM/34X2OuEb+ump86QIYqpwjOVL0Q
         utbl8fBVgonNijf4+Ewdp5i0r8yGAwtjnqQrqxGFjRKnjSlI1VxDbO2bQgpDvt96hDmy
         9e+2V7Ns6VSmkb05MGw2jc+JMVAoe/cs/p230z+fFQn8RLdvy+31kVUd7E1C0vbywnX1
         A1vw==
In-Reply-To: <20200916100030.71698-1-songmuchun@bytedance.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Randy Dunlap <rdunlap@infradead.org>, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>

On Wed, Sep 16, 2020 at 3:00 AM Muchun Song <songmuchun@bytedance.com> wrote:
>
> We forget to add the suffix to the workingset_restore string, so
> fix it. And also update the documentation of cgroup-v2.rst.
>
> Fixes: 170b04b7ae49 ("mm/workingset: prepare the workingset detection infrastructure for anon LRU")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
