From: "azurIt" <azurit-Rm0zKEqwvD4@public.gmane.org>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=2E34=5D_memcg=3A_do_not_trigger_OOM_from_add=5Fto=5Fpage=5Fcache=5Flocked?=
Date: Fri, 30 Nov 2012 16:59:37 +0100
Message-ID: <20121130165937.F9564EBE@pobox.sk>
References: <20121125120524.GB10623@dhcp22.suse.cz>, <20121125135542.GE10623@dhcp22.suse.cz>, <20121126013855.AF118F5E@pobox.sk>, <20121126131837.GC17860@dhcp22.suse.cz>, <20121126132149.GD17860@dhcp22.suse.cz>, <20121130032918.59B3F780@pobox.sk>, <20121130124506.GH29317@dhcp22.suse.cz>, <20121130144427.51A09169@pobox.sk>, <20121130144431.GI29317@dhcp22.suse.cz>, <20121130160811.6BB25BDD@pobox.sk> <20121130153942.GL29317@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121130153942.GL29317-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: =?utf-8?q?Michal_Hocko?= <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, =?utf-8?q?cgroups_mailinglist?= <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, =?utf-8?q?Johannes_Weiner?= <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

>> Here is the full boot log:
>> www.watchdog.sk/lkml/kern.log
>
>The log is not complete. Could you paste the comple dmesg output? Or
>even better, do you have logs from the previous run?


What is missing there? All kernel messages are logging into /var/log/kern.log (it's the same as dmesg), dmesg itself was already rewrited by other messages. I think it's all what that kernel printed.
