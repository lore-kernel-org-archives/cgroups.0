From: TSUKADA Koutaro <tsukada@ascade.co.jp>
Subject: Re: [PATCH v2 0/7] mm: pages for hugetlb's overcommit may be able to
 charge to memcg
Date: Fri, 25 May 2018 10:55:58 +0900
Message-ID: <5943db59-1c33-7004-7574-fc07e577e1ee@ascade.co.jp>
References: <e863529b-7ce5-4fbe-8cff-581b5789a5f9@ascade.co.jp>
 <20180522135148.GA20441@dhcp22.suse.cz>
 <af1a3050-7365-428a-dfb1-2f3da37dc9ff@ascade.co.jp>
 <4078bc2d-4aaf-cd1b-0145-5915e382852f@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4078bc2d-4aaf-cd1b-0145-5915e382852f@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jonathan Corbet <corbet@lwn.net>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, David Rientjes <rientjes@google.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, Marc-Andre Lureau <marcandre.lureau@redhat.com>, Punit Agrawal <punit.agrawal@arm.com>, Dan Williams <dan.j.williams@intel.com>, Vlastimil Babka <vbabka@suse.cz>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgrou

On 2018/05/25 2:45, Mike Kravetz wrote:
[...]
>> THP does not guarantee to use the Huge Page, but may use the normal page.
> 
> Note.  You do not want to use THP because "THP does not guarantee".

[...]
>> One of the answers I have reached is to use HugeTLBfs by overcommitting
>> without creating a pool(this is the surplus hugepage).
> 
> Using hugetlbfs overcommit also does not provide a guarantee.  Without
> doing much research, I would say the failure rate for obtaining a huge
> page via THP and hugetlbfs overcommit is about the same.  The most
> difficult issue in both cases will be obtaining a "huge page" number of
> pages from the buddy allocator.

Yes. If do not support multiple size hugetlb pages such as x86, because
number of pages between THP and hugetlb is same, the failure rate of
obtaining a compound page is same, as you said.

> I really do not think hugetlbfs overcommit will provide any benefit over
> THP for your use case.

I think that what you say is absolutely right.

>  Also, new user space code is required to "fall back"
> to normal pages in the case of hugetlbfs page allocation failure.  This
> is not needed in the THP case.

I understand the superiority of THP, but there are scenes where khugepaged
occupies cpu due to page fragmentation. Instead of overcommit, setup a
persistent pool once, I think that hugetlb can be superior, such as memory
allocation performance exceeding THP. I will try to find a good way to use
hugetlb page.

I sincerely thank you for your help.

-- 
Thanks,
Tsukada

