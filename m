From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 09/11] drm, cgroup: Introduce lgpu as DRM cgroup resource
Date: Wed, 19 Feb 2020 11:21:25 -0500
Message-ID: <20200219162125.GC13406@cmpxchg.org>
References: <20200214155650.21203-1-Kenny.Ho@amd.com>
 <20200214155650.21203-10-Kenny.Ho@amd.com>
 <CAOFGe96N5gG+08rQCRC+diHKDAfxPFYEnVxDS8_udvjcBYgsPg@mail.gmail.com>
 <CAOWid-f62Uv=GZXX2V2BsQGM5A1JJG_qmyrOwd=KwZBx_sr-bg@mail.gmail.com>
 <20200214183401.GY2363188@phenom.ffwll.local>
 <CAOWid-caJHeXUnQv3MOi=9U+vdBLfewN+CrA-7jRrz0VXqatbQ@mail.gmail.com>
 <20200214191754.GA218629@mtj.thefacebook.com>
 <CAOWid-dA2Ad-FTZDDLOs4pperYbsru9cknSuXo_2ajpPbQH0Xg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1IjE5f3DRWrL7DyNrD/EPrz9NqvpJo1LzwPmSu0Loyo=;
        b=Y0xUdyvI/KOwgnUyUAXVRQts2j2UDpi0MSoQ8O0ZIpFCbCbLaplKvU5pIrb49CIcHK
         Oko/yr/AtoCn2I7wP1Yz/l85vKpPmPYS2VLT7dy7v+KArYcmNL6mvY79eopcTfkaMHlR
         6ad0zsqSYvukfQwQMDKXW3o2M1y+7ZLCHho3eH9+XHp9GDKhBElQTtLcwPW1OzZqDG+o
         ey+6JO61zvRaKvwJ1VNS2Jvb4aETsOQDmV7IiKJxQwWThbSwQ3VPR/0SGwTsSc5081+r
         p4IwL9I721gfQnwgUof/i3OQS3UBN6v3KV2bdrPVFgNPBL/Fy8ditUJoByLUoc/wDrIn
         VXEQ==
Content-Disposition: inline
In-Reply-To: <CAOWid-dA2Ad-FTZDDLOs4pperYbsru9cknSuXo_2ajpPbQH0Xg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Jason Ekstrand <jason-fQELhIk9awXprZlt/sZkLg@public.gmane.org>, Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maling list - DRI developers <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, amd-gfx mailing list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, "Kuehling, Felix" <felix.kuehling-5C7GfCeVMHo@public.gmane.org>, "Greathouse, Joseph" <joseph.greathouse-5C7GfCeVMHo@public.gmane.org>, jsparks-WVYJKLFxKCc@public.gmane.org, lkaplan-WVYJKLFxKCc@public.gmane.org, nirmoy.das-5C7GfCeVMHo@public.gmane.org, damon.mcdougall-5C7GfCeVMHo@public.gmane.org, juan.zuniga-anaya-5C7GfCeVMHo@public.gmane.org

On Fri, Feb 14, 2020 at 03:28:40PM -0500, Kenny Ho wrote:
> On Fri, Feb 14, 2020 at 2:17 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > Also, a rather trivial high level question. Is drm a good controller
> > name given that other controller names are like cpu, memory, io?
> 
> There was a discussion about naming early in the RFC (I believe
> RFCv2), the consensuses then was to use drmcg to align with the drm
> subsystem.  I have no problem renaming it to gpucg  or something
> similar if that is the last thing that's blocking acceptance.  For
> now, I would like to get some clarity on the implementation before
> having more code churn.

As far as precedence goes, we named the other controllers after the
resources they control rather than the subsystem: cpu instead of
scheduler, memory instead of mm, io instead of block layer etc.
