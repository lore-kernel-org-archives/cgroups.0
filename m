From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.16] cgroup: disallow debug controller on the
 default hierarchy
Date: Mon, 19 May 2014 16:38:11 -0400
Message-ID: <20140519203811.GF27506@mtj.dyndns.org>
References: <20140514233307.GI15690@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=VpManIPtmDK2C429DytpdSpfs6LRG2m1Z2MI1/XNhR8=;
        b=F1nrc3bC6DnjtRpKvcmKVXTtZqA6m5enzZ73AaQ4BXMgWh2vDY6dRRNTyiRHcuCuVc
         vzlgKxqbETTatghouH9ZRu6hoEp8CjbjLNO0osoW+eZ1iU9tXXebPJQO/+CrfZmia9WO
         vd+KurxVcVjZdBts/1p7yZRdDP8kbvSeK2gWl6+PYDFJjceFqszSQtrwzTBfR81RB6T2
         gahZX7sTvlHs088UsLIriK+YyUiaQpwpxVyJBQnh3eIzJa96DsBrRlS+QvznR+I+oBIW
         meAgTB9Fb7+lMrvVSAh8YIvZR20afarlrsHepaXfP0AudH9Em5M9nhTkIUNA3JKSIPr6
         Bz/w==
Content-Disposition: inline
In-Reply-To: <20140514233307.GI15690-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, May 14, 2014 at 07:33:07PM -0400, Tejun Heo wrote:
> The debug controller, as its name suggests, exposes cgroup core
> internals to userland to aid debugging.  Unfortunately, except for the
> name, there's no provision to prevent its usage in production
> configurations and the controller is widely enabled and mounted
> leaking internal details to userland.  Like most other debug
> information, the information exposed by debug isn't interesting even
> for debugging itself once the related parts are working reliably.
> 
> This controller has no reason for existing.  This patch implements
> cgrp_dfl_root_inhibit_ss_mask which can suppress specific subsystems
> on the default hierarchy and adds the debug subsystem to it so that it
> can be gradually deprecated as usages move towards the unified
> hierarchy.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Applied to cgroup/for-3.16.

Thanks.

-- 
tejun
