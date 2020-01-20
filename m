From: Wei Yang <richardw.yang@linux.intel.com>
Subject: Re: [Patch v4] mm: thp: remove the defer list related code since
 this will not happen
Date: Mon, 20 Jan 2020 16:17:10 +0800
Message-ID: <20200120081710.GA18028@richard>
References: <20200117233836.3434-1-richardw.yang@linux.intel.com>
 <20200118145421.0ab96d5d9bea21a3339d52fe@linux-foundation.org>
 <alpine.DEB.2.21.2001181525250.27051@chino.kir.corp.google.com>
 <20200120072237.GA18451@dhcp22.suse.cz>
Reply-To: Wei Yang <richardw.yang@linux.intel.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200120072237.GA18451@dhcp22.suse.cz>
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Wei Yang <richardw.yang@linux.intel.com>, hannes@cmpxchg.org, vdavydov.dev@gmail.com, ktkhai@virtuozzo.com, kirill.shutemov@linux.intel.com, yang.shi@linux.alibaba.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, alexander.duyck@gmail.com, stable@vger.kernel.org

On Mon, Jan 20, 2020 at 08:22:37AM +0100, Michal Hocko wrote:
>On Sat 18-01-20 15:36:06, David Rientjes wrote:
>> On Sat, 18 Jan 2020, Andrew Morton wrote:
>> 
>> > On Sat, 18 Jan 2020 07:38:36 +0800 Wei Yang <richardw.yang@linux.intel.com> wrote:
>> > 
>> > > If compound is true, this means it is a PMD mapped THP. Which implies
>> > > the page is not linked to any defer list. So the first code chunk will
>> > > not be executed.
>> > > 
>> > > Also with this reason, it would not be proper to add this page to a
>> > > defer list. So the second code chunk is not correct.
>> > > 
>> > > Based on this, we should remove the defer list related code.
>> > > 
>> > > Fixes: 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg aware")
>> > > 
>> > > Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
>> > > Suggested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>> > > Cc: <stable@vger.kernel.org>    [5.4+]
>> > 
>> > This patch is identical to "mm: thp: grab the lock before manipulating
>> > defer list", which is rather confusing.  Please let people know when
>> > this sort of thing is done.
>> > 
>> > The earlier changelog mentioned a possible race condition.  This
>> > changelog does not.  In fact this changelog fails to provide any
>> > description of any userspace-visible runtime effects of the bug. 
>> > Please send along such a description for inclusion, as always.
>> > 
>> 
>> The locking concern that Wei was originally looking at is no longer an 
>> issue because we determined that the code in question could simply be 
>> removed.
>> 
>> I think the following can be added to the changelog:
>> 
>> ----->o-----
>> 
>> When migrating memcg charges of thp memory, there are two possibilities:
>> 
>>  (1) The underlying compound page is mapped by a pmd and thus does is not 
>>      on a deferred split queue (it's mapped), or
>> 
>>  (2) The compound page is not mapped by a pmd and is awaiting split on a
>>      deferred split queue.
>> 
>> The current charge migration implementation does *not* migrate charges for 
>> thp memory on the deferred split queue, it only migrates charges for pages 
>> that are mapped by a pmd.
>> 
>> Thus, to migrate charges, the underlying compound page cannot be on a 
>> deferred split queue; no list manipulation needs to be done in 
>> mem_cgroup_move_account().
>> 
>> With the current code, the underlying compound page is moved to the 
>> deferred split queue of the memcg its memory is not charged to, so 
>> susbequent reclaim will consider these pages for the wrong memcg.  Remove 
>> the deferred split queue handling in mem_cgroup_move_account() entirely.
>
>I believe this still doesn't describe the underlying problem to the full
>extent. What happens with the page on the deferred list when it
>shouldn't be there in fact? Unless I am missing something deferred_split_scan
>will simply split that huge page. Which is a bit unfortunate but nothing
>really critical. This should be mentioned in the changelog.
>

Per my understanding, if we do the split when it is not necessary, we
probably have a lower performance due to tlb miss. For others, I don't see the
impact.

>With that clarified, feel free to add
>
>Acked-by: Michal Hocko <mhocko@suse.com>
>
>-- 
>Michal Hocko
>SUSE Labs

-- 
Wei Yang
Help you, Help me
