From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 13/28] slub: create duplicate cache
Date: Wed, 30 May 2012 17:02:35 +0900
Message-ID: <CAOS58YPqOBgmXQia5wM1FKKj5zD2K6gbC3EyQyppFnVSM2i-gQ@mail.gmail.com>
References: <alpine.DEB.2.00.1205291101580.6723@router.home>
	<4FC501E9.60607@parallels.com>
	<alpine.DEB.2.00.1205291222360.8495@router.home>
	<4FC506E6.8030108@parallels.com>
	<alpine.DEB.2.00.1205291424130.8495@router.home>
	<4FC52612.5060006@parallels.com>
	<alpine.DEB.2.00.1205291454030.2504@router.home>
	<4FC52CC6.7020109@parallels.com>
	<alpine.DEB.2.00.1205291514090.2504@router.home>
	<4FC530C0.30509@parallels.com>
	<20120530012955.GA4854@google.com>
	<4FC5D228.2070100@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        bh=ntEBM6MF20rpMHZzP00CyhEp0qdMkK3He8mUwi41ICs=;
        b=TmrQNXtX4mjCknjAbfyLScgwU2V5DzzxucYruW02Hn/z8d9/t0i0wkmAdtiL/wt9RX
         l+kpWBbP60rjVd7d4zS0P2Zt7k/7xarqUhqOYIvnGrVMCDK5rVaCg5cigPMxxhJQGN0m
         Ln0JHn5iXeoIjlJ7Al1SIxsyqvV3DMvJhxIipLORV9Yi3bYk/TX8/Jovp9l66AwgEOQY
         gaZx8SGjliaE7GsYc5Zd10ZkpTHf+XQbGXgCcoWzRox2PPG3/2JpCLiFqXh1jqMEZrqV
         1Xmo+oOsORtT2tf31x1jPOdKfnTEDXKZzZMVsTIDjB5qX4ZSRyYPk2ev27MR3Qxy/pSw
         Jl1w==
In-Reply-To: <4FC5D228.2070100-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

Hello, Glauber.

On Wed, May 30, 2012 at 4:54 PM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> =
wrote:
> On 05/30/2012 05:29 AM, Tejun Heo wrote:
>>
>> The two goals for cgroup controllers that I think are important are
>> proper (no, not crazy perfect but good enough) isolation and an
>> implementation which doesn't impact !cg path in an intrusive manner =
-
>> if someone who doesn't care about cgroup but knows and wants to work
>> on the subsystem should be able to mostly ignore cgroup support. =A0=
If
>> that means overhead for cgroup users, so be it.
>
>
> Well, my code in the slab is totally wrapped in static branches. They=
 only
> come active when the first group is *limited* (not even created: you =
can
> have a thousand memcg, if none of them are kmem limited, nothing will
> happen).

Great, but I'm not sure why you're trying to emphasize that while my
point was about memory overhead and that it's OK to have some
overheads for cg users. :)

> After that, the cost paid is to find out at which cgroup the process =
is at.
> I believe that if we had a faster way for this (like for instance: if=
 we had
> a single hierarchy, the scheduler could put this in a percpu variable=
 after
> context switch - or any other method), then the cost of it could be r=
eally
> low, even when this is enabled.

Someday, hopefully.

> I will rework this series to try work more towards this goal, but at =
least
> for now I'll keep duplicating the caches. I still don't believe that =
a loose
> accounting to the extent Christoph proposed will achieve what we need=
 this
> to achieve.

Yeah, I prefer your per-cg cache approach but do hope that it stays as
far from actual allocator code as possible. Christoph, would it be
acceptable if the cg logic is better separated?

Thanks.

--=20
tejun
