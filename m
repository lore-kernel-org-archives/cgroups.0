From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v2 0/7] mm: pages for hugetlb's overcommit may be able to
 charge to memcg
Date: Mon, 21 May 2018 11:07:33 -0700
Message-ID: <240f1b14-ed7d-4983-6c52-be4899d4caa5@oracle.com>
References: <e863529b-7ce5-4fbe-8cff-581b5789a5f9@ascade.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2017-10-26;
 bh=1wf3KeyppGF4/3KI0g3XffKODpcIeRdHG/6y6ba7EOw=;
 b=qLFPSzognmIDl5HhGZH/x5OeL6qvIjC7C3wYluBXXig7EsSWOVfNbI0pjes5rZqMgCdc
 k6U4HW1uuOb5aLL4T6MN3g+ONq1pHoW3W8x0LrZTL7b9J/KgNK2qSMqj7YW/CfPcx1aR
 VhfUdsS89JNXd15mWTLkJgass0ibpHqgb1XUlRSMTovAwpzNk8mGaVZPt/VckMOFcO3D
 3md8tGqIBXl7pQW8V+4xck7Bj7PxB+E4zh/Uyl1tzHsJBkRPWe8sjBn53JSyUpktWGNz
 EJgvtSYa8s/Hd8dDE++OtHur+OK/yMiiQlBWEkrBdqTqtO9zIIs0NieglD7vFAhoihwb 7A== 
In-Reply-To: <e863529b-7ce5-4fbe-8cff-581b5789a5f9@ascade.co.jp>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: TSUKADA Koutaro <tsukada@ascade.co.jp>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jonathan Corbet <corbet@lwn.net>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, David Rientjes <rientjes@google.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, Marc-Andre Lureau <marcandre.lureau@redhat.com>, Punit Agrawal <punit.agrawal@arm.com>, Dan Williams <dan.j.williams@intel.com>, Vlastimil Babka <vbabka@suse.cz>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On 05/17/2018 09:27 PM, TSUKADA Koutaro wrote:
> Thanks to Mike Kravetz for comment on the previous version patch.
> 
> The purpose of this patch-set is to make it possible to control whether or
> not to charge surplus hugetlb pages obtained by overcommitting to memory
> cgroup. In the future, I am trying to accomplish limiting the memory usage
> of applications that use both normal pages and hugetlb pages by the memory
> cgroup(not use the hugetlb cgroup).
> 
> Applications that use shared libraries like libhugetlbfs.so use both normal
> pages and hugetlb pages, but we do not know how much to use each. Please
> suppose you want to manage the memory usage of such applications by cgroup
> How do you set the memory cgroup and hugetlb cgroup limit when you want to
> limit memory usage to 10GB?
> 
> If you set a limit of 10GB for each, the user can use a total of 20GB of
> memory and can not limit it well. Since it is difficult to estimate the
> ratio used by user of normal pages and hugetlb pages, setting limits of 2GB
> to memory cgroup and 8GB to hugetlb cgroup is not very good idea. In such a
> case, I thought that by using my patch-set, we could manage resources just
> by setting 10GB as the limit of memory cgoup(there is no limit to hugetlb
> cgroup).
> 
> In this patch-set, introduce the charge_surplus_huge_pages(boolean) to
> struct hstate. If it is true, it charges to the memory cgroup to which the
> task that obtained surplus hugepages belongs. If it is false, do nothing as
> before, and the default value is false. The charge_surplus_huge_pages can
> be controlled procfs or sysfs interfaces.
> 
> Since THP is very effective in environments with kernel page size of 4KB,
> such as x86, there is no reason to positively use HugeTLBfs, so I think
> that there is no situation to enable charge_surplus_huge_pages. However, in
> some distributions such as arm64, the page size of the kernel is 64KB, and
> the size of THP is too huge as 512MB, making it difficult to use. HugeTLBfs
> may support multiple huge page sizes, and in such a special environment
> there is a desire to use HugeTLBfs.

One of the basic questions/concerns I have is accounting for surplus huge
pages in the default memory resource controller.  The existing huegtlb
resource controller already takes hugetlbfs huge pages into account,
including surplus pages.  This series would allow surplus pages to be
accounted for in the default  memory controller, or the hugetlb controller
or both.

I understand that current mechanisms do not meet the needs of the above
use case.  The question is whether this is an appropriate way to approach
the issue.  My cgroup experience and knowledge is extremely limited, but
it does not appear that any other resource can be controlled by multiple
controllers.  Therefore, I am concerned that this may be going against
basic cgroup design philosophy.

It would be good to get comments from people more cgroup knowledgeable,
and especially from those involved in the decision to do separate hugetlb
control.

-- 
Mike Kravetz

> 
> The patch set is for 4.17.0-rc3+. I don't know whether patch-set are
> acceptable or not, so I just done a simple test.
> 
> Thanks,
> Tsukada
> 
> TSUKADA Koutaro (7):
>   hugetlb: introduce charge_surplus_huge_pages to struct hstate
>   hugetlb: supports migrate charging for surplus hugepages
>   memcg: use compound_order rather than hpage_nr_pages
>   mm, sysctl: make charging surplus hugepages controllable
>   hugetlb: add charge_surplus_hugepages attribute
>   Documentation, hugetlb: describe about charge_surplus_hugepages
>   memcg: supports movement of surplus hugepages statistics
> 
>  Documentation/vm/hugetlbpage.txt |    6 +
>  include/linux/hugetlb.h          |    4 +
>  kernel/sysctl.c                  |    7 +
>  mm/hugetlb.c                     |  148 +++++++++++++++++++++++++++++++++++++++
>  mm/memcontrol.c                  |  109 +++++++++++++++++++++++++++-
>  5 files changed, 269 insertions(+), 5 deletions(-)
> 
