From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [patch] mm, memcg: avoid unnecessary function call when memcg
 is disabled
Date: Tue, 20 Nov 2012 12:34:29 +0400
Message-ID: <50AB4095.6000502@parallels.com>
References: <alpine.DEB.2.00.1211191741060.24618@chino.kir.corp.google.com> <50AB05B4.4000303@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50AB05B4.4000303-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 11/20/2012 08:23 AM, Kamezawa Hiroyuki wrote:
> (2012/11/20 10:44), David Rientjes wrote:
>> While profiling numa/core v16 with cgroup_disable=memory on the command
>> line, I noticed mem_cgroup_count_vm_event() still showed up as high as
>> 0.60% in perftop.
>>
>> This occurs because the function is called extremely often even when
>> memcg
>> is disabled.
>>
>> To fix this, inline the check for mem_cgroup_disabled() so we avoid the
>> unnecessary function call if memcg is disabled.
>>
>> Signed-off-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> Acked-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> 
I am fine with this as well.

Acked-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
