From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [RFC 1/6] mm, page_alloc: fix more premature OOM due to race with
 cpuset update
Date: Thu, 13 Apr 2017 08:07:21 +0200
Message-ID: <3dc5ebcf-f8da-99ca-1bd4-6ee734382443@suse.cz>
References: <20170411140609.3787-1-vbabka@suse.cz>
 <20170411140609.3787-2-vbabka@suse.cz>
 <95469f35-56e9-7dc4-b7fd-a3e8c25bdff3@linux.vnet.ibm.com>
 <2dbcff3c-f0f1-b568-f98c-519dd98c6e63@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <2dbcff3c-f0f1-b568-f98c-519dd98c6e63@suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@kernel.org>, Mel Gorman <mgorman@techsingularity.net>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

On 04/13/2017 08:06 AM, Vlastimil Babka wrote:
>> Did you really mean node_zonelist() in both the instances above. Because
>> that function just picks up either FALLBACK_ZONELIST or NOFALLBACK_ZONELIST
>> depending upon the passed GFP flags in the allocation request and does not
>> deal with ignoring the passed nodemask.
> 
> Oops, I meant policy_zonelist(), thanks for noticing.

Nah, policy_nodemask()... I need coffee.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
