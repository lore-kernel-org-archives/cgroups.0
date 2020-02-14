From: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 09/11] drm, cgroup: Introduce lgpu as DRM cgroup resource
Date: Fri, 14 Feb 2020 15:28:40 -0500
Message-ID: <CAOWid-dA2Ad-FTZDDLOs4pperYbsru9cknSuXo_2ajpPbQH0Xg@mail.gmail.com>
References: <20200214155650.21203-1-Kenny.Ho@amd.com> <20200214155650.21203-10-Kenny.Ho@amd.com>
 <CAOFGe96N5gG+08rQCRC+diHKDAfxPFYEnVxDS8_udvjcBYgsPg@mail.gmail.com>
 <CAOWid-f62Uv=GZXX2V2BsQGM5A1JJG_qmyrOwd=KwZBx_sr-bg@mail.gmail.com>
 <20200214183401.GY2363188@phenom.ffwll.local> <CAOWid-caJHeXUnQv3MOi=9U+vdBLfewN+CrA-7jRrz0VXqatbQ@mail.gmail.com>
 <20200214191754.GA218629@mtj.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O7pGksv/syYfMklkQS/MIxpCbqI6gBoN9ooNLnkw1E8=;
        b=N1XKAjyzrOIL2WzL1i8osQZXd6YVKxqkJSXnzZnFBy1EQOWFgDBfiObxlJ6bu7mVat
         eUdmeSjiexNOP2Prvp/0vLY5h/yLiURfC8HoGpPbpMX54OZ8mr/dUR29OBSMivfWUWXn
         iyguSO0yZXfkaIQtW7BYfxWDSegl8iR5+RdQ82QsOBT8A8FoilCfgTKeFMSqVwieUMZi
         U8o4gtsr1gm5O6AvmypSDqY/hNM0Gcg7QWEJ2WD9fhHMcr7QyfNgEhkD1woTpTAfdwvQ
         Eb3cQ7NrGnGi9ubqbT2kUO6hU52AeCwU0WutSeAT4c8nD40tE5hqBlMSInEIdyFR905L
         EXqg==
In-Reply-To: <20200214191754.GA218629-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Jason Ekstrand <jason-fQELhIk9awXprZlt/sZkLg@public.gmane.org>, Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maling list - DRI developers <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, amd-gfx mailing list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, "Kuehling, Felix" <felix.kuehling-5C7GfCeVMHo@public.gmane.org>, "Greathouse, Joseph" <joseph.greathouse-5C7GfCeVMHo@public.gmane.org>, jsparks-WVYJKLFxKCc@public.gmane.org, lkaplan-WVYJKLFxKCc@public.gmane.org, nirmoy.das-5C7GfCeVMHo@public.gmane.org, damon.mcdougall-5C7GfCeVMHo@public.gmane.org, juan.zuniga-anaya-5C7GfCeVMHo@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hi Tejun,

On Fri, Feb 14, 2020 at 2:17 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> I have to agree with Daniel here. My apologies if I weren't clear
> enough. Here's one interface I can think of:
>
>  * compute weight: The same format as io.weight. Proportional control
>    of gpu compute.
>
>  * memory low: Please see how the system memory.low behaves. For gpus,
>    it'll need per-device entries.
>
> Note that for both, there one number to configure and conceptually
> it's pretty clear to everybody what that number means, which is not to
> say that it's clear to implement but it's much better to deal with
> that on this side of the interface than the other.

Can you elaborate, per your understanding, how the lgpu weight
attribute differ from the io.weight you suggested?  Is it merely a
formatting/naming issue or is it the implementation details that you
find troubling?  From my perspective, the weight attribute implements
as you suggested back in RFCv4 (proportional control on top of a unit
- either physical or time unit.)

Perhaps more explicit questions would help me understand what you
mean. If I remove the 'list' and 'count' attributes leaving just
weight, is that satisfactory?  Are you saying the idea of affinity or
named-resource is banned from cgroup entirely (even though it exists
in the form of cpuset already and users are interested in having such
options [i.e. userspace OpenCL] when needed?)

To be clear, I am not saying no proportional control.  I am saying
give the user the options, which is what has been implemented.

> cc'ing Johannes. Do you have anything on mind regarding how gpu memory
> configuration should look like? e.g. should it go w/ weights rather
> than absoulte units (I don't think so given that it'll most likely
> need limits at some point too but still and there are benefits from
> staying consistent with system memory).
>
> Also, a rather trivial high level question. Is drm a good controller
> name given that other controller names are like cpu, memory, io?

There was a discussion about naming early in the RFC (I believe
RFCv2), the consensuses then was to use drmcg to align with the drm
subsystem.  I have no problem renaming it to gpucg  or something
similar if that is the last thing that's blocking acceptance.  For
now, I would like to get some clarity on the implementation before
having more code churn.

Regards,
Kenny


> Thanks.
>
> --
> tejun
