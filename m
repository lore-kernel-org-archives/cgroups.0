From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC 2/6] mm, mempolicy: stop adjusting current->il_next in
 mpol_rebind_nodemask()
Date: Tue, 11 Apr 2017 21:03:53 +0200
Message-ID: <9665a022-197a-4b02-8813-66aca252f0f9@suse.cz>
References: <20170411140609.3787-1-vbabka@suse.cz>
 <20170411140609.3787-3-vbabka@suse.cz>
 <alpine.DEB.2.20.1704111227080.25069@east.gentwo.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1704111227080.25069-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

On 11.4.2017 19:32, Christoph Lameter wrote:
> On Tue, 11 Apr 2017, Vlastimil Babka wrote:
> 
>> The task->il_next variable remembers the last allocation node for task's
>> MPOL_INTERLEAVE policy. mpol_rebind_nodemask() updates interleave and
>> bind mempolicies due to changing cpuset mems. Currently it also tries to
>> make sure that current->il_next is valid within the updated nodemask. This is
>> bogus, because 1) we are updating potentially any task's mempolicy, not just
>> current, and 2) we might be updating per-vma mempolicy, not task one.
>>
>> The interleave_nodes() function that uses il_next can cope fine with the value
>> not being within the currently allowed nodes, so this hasn't manifested as an
>> actual issue. Thus it also won't be an issue if we just remove this adjustment
>> completely.
> 
> Well, interleave_nodes() will then potentially return a node outside of
> the allowed memory policy when its called for the first time after
> mpol_rebind_.. . But thenn it will find the next node within the
> nodemask and work correctly for the next invocations.

Hmm, you're right. But that could be easily fixed if il_next became il_prev, so
we would return the result of next_node_in(il_prev) and also store it as the new
il_prev, right? I somehow assumed it already worked that way.

> But yea the race can probably be ignored. The idea was that the
> application has a stable memory footprint during rebinding.


