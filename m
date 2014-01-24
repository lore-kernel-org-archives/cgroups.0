From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cpusets: Allocate heap only when required
Date: Fri, 24 Jan 2014 05:59:52 -0500
Message-ID: <20140124105952.GD4101@htj.dyndns.org>
References: <8622e93b9c49c66ffdc9ef0aa8371c322718edd5.1390475530.git.viresh.kumar@linaro.org>
 <alpine.DEB.2.02.1401231330530.7313@chino.kir.corp.google.com>
 <52E1C8BD.2010500@huawei.com>
 <alpine.DEB.2.02.1401240230190.9846@chino.kir.corp.google.com>
 <20140124103631.GB4101@htj.dyndns.org>
 <alpine.DEB.2.02.1401240243260.24372@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=NDZJEgbWglpPFcWinv+9YWl09LoV5LQNuSRbNmFfleA=;
        b=BISfxgNCocLF28eDaNke8gA6kNjAD0wfYVFo6rPxNKtPaes7MvMRWo1yf5PtWgnwNF
         520S14HadYKGkRPLSKqwV+I0kmwZqSyfe+qBUSTl+kuOR8vAJeXB5wAkRv932sSuscGU
         ilFz6pad1tjb9/dckyJ0cmWG9Ps2j1tg0uFE6+74sTc0qoMim0OtHgQK/8WletDvD4xA
         RJKgIpA3JwSqmMmcet2hoNgpOp/+hE2VnTzTuYp76qt9AZHtcj9npnfS5AeC7aYECJHQ
         Ey5rl13qrsiCoOFzkN1BZ99zLbEPID6uhtZ2cFNiGeNQLPnbUVrkBFkfx7NRYRcxtb8G
         6UIA==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401240243260.24372-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hey,

On Fri, Jan 24, 2014 at 02:51:12AM -0800, David Rientjes wrote:
> Nobody is depending on shit, the patch is removing a completely pointless 
> memory allocation in braindead cpuset code.  What you think is "harmful" 
> or "more harmful" is irrelevant, but nobody said anything about depending 
> on that behavior to do anything.

Weren't you talking something of that effect in memcg?  Or was it
Michal?  At any rate, I think you're missing the point why Li replied
that it's harmless.  He, I think, meant that it doesn't make any
semantical difference to userland, so your reply saying that it's not
harmless listing the failure mode under memory pressure seemed
misleading, so I thought clarification was necessary.  Probably my
(false?) memory of you talking about that contributed.  Anyways, we
agree.  Don't depend on it.

Thanks.

-- 
tejun
