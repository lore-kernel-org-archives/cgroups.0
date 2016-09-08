From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [PATCH -v3 03/10] mm, memcg: Support to charge/uncharge multiple
 swap entries
Date: Thu, 08 Sep 2016 13:58:36 +0530
Message-ID: <57D12134.40604@linux.vnet.ibm.com>
References: <1473266769-2155-1-git-send-email-ying.huang@intel.com> <1473266769-2155-4-git-send-email-ying.huang@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1473266769-2155-4-git-send-email-ying.huang@intel.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Huang, Ying" <ying.huang@intel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: tim.c.chen@intel.com, dave.hansen@intel.com, andi.kleen@intel.com, aaron.lu@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Vladimir Davydov <vdavydov@virtuozzo.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org

On 09/07/2016 10:16 PM, Huang, Ying wrote:
> From: Huang Ying <ying.huang@intel.com>
> 
> This patch make it possible to charge or uncharge a set of continuous
> swap entries in the swap cgroup.  The number of swap entries is
> specified via an added parameter.
> 
> This will be used for the THP (Transparent Huge Page) swap support.
> Where a swap cluster backing a THP may be allocated and freed as a
> whole.  So a set of continuous swap entries (512 on x86_64) backing one

Please use HPAGE_SIZE / PAGE_SIZE instead of hard coded number like 512.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
