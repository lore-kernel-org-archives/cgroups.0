From: "azurIt" <azurit-Rm0zKEqwvD4@public.gmane.org>
Subject: =?utf-8?q?Re=3A_=5Bpatch_0=2F7=5D_improve_memcg_oom_killer_robustness_v2?=
Date: Fri, 11 Oct 2013 00:59:45 +0200
Message-ID: <20131011005945.33D49C21@pobox.sk>
References: <20130917141013.GA30838@dhcp22.suse.cz>, <20130918160304.6EDF2729@pobox.sk>, <20130918180455.GD856@cmpxchg.org>, <20130918181946.GE856@cmpxchg.org>, <20130918195504.GF856@cmpxchg.org>, <20130926185459.E5D2987F@pobox.sk>, <20130926192743.GP856@cmpxchg.org>, <20131007130149.5F5482D8@pobox.sk>, <20131007192336.GU856@cmpxchg.org>, <20131009204450.6AB97915@pobox.sk> <20131010001422.GB856@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131010001422.GB856-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: =?utf-8?q?Johannes_Weiner?= <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: =?utf-8?q?Michal_Hocko?= <mhocko-AlSwsSmVLrQ@public.gmane.org>, =?utf-8?q?Andrew_Morton?= <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?utf-8?q?David_Rientjes?= <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, =?utf-8?q?KOSAKI_Motohiro?= <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

>On Wed, Oct 09, 2013 at 08:44:50PM +0200, azurIt wrote:
>> Joahnnes,
>> 
>> i'm very sorry to say it but today something strange happened.. :) i was just right at the computer so i noticed it almost immediately but i don't have much info. Server stoped to respond from the net but i was already logged on ssh which was working quite fine (only a little slow). I was able to run commands on shell but i didn't do much because i was afraid that it will goes down for good soon. I noticed few things:
>>  - htop was strange because all CPUs were doing nothing (totally nothing)
>>  - there were enough of free memory
>>  - server load was about 90 and was raising slowly
>>  - i didn't see ANY process in 'run' state
>>  - i also didn't see any process with strange behavior (taking much CPU, memory or so) so it wasn't obvious what to do to fix it
>>  - i started to kill Apache processes, everytime i killed some, CPUs did some work, but it wasn't fixing the problem
>>  - finally i did 'skill -kill apache2' in shell and everything started to work
>>  - server monitoring wasn't sending any data so i have no graphs
>>  - nothing interesting in logs
>> 
>> I will send more info when i get some.
>
>Somebody else reported a problem on the upstream patches as well.  Any
>chance you can confirm the stacks of the active but not running tasks?



Unfortunately i don't have any stacks but i will try to take some next time.



>It sounds like they are stuck on a waitqueue, the question is which
>one.  I forgot to disable OOM for __GFP_NOFAIL allocations, so they
>could succeed and leak an OOM context.  task structs are not
>reinitialized between alloc & free so a different task could later try
>to oom trylock a memcg that has been freed, fail, and wait
>indefinitely on the OOM waitqueue.  There might be a simpler
>explanation but I can't think of anything right now.
>
>But the OOM context is definitely being leaked, so please apply the
>following for your next reboot:


It's installed, thank you!

azur
