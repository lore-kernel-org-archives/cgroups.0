From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Tue, 5 Nov 2013 17:01:37 +0800
Message-ID: <5278B3F1.9040502@huawei.com>
References: <4431690.ZqnBIdaGMg@akheu22.uni-muenster.de> <5257F7CE.90702@huawei.com> <CA+SBX_Pa8sJbRq3aOghzqam5tDUbs_SPnVTaewtg-pRmvUqSzA@mail.gmail.com> <5258E584.70500@huawei.com> <CA+SBX_MQVMuzWKroASK7Cr5J8cu9ajGo=CWr7SRs+OWh83h4_w@mail.gmail.com> <525CB337.8050105@huawei.com> <CA+SBX_Ogo8HP81o+vrJ8ozSBN6gPwzc8WNOV3Uya=4AYv+CCyQ@mail.gmail.com> <CA+SBX_OJBbYzrNX5Mi4rmM2SANShXMmAvuPGczAyBdx8F2hBDQ@mail.gmail.com> <5270BFE7.4000602@huawei.com> <alpine.LNX.2.00.1310301606080.2333@eggly.anvils> <20131031130647.0ff6f2c7@gandalf.local.home> <alpine.LNX.2.00.1310311442030.2633@eggly.anvils> <20131031192732.2dbb14b3@gandalf.local.home> <CA+SBX_NjAYrqqOpSuCy8Wpj6q1hE_qdLrRV6auydmJjdcHKQHg@mail.gmail.com> <5277932C.40400@huawei.com> <CA+SBX_ORkOzDynKKweg=JomY2+1kz4=FXYJXYMsN8LKf48idBg@mail.gmail.
 com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+SBX_ORkOzDynKKweg=JomY2+1kz4=FXYJXYMsN8LKf48idBg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2013/11/4 21:43, Markus Blank-Burian wrote:
>> synchronize_rcu() is a block operation and can keep us waiting for
>> a long period, so instead it's possible that usage never goes down
>> to 0 and we are in a dead loop.
> 
> Ok, I didn't think of that. Tracing shows that the function keeps
> looping. The last lines repeat indefinitely.
> 
...
>      kworker/3:5-7605  [003] ....   987.475678:
> mem_cgroup_reparent_charges: usage: 1568768
>      kworker/3:5-7605  [003] ....   987.478677:
> mem_cgroup_reparent_charges: usage: 1568768
>      kworker/3:5-7605  [003] ....   987.481675:
> mem_cgroup_reparent_charges: usage: 1568768

So it's much more likely this is a memcg bug rather than a cgroup bug.
I hope memcg guys could look into it, or you could do a git-bisect if
you can reliably reproduce the bug.
