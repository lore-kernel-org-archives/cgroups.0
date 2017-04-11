From: Christoph Lameter <cl@linux.com>
Subject: Re: [RFC 1/6] mm, page_alloc: fix more premature OOM due to race
 with cpuset update
Date: Tue, 11 Apr 2017 12:24:25 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1704111152170.25069@east.gentwo.org>
References: <20170411140609.3787-1-vbabka@suse.cz> <20170411140609.3787-2-vbabka@suse.cz>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170411140609.3787-2-vbabka@suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@kernel.org>, Mel Gorman <mgorman@techsingularity.net>, David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

On Tue, 11 Apr 2017, Vlastimil Babka wrote:

> The root of the problem is that the cpuset's mems_allowed and mempolicy's
> nodemask can temporarily have no intersection, thus get_page_from_freelist()
> cannot find any usable zone. The current semantic for empty intersection is to
> ignore mempolicy's nodemask and honour cpuset restrictions. This is checked in
> node_zonelist(), but the racy update can happen after we already passed the

The fallback was only intended for a cpuset on which boundaries are not enforced
in critical conditions (softwall). A hardwall cpuset (CS_MEM_HARDWALL)
should fail the allocation.

> This patch fixes the issue by having __alloc_pages_slowpath() check for empty
> intersection of cpuset and ac->nodemask before OOM or allocation failure. If
> it's indeed empty, the nodemask is ignored and allocation retried, which mimics
> node_zonelist(). This works fine, because almost all callers of

Well that would need to be subject to the hardwall flag. Allocation needs
to fail for a hardwall cpuset.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
