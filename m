From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 02/11] memcg: Reclaim when more than one page needed.
Date: Tue, 26 Jun 2012 12:39:55 +0400
Message-ID: <4FE9755B.1040905@parallels.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-3-git-send-email-glommer@parallels.com> <CABCjUKD0h089StLF8BwVRU-St70Ai9PTw-cjis40_aLLG3MAQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <CABCjUKD0h089StLF8BwVRU-St70Ai9PTw-cjis40_aLLG3MAQQ@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Suleiman Souhlal <suleiman@google.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>

On 06/26/2012 03:33 AM, Suleiman Souhlal wrote:
> On Mon, Jun 25, 2012 at 7:15 AM, Glauber Costa <glommer@parallels.com> wrote:
>> From: Suleiman Souhlal <ssouhlal@FreeBSD.org>
>>
>> mem_cgroup_do_charge() was written before slab accounting, and expects
>> three cases: being called for 1 page, being called for a stock of 32 pages,
>> or being called for a hugepage.  If we call for 2 or 3 pages (and several
>> slabs used in process creation are such, at least with the debug options I
>> had), it assumed it's being called for stock and just retried without reclaiming.
>>
>> Fix that by passing down a minsize argument in addition to the csize.
>>
>> And what to do about that (csize == PAGE_SIZE && ret) retry?  If it's
>> needed at all (and presumably is since it's there, perhaps to handle
>> races), then it should be extended to more than PAGE_SIZE, yet how far?
>> And should there be a retry count limit, of what?  For now retry up to
>> COSTLY_ORDER (as page_alloc.c does), stay safe with a cond_resched(),
>> and make sure not to do it if __GFP_NORETRY.
>
> The commit description mentions COSTLY_ORDER, but it's not actually
> used in the patch.
>
> -- Suleiman
>
Yeah, forgot to update the changelog =(

But much more importantly, are you still happy with those changes?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
