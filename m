From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv3 1/3] rdmacg: Added rdma cgroup controller.
Date: Fri, 12 Feb 2016 02:49:38 +0530
Message-ID: <CAG53R5WC17nLL2qjtB-_RZR+45qBDmJ2=12UtHxuKtvWhfN5XA@mail.gmail.com>
References: <1454167387-31260-1-git-send-email-pandit.parav@gmail.com>
	<1454167387-31260-2-git-send-email-pandit.parav@gmail.com>
	<20160130183015.GP32380@htj.duckdns.org>
	<CAG53R5XrnYY1AVBnu1b6BVfWwiUgyq+EsXay=CianRXnsUDviQ@mail.gmail.com>
	<20160131100237.GS32380@htj.duckdns.org>
	<CAG53R5WOLA_=gD9qVnsVk_oPs0iyacL3M+1qD+RAbrnciVXEOA@mail.gmail.com>
	<20160131110420.GV32380@htj.duckdns.org>
	<CAG53R5XXaW-fhb9megcp+Xnv05bSuonDws2fE-D6Wk3JNqS2Aw@mail.gmail.com>
	<20160201184046.GD14091@mtj.duckdns.org>
	<CAG53R5U=ojbn5tQoq=xR0DUb3Tm6yw+oO6mXVAQ2cUOhbvCdKQ@mail.gmail.com>
	<56BB6502.8040507@mellanox.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=oPcx20vkvF4vQOWAQK7SC21RLVy2//QN26B0Y6RBJDI=;
        b=xSFWBsOZyaUI5VuRkjMP0nWw4wUqeVl/DLu7GYfCGKsd2uu36hEtrStSRU9yzqhzyt
         ymLJaDYu3Z8/N5Fnk2SMIBsdtkYQMMU/wsuNREt+sPpMwPzmcvnh+sHQgeOAisSgQupU
         xzg+sw8WA0JCpb8GRHCsSY+1Nf2wDC6rDl3T5wXZ2/CFr3V0nOF4MqQouYITquvf7z80
         uSgzzTgHekFd/lypimhS+zwocOEkgasIvD1Q6WZLQu7/g9eWN6V61QNt7PnMGRSqBdJN
         GLF5XCqSaXNLDX9q6Wa3bjNb8EevyphyHoyXmNUIAn0RWNRQ9aLicY717tpnPLiGcWIH
         GtXA==
In-Reply-To: <56BB6502.8040507@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haggai Eran <haggaie@mellanox.com>
Cc: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

Hi Tejun,

(Sending again as by mistake previous mail was non plain text, sorry
about that).

So based on your comments, Haggai's comments below and past
experience, I will spin v6.o
I have made changes, and testing them. I am likely to post during
coming long weekend.

I have simplified many pieces.
Can you please confirm below design/implementation looks ok to you?
If you want to review v6 directly, I am fine with that too instead of
below post.

1. Removed two type of resource pool, made is single type (as you
described in past comment)
2. Removed match tokens and have array definition like "qp", "mr", "cq" etc.
3. Wrote small parser and avoided match_token API as that won't work
due to different array definition
4. Removed one-off remove API to unconfigure cgroup, instead all
resource should be set to max.
5. Removed resource pool type (user/default), instead having max_num_cnt,
when ref_cnt drops to zero and max_num_cnt = total_rescource_cnt, pool is freed.
6. Resource definition ownership is now only with IB stack at single
header file, no longer in each low level driver.
This goes through IB maintainer and other reviewers eyes.
This continue to give flexibility to not force kernel upgrade for few
enums additions for new resource type.
7. Wherever possible pool lock is pushed out, except for hierarchical
charging/unchanging points, as it not possible to do so, due to
iterative process involves blocking allocations of rpool. Coming up
more levels up to release locks doesn't make any sense either.
This is anyway slow path where rpool is not allocated. Except for
typical first resource allocation, this is less traveled path.
8.Other minor cleanups.
9. Avoided %d manipulation due to removal of match_token and replaced
with seq_putc etc friend functions.

Parav

On Wed, Feb 10, 2016 at 9:57 PM, Haggai Eran <haggaie@mellanox.com> wrote:
> On 01/02/2016 20:59, Parav Pandit wrote:
>> On Tue, Feb 2, 2016 at 12:10 AM, Tejun Heo <tj@kernel.org> wrote:
>>> So, I'm really not gonna go for individual drivers defining resources
>>> on their own.  That's a trainwreck waiting to happen.  There needs to
>>> be a lot more scrutiny than that.
>>>
>> Not every low level driver. I started with that infrastructure in
>> v2,v3 but I got your inputs and
>> I align with that. It could be just single IB stack in one header file
>> in one enum list would be sufficient.
>> You have already given that example.
>> With that mostly two resource type that I have can also shrink to just
>> single type.
>> Will wait to hear from them, in case if they have any different thought.
>
> Hi,
>
> Sorry for the late reply.
>
> I think that starting with the standard set of resources that uverbs
> provide is good, and if we need in the future new types of resources
> we can add them later.
>
> On 31/01/2016 19:50, Parav Pandit wrote:
>> How would you like to see RDMA verb resources being defined - in RDMA
>> cgroup or in IB stack?
>> In current patch v5, its defined by the IB stack which is often
>> shipped as different package due to high amount of changes, bug fixes,
>> features.
>> In v0 patch it was defined by the RDMA cgroup, which means any new
>> resource addition/definition requires kernel upgrade. Which is hard to
>> change often.
>
> There is indeed an effort to backport the latest RDMA subsystem modules to
> older kernels, and it would be preferable to be able to introduce new
> resources through these modules. However, I understand that there are no
> other cgroups that are modules or depend on modules this way, so I would
> understand if you decide against it.
>
>> If resources are defined by RDMA cgroup kernel than adding/removing
>> resource means, someone have to do lot of engineering with different
>> versions of kernel support and loadable module support using compat.h
>> etc at driver level, which in my mind is some amount of engineering
>> compare to what v5 has to offer and its already available. With one
>> round of cleanup in resource definition, it should be usable.
> If I understand correctly, if the resources are defined in the cgroup,
> you simply won't be able to add new resources with a module update,
> no matter how hard you work.
>
> I agree that if the cgroup code is changed for cleanup or whatever
> reason, the backporting may become difficult, but that's just life.
>
>> Its important to provide this feedback to Tejun and me, so that we
>> take informed design decision.
>
> Sure. I hope this patchset gets accepted eventually, as I believe it
> solves a real problem. Today RDMA application can easily hog these
> resources and the rdma cgroup allows users to prevent that.
>
> Regards,
> Haggai
