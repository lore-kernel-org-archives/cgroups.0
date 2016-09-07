From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Wed, 7 Sep 2016 20:24:52 +0530
Message-ID: <CAG53R5Xi0nJKa-EZs8DZ=TTVDSB-CkrD+OS0mKp=peYihjoeaQ@mail.gmail.com>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com>
 <1472632647-1525-2-git-send-email-pandit.parav@gmail.com> <61101e8b-5776-c0bc-b3ea-d8b984eebabf@mellanox.com>
 <20160831211618.GA12660@htj.duckdns.org> <9b6a346d-af4c-1e5f-0144-f68fb8e46c27@mellanox.com>
 <20160901084406.GA4115@lst.de> <CAG53R5Ws4BJKqeEYfEoEx5kuaXUmhDKcXfH4Vx=LTMK6tKMG0A@mail.gmail.com>
 <ae3adcc4-253e-f87c-6ff6-202c91599f48@mellanox.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=gGwCW+qxBop5nG3xonODLjbtiVmW/r7OKVfo4PoDDE0=;
        b=0e2FrOrBOwqAq/mQEhXOCp5pCG6Vm5buoi/rfTvpP/yd/RAq+iTJxcOzF9K1MpO3PW
         cXnoNUP2SVnusu0ui1+BNVEd/oaOMhF2qgzCtdpXthKAiYx2uDRbaJQK6DMzReQC+6P8
         PWHb48HvA5zw9dYosjPSjicU8YGYfI/EpAyH8F7Cg0WOoBHDC3OIoBJZaBEPXco2sxEm
         gdomi+G5DV1KJQgOLhVwyb8tSDAmjnENXEZBdKR5NZHvC9uO6U0fNVWrWd7P509swJZW
         ZZlI8E/tqsLozMj168yR2HF1NKX8DATn+pilDwTHK32VI0RxKjwbrDRL48BmoPE6A6Ux
         aK9w==
In-Reply-To: <ae3adcc4-253e-f87c-6ff6-202c91599f48@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matan Barak <matanb@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org

On Wed, Sep 7, 2016 at 2:21 PM, Matan Barak <matanb@mellanox.com> wrote:
> On 07/09/2016 10:55, Parav Pandit wrote:
>>
>> Hi Matan,
>>
>> On Thu, Sep 1, 2016 at 2:14 PM, Christoph Hellwig <hch@lst.de> wrote:
>>>
>>> On Thu, Sep 01, 2016 at 10:25:40AM +0300, Matan Barak wrote:
>>>>
>>>> Well, if I recall, the reason doing so last time was in order to allow
>>>> flexible updating of ib_core independently, which is obviously not a
>>>> good
>>>> reason (to say the least).
>>>>
>>>> Since the new ABI will probably define new object types (all recent
>>>> proposals go this way), the current approach could lead to either trying
>>>> to
>>>> map new objects to existing cgroup resource types, which could lead to
>>>> some
>>>> weird non 1:1 mapping, or having a split definitions - such that each
>>>> driver will declare its objects both in the cgroups mechanism and in its
>>>> driver dispatch table.
>>
>>
>>>> Even worse than that, drivers could simply ignore the cgroups support
>>>> while
>>>> implementing their own resource types and get a very broken containers
>>>> support.
>>
>> If drivers are broken due to ignorance of not-calling cgroup APIs,
>> that should be ok.
>> That particular driver should fix it.
>> If the resource creation using uverbs is using well defined rdma level
>> resource, uverbs level will make sure to honor cgroup limits without
>> involving hw drivers anyway.
>>
>
> All recent proposals of the new ABI schema deals with extending the
> flexibility of the current schema by letting drivers define their specific
> types, actions, attributes, etc. Even more than that, the dispatching starts
> from the driver and it chooses if it wants to use the common RDMA core layer
> or have it's own wise implementation instead.
> Some drivers might even prefer not to implement the current verbs types.
> These decisions were made in the OFVWG meetings.

o.k. If some drivers doesn't implement current verbs type, there is no
point in controlling it either.
In such case application space library won't even invoke resource
allocation/free for unsupported resources.
For resources (type in your word) which are not defined in cgroup, but
exist in hw driver, cannot be controlled by cgroup.
As you highlighted in your [1], "driver's specific attributes could
someday become core's standard attributes", we should be able to add
new resource type to existing rdma cgroup.

>
> Anyway, maybe we should consider using a more higher-level logic objects
> that could fit multiple drivers requirements.
I do not have any other objects other than QP, MR etc in mind currently.
I can think of a RDMA specific socket that encompass one PD, AH,
couple of MRs, and QP.
But we don't have such resource abstraction and its data transport
APIs in place.
There is rsocket, various versions of MPI, libfabric etc in place.
So I am not sure which high level objects to defined at this point.
If you have such objects nailed down, we should be able to add them in
incremental development.

>
>> RDMA Verb level resource is charged/uncharged by RDMA core.
>> RDMA HW level resource is charged/uncharged by RDMA HW driver using
>> well defined API and resource by cgroup core.
>> This scheme ensures that there is 1:1 mapping.
>>
>
> Sounds reasonable, but what about drivers which ignore the common code and
> implement it in their own way?
Shouldn't Doug ask them to use cgroup infrastructure instead of
implementing resource charging/uncharing in their own way.
It still unlikely or difficult for drivers to group processes them
selves like cgroup to implement things in their own way.
I agree, they can completely ignore RDMA verbs resources and implement
their own HW resources.

As you pointed below, we need to find balance between which hw
resource to be defined and which not.
For example, newly added XRQ object, which could be a pure buffer_tag
with receive queue for other vendor. I am not sure how to abstract
them into single object.



> What about drivers which don't support the
> standard RDMA types at all?
> I guess we should find a balance between something abstract and common
> enough that will ease administrator configuration but be specific enough for
> the various models we have (or will have) in the RDMA stack.
>
>> I don't think current definition of resource type is carved out on stone.
>> They can be extended as we forward.
>> As many of us agree that, they should be well defined and it should be
>> agreed by cgroup and rdma community.
>>
>
> Of course, but since the ABI and cgroups model are somehow related, they
> should be dealt with together and approved by Doug who participated in some
> of the OFVWG meetings.
Sure.
>
>> For example, today we have RDMA_VERB_xxx resources.
>> New well defined RDMA HW resources can be defined in rdma_cgroup.h
>> file as RDMA_HW_xx in same enum table.
>>
>
> So a driver will change the cgroups file for every new type it adds?
Well, we wanted to avoid that such churn in cgroup file, thats why v11
was defining resources in IB core. But I guess that was not
acceptable. I had NAK from Christoph and Tejun on that idea.

> Will we just have a super set enum of all crazy types vendors added?
As you said, we need to find balance. I frankly don't know how to do
so. There has to be some reasonable number of types. As we go along
Doug, Tejun and others should approve adding such.
If I am not wrong in past one year, may be two more resource types got
added? XRQ, state-less Queues?

>
>>>
>>> Sorry guys, but arbitrary extensibility for something not finished is the
>>> worst idea ever.  We have two options here:
>>>
>>>  a) delay cgroups support until the grand rewrite is done
>>>  b) add it now and deal with the consequences later
>>>
>> Can we do (b) now and differ adding any HW resources to cgroup until
>> they are clearly called out.
>> Architecture and APIs are already in place to support this.
>>
>
> Since this affect the user, it's better to think how it fits our "optional
> standard"/"vendor types" model first. Maybe we could force all standard
> types even if the driver we use doesn't support any of them.

If vendor doesn't support a given type, user won't allocate it. So its
just don't care condition.
I dont see a need to force standard types either.

>
>>> That being said, adding random non-Verbs hardwasre to the RDMA core is
>>> the second worst idea ever.
>>
>>
>> We can differ adding HW resource to core and cgroup until they are
>> clearly defined.
>> In that case current architecture still holds good.
>>
>
> Clearly we should differ adding the actual code until a driver could declare
> such objects, but we need to decide how to expose the standard optional RDMA
> types (basically, the types you've added) and how future driver specific
> types fit in.
>

o.k. Few more handful of driver specific types should be ok to add in cgroup.
I will let others speak up if thats not acceptable. Current code
already documents and provide infrastructure for that.

>>
>>
>> Matan,
>> Can you please point us to the new RFC/ABI email thread which
>> describes the design, partitioning of code between core vs hw drivers
>> etc.
>>
>
> One proposal is [1]. There's another one from Sean which aims for similar
> targets regards the driver specific types.
>
> [1] https://www.spinics.net/lists/linux-rdma/msg38997.html
>
I looked at the RFC briefly. I can see that old infrastructure (a) and
(b) is not going away.
So It should be ok. to charge/uncharge those standard resources from
those hooks.
