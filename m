From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v2 0/7] mm: pages for hugetlb's overcommit may be able to
 charge to memcg
Date: Tue, 22 May 2018 13:28:30 -0700
Message-ID: <5c32a05e-da2e-84b8-3435-4cd5f8a1f0f9@oracle.com>
References: <e863529b-7ce5-4fbe-8cff-581b5789a5f9@ascade.co.jp>
 <240f1b14-ed7d-4983-6c52-be4899d4caa5@oracle.com>
 <8711fed5-fc35-a11a-3a17-740a9dca1f2a@ascade.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2017-10-26;
 bh=nejuSqe2DUTcwHUGYJa1QQhWa0q7LOwFVJP5QjpN7ek=;
 b=J+ObywwCY6k93UmaPVod27GNGoAUtZGL/E1Br+vXqpC/QsJ2VdgAJ+kVbeCgDD8TAY+A
 O6rFAV3Q2JeygMPmHuK/pRSaDs0ZxWTjkJQlME6qZ6I7D5M/Cce95AaSOCYW+9Akb0Rt
 W8F58JuZP1a1dJZcOzWv7dc+fgVd7zuVsRHXIuqJBUBKN3aayIBTrYBqng34Ykpz6qfW
 Zfjit6kZ/ieJ9gYOGxnPfsdpv4ho+gCpjiN3BYcjrpYsvf0NPaGJUVFjaKP6tV90MOOt
 CzAn6FLdpiIMSbxyKlOpYwBjWSMguVN2rwiC9LijnNHv8WvTdkOEo6ufW31SkNO1f+NK PA== 
In-Reply-To: <8711fed5-fc35-a11a-3a17-740a9dca1f2a@ascade.co.jp>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: TSUKADA Koutaro <tsukada@ascade.co.jp>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jonathan Corbet <corbet@lwn.net>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, David Rientjes <rientjes@google.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, Marc-Andre Lureau <marcandre.lureau@redhat.com>, Punit Agrawal <punit.agrawal@arm.com>, Dan Williams <dan.j.williams@intel.com>, Vlastimil Babka <vbabka@suse.cz>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgrou

On 05/22/2018 06:04 AM, TSUKADA Koutaro wrote:
> 
> I stared at the commit log of mm/hugetlb_cgroup.c, but it did not seem to
> have specially considered of surplus hugepages. Later, I will send a mail
> to hugetlb cgroup's committer to ask about surplus hugepages charge
> specifications.
> 

I went back and looked at surplus huge page allocation.  Previously, I made
a statement that the hugetlb controller accounts for surplus huge pages.
Turns out that may not be 100% correct.

Thanks to Michal, all surplus huge page allocation is performed via the
alloc_surplus_huge_page() routine.  This will ultimately call into the
buddy allocator without any cgroup charges.  Calls to alloc_surplus_huge_page
are made from:
- alloc_huge_page() when allocating a huge page to a mapping/file.  In this
  case, appropriate calls to the hugetlb controller are in place.  So, any
  limits are enforced here.
- gather_surplus_pages() when allocating and setting aside 'reserved' huge
  pages. No accounting is performed here.  Do note that in this case the
  allocated huge pages are not assigned to the mapping/file.  Even though
  'reserved', they are deposited into the global pool and also counted as
  'free'.  When these reserved pages are ultimately used to populate a
  file/mapping, the code path goes through alloc_huge_page() where appropriate
  calls to the hugetlb controller are in place.

So, the bottom line is that surplus huge pages are not accounted for when
they are allocated as 'reserves'.  It is not until these reserves are actually
used that accounting limits are checked.  This 'seems' to align with general
allocation of huge pages within the pool.  No accounting is done until they
are actually allocated to a mapping/file.

-- 
Mike Kravetz
