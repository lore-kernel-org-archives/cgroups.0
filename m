From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] mm: memcontrol: memory+swap accounting for cgroup-v2
Date: Wed, 20 Dec 2017 11:37:41 -0800
Message-ID: <20171220193741.GD3413940@devbig577.frc2.facebook.com>
References: <20171219000131.149170-1-shakeelb@google.com>
 <20171219124908.GS2787@dhcp22.suse.cz>
 <CALvZod5jU9vPoJaf44TVT0_HQpEESiELJU5MD_DDRbcOkPNQbg@mail.gmail.com>
 <20171219152444.GP3919388@devbig577.frc2.facebook.com>
 <CALvZod5sWWBX69QovOeLBSx9vij7=5cmoSocdTUvh2Uq8=noyQ@mail.gmail.com>
 <20171219173354.GQ3919388@devbig577.frc2.facebook.com>
 <CALvZod7pbp0fFUPRnC68qdzkCEUg2YTavq6C6OLxqooCU5VeyQ@mail.gmail.com>
 <20171219214107.GR3919388@devbig577.frc2.facebook.com>
 <CALvZod5XRhXc3XrQw50Jw_OpRQB2iCCbgG-NMDCa8xRmGNdLrw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BoIDO1fgPU68XthW6hQDwua0uo1j5JP6PHQ+3yPSYdg=;
        b=Ai2HEvw30ckB87BpBkdAqpfP0+qPg5g9h7i5n+kCWIVPdnUgaD1Oq0uSVT+V6qxOLT
         WSF57eJ+nC0HdP7vGRnDh85AMJWuPZ/TqNeW6uZ8uGcRh6oRhKAoLf7O5PlDVTJZc8aL
         buBya8Vdg1bWw4hY3rtcmYDHJSjCPdpb+cDrHChjxWMkGoyIm0kGjVdWUArPLlv58qo7
         W7Y/k6qFVQNaqcmrXHwgDN0+lknL8k+n6DI3yzGUxSJ8GLcSUpXe94ENZ4P88+1CRI2K
         rNYGqmPexQ5zARx9uHgjhv0Q8zSVBE4yQWDIAxAgIWsRsX/A6PVEyUXNWcL1DNi/PcjP
         pTyw==
Content-Disposition: inline
In-Reply-To: <CALvZod5XRhXc3XrQw50Jw_OpRQB2iCCbgG-NMDCa8xRmGNdLrw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Shakeel.

On Tue, Dec 19, 2017 at 02:39:19PM -0800, Shakeel Butt wrote:
> Suppose a user wants to run multiple instances of a specific job on
> different datacenters and s/he has budget of 100MiB for each instance.
> The instances are schduled on the requested datacenters and the
> scheduler has set the memory limit of those instances to 100MiB. Now,
> some datacenters have swap deployed, so, there, let's say, the swap
> limit of those instances are set according to swap medium
> availability. In this setting the user will see inconsistent memcg OOM
> behavior. Some of the instances see OOMs at 100MiB usage (suppose only
> anon memory) while some will see OOMs way above 100MiB due to swap.
> So, the user is required to know the internal knowledge of datacenters
> (like which has swap or not and swap type) and has to set the limits
> accordingly and thus increase the chance of config bugs.

I don't understand how this invariant is useful across different
backing swap devices and availability.  e.g. Our OOM decisions are
currently not great in that the kernel can easily thrash for a very
long time without making actual progresses.  If you combine that with
widely varying types and availability of swaps, whether something is
OOMing or not doesn't really tell you much.  The workload could be
running completely fine or have been thrashing without making any
meaningful forward progress for the past 15 mins.

Given that whether or not swap exists, how much is avialable and how
fast the backing swap device is all highly influential parameters in
how the workload behaves, I don't see what having sum of memory + swap
as an invariant actually buys.  And, even that essentially meaningless
invariant doesn't really exist - the performance of the swap device
absolutely affects when the OOM killer would kick in.

So, I don't see how the sum of memory+swap makes it possible to ignore
the swap type and availability.  Can you please explain that further?

> Also different types and sizes of swap mediums in data center will
> further complicates the configuration. One datacenter might have SSD
> as a swap, another might be doing swap on zram and third might be
> doing swap on nvdimm. Each can have different size and can be assigned
> to jobs differently. So, it is possible that the instances of the same
> job might be assigned different swap limit on different datacenters.

Sure, but what does memswap achieve?

Thanks.

-- 
tejun
