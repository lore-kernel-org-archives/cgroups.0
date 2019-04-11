From: Waiman Long <longman@redhat.com>
Subject: Re: [RFC PATCH 0/2] mm/memcontrol: Finer-grained memory control
Date: Thu, 11 Apr 2019 10:22:22 -0400
Message-ID: <d8d6f82f-a950-8eea-16ce-9189e78f37fd@redhat.com>
References: <20190410191321.9527-1-longman@redhat.com>
 <20190410213824.GA13638@chrisdown.name>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190410213824.GA13638@chrisdown.name>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Chris Down <chris@chrisdown.name>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Kirill Tkhai <ktkhai@virtuozzo.com>

On 04/10/2019 05:38 PM, Chris Down wrote:
> Hi Waiman,
>
> Waiman Long writes:
>> The current control mechanism for memory cgroup v2 lumps all the memory
>> together irrespective of the type of memory objects. However, there
>> are cases where users may have more concern about one type of memory
>> usage than the others.
>
> I have concerns about this implementation, and the overall idea in
> general. We had per-class memory limiting in the cgroup v1 API, and it
> ended up really poorly, and resulted in a situation where it's really
> hard to compose a usable system out of it any more.
>
> A major part of the restructure in cgroup v2 has been to simplify
> things so that it's more easy to understand for service owners and
> sysadmins. This was intentional, because otherwise the system overall
> is hard to make into something that does what users *really* want, and
> users end up with a lot of confusion, misconfiguration, and generally
> an inability to produce a coherent system, because we've made things
> too hard to piece together.
>
> In general, for purposes of resource control, I'm not convinced that
> it makes sense to limit only one kind of memory based on prior
> experience with v1. Can you give a production use case where this
> would be a clear benefit, traded off against the increase in
> complexity to the API?
>

As I said in my previous email on this thread, the customer considered
pages cache as common goods not fully representing the "real" memory
footprint used by an application.=C2=A0 Depending on actual mix of
applications running on a system, there are certainly cases where their
view is correct. In fact, what the customer is asking for is not even
provided by the v1 API even with that many classes of memory that you
can choose from.

>> For simplicity, the limit is not hierarchical and applies to only tasks
>> in the local memory cgroup.
>
> We've made an explicit effort to make all things hierarchical -- this
> confuses things further. Even if we did have something like this, it
> would have to respect the hierarchy, we really don't want to return to
> the use_hierarchy days where users, sysadmins, and even ourselves are
> confused by the resource control semantics that are supposed to be
> achieved.

I see your point. I am now suggesting that this new feature is limited
to just leaf memory cgroup for now. We can extend it to full
hierarchical support in the future if necessary.

>
>> We have customer request to limit memory consumption on anonymous memory
>> only as they said the feature was available in other OSes like Solaris.
>
> What's the production use case where this is demonstrably providing
> clear benefits in terms of resource control? How can it compose as
> part of an easy to understand, resource controlling system? I'd like
> to see a lot more information on why this is needed, and the usability
> and technical tradeoffs considered.=20

Simply put, the customers want to control and limit memory consumption
based on the anonymous memory (RSS) that are used by the applications.
This was what they were doing in the past and their tooling was based on
this. They want to continue doing that after migrating to Linux. Adding
page cache into the mix and they don't know how they should handle that.

Cheers,
Longman

