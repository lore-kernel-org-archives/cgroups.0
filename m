From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v1] proc: Implement /proc/self/meminfo
Date: Wed, 16 Jun 2021 11:17:38 -0500
Message-ID: <87zgvpg4wt.fsf@disp2133>
References: <ac070cd90c0d45b7a554366f235262fa5c566435.1622716926.git.legion@kernel.org>
        <20210615113222.edzkaqfvrris4nth@wittgenstein>
        <20210615124715.nzd5we5tl7xc2n2p@example.org>
        <CALvZod7po_fK9JpcUNVrN6PyyP9k=hdcyRfZmHjSVE5r_8Laqw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CALvZod7po_fK9JpcUNVrN6PyyP9k=hdcyRfZmHjSVE5r_8Laqw@mail.gmail.com>
        (Shakeel Butt's message of "Tue, 15 Jun 2021 18:09:49 -0700")
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Alexey Gladkov <legion@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux.dev>, Linux Containers <containers@lists.linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Chris Down <chris@chrisdown.name>, Cgroups <cgroups@vger.kernel.org>

Shakeel Butt <shakeelb@google.com> writes:

> On Tue, Jun 15, 2021 at 5:47 AM Alexey Gladkov <legion@kernel.org> wrote:
>>
> [...]
>>
>> I made the second version of the patch [1], but then I had a conversation
>> with Eric W. Biederman offlist. He convinced me that it is a bad idea to
>> change all the values in meminfo to accommodate cgroups. But we agreed
>> that MemAvailable in /proc/meminfo should respect cgroups limits. This
>> field was created to hide implementation details when calculating
>> available memory. You can see that it is quite widely used [2].
>> So I want to try to move in that direction.
>>
>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/legion/linux.git/log/?h=patchset/meminfo/v2.0
>> [2] https://codesearch.debian.net/search?q=MemAvailable%3A
>>
>
> Please see following two links on the previous discussion on having
> per-memcg MemAvailable stat.
>
> [1] https://lore.kernel.org/linux-mm/alpine.DEB.2.22.394.2006281445210.855265@chino.kir.corp.google.com/
> [2] https://lore.kernel.org/linux-mm/alpine.DEB.2.23.453.2007142018150.2667860@chino.kir.corp.google.com/
>
> MemAvailable itself is an imprecise metric and involving memcg makes
> this metric even more weird. The difference of semantics of swap
> accounting of v1 and v2 is one source of this weirdness (I have not
> checked your patch if it is handling this weirdness). The lazyfree and
> deferred split pages are another source.
>
> So, I am not sure if complicating an already imprecise metric will
> make it more useful.

Making a good guess at how much memory can be allocated without
triggering swapping or otherwise stressing the system is something that
requires understanding our mm internals.

To be able to continue changing the mm or even mm policy without
introducing regressions in userspace we need to export values that
userspace can use.

At a first approximation that seems to look like MemAvailable.

MemAvailable seems to have a good definition.  Roughly the amount of
memory that can be allocated without triggering swapping.  Updated
to include not trigger memory cgroup based swapping and I sounds good.

I don't know if it will work in practice but I think it is worth
exploring.

I do know that hiding the implementation details and providing userspace
with information it can directly use seems like the programming model
that needs to be explored.  Most programs should not care if they are in
a memory cgroup, etc.  Programs, load management systems, and even
balloon drivers have a legitimately interest in how much additional load
can be placed on a systems memory.


A version of this that I remember working fairly well is free space
on compressed filesystems.  As I recall compressed filesystems report
the amount of uncompressed space that is available (an underestimate).
This results in the amount of space consumed going up faster than the
free space goes down.

We can't do exactly the same thing with our memory usability estimate,
but having our estimate be a reliable underestimate might be enough
to avoid problems with reporting too much memory as available to
userspace.

I know that MemAvailable already does that /2 so maybe it is already
aiming at being an underestimate.  Perhaps we need some additional
accounting to help create a useful metric for userspace as well.


I don't know the final answer.  I do know that not designing an
interface that userspace can use to deal with it's legitimate concerns
is sticking our collective heads in the sand and wishing the problem
will go away.

Eric

