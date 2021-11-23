From: Muchun Song <songmuchun@bytedance.com>
Subject: Re: [PATCH v8] hugetlb: Add hugetlb.*.numa_stat file
Date: Tue, 23 Nov 2021 10:36:48 +0800
Message-ID: <CAMZfGtVe9oeqz-E2kquodD6JPvt=2qkpU4E0T6OgSu4_3PXQhA@mail.gmail.com>
References: <20211123001020.4083653-1-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nTPvXtzHv6HZ++mcRaXSOv1XKXnEa9rG+SSlC7lYWhE=;
        b=bHQq0Hd9I+/x8g1ZiZ0Z02M8FM3ZseM/4YkRg0DgwRAubOxI1F66GBSSnLposQ8q4Y
         ZM0VPxfaLVAhZuZw4o9hBxpIt8KQSF3bp39N5GJlruPuG9tmzZGTUvjFK39kInRaraMF
         7rwRsQKa4eu8zoZeZpq+NT+Wc6ZCWPxsHKnsf7Etw+JKv0aHa6BQ4gR3yjYGPvqRyD0r
         lsTm+CQQZ6wOPt5sNrS35Niz2aKBkxQ82ky0RbYVnCYKTNTMVM0rLM40UaLtTSNSxU1n
         VnqNWPUsrC9P9yN1kZh8AnqaIvybNdmzYY6Wm9B0BU9lYhN5bDHT5XVpKPD84TjCOUjU
         HrYA==
In-Reply-To: <20211123001020.4083653-1-almasrymina@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Mina Almasry <almasrymina@google.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, Oscar Salvador <osalvador@suse.de>, Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, Shakeel Butt <shakeelb@google.com>, Jue Wang <juew@google.com>, Yang Yao <ygyao@google.com>, Joanna Li <joannali@google.com>, Cannon Matthews <cannonmatthews@google.com>, Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org

On Tue, Nov 23, 2021 at 8:10 AM Mina Almasry <almasrymina@google.com> wrote=
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

Reviewed-by: Muchun Song <songmuchun@bytedance.com>
