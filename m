From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [RFC 2/6] mm, mempolicy: stop adjusting current->il_next in
 mpol_rebind_nodemask()
Date: Wed, 12 Apr 2017 23:18:53 +0200
Message-ID: <a750d0cb-9583-01bf-1bc4-870e785c7e07@suse.cz>
References: <20170411140609.3787-1-vbabka@suse.cz>
 <20170411140609.3787-3-vbabka@suse.cz>
 <alpine.DEB.2.20.1704111227080.25069@east.gentwo.org>
 <9665a022-197a-4b02-8813-66aca252f0f9@suse.cz>
 <97045760-77eb-c892-9bcb-daad10a1d91d@suse.cz>
 <alpine.DEB.2.20.1704121607520.28335@east.gentwo.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.20.1704121607520.28335@east.gentwo.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Lameter <cl@linux.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@kernel.org>, Mel Gorman <mgorman@techsingularity.net>, David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

On 12.4.2017 23:16, Christoph Lameter wrote:
> On Wed, 12 Apr 2017, Vlastimil Babka wrote:
> 
>>>> Well, interleave_nodes() will then potentially return a node outside of
>>>> the allowed memory policy when its called for the first time after
>>>> mpol_rebind_.. . But thenn it will find the next node within the
>>>> nodemask and work correctly for the next invocations.
>>>
>>> Hmm, you're right. But that could be easily fixed if il_next became il_prev, so
>>> we would return the result of next_node_in(il_prev) and also store it as the new
>>> il_prev, right? I somehow assumed it already worked that way.
> 
> Yup that makes sense and I thought about that when I saw the problem too.
> 
>> @@ -863,6 +856,18 @@ static int lookup_node(unsigned long addr)
>>  	return err;
>>  }
>>
>> +/* Do dynamic interleaving for a process */
>> +static unsigned interleave_nodes(struct mempolicy *policy, bool update_prev)
> 
> Why do you need an additional flag? Would it not be better to always
> update and switch the update_prev=false case to simply use
> next_node_in()?

Looked to me as better wrapping, but probably overengineered, ok. Will change
for v2.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
