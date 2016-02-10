From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv3 1/3] rdmacg: Added rdma cgroup controller.
Date: Wed, 10 Feb 2016 18:27:46 +0200
Message-ID: <56BB6502.8040507@mellanox.com>
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
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1; h=From:To:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=c3gBjSS3eymYMB6p0BzYp08uHLJTJJnpfqOv3rq/Uh0=;
 b=sCbUMUZ2EWb/Y2M/1EjXzP4AQnqjmOSN1/V94BWzir86S7nvDdwkbdOudt+5SyBlavj0cazih8optTRljeAOs0C6mmiKQ1SXu+5dmyNUDwlSasE2ENr5OGSXUEU3Z4PEGq5Ut/4HdrS1LquaeF2NCB999r5IKdU/hPOFBy/7+/o=
In-Reply-To: <CAG53R5U=ojbn5tQoq=xR0DUb3Tm6yw+oO6mXVAQ2cUOhbvCdKQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 01/02/2016 20:59, Parav Pandit wrote:
> On Tue, Feb 2, 2016 at 12:10 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> So, I'm really not gonna go for individual drivers defining resources
>> on their own.  That's a trainwreck waiting to happen.  There needs to
>> be a lot more scrutiny than that.
>>
> Not every low level driver. I started with that infrastructure in
> v2,v3 but I got your inputs and
> I align with that. It could be just single IB stack in one header file
> in one enum list would be sufficient.
> You have already given that example.
> With that mostly two resource type that I have can also shrink to just
> single type.
> Will wait to hear from them, in case if they have any different thought.

Hi,

Sorry for the late reply.

I think that starting with the standard set of resources that uverbs 
provide is good, and if we need in the future new types of resources 
we can add them later.

On 31/01/2016 19:50, Parav Pandit wrote:
> How would you like to see RDMA verb resources being defined - in RDMA
> cgroup or in IB stack?
> In current patch v5, its defined by the IB stack which is often
> shipped as different package due to high amount of changes, bug fixes,
> features.
> In v0 patch it was defined by the RDMA cgroup, which means any new
> resource addition/definition requires kernel upgrade. Which is hard to
> change often.

There is indeed an effort to backport the latest RDMA subsystem modules to 
older kernels, and it would be preferable to be able to introduce new
resources through these modules. However, I understand that there are no
other cgroups that are modules or depend on modules this way, so I would
understand if you decide against it.

> If resources are defined by RDMA cgroup kernel than adding/removing
> resource means, someone have to do lot of engineering with different
> versions of kernel support and loadable module support using compat.h
> etc at driver level, which in my mind is some amount of engineering
> compare to what v5 has to offer and its already available. With one
> round of cleanup in resource definition, it should be usable.
If I understand correctly, if the resources are defined in the cgroup,
you simply won't be able to add new resources with a module update,
no matter how hard you work.

I agree that if the cgroup code is changed for cleanup or whatever 
reason, the backporting may become difficult, but that's just life.

> Its important to provide this feedback to Tejun and me, so that we
> take informed design decision.

Sure. I hope this patchset gets accepted eventually, as I believe it 
solves a real problem. Today RDMA application can easily hog these 
resources and the rdma cgroup allows users to prevent that.

Regards,
Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
