From: "azurIt" <azurit-Rm0zKEqwvD4@public.gmane.org>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=5D_memcg=3A_do_not_trap_chargers_with_full_callstack_on_OOM?=
Date: Fri, 28 Jun 2013 12:06:13 +0200
Message-ID: <20130628120613.6D6CAD21@pobox.sk>
References: <20130210150310.GA9504@dhcp22.suse.cz>, <20130210174619.24F20488@pobox.sk>, <20130211112240.GC19922@dhcp22.suse.cz>, <20130222092332.4001E4B6@pobox.sk>, <20130606160446.GE24115@dhcp22.suse.cz>, <20130606181633.BCC3E02E@pobox.sk>, <20130607131157.GF8117@dhcp22.suse.cz>, <20130617122134.2E072BA8@pobox.sk>, <20130619132614.GC16457@dhcp22.suse.cz>, <20130622220958.D10567A4@pobox.sk> <20130624201345.GA21822@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130624201345.GA21822-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: =?utf-8?q?Johannes_Weiner?= <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: =?utf-8?q?Michal_Hocko?= <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, =?utf-8?q?cgroups_mailinglist?= <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

>It's not a kernel thread that does it because all kernel-context
>handle_mm_fault() are annotated properly, which means the task must be
>userspace and, since tasks is empty, have exited before synchronizing.
>
>Can you try with the following patch on top?


Michal and Johannes,

i have some observations which i made:
Original patch from Johannes was really fixing something but definitely not everything and was introducing new problems. I'm running unpatched kernel from time i send my last message and problems with freezing cgroups are occuring very often (several times per day) - they were, on the other hand, quite rare with patch from Johannes.

Johannes, i didn't try your last patch yet. I would like to wait until you or Michal look at my last message which contained detailed information about freezing of cgroups on kernel running your original patch (which was suppose to fix it for good). Even more, i would like to hear your opinion about that stucked processes which was holding web server port and which forced me to reboot production server at the middle of the day :( more information was in my last message. Thank you very much for your time.

azur
