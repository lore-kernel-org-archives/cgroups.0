From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Wed, 19 Oct 2016 01:45:15 +0530
Message-ID: <CAG53R5WVMxfEFsqerFoCV8W2Zrfd=8WoW6a=RLyn_z7BUocs=Q@mail.gmail.com>
References: <20160910170151.GA5230@obsidianresearch.com> <20160911133421.GA23384@lst.de>
 <20160911143522.GL6415@leon.nu> <20160911171409.GA13442@obsidianresearch.com>
 <20160911172445.GA25953@lst.de> <20160911175235.GB13442@obsidianresearch.com>
 <20160912050717.GE8812@leon.nu> <CAG53R5X4stfy5+Jmg+XReUJqt56Z-zABK+UEswHW1dXhH-9cNw@mail.gmail.com>
 <20160915185629.GF26069@leon.nu> <CAG53R5XBS0B5XaTzjKC3-zgoB2-fz2ctbk_E2YG76zBgzOfG-A@mail.gmail.com>
 <20160921142645.GB10734@htj.duckdns.org> <CAG53R5WMuojhzFGmqk6nHfypd9Hq4dGsWRKjtUyMZ=RezU-LhQ@mail.gmail.com>
 <CAG53R5VqQ6UzsuzcovsD+ufv3HaEQEbUpaf3kDo4zLOrAf__8A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-security-module-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=Bz4qvXNm7O7LTY6g2KTsdZcHIjIsTpCBzsUiFmsKYNo=;
        b=jFj6kVxPtElm+fIf3nwlmSiEL2bXt0vyQwubx59Gb6z56ynP0ubCSJ9v0fxta8JtxA
         CLlE+RNsOUBgZBOSQdcD7em185Uo94RDRCZKXp8IoBhUOib9UmaPDmzrUBrXkbz55dCT
         lbZblMNzMfAFlZQqRhFh51VR5A5J+NmjOa7A4xnc5GP5w1/OtoZC0GBy7bKweUDDKg90
         V3+fnowYNwAHqNbppRPJG2qtUYJsSZft+Kc11JM/dXprdrYeS5cLCxFH/s8bGLWVN8Lt
         FLrmIafKpULvnOJYTUIzJAZs/MPxapw8/nzrun5rD3qqqmGrwMm8Ti+JDkK/LOjmDCzb
         NelQ==
In-Reply-To: <CAG53R5VqQ6UzsuzcovsD+ufv3HaEQEbUpaf3kDo4zLOrAf__8A@mail.gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Christoph Hellwig <hch@lst.de>, Matan Barak <matanb@mellanox.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org

Hi Doug,

Leon has finished review as well in [7].
Christoph Acked too in [8].

Can you please advise whether
(1) I should rebase and resend PatchV12?
(2) If so for which branch - master/4.9 or?

Tejun and Christoph mentioned that it might be late for 4.9.
Can we atleast merge to linux-rdma tree, so that more features/changes
can be done on top of it?

How can we avoid merge conflict to Linus since this patchset is
applicable to two git trees. (cgroup and linux-rdma).
I was thinking to push through linux-rdma as it is currently going
through more changes, so resolving merge conflict would be simpler if
that happens.

Please provide the direction.

[7] https://lkml.org/lkml/2016/10/5/134
[8] https://lkml.org/lkml/2016/10/5/30

Regards,
Parav Pandit

On Tue, Oct 4, 2016 at 11:49 PM, Parav Pandit <pandit.parav@gmail.com> wrote:
> Hi Doug,
>
> I am still waiting for Leon to provide his comments if any on rdma cgroup.
> From other email context, he was on vacation last week.
> While we wait for his comments, I wanted to know your view of this
> patchset in 4.9 merge window.
>
> To summarize the discussion that happened in two threads.
>
> [1] Ack by Tejun, asking for review from rdma list
> [2] quick review by Christoph on patch-v11 (patch 12 has only typo corrections)
> [3] Christoph's ack on architecture of rdma cgroup and fitting it with ABI
> [4] My response on Matan's query on RSS indirection table
> [5] Response from Intel on their driver support for Matan's query
> [6] Christoph's point on architecture, which we are following in new
> ABI and current ABI
>
> I have reviewed recent patch [7] from Matan where I see IB verbs
> objects are still handled through common path as suggested by
> Christoph.
>
> I do not see any issues with rdma cgroup patchset other than it requires rebase.
> Am I missing something?
> Can you please help me - What would be required to merge it to 4.9?
>
> [1] https://lkml.org/lkml/2016/8/31/494
> [2] https://lkml.org/lkml/2016/8/25/146
> [3] https://lkml.org/lkml/2016/9/10/175
> [4] https://lkml.org/lkml/2016/9/14/221
> [5] https://lkml.org/lkml/2016/9/19/571
> [6] http://www.spinics.net/lists/linux-rdma/msg40337.html
> [7] email subject: [RFC ABI V4 0/7] SG-based RDMA ABI Proposal
>
> Regards,
> Parav Pandit
>
> On Wed, Sep 21, 2016 at 9:32 PM, Parav Pandit <pandit.parav@gmail.com> wrote:
>> Hi Tejun,
>>
>> On Wed, Sep 21, 2016 at 7:56 PM, Tejun Heo <tj@kernel.org> wrote:
>>> Hello, Parav.
>>>
>>> On Wed, Sep 21, 2016 at 10:13:38AM +0530, Parav Pandit wrote:
>>>> We have completed review from Tejun, Christoph.
>>>> HFI driver folks also provided feedback for Intel drivers.
>>>> Matan's also doesn't have any more comments.
>>>>
>>>> If possible, if you can also review, it will be helpful.
>>>>
>>>> I have some more changes unrelated to cgroup in same files in both the git tree.
>>>> Pushing them now either results into merge conflict later on for
>>>> Doug/Tejun, or requires rebase and resending patch.
>>>> If you can review, we can avoid such rework.
>>>
>>> My impression of the thread was that there doesn't seem to be enough
>>> of consensus around how rdma resources should be defined.  Is that
>>> part agreed upon now?
>>>
>>
>> We ended up discussing few points on different thread [1].
>>
>> There was confusion on how some non-rdma/non-IB drivers would work
>> with rdma cgroup from Matan.
>> Christoph explained how they don't fit in the rdma subsystem and
>> therefore its not prime target to addess.
>> Intel driver maintainer Denny also acknowledged same on [2].
>> IB compliant drivers of Intel support rdma cgroup as explained in [2].
>> With that usnic and Intel psm drivers falls out of rdma cgroup support
>> as they don't fit very well in the verbs definition.
>>
>> [1] https://www.spinics.net/lists/linux-rdma/msg40340.html
>> [2] http://www.spinics.net/lists/linux-rdma/msg40717.html
>>
>> I will wait for Leon's review comments if he has different view on architecture.
>> Back in April when I met face-to-face to Leon and Haggai, Leon was in
>> support to have kernel defined the rdma resources as suggested by
>> Christoph and Tejun instead of IB/RDMA subsystem.
>> I will wait for his comments if his views have changed with new uAPI
>> taking shape.
