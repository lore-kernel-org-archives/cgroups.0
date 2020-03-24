From: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 00/11] new cgroup controller for gpu/drm subsystem
Date: Tue, 24 Mar 2020 14:49:27 -0400
Message-ID: <CAOWid-cS-5YkFBLACotkZZCH0RSjHH94_r3VFH8vEPOubzSpPA@mail.gmail.com>
References: <20200226190152.16131-1-Kenny.Ho@amd.com> <CAOWid-eyMGZfOyfEQikwCmPnKxx6MnTm17pBvPeNpgKWi0xN-w@mail.gmail.com>
 <20200324184633.GH162390@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+Bn2txemVnNW3tHUFGp2WOb1jH3UpeSV6hCDyIGrExc=;
        b=RNFkkhe84ZEGayHB8baD92NZqRNYMXvMXE6mRhmjiQa6+aEXFVM7MbYvmyJIdKpcyL
         P0Kt/3R2vW84P4s/9DAgLdNeg35C5fOZkjEhyT13/ZCUR+gG626E0DClz8eIGUTN4nKh
         kPtmyz2MZ8OtHGbxKYWz0+VZ3mQ3xF5qLTcUcbUjDvhp3hca4DAJ/qNdW2MiOi5eR3i0
         RLCdb2fIDqmg5ainr8H58LNrwP4j2Jnrr8FDHiGROvKA7RIu/LOsoSvLChS7sTz6LFpj
         ywjdBuh7EW9/2VFW49Duuk5GS0Htz5fgT9QzmpTW7cYC62W0m/UhGfP0tDnBfRz2EzUV
         K6dQ==
In-Reply-To: <20200324184633.GH162390-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, "Kuehling, Felix" <felix.kuehling-5C7GfCeVMHo@public.gmane.org>, "Greathouse, Joseph" <joseph.greathouse-5C7GfCeVMHo@public.gmane.org>, jsparks-WVYJKLFxKCc@public.gmane.org

Hi Tejun,

Can you elaborate more on what are the missing pieces?

Regards,
Kenny

On Tue, Mar 24, 2020 at 2:46 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Tue, Mar 17, 2020 at 12:03:20PM -0400, Kenny Ho wrote:
> > What's your thoughts on this latest series?
>
> My overall impression is that the feedbacks aren't being incorporated throughly
> / sufficiently.
>
> Thanks.
>
> --
> tejun
