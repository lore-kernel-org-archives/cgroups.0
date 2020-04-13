From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 00/11] new cgroup controller for gpu/drm subsystem
Date: Mon, 13 Apr 2020 15:11:36 -0400
Message-ID: <20200413191136.GI60335@mtj.duckdns.org>
References: <20200226190152.16131-1-Kenny.Ho@amd.com>
 <CAOWid-eyMGZfOyfEQikwCmPnKxx6MnTm17pBvPeNpgKWi0xN-w@mail.gmail.com>
 <20200324184633.GH162390@mtj.duckdns.org>
 <CAOWid-cS-5YkFBLACotkZZCH0RSjHH94_r3VFH8vEPOubzSpPA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+lbubkUGFiM6VzQ+ueHXGQsXYs3AnJsTHepD8DGOyaE=;
        b=eaYLPoyRllFIIJ1rsXYKhFdiz0QqsdX7PAjZtRacsfQZqFUOOFeyjQ7vNX5brDMf82
         Uue5XZO8jlEiz9SQba87q5dC3SUCiD7k3LRm/w/0yX/UkQ2PzmEiC16wNMwL3/s5Fwyw
         HtsKhQjpjwegOtBIZ9HSjQH1YdNlbxSiPuzcLphimp2WqXJpyyvPRUNMWOUk7iixdixj
         Z/pbwzYJv+KRMY04nvZDKbtpp4CoiJ60W/HRsp/sdywWVD2JB6nKyxfHGPu8xDc5+MHT
         vVHbrbYqM5DBhz2tVz/4/rEmbjeV3PWxyENQFvkI4YdOpFxfCbmRFX2dFi+3WAbjEy6x
         19pA==
Content-Disposition: inline
In-Reply-To: <CAOWid-cS-5YkFBLACotkZZCH0RSjHH94_r3VFH8vEPOubzSpPA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, "Kuehling, Felix" <felix.kuehling-5C7GfCeVMHo@public.gmane.org>, "Greathouse, Joseph" <joseph.greathouse-5C7GfCeVMHo@public.gmane.org>, jsparks-WVYJKLFxKCc@public.gmane.org

Hello, Kenny.

On Tue, Mar 24, 2020 at 02:49:27PM -0400, Kenny Ho wrote:
> Can you elaborate more on what are the missing pieces?

Sorry about the long delay, but I think we've been going in circles for quite
a while now. Let's try to make it really simple as the first step. How about
something like the following?

* gpu.weight (should it be gpu.compute.weight? idk) - A single number
  per-device weight similar to io.weight, which distributes computation
  resources in work-conserving way.

* gpu.memory.high - A single number per-device on-device memory limit.

The above two, if works well, should already be plenty useful. And my guess is
that getting the above working well will be plenty challenging already even
though it's already excluding work-conserving memory distribution. So, let's
please do that as the first step and see what more would be needed from there.

Thanks.

-- 
tejun
