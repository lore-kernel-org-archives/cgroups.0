From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Wed, 7 Sep 2016 13:25:13 +0530
Message-ID: <CAG53R5Ws4BJKqeEYfEoEx5kuaXUmhDKcXfH4Vx=LTMK6tKMG0A@mail.gmail.com>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com>
 <1472632647-1525-2-git-send-email-pandit.parav@gmail.com> <61101e8b-5776-c0bc-b3ea-d8b984eebabf@mellanox.com>
 <20160831211618.GA12660@htj.duckdns.org> <9b6a346d-af4c-1e5f-0144-f68fb8e46c27@mellanox.com>
 <20160901084406.GA4115@lst.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=XGV0giUoEKEwEdNDhS8Uv8pktyyavskJqStcgtha9ds=;
        b=ITcpMMaQbbiYPRrreMoYi7QqlwOWKOn2Y4d1HUY8CBR+TNaOTklmdevEJ/Hgnoj+89
         CpQwZIR4YtZKC+YcNumBg7mmsBTc+XgAgKYoaMMwb/DkwEYRU3oWRoKLiNPYd6h3maab
         LTJycrAlcsAbaBijAycOkkB2gS5yefNvXMAbS+SzTPX+JQjqLo4gf102ZcB3Uv6a8axn
         kBFAlAl7t7Z2nkN+vsdOS+TnSCWwnz8Z6I2qn5pNJZ2TC9eyTx5Ur6w7BBEpEb6xaR1Y
         F0bxRMIFJnARiV7gH8Dg1xWgAXydTyM1kSCR//jEFLOYIPK1Ia6fY3ePI2g0FkIxbBM2
         ImWQ==
In-Reply-To: <20160901084406.GA4115-jcswGhMUV9g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Matan,

On Thu, Sep 1, 2016 at 2:14 PM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> On Thu, Sep 01, 2016 at 10:25:40AM +0300, Matan Barak wrote:
>> Well, if I recall, the reason doing so last time was in order to allow
>> flexible updating of ib_core independently, which is obviously not a good
>> reason (to say the least).
>>
>> Since the new ABI will probably define new object types (all recent
>> proposals go this way), the current approach could lead to either trying to
>> map new objects to existing cgroup resource types, which could lead to some
>> weird non 1:1 mapping, or having a split definitions - such that each
>> driver will declare its objects both in the cgroups mechanism and in its
>> driver dispatch table.

>> Even worse than that, drivers could simply ignore the cgroups support while
>> implementing their own resource types and get a very broken containers
>> support.
If drivers are broken due to ignorance of not-calling cgroup APIs,
that should be ok.
That particular driver should fix it.
If the resource creation using uverbs is using well defined rdma level
resource, uverbs level will make sure to honor cgroup limits without
involving hw drivers anyway.

RDMA Verb level resource is charged/uncharged by RDMA core.
RDMA HW level resource is charged/uncharged by RDMA HW driver using
well defined API and resource by cgroup core.
This scheme ensures that there is 1:1 mapping.

I don't think current definition of resource type is carved out on stone.
They can be extended as we forward.
As many of us agree that, they should be well defined and it should be
agreed by cgroup and rdma community.

For example, today we have RDMA_VERB_xxx resources.
New well defined RDMA HW resources can be defined in rdma_cgroup.h
file as RDMA_HW_xx in same enum table.

>
> Sorry guys, but arbitrary extensibility for something not finished is the
> worst idea ever.  We have two options here:
>
>  a) delay cgroups support until the grand rewrite is done
>  b) add it now and deal with the consequences later
>
Can we do (b) now and differ adding any HW resources to cgroup until
they are clearly called out.
Architecture and APIs are already in place to support this.

> That being said, adding random non-Verbs hardwasre to the RDMA core is
> the second worst idea ever.

We can differ adding HW resource to core and cgroup until they are
clearly defined.
In that case current architecture still holds good.

> Guess I need to catch up with the
> discussion and start using the flame thrower.

Matan,
Can you please point us to the new RFC/ABI email thread which
describes the design, partitioning of code between core vs hw drivers
etc.
