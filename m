From: Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>
Subject: Re: [PATCH v2 cgroup/for-3.16] cgroup: introduce CSS_NO_REF and skip
 refcnting on normal root csses
Date: Fri, 16 May 2014 11:19:24 -0600
Message-ID: <5376489C.9010902@wwwdotorg.org>
References: <1399670015-23463-1-git-send-email-tj@kernel.org> <1399670015-23463-10-git-send-email-tj@kernel.org> <53751062.2050401@wwwdotorg.org> <53753823.2090402@wwwdotorg.org> <20140516143718.GA5379@htj.dyndns.org> <20140516154330.GB5379@htj.dyndns.org> <537643F9.1030303@wwwdotorg.org> <20140516170959.GG5379@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140516170959.GG5379-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ARM kernel mailing list <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>

On 05/16/2014 11:09 AM, Tejun Heo wrote:
> 9395a4500404 ("cgroup: enable refcnting for root csses") enabled
> reference counting for root csses (cgroup_subsys_states) so that
> cgroup's self csses can be used to manage the lifetime of the
> containing cgroups.
> 
> Unfortunately, this change was incorrect.  During early init,
> cgrp_dfl_root self css refcnt is used.  percpu_ref can't initialized
> during early init and its initialization is deferred till
> cgroup_init() time.  This means that cpu was using percpu_ref which
> wasn't properly initialized.  Due to the way percpu variables are laid
> out on x86, this didn't blow up immediately on x86 but ended up
> incrementing and decrementing the percpu variable at offset zero,
> whatever it may be; however, on other archs, this caused fault and
> early boot failure.
> 
> As cgroup self csses for root cgroups of non-dfl hierarchies need
> working refcounting, we can't revert 9395a4500404.  This patch adds
> CSS_NO_REF which explicitly inhibits reference counting on the css and
> sets it on all normal (non-self) csses and cgroup_dfl_root self css.
> 
> v2: cgrp_dfl_root.self is the offending one.  Set the flag on it.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reported-by: Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>
> Fixes: 9395a4500404 ("cgroup: enable refcnting for root csses")
> ---
> Hello,
> 
> Can you try this one instead?

Yes, this one works great, thanks.
Tested-by: Stephen Warren <swarren-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
