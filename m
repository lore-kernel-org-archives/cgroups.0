From: TSUKADA Koutaro <tsukada@ascade.co.jp>
Subject: Re: [PATCH v2 0/7] mm: pages for hugetlb's overcommit may be able to
 charge to memcg
Date: Tue, 22 May 2018 21:56:42 +0900
Message-ID: <9456064b-3ae1-0234-a1fc-918708156b6a@ascade.co.jp>
References: <e863529b-7ce5-4fbe-8cff-581b5789a5f9@ascade.co.jp>
 <871se5ysbg.fsf@e105922-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <871se5ysbg.fsf@e105922-lin.cambridge.arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jonathan Corbet <corbet@lwn.net>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, David Rientjes <rientjes@google.com>, Mike Kravetz <mike.kravetz@oracle.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, Marc-Andre Lureau <marcandre.lureau@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Vlastimil Babka <vbabka@suse.cz>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgro

Hi Punit,

On 2018/05/21 23:52, Punit Agrawal wrote:
> Hi Tsukada,
> 
> I was staring at memcg code to better understand your changes and had
> the below thought.
> 
> TSUKADA Koutaro <tsukada@ascade.co.jp> writes:
> 
> [...]
> 
>> In this patch-set, introduce the charge_surplus_huge_pages(boolean) to
>> struct hstate. If it is true, it charges to the memory cgroup to which the
>> task that obtained surplus hugepages belongs. If it is false, do nothing as
>> before, and the default value is false. The charge_surplus_huge_pages can
>> be controlled procfs or sysfs interfaces.
> 
> Instead of tying the surplus huge page charging control per-hstate,
> could the control be made per-memcg?
> 
> This can be done by introducing a per-memory controller file in sysfs
> (memory.charge_surplus_hugepages?) that indicates whether surplus
> hugepages are to be charged to the controller and forms part of the
> total limit. IIUC, the limit already accounts for page and swap cache
> pages.
> 
> This would allow the control to be enabled per-cgroup and also keep the
> userspace control interface in one place.
> 
> As said earlier, I'm not familiar with memcg so the above might not be a
> feasible but think it'll lead to a more coherent user
> interface. Hopefully, more knowledgeable folks on the thread can chime
> in.
> 

Thank you for good advise.
As you mentioned, it is better to be able to control by per-memcg. After
organizing my thoughts, I will develop the next version patch-set that can
solve issues and challenge again.

Thanks,
Tsukada

> Thanks,
> Punit
> 
>> Since THP is very effective in environments with kernel page size of 4KB,
>> such as x86, there is no reason to positively use HugeTLBfs, so I think
>> that there is no situation to enable charge_surplus_huge_pages. However, in
>> some distributions such as arm64, the page size of the kernel is 64KB, and
>> the size of THP is too huge as 512MB, making it difficult to use. HugeTLBfs
>> may support multiple huge page sizes, and in such a special environment
>> there is a desire to use HugeTLBfs.
>>
>> The patch set is for 4.17.0-rc3+. I don't know whether patch-set are
>> acceptable or not, so I just done a simple test.
>>
>> Thanks,
>> Tsukada
>>
>> TSUKADA Koutaro (7):
>>   hugetlb: introduce charge_surplus_huge_pages to struct hstate
>>   hugetlb: supports migrate charging for surplus hugepages
>>   memcg: use compound_order rather than hpage_nr_pages
>>   mm, sysctl: make charging surplus hugepages controllable
>>   hugetlb: add charge_surplus_hugepages attribute
>>   Documentation, hugetlb: describe about charge_surplus_hugepages
>>   memcg: supports movement of surplus hugepages statistics
>>
>>  Documentation/vm/hugetlbpage.txt |    6 +
>>  include/linux/hugetlb.h          |    4 +
>>  kernel/sysctl.c                  |    7 +
>>  mm/hugetlb.c                     |  148 +++++++++++++++++++++++++++++++++++++++
>>  mm/memcontrol.c                  |  109 +++++++++++++++++++++++++++-
>>  5 files changed, 269 insertions(+), 5 deletions(-)


