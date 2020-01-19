From: Wei Yang <richardw.yang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [Patch v4] mm: thp: remove the defer list related code since
 this will not happen
Date: Sun, 19 Jan 2020 10:24:56 +0800
Message-ID: <20200119022456.GC9745@richard>
References: <20200117233836.3434-1-richardw.yang@linux.intel.com>
 <20200118145421.0ab96d5d9bea21a3339d52fe@linux-foundation.org>
 <alpine.DEB.2.21.2001181525250.27051@chino.kir.corp.google.com>
Reply-To: Wei Yang <richardw.yang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2001181525250.27051-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Wei Yang <richardw.yang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Jan 18, 2020 at 03:36:06PM -0800, David Rientjes wrote:
>On Sat, 18 Jan 2020, Andrew Morton wrote:
>
>> On Sat, 18 Jan 2020 07:38:36 +0800 Wei Yang <richardw.yang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
>> 
>> > If compound is true, this means it is a PMD mapped THP. Which implies
>> > the page is not linked to any defer list. So the first code chunk will
>> > not be executed.
>> > 
>> > Also with this reason, it would not be proper to add this page to a
>> > defer list. So the second code chunk is not correct.
>> > 
>> > Based on this, we should remove the defer list related code.
>> > 
>> > Fixes: 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg aware")
>> > 
>> > Signed-off-by: Wei Yang <richardw.yang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>> > Suggested-by: Kirill A. Shutemov <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>> > Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>    [5.4+]
>> 
>> This patch is identical to "mm: thp: grab the lock before manipulating
>> defer list", which is rather confusing.  Please let people know when
>> this sort of thing is done.
>> 
>> The earlier changelog mentioned a possible race condition.  This
>> changelog does not.  In fact this changelog fails to provide any
>> description of any userspace-visible runtime effects of the bug. 
>> Please send along such a description for inclusion, as always.
>> 
>
>The locking concern that Wei was originally looking at is no longer an 
>issue because we determined that the code in question could simply be 
>removed.
>
>I think the following can be added to the changelog:
>
>----->o-----
>
>When migrating memcg charges of thp memory, there are two possibilities:
>
> (1) The underlying compound page is mapped by a pmd and thus does is not 
>     on a deferred split queue (it's mapped), or
>
> (2) The compound page is not mapped by a pmd and is awaiting split on a
>     deferred split queue.
>
>The current charge migration implementation does *not* migrate charges for 
>thp memory on the deferred split queue, it only migrates charges for pages 
>that are mapped by a pmd.
>
>Thus, to migrate charges, the underlying compound page cannot be on a 
>deferred split queue; no list manipulation needs to be done in 
>mem_cgroup_move_account().
>
>With the current code, the underlying compound page is moved to the 
>deferred split queue of the memcg its memory is not charged to, so 
>susbequent reclaim will consider these pages for the wrong memcg.  Remove 
>the deferred split queue handling in mem_cgroup_move_account() entirely.
>
>----->o-----
>
>Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hi David,

The changlog looks awesome to me. Thanks ~

Hi Andrew

I see you queue this in you tree, do I need to rewrite a patch with better
changelog?

-- 
Wei Yang
Help you, Help me
