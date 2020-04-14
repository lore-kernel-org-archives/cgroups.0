From: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 00/11] new cgroup controller for gpu/drm subsystem
Date: Tue, 14 Apr 2020 08:47:01 -0400
Message-ID: <CAOWid-f-XWyg0o3znH28xYndZ0OMzWfv3OOuWw08iJDKjrqFGA@mail.gmail.com>
References: <20200226190152.16131-1-Kenny.Ho@amd.com>
 <CAOWid-eyMGZfOyfEQikwCmPnKxx6MnTm17pBvPeNpgKWi0xN-w@mail.gmail.com>
 <20200324184633.GH162390@mtj.duckdns.org>
 <CAOWid-cS-5YkFBLACotkZZCH0RSjHH94_r3VFH8vEPOubzSpPA@mail.gmail.com>
 <20200413191136.GI60335@mtj.duckdns.org>
 <20200414122015.GR3456981@phenom.ffwll.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=PRyhuD/q/qOwlm0kCGXzYUfBwRXX/YNDPiZm8kxyWfw=;
 b=eZ75jlgV8S/ZzIaX7d0n1GVxx+e+nNLM0JeqIjKIZL5R2fXELL1gLdVc1A3L+2/Ymk
 WhbIpajbhckGLvguf9NIaCUzUBncvsNIXltfNiXd3Ef92Bq+2BvGDzIw4apEYExuCyvr
 tuPpAk1sZehGNF9Au+LL0+d3FJHVDBAKvMcXizZnjJRTCKpxbByjs2PFw48Mwvf9RfE+
 dN4m865SUI20bTA/onU+ZeDVQjWvQ/d7AX9ZQbukAkSuKxVdf3+CNP61K82+/vm/zMM8
 5BQzHCVquADazudWyZozQ5Hg8yTweCsWYsmgLtrL4umj5RV73+3ND4P6uTEYnAHLu8ON
 jdyQ==
In-Reply-To: <20200414122015.GR3456981-dv86pmgwkMBes7Z6vYuT8azUEOm+Xw19@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Cc: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, "Kuehling, Felix" <felix.kuehling-5C7GfCeVMHo@public.gmane.org>, jsparks-WVYJKLFxKCc@public.gmane.org, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, lkaplan-WVYJKLFxKCc@public.gmane.org, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Greathouse,
 Joseph" <joseph.greathouse-5C7GfCeVMHo@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>

Hi Daniel,

On Tue, Apr 14, 2020 at 8:20 AM Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org> wrote:
> My understanding from talking with a few other folks is that
> the cpumask-style CU-weight thing is not something any other gpu can
> reasonably support (and we have about 6+ of those in-tree)

How does Intel plan to support the SubDevice API as described in your
own spec here:
https://spec.oneapi.com/versions/0.7/oneL0/core/INTRO.html#subdevice-support

Regards,
Kenny
