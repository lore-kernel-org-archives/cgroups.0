From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v3 13/28] slub: create duplicate cache
Date: Tue, 29 May 2012 21:05:45 +0400
Message-ID: <4FC501E9.60607@parallels.com>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-14-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205290932530.4666@router.home> <4FC4F1A7.2010206@parallels.com> <alpine.DEB.2.00.1205291101580.6723@router.home>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.00.1205291101580.6723@router.home>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>, Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@cs.helsinki.fi>

On 05/29/2012 08:05 PM, Christoph Lameter wrote:
> On Tue, 29 May 2012, Glauber Costa wrote:
>
>> Accounting pages seems just crazy to me. If new allocators come in the future,
>> organizing the pages in a different way, instead of patching it here and
>> there, we need to totally rewrite this.
>
> Quite to the contrary. We could either pass a THIS_IS_A_SLAB page flag to
> the page allocator call or have a special call that does the accounting
> and then calls the page allocator. The code could be completely in
> cgroups. There would be no changes to the allocators aside from setting
> the flag or calling the alternate page allocator functions.

Again: for the page allocation itself, we could do it. (maybe we still 
can, keeping the rest of the approach, so as to simplify that particular 
piece of code, and reduce the churn inside the cache - I am all for it)

But that only solves the page allocation part. I would still need to 
make sure the caller is directed to the right page.

>>> Why do you need to increase the refcount? You made a full copy right?
>>
>> Yes, but I don't want this copy to go away while we have other caches around.
>
> You copied all metadata so what is there that you would still need should
> the other copy go away?

Well, consistency being one, because it sounded weird to have the parent 
cache being deleted while the kids are around. You wouldn't be able to 
reach them, for once.

But one can argue that if you deleted the cache, why would you want to 
ever reach it?

I can try to remove the refcount.

>
>> So, in the memcg internals, I used a different reference counter, to avoid
>> messing with this one. I could use that, and leave the original refcnt alone.
>> Would you prefer this?
>
> The refcounter is really not the issue.
>
> I am a bit worried about the various duplicate features here and there.
> The approach is not tightened down yet.

Well, I still think that duplication of the structure is better - a lot 
less intrusive - than messing with the cache internals.

I will try to at least have the page accounting done in a consistent 
way. How about that?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
