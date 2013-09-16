From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 0/7] improve memcg oom killer robustness v2
Date: Mon, 16 Sep 2013 11:17:26 -0400
Message-ID: <20130916151726.GY856@cmpxchg.org>
References: <20130911191150.GN856@cmpxchg.org>
 <20130911214118.7CDF2E71@pobox.sk>
 <20130911200426.GO856@cmpxchg.org>
 <20130914124831.4DD20346@pobox.sk>
 <20130916134014.GA3674@dhcp22.suse.cz>
 <20130916160119.2E76C2A1@pobox.sk>
 <20130916140607.GC3674@dhcp22.suse.cz>
 <20130916161316.5113F6E7@pobox.sk>
 <20130916145744.GE3674@dhcp22.suse.cz>
 <20130916170543.77F1ECB4@pobox.sk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130916170543.77F1ECB4-Rm0zKEqwvD4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Sep 16, 2013 at 05:05:43PM +0200, azurIt wrote:
> > CC: "Johannes Weiner" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Andrew Morton" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David Rientjes" <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "KAMEZAWA Hiroyuki" <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "KOSAKI Motohiro" <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >On Mon 16-09-13 16:13:16, azurIt wrote:
> >[...]
> >> >You can use sysrq+l via serial console to see tasks hogging the CPU or
> >> >sysrq+t to see all the existing tasks.
> >> 
> >> 
> >> Doesn't work here, it just prints 'l' resp. 't'.
> >
> >I am using telnet for accessing my serial consoles exported by
> >the multiplicator or KVM and it can send sysrq via ctrl+t (Send
> >Break). Check your serial console setup.
> 
> 
> 
> I'm using Raritan KVM and i created keyboard macro 'sysrq + l' resp. 'sysrq + t'. I'm also unable to use it on my local PC. Maybe it needs to be enabled somehow?

Can you 'echo t >/proc/sysrq-trigger'?
