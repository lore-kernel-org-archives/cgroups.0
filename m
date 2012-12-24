From: "azurIt" <azurit-Rm0zKEqwvD4@public.gmane.org>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=2E34=5D_memcg=3A_do_not_trigger_OOM_from_add=5Fto=5Fpage=5Fcache=5Flocked?=
Date: Mon, 24 Dec 2012 14:25:26 +0100
Message-ID: <20121224142526.020165D3@pobox.sk>
References: <20121206095423.GB10931@dhcp22.suse.cz>, <20121210022038.E6570D37@pobox.sk>, <20121210094318.GA6777@dhcp22.suse.cz>, <20121210111817.F697F53E@pobox.sk>, <20121210155205.GB6777@dhcp22.suse.cz>, <20121217023430.5A390FD7@pobox.sk>, <20121217163203.GD25432@dhcp22.suse.cz>, <20121217192301.829A7020@pobox.sk>, <20121217195510.GA16375@dhcp22.suse.cz>, <20121218152223.6912832C@pobox.sk> <20121218152004.GA25208@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121218152004.GA25208-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: =?utf-8?q?Michal_Hocko?= <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, =?utf-8?q?cgroups_mailinglist?= <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, =?utf-8?q?Johannes_Weiner?= <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

>OK, good to hear and fingers crossed. I will try to get back to the
>original problem and a better solution sometimes early next year when
>all the things settle a bit.


Michal, problem, unfortunately, happened again :( twice. When it happened first time (two days ago) i don't want to believe it so i recompiled the kernel and boot it again to be sure i really used your patch. Today it happened again, here is report:
http://watchdog.sk/lkml/memcg-bug-3.tar.gz

Here is patch which i used (kernel 3.2.35, i didn't use any other from your patches):
http://watchdog.sk/lkml/5-memcg-fix.patch

azur
