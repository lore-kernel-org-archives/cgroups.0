From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
Date: Wed, 27 Mar 2013 09:15:53 +0800
Message-ID: <51524849.6090603@huawei.com>
References: <20130321090849.GF6094@dhcp22.suse.cz> <20130321102257.GH6094@dhcp22.suse.cz> <514BB23E.70908@huawei.com> <20130322080749.GB31457@dhcp22.suse.cz> <514C1388.6090909@huawei.com> <514C14BF.3050009@parallels.com> <20130322093141.GE31457@dhcp22.suse.cz> <514EAC41.5050700@huawei.com> <20130325090629.GN2154@dhcp22.suse.cz> <51515DEE.70105@parallels.com> <20130326084348.GJ2295@dhcp22.suse.cz> <51516410.2000007@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51516410.2000007-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

> Although correct, it is a bit misleading. It is static in the sense it
> is held by a static variable. But it is acquired by kmalloc...
> 
> In any way, this is a tiny detail.
> 
> FWIW, I am fine with the patch you provided:
> 
> Acked-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> 

Michal, could you resend your final patch to Tejun in a new mail thread?
There are quite a few different patches inlined in this thread.
