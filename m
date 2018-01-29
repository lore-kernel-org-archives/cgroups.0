From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4.15-rc9] sched, cgroup: Don't reject lower cpu.max on
 ancestors
Date: Mon, 29 Jan 2018 11:15:35 -0800
Message-ID: <20180129191535.GC1121507@devbig577.frc2.facebook.com>
References: <20180122192618.GA1771050@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xyaSuRf0DUP0O+4Ub+6FSi/AVs83mpklQrUE2JhuV3A=;
        b=X+ijzTuQtSx318NsdThBxdxw5ypzMxcMzgay0csqZiBcCzkjtFcuHT3Wp4IETIgYcU
         j0tW4T36pdAfJRs1Sc1lcr0v7WtGJn++v3RkJfiGqraZfxOdxJhr4NXjC4aAfQa8kKXh
         G2h04yJAipNniLIrAqrOX4QYAqe1yJor87BrEXow9t880AH0geiXURiOgkQFNmkl3t5E
         dCBYHgvRyp6Myg0Ovees6Or4O/IQOPQV65KcIUAoiMVF7FN9/Meg32jOz1WQ6eqzp0JT
         E5sjweKPMX/zgtOcbyXfrQUWNAc0W2Pulxi9Kjj91byUQi6gQAExThaHFcT6UDGQpMYH
         YRKQ==
Content-Disposition: inline
In-Reply-To: <20180122192618.GA1771050-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello,

On Mon, Jan 22, 2018 at 11:26:18AM -0800, Tejun Heo wrote:
> While adding cgroup2 interface for the cpu controller, 0d5936344f30
> ("sched: Implement interface for cgroup unified hierarchy") forgot to
> update input validation and left it to reject cpu.max config if any
> descendant has set a higher value.
> 
> cgroup2 officially supports delegation and a descendant must not be
> able to restrict what its ancestors can configure.  For absolute
> limits such as cpu.max and memory.max, this means that the config at
> each level should only act as the upper limit at that level and
> shouldn't interfere with what other cgroups can configure.
> 
> This patch updates config validation on cgroup2 so that the cpu
> controller follows the same convention.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Fixes: 0d5936344f30 ("sched: Implement interface for cgroup unified hierarchy")

Peter, can you please take a look?  I can route it through cgroup tree
if that's preferable.

Thanks.

-- 
tejun
