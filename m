From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 09/11] drm, cgroup: Introduce lgpu as DRM cgroup resource
Date: Fri, 14 Feb 2020 16:15:28 -0500
Message-ID: <20200214211528.GB218629@mtj.thefacebook.com>
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
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oZCVTJqDOaYO0qLkkhU/b4V9LR30/p6GYzU8hBz9PHo=;
        b=fFy3EPOllhkeZuzDwhQeqY7WkzV5jBRVVniJ7hseWZc2SSWEnQ9ce7rP0M2cQrtBfW
         7hjXGLyLSXhHOn7Wn+bbVWsEqqTZXjwGqwLKmERklVLh+nVry9j8yIENTvW6e8r4nLyB
         9+1r3RfKg8wimtCMuqW6k29EPOP8HHgvs89vRtxhFp3zep4Zkk4/9YolWCEC3bn9RGho
         HpB2Vbx1/sAk8/99Vg8kA9lMEMqsw7ZFsczNvCPnDn09+DCLogmOtCPSh0PAJbq4xZfO
         UxpTTCCq/EU7xB/PwUDxql5HhYbniZ8ZFh0GUFh+BY+u/OR21TGFiOJr2voMSp/WIyOB
         Edrg==
Content-Disposition: inline
In-Reply-To: <CAOWid-dA2Ad-FTZDDLOs4pperYbsru9cknSuXo_2ajpPbQH0Xg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Jason Ekstrand <jason-fQELhIk9awXprZlt/sZkLg@public.gmane.org>, Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maling list - DRI developers <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, amd-gfx mailing list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, "Kuehling, Felix" <felix.kuehling-5C7GfCeVMHo@public.gmane.org>, "Greathouse, Joseph" <joseph.greathouse-5C7GfCeVMHo@public.gmane.org>, jsparks-WVYJKLFxKCc@public.gmane.org, lkaplan-WVYJKLFxKCc@public.gmane.org, nirmoy.das-5C7GfCeVMHo@public.gmane.org, damon.mcdougall-5C7GfCeVMHo@public.gmane.org, juan.zuniga-anaya-5C7GfCeVMHo@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Fri, Feb 14, 2020 at 03:28:40PM -0500, Kenny Ho wrote:
> Can you elaborate, per your understanding, how the lgpu weight
> attribute differ from the io.weight you suggested?  Is it merely a

Oh, it's the non-weight part which is problematic.

> formatting/naming issue or is it the implementation details that you
> find troubling?  From my perspective, the weight attribute implements
> as you suggested back in RFCv4 (proportional control on top of a unit
> - either physical or time unit.)
> 
> Perhaps more explicit questions would help me understand what you
> mean. If I remove the 'list' and 'count' attributes leaving just
> weight, is that satisfactory?  Are you saying the idea of affinity or

At least from interface pov, yes, although I think it should be clear
what the weight controls.

> named-resource is banned from cgroup entirely (even though it exists
> in the form of cpuset already and users are interested in having such
> options [i.e. userspace OpenCL] when needed?)
> 
> To be clear, I am not saying no proportional control.  I am saying
> give the user the options, which is what has been implemented.

We can get there if we *really* have to but not from the get-go but
I'd rather avoid affinities if at all possible.

Thanks.

-- 
tejun
