From: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 00/11] new cgroup controller for gpu/drm subsystem
Date: Mon, 13 Apr 2020 17:40:32 -0400
Message-ID: <CAOWid-fvmxSXtGUtQSZ4Ow1fK+wR8hbnUe5PcsM56EZMOMwb6g@mail.gmail.com>
References: <20200226190152.16131-1-Kenny.Ho@amd.com> <CAOWid-eyMGZfOyfEQikwCmPnKxx6MnTm17pBvPeNpgKWi0xN-w@mail.gmail.com>
 <20200324184633.GH162390@mtj.duckdns.org> <CAOWid-cS-5YkFBLACotkZZCH0RSjHH94_r3VFH8vEPOubzSpPA@mail.gmail.com>
 <20200413191136.GI60335@mtj.duckdns.org> <CAOWid-dM=38faGOF9=-Pq=sxssaL+gm2umctyGVQWVx2etShyQ@mail.gmail.com>
 <20200413205436.GM60335@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O3TzEoMtIfUdNB8j5+48orQwp7L+4a4BtPUMG6Pa9Qs=;
        b=JJPXaMUMVrsrFSqVXlhblXhpVdyvyU1hImwu8WoU8B2TfGosdDZS3BTkSPdwtBM3aW
         YKmrxwFbUw9GDetYjYLgNvG3ssHyU7RxH9cLyKRMfyXowPCRYtusXu/fS3S6XhCizpF2
         Uojh6woCNv7Q/tz6Z0gTY+LbuIAN45HA8KGXBCpJBhAUTr9JdEtY5V0yoO9DpWXkuVt0
         r+E/qJVorbUAwxCz3D9gYe4ZrXP2G72jPanfh6r7R1UsmxWDRL5b065ilJyDREYQj2aG
         u3t+f91ZDlqBbA1t1sd7y5uaOpjCSurFyTCr0NhvXqLd+BFTjyN5fdA/Hza/FDYtnxqB
         rpVQ==
In-Reply-To: <20200413205436.GM60335-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, "Kuehling, Felix" <felix.kuehling-5C7GfCeVMHo@public.gmane.org>, "Greathouse, Joseph" <joseph.greathouse-5C7GfCeVMHo@public.gmane.org>, jsparks-WVYJKLFxKCc@public.gmane.org, lkaplan-WVYJKLFxKCc@public.gmane.org

Hi,

On Mon, Apr 13, 2020 at 4:54 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Allocations definitely are acceptable and it's not a pre-requisite to have
> work-conserving control first either. Here, given the lack of consensus in
> terms of what even constitute resource units, I don't think it'd be a good
> idea to commit to the proposed interface and believe it'd be beneficial to
> work on interface-wise simpler work conserving controls.
>
...
> I hope the rationales are clear now. What I'm objecting is inclusion of
> premature interface, which is a lot easier and more tempting to do for
> hardware-specific limits and the proposals up until now have been showing
> ample signs of that. I don't think my position has changed much since the
> beginning - do the difficult-to-implement but easy-to-use weights first and
> then you and everyone would have a better idea of what hard-limit or
> allocation interfaces and mechanisms should look like, or even whether they're
> needed.

By lack of consense, do you mean Intel's assertion that a standard is
not a standard until Intel implements it? (That was in the context of
OpenCL language standard with the concept of SubDevice.)  I thought
the discussion so far has established that the concept of a compute
unit, while named differently (AMD's CUs, ARM's SCs, Intel's EUs,
Nvidia's SMs, Qualcomm's SPs), is cross vendor.  While an AMD CU is
not the same as an Intel EU or Nvidia SM, the same can be said for CPU
cores.  If cpuset is acceptable for a diversity of CPU core designs
and arrangements, I don't understand why an interface derived from GPU
SubDevice is considered premature.

If a decade-old language standard is not considered a consenses, can
you elaborate on what might consitute a consenses?

Regards,
Kenny
