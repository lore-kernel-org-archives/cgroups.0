From: "azurIt" <azurit-Rm0zKEqwvD4@public.gmane.org>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=2E34=5D_memcg=3A_do_not_trigger_OOM_from_add=5Fto=5Fpage=5Fcache=5Flocked?=
Date: Thu, 06 Dec 2012 01:29:24 +0100
Message-ID: <20121206012924.FE077FD7@pobox.sk>
References: <20121130032918.59B3F780@pobox.sk>, <20121130124506.GH29317@dhcp22.suse.cz>, <20121130144427.51A09169@pobox.sk>, <20121130144431.GI29317@dhcp22.suse.cz>, <20121130160811.6BB25BDD@pobox.sk>, <20121130153942.GL29317@dhcp22.suse.cz>, <20121130165937.F9564EBE@pobox.sk>, <20121130161923.GN29317@dhcp22.suse.cz>, <20121203151601.GA17093@dhcp22.suse.cz>, <20121205023644.18C3006B@pobox.sk> <20121205141722.GA9714@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121205141722.GA9714-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: =?utf-8?q?Michal_Hocko?= <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, =?utf-8?q?cgroups_mailinglist?= <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, =?utf-8?q?Johannes_Weiner?= <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

>OK, so the ENOMEM seems to be leaking from mem_cgroup_newpage_charge.
>This can only happen if this was an atomic allocation request
>(!__GFP_WAIT) or if oom is not allowed which is the case only for
>transparent huge page allocation.
>The first case can be excluded (in the clean 3.2 stable kernel) because
>all callers of mem_cgroup_newpage_charge use GFP_KERNEL. The later one
>should be OK because the page fault should fallback to a regular page if
>THP allocation/charge fails.
>[/me goes to double check]
>Hmm do_huge_pmd_wp_page seems to charge a huge page and fails with
>VM_FAULT_OOM without any fallback. We should do_huge_pmd_wp_page_fallback
>instead. This has been fixed in 3.5-rc1 by 1f1d06c3 (thp, memcg: split
>hugepage for memcg oom on cow) but it hasn't been backported to 3.2. The
>patch applies to 3.2 without any further modifications. I didn't have
>time to test it but if it helps you we should push this to the stable
>tree.


This, unfortunately, didn't fix the problem :(
http://www.watchdog.sk/lkml/oom_mysqld3
