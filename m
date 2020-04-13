From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 00/11] new cgroup controller for gpu/drm subsystem
Date: Mon, 13 Apr 2020 17:53:30 -0400
Message-ID: <20200413215330.GN60335@mtj.duckdns.org>
References: <20200226190152.16131-1-Kenny.Ho@amd.com>
 <CAOWid-eyMGZfOyfEQikwCmPnKxx6MnTm17pBvPeNpgKWi0xN-w@mail.gmail.com>
 <20200324184633.GH162390@mtj.duckdns.org>
 <CAOWid-cS-5YkFBLACotkZZCH0RSjHH94_r3VFH8vEPOubzSpPA@mail.gmail.com>
 <20200413191136.GI60335@mtj.duckdns.org>
 <CAOWid-dM=38faGOF9=-Pq=sxssaL+gm2umctyGVQWVx2etShyQ@mail.gmail.com>
 <20200413205436.GM60335@mtj.duckdns.org>
 <CAOWid-fvmxSXtGUtQSZ4Ow1fK+wR8hbnUe5PcsM56EZMOMwb6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=sender:date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=kr/9d9Xct1hX07rDbEYx8wUsf1dJ+pFlOXTM040jufY=;
 b=gt6u/J4rlzknBml16vacwiBKZilSvdoYDgWZrDknJ+/046sco+2EB80oMUdV/xHBPs
 JXsoYf9KaaFkZbzeDRtByuMlHipVMlzej9/sgWSKPxw3Y2bbq19joPpCqEeVpFGZN/kW
 LGzexbW2TXKA87eDlyeQPbwbYK//L1/PGzT+32hn9sEykCWesA9Z4Z+XJ6qgnQblAwke
 zxLDzq78qEG9KKKCo/BbyLfOgUYD3uVPXzDtQOaEHP2kvWOMG1rr9rTw2Hse/IGwcYsD
 8Xg55dDgYHJ90FzihCUobI7Sv7LeHFHd7CqDtHUuB7DdwAEPvH+OY+6IqE3xGXs/m7+0
 7kxg==
Content-Disposition: inline
In-Reply-To: <CAOWid-fvmxSXtGUtQSZ4Ow1fK+wR8hbnUe5PcsM56EZMOMwb6g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, "Kuehling, Felix" <felix.kuehling-5C7GfCeVMHo@public.gmane.org>, jsparks-WVYJKLFxKCc@public.gmane.org, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, lkaplan-WVYJKLFxKCc@public.gmane.org, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Greathouse,
 Joseph" <joseph.greathouse-5C7GfCeVMHo@public.gmane.org>, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>

Hello,

On Mon, Apr 13, 2020 at 05:40:32PM -0400, Kenny Ho wrote:
> By lack of consense, do you mean Intel's assertion that a standard is
> not a standard until Intel implements it? (That was in the context of
> OpenCL language standard with the concept of SubDevice.)  I thought
> the discussion so far has established that the concept of a compute
> unit, while named differently (AMD's CUs, ARM's SCs, Intel's EUs,
> Nvidia's SMs, Qualcomm's SPs), is cross vendor.  While an AMD CU is
> not the same as an Intel EU or Nvidia SM, the same can be said for CPU
> cores.  If cpuset is acceptable for a diversity of CPU core designs
> and arrangements, I don't understand why an interface derived from GPU
> SubDevice is considered premature.

CPUs are a lot more uniform across vendors than GPUs and have way higher user
observability and awareness. And, even then, it's something which has limited
usefulness because the configuration is inherently more complex involving
topology details and the end result is not work-conserving.

cpuset is there partly due to historical reasons and its features can often be
trivially replicated with some scripting around taskset. If that's all you're
trying to add, I don't see why it needs to be in cgroup at all. Just implement
a tool similar to taskset and build sufficient tooling around it. Given how
hardware specific it can become, that is likely the better direction anyway.

Thanks.

-- 
tejun
