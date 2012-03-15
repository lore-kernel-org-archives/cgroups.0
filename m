From: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: What's the progress of per cgroup background reclaim?
Date: Thu, 15 Mar 2012 09:31:38 -0700
Message-ID: <CALWz4iwO+eGFW23qVwjy=MKufRtiVck08pJphSij226pjTQiBw@mail.gmail.com>
References: <CAC8teKW9Yry114+B06XiFbOtamwS6fNLzrKYo8PZazjEzMCiNQ@mail.gmail.com>
	<CALWz4iyqyQD3g27J=wLvQ=WN0enXLB3rmHDAb51UJaLPJDz5BA@mail.gmail.com>
	<CAC8teKUrJ_ufkhtVAnsv-gzHfYmp8agY_bncOYS7mEdiqD+YZA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding:x-system-of-record;
        bh=atV364cRzLfJev55mIA8Kciu6XMc+4GmEgstaqdlM2I=;
        b=ZqN6Uxnk2mWctXCLut3KPYo1zpRLn2MX2r1mB3OYVcAG5fWzQmL2tIlLCvhYsrjMPF
         UlTrvqtVd5CSsWWdBSgZ2Iftz7HipTFB1C7kSck67+kLOwL5qlK68AWwrC0fgvW3gmYx
         6oIb7GZs2HA6putIPX7iH+RDN26qZw1R2Q2mSieIDbv/I2QTG7f+uxqyv3uQ+7nHW/WK
         EeiiHvDFBhn2/+JMxx7wYuOGHwLlCt61PGqx9y/oXmCUp1BxperEEzffWbcGDvpHjzx4
         YPYeFaUAAIibR8Lo+pD6rCozgcf0CG0Gu5Rx/K97JalImQmbFlRqxt1zSv1GTDdV5+DR
         7vtw==
In-Reply-To: <CAC8teKUrJ_ufkhtVAnsv-gzHfYmp8agY_bncOYS7mEdiqD+YZA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-9"
To: Zhu Yanhai <zhu.yanhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On Wed, Mar 14, 2012 at 8:12 PM, Zhu Yanhai <zhu.yanhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> 2012/3/15 Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>:
>> On Wed, Mar 14, 2012 at 12:53 AM, Zhu Yanhai <zhu.yanhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =
wrote:
>>> Hi all,
>>> Just a quick question, could you please tell me what's the current
>>> status of the development of per cgroup background reclaim? This to=
pic
>>> seems to be silent after Han Ying's patchset V7
>>> (http://lwn.net/Articles/440073/) and Kame's async reclaim patchset=
 V3
>>> (https://lkml.org/lkml/2011/5/26/20), and I can't find it in
>>> memcg-devel tree either.
>>> Is anyone still working on this?
>>
>> There were some discussions on going w/ per-memcg kswapd thread or
>> workqueue by that time. And now I think we agree to go w/ the
>> per-memcg thread model. =A0I haven't done much work since then, and =
one
>> of questions is to demonstrate the need of this feature.
>>
>> I am glad you are asking, do you have workload showing problems w/o =
it?
>
> Yes, the background is we have a cluster of about 3k-4k servers, all
> running JVMs. Because the load of each Java application is small, we
> gave each of them a small GC heap, which was 1.5GB or so. Then to tak=
e
> full use of the huge memory of the servers, we setup several XEN base=
d
> virtual machines on each physical box, each XEN VM had one single JVM
> running in it.
> Now we are trying to switch to a LXC/cgroup based solution, =A0at the
> first step we have built a small experimental cluster online, the
> containers equipped with memcg are sizing to the same size with the
> XEN VMs (we haven't enabled other controllers since the major need fo=
r
> resources came from the memory, while the pressure against CPU and IO
> usually is smaller). As soon as they are online, we noticed that the
> latency recorded in the client side had periodic peaks. We also
> noticed that the memory.failcnt counter periodic increased. By
> enabling kmem:mm_directreclaim_reclaimall,
> kmem:mm_vmscan_direct_reclaim_begin, kmem:mm_vmscan_direct_reclaim_en=
d
> in trace events, we can see that kmem:mm_directreclaim_reclaimall cam=
e
> out regularly, without =A0kmem:mm_vmscan_direct_reclaim_begin/end see=
n.
> That means the caller of do_try_to_free_pages is
> try_to_free_mem_cgroup_pages, not the global caller try_to_free_pages=
=2E
> To make load balance in the cluster wide, we tend to dispatch the Jav=
a
> apps average over the containers on different physical boxes, that's
> to say unless the cluster is to be filled up, the number of active
> containers on each box won't be large. I think under such scenario th=
e
> global pressure can never be high, so kswapd keep sleeping most of th=
e
> time, however the local pressure within one single cgroup maybe very
> high, which results to frequent direct reclaim.
> The kernel we are using is a custom RHEL6U2 kernel. We have a kernel
> team here so it's fine to backport the upstream solution if there is
> any.


Thank you for the information.

Sounds like that is exactly what the per-memcg kswapd was designed
for. Two things I am interested to looking into now:

1. why the per-memcg direct reclaim introduce such noticeable latency
spike, what workload that can reproduce that?

2. we can quickly patch the last version of per-memcg kswapd (V6) on
your environment and see what difference it makes. Maybe I can help on
that.

Thanks

--Ying

> --
> Thanks,
> Zhu Yanhai
>
>> --Ying
>>
>>>
>>> Thanks,
>>> Zhu Yanhai
