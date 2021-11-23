From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v8] hugetlb: Add hugetlb.*.numa_stat file
Date: Mon, 22 Nov 2021 17:20:59 -0800
Message-ID: <CALvZod6gy6HNq5zmjwpOfG2K5RwCDnyBEPBr1wK8H6nk77UM9A@mail.gmail.com>
References: <20211123001020.4083653-1-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PZNVY9+03dEFejIwzLUj2PbaiVC1vy5FYIvkJizW4dQ=;
        b=CUvfp14TbL49LRiKzGVqTH2EYU63uY6IsAJcq5kvTwhdkLT5s1JIargoRqeM6fpkEm
         LFMO5UIM+oAVs07AlSdrpr5zZIJmQHqSz8d0xEHXO/6QkDzo2z7WN70mjVjOSjDPrQzj
         v3HALSn4twgfz2FdbNk6l4GBYfoaMWqi/YiSJ/Fu6tYQbVh5242dK3h+mJBxSnXlALUV
         uJO/eIlyVe5K1AjcEK8oqYVhOKsxWw0R5zowd15VsE7pqg/H2BnP7l9Twy/g6NY9H9HM
         TVNK7fFUbOP58/IGQeb+O9qHIHzn6fBXcmTk/GnDSf2zcFbrx8fsb+UEJrCrSF06DywY
         hIOA==
In-Reply-To: <20211123001020.4083653-1-almasrymina@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Mina Almasry <almasrymina@google.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, Oscar Salvador <osalvador@suse.de>, Michal Hocko <mhocko@suse.com>, Muchun Song <songmuchun@bytedance.com>, David Rientjes <rientjes@google.com>, Jue Wang <juew@google.com>, Yang Yao <ygyao@google.com>, Joanna Li <joannali@google.com>, Cannon Matthews <cannonmatthews@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

On Mon, Nov 22, 2021 at 4:10 PM Mina Almasry <almasrymina@google.com> wrote=
:
>
> For hugetlb backed jobs/VMs it's critical to understand the numa
> information for the memory backing these jobs to deliver optimal
> performance.
>
> Currently this technically can be queried from /proc/self/numa_maps, but
> there are significant issues with that. Namely:
> 1. Memory can be mapped or unmapped.
> 2. numa_maps are per process and need to be aggregated across all
>    processes in the cgroup. For shared memory this is more involved as
>    the userspace needs to make sure it doesn't double count shared
>    mappings.
> 3. I believe querying numa_maps needs to hold the mmap_lock which adds
>    to the contention on this lock.
>
> For these reasons I propose simply adding hugetlb.*.numa_stat file,
> which shows the numa information of the cgroup similarly to
> memory.numa_stat.
>
> On cgroup-v2:
>    cat /sys/fs/cgroup/unified/test/hugetlb.2MB.numa_stat
>    total=3D2097152 N0=3D2097152 N1=3D0
>
> On cgroup-v1:
>    cat /sys/fs/cgroup/hugetlb/test/hugetlb.2MB.numa_stat
>    total=3D2097152 N0=3D2097152 N1=3D0
>    hierarichal_total=3D2097152 N0=3D2097152 N1=3D0
>
> This patch was tested manually by allocating hugetlb memory and querying
> the hugetlb.*.numa_stat file of the cgroup and its parents.
> =EF=BF=BC
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Muchun Song <songmuchun@bytedance.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: Jue Wang <juew@google.com>
> Cc: Yang Yao <ygyao@google.com>
> Cc: Joanna Li <joannali@google.com>
> Cc: Cannon Matthews <cannonmatthews@google.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
>
> Signed-off-by: Mina Almasry <almasrymina@google.com>
>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
