From: Christoph Lameter <cl@linux.com>
Subject: Re: [RFC 2/6] mm, mempolicy: stop adjusting current->il_next in
 mpol_rebind_nodemask()
Date: Tue, 11 Apr 2017 12:32:29 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1704111227080.25069@east.gentwo.org>
References: <20170411140609.3787-1-vbabka@suse.cz> <20170411140609.3787-3-vbabka@suse.cz>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170411140609.3787-3-vbabka@suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@kernel.org>, Mel Gorman <mgorman@techsingularity.net>, David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

On Tue, 11 Apr 2017, Vlastimil Babka wrote:

> The task->il_next variable remembers the last allocation node for task's
> MPOL_INTERLEAVE policy. mpol_rebind_nodemask() updates interleave and
> bind mempolicies due to changing cpuset mems. Currently it also tries to
> make sure that current->il_next is valid within the updated nodemask. This is
> bogus, because 1) we are updating potentially any task's mempolicy, not just
> current, and 2) we might be updating per-vma mempolicy, not task one.
>
> The interleave_nodes() function that uses il_next can cope fine with the value
> not being within the currently allowed nodes, so this hasn't manifested as an
> actual issue. Thus it also won't be an issue if we just remove this adjustment
> completely.

Well, interleave_nodes() will then potentially return a node outside of
the allowed memory policy when its called for the first time after
mpol_rebind_.. . But thenn it will find the next node within the
nodemask and work correctly for the next invocations.

But yea the race can probably be ignored. The idea was that the
application has a stable memory footprint during rebinding.


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
