From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Tue, 4 Oct 2016 23:49:05 +0530
Message-ID: <CAG53R5VqQ6UzsuzcovsD+ufv3HaEQEbUpaf3kDo4zLOrAf__8A@mail.gmail.com>
References: <20160910170151.GA5230@obsidianresearch.com> <20160911133421.GA23384@lst.de>
 <20160911143522.GL6415@leon.nu> <20160911171409.GA13442@obsidianresearch.com>
 <20160911172445.GA25953@lst.de> <20160911175235.GB13442@obsidianresearch.com>
 <20160912050717.GE8812@leon.nu> <CAG53R5X4stfy5+Jmg+XReUJqt56Z-zABK+UEswHW1dXhH-9cNw@mail.gmail.com>
 <20160915185629.GF26069@leon.nu> <CAG53R5XBS0B5XaTzjKC3-zgoB2-fz2ctbk_E2YG76zBgzOfG-A@mail.gmail.com>
 <20160921142645.GB10734@htj.duckdns.org> <CAG53R5WMuojhzFGmqk6nHfypd9Hq4dGsWRKjtUyMZ=RezU-LhQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=jnDecWC89AH/LYJ6yRErTuX+tPDYZKo68+L7wgTyDKA=;
        b=wsHkr3y4dlXG02qXnpu9sr6igqiXvVEfjFM1mDYYYWp8NPVFuJY+wcUoxYGJNwz7MV
         3vCMoVA1dQql9Pyx01IQuMgDNBcwOKbRSGuR+k5uIqB1mQbX1RPsvm3p1abj0FUb3qMc
         JgVMZ4nxp3lcBV26jUTAilpGiR+gR/8fOEKqDrg9n13OJG2c28uY4jd/LekEbqcqAUSO
         6UVb0N99THGoj2aCE+nq0x59JXHP687bMXmj6jftlmawaRVxWrwAJ7T/ciVayFj1AD5h
         QukH/ZBlLXbf7C8xOpnerX1sp8Mg73ByMpOXdjn+VA5xNHXjSdKA+IhFq9+7+1QCxbdz
         mSTQ==
In-Reply-To: <CAG53R5WMuojhzFGmqk6nHfypd9Hq4dGsWRKjtUyMZ=RezU-LhQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Doug,

I am still waiting for Leon to provide his comments if any on rdma cgroup.
From other email context, he was on vacation last week.
While we wait for his comments, I wanted to know your view of this
patchset in 4.9 merge window.

To summarize the discussion that happened in two threads.

[1] Ack by Tejun, asking for review from rdma list
[2] quick review by Christoph on patch-v11 (patch 12 has only typo corrections)
[3] Christoph's ack on architecture of rdma cgroup and fitting it with ABI
[4] My response on Matan's query on RSS indirection table
[5] Response from Intel on their driver support for Matan's query
[6] Christoph's point on architecture, which we are following in new
ABI and current ABI

I have reviewed recent patch [7] from Matan where I see IB verbs
objects are still handled through common path as suggested by
Christoph.

I do not see any issues with rdma cgroup patchset other than it requires rebase.
Am I missing something?
Can you please help me - What would be required to merge it to 4.9?

[1] https://lkml.org/lkml/2016/8/31/494
[2] https://lkml.org/lkml/2016/8/25/146
[3] https://lkml.org/lkml/2016/9/10/175
[4] https://lkml.org/lkml/2016/9/14/221
[5] https://lkml.org/lkml/2016/9/19/571
[6] http://www.spinics.net/lists/linux-rdma/msg40337.html
[7] email subject: [RFC ABI V4 0/7] SG-based RDMA ABI Proposal

Regards,
Parav Pandit

On Wed, Sep 21, 2016 at 9:32 PM, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi Tejun,
>
> On Wed, Sep 21, 2016 at 7:56 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> Hello, Parav.
>>
>> On Wed, Sep 21, 2016 at 10:13:38AM +0530, Parav Pandit wrote:
>>> We have completed review from Tejun, Christoph.
>>> HFI driver folks also provided feedback for Intel drivers.
>>> Matan's also doesn't have any more comments.
>>>
>>> If possible, if you can also review, it will be helpful.
>>>
>>> I have some more changes unrelated to cgroup in same files in both the git tree.
>>> Pushing them now either results into merge conflict later on for
>>> Doug/Tejun, or requires rebase and resending patch.
>>> If you can review, we can avoid such rework.
>>
>> My impression of the thread was that there doesn't seem to be enough
>> of consensus around how rdma resources should be defined.  Is that
>> part agreed upon now?
>>
>
> We ended up discussing few points on different thread [1].
>
> There was confusion on how some non-rdma/non-IB drivers would work
> with rdma cgroup from Matan.
> Christoph explained how they don't fit in the rdma subsystem and
> therefore its not prime target to addess.
> Intel driver maintainer Denny also acknowledged same on [2].
> IB compliant drivers of Intel support rdma cgroup as explained in [2].
> With that usnic and Intel psm drivers falls out of rdma cgroup support
> as they don't fit very well in the verbs definition.
>
> [1] https://www.spinics.net/lists/linux-rdma/msg40340.html
> [2] http://www.spinics.net/lists/linux-rdma/msg40717.html
>
> I will wait for Leon's review comments if he has different view on architecture.
> Back in April when I met face-to-face to Leon and Haggai, Leon was in
> support to have kernel defined the rdma resources as suggested by
> Christoph and Tejun instead of IB/RDMA subsystem.
> I will wait for his comments if his views have changed with new uAPI
> taking shape.
