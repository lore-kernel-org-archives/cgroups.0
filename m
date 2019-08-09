From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [RFC PATCH v2 0/5] hugetlb_cgroup: Add hugetlb_cgroup reservation
 limits
Date: Fri, 9 Aug 2019 10:54:44 -0700
Message-ID: <f0a5afe9-2586-38c9-9a6d-8a2b7b288b50@oracle.com>
References: <20190808231340.53601-1-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=BIZJ8s9VWMSHzLAmHEjdX/xl2iyn2dtlXxgsI9RWSag=;
 b=b/m9aXWdVCJLg8mbuczqSBp03AvKIfgtHPMb9MdszRXG57gCF0QeOC8x/UFYYOsnAx5c
 ljkmFUzvrpBvLmR9/R4JKHRezPLovTu/h1x7clREgVokVo+B6WmV4betutdzX01lzvOC
 DZ7X5vvSBE7mV3edFQSAMN/mK13xiYM/EJdfWFq77NKZS20OpsLu7uqzXgsT3PWVaCFS
 zmMADnM9NgwcfE6PlhaadJ8RdZ5DJVtU77dN7JqwM+hGDhQr5lTaI8bhhFNhn8N9y9P6
 YAeg8gIGpihtJz+CZTi38w/jun5NwKk1IaydvqChXvjBlWTELZ3pyf1UF9uewzdM5ViP Iw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=BIZJ8s9VWMSHzLAmHEjdX/xl2iyn2dtlXxgsI9RWSag=;
 b=D0pz9qIehlbVBpUKr1uUJgaq3OBCscE1NJ4uiLmUb5tREbOV0Bm2B1c6e+hgtkah6PBD
 ANv/kvw4q1IuyqM8T3/nzrf82NSfONja/P7kjtpaTkgxs4QbRkalgYqVwfEWDlKgf+fj
 mLkggSa8Mnoj49hppTkHhNntvBAHyY1NKyMqKXlIL42rc2NELErCjQSCINzMNzdw6Djn
 z/pogYq7opVYtUcmuCzqEEogy/48lKcJSuGNgE7y1y58qZFZPDeDSl1p4eNagAmMmRC+
 Hs4gFhzcae+b0lEsaTKCiGCPlNN1utvBgM9ldt2r32l8HsDGBxAOianucwSuArWDKKao 0Q== 
In-Reply-To: <20190808231340.53601-1-almasrymina@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Mina Almasry <almasrymina@google.com>
Cc: shuah@kernel.org, rientjes@google.com, shakeelb@google.com, gthelen@google.com, akpm@linux-foundation.org, khalid.aziz@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, cgroups@vger.kernel.org

(+CC  Michal Koutn=C3=BD, cgroups@vger.kernel.org, Aneesh Kumar)

On 8/8/19 4:13 PM, Mina Almasry wrote:
> Problem:
> Currently tasks attempting to allocate more hugetlb memory than is availa=
ble get
> a failure at mmap/shmget time. This is thanks to Hugetlbfs Reservations [=
1].
> However, if a task attempts to allocate hugetlb memory only more than its
> hugetlb_cgroup limit allows, the kernel will allow the mmap/shmget call,
> but will SIGBUS the task when it attempts to fault the memory in.
>=20
> We have developers interested in using hugetlb_cgroups, and they have exp=
ressed
> dissatisfaction regarding this behavior. We'd like to improve this
> behavior such that tasks violating the hugetlb_cgroup limits get an error=
 on
> mmap/shmget time, rather than getting SIGBUS'd when they try to fault
> the excess memory in.
>=20
> The underlying problem is that today's hugetlb_cgroup accounting happens
> at hugetlb memory *fault* time, rather than at *reservation* time.
> Thus, enforcing the hugetlb_cgroup limit only happens at fault time, and
> the offending task gets SIGBUS'd.
>=20
> Proposed Solution:
> A new page counter named hugetlb.xMB.reservation_[limit|usage]_in_bytes. =
This
> counter has slightly different semantics than
> hugetlb.xMB.[limit|usage]_in_bytes:
>=20
> - While usage_in_bytes tracks all *faulted* hugetlb memory,
> reservation_usage_in_bytes tracks all *reserved* hugetlb memory.
>=20
> - If a task attempts to reserve more memory than limit_in_bytes allows,
> the kernel will allow it to do so. But if a task attempts to reserve
> more memory than reservation_limit_in_bytes, the kernel will fail this
> reservation.
>=20
> This proposal is implemented in this patch, with tests to verify
> functionality and show the usage.

Thanks for taking on this effort Mina.

Before looking at the details of the code, it might be helpful to discuss
the expected semantics of the proposed reservation limits.

I see you took into account the differences between private and shared
mappings.  This is good, as the reservation behavior is different for each
of these cases.  First let's look at private mappings.

For private mappings, the reservation usage will be the size of the mapping.
This should be fairly simple.  As reservations are consumed in the hugetlbfs
code, reservations in the resv_map are removed.  I see you have a hook into
region_del.  So, the expectation is that as reservations are consumed the
reservation usage will drop for the cgroup.  Correct?
The only tricky thing about private mappings is COW because of fork.  Curre=
nt
reservation semantics specify that all reservations stay with the parent.
If child faults and can not get page, SIGBUS.  I assume the new reservation
limits will work the same.

I believe tracking reservations for shared mappings can get quite complicat=
ed.
The hugetlbfs reservation code around shared mappings 'works' on the basis
that shared mapping reservations are global.  As a result, reservations are
more associated with the inode than with the task making the reservation.
For example, consider a file of size 4 hugetlb pages.
Task A maps the first 2 pages, and 2 reservations are taken.  Task B maps
all 4 pages, and 2 additional reservations are taken.  I am not really sure
of the desired semantics here for reservation limits if A and B are in sepa=
rate
cgroups.  Should B be charged for 4 or 2 reservations?
Also in the example above, after both tasks create their mappings suppose
Task B faults in the first page.  Does the reservation usage of Task A go
down as it originally had the reservation?

It should also be noted that when hugetlbfs reservations are 'consumed' for
shared mappings there are no changes to the resv_map.  Rather the unmap code
compares the contents of the page cache to the resv_map to determine how
many reservations were actually consumed.  I did not look close enough to
determine the code drops reservation usage counts as pages are added to sha=
red
mappings.

--=20
Mike Kravetz
