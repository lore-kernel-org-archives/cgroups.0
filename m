From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v8] hugetlb: Add hugetlb.*.numa_stat file
Date: Mon, 22 Nov 2021 19:30:21 -0800
Message-ID: <53ce6e47-109d-af25-25fc-151ddf512287@oracle.com>
References: <20211123001020.4083653-1-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=FJhRUVLF41IteNP30kjmIDQ0wvnfb7LrsYn2Y4FK0O8=;
 b=leWUqjA43YuNHTqWoFYWCDu1nOkEsWQP8lTGP7sc7bEp1fgQSNf2sj/7bZboGLdOJaUG
 tCAd+6kCY7Xy3/UrpbHffnxQvHbbgCnZHKOdOY7qLpSLMEqLo8WIGJpp6d9fawaiBMZa
 Pz5/nJBMN6br7DObjItS993ROv5+ya4Ci7ei52jQZwBqZE6flA3FHoItak3QqcZEWlF4
 ISYR56oBG0LXiz13nVGJKGAo7ZaB4pNQgB514Gyl0waSHKq8lM/HAfvR+UuXtXR0GmlD
 zM5W1oDAgMO1aQDSyxtkQeFgnj/Hbz/LQNHwgemZBmIxcpAbUoZyoWRNRV+K2vdao899 7w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FJhRUVLF41IteNP30kjmIDQ0wvnfb7LrsYn2Y4FK0O8=;
 b=mM7XUHVVgdFMpRfIH8cPtHHvwdy8nssQ/6AVNS8Pw7Q2eUVkGUJ4l0cxwQkG69up5m0lXsyntXV19zQ0216Ntv1+UnECxthtyt23HV4K/RSbeuc5phuKxQXIEMHOBWhnvEsJh5o21BSFtVlB7IIgjr93dkTBKmGS/RyYfWi+k8A=
Content-Language: en-US
In-Reply-To: <20211123001020.4083653-1-almasrymina@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Mina Almasry <almasrymina@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, Oscar Salvador <osalvador@suse.de>, Michal Hocko <mhocko@suse.com>, Muchun Song <songmuchun@bytedance.com>, David Rientjes <rientjes@google.com>, Shakeel Butt <shakeelb@google.com>, Jue Wang <juew@google.com>, Yang Yao <ygyao@google.com>, Joanna Li <joannali@google.com>, Cannon Matthews <cannonmatthews@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

On 11/22/21 16:10, Mina Almasry wrote:
> For hugetlb backed jobs/VMs it's critical to understand the numa
> information for the memory backing these jobs to deliver optimal
> performance.
>=20
> Currently this technically can be queried from /proc/self/numa_maps, but
> there are significant issues with that. Namely:
> 1. Memory can be mapped or unmapped.
> 2. numa_maps are per process and need to be aggregated across all
>    processes in the cgroup. For shared memory this is more involved as
>    the userspace needs to make sure it doesn't double count shared
>    mappings.
> 3. I believe querying numa_maps needs to hold the mmap_lock which adds
>    to the contention on this lock.
>=20
> For these reasons I propose simply adding hugetlb.*.numa_stat file,
> which shows the numa information of the cgroup similarly to
> memory.numa_stat.
>=20
> On cgroup-v2:
>    cat /sys/fs/cgroup/unified/test/hugetlb.2MB.numa_stat
>    total=3D2097152 N0=3D2097152 N1=3D0
>=20
> On cgroup-v1:
>    cat /sys/fs/cgroup/hugetlb/test/hugetlb.2MB.numa_stat
>    total=3D2097152 N0=3D2097152 N1=3D0
>    hierarichal_total=3D2097152 N0=3D2097152 N1=3D0
>=20
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
>=20
> Signed-off-by: Mina Almasry <almasrymina@google.com>
>=20

Thanks for continuing to update, this version looks good.

Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
--=20
Mike Kravetz
