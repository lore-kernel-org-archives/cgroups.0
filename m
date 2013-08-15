From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] mm: memcontrol: fix handling of swapaccount parameter
Date: Thu, 15 Aug 2013 09:47:14 +0200
Message-ID: <20130815074714.GA27864@dhcp22.suse.cz>
References: <1376486495-21457-1-git-send-email-gergely@risko.hu>
 <20130814183604.GE24033@dhcp22.suse.cz>
 <20130814184956.GF24033@dhcp22.suse.cz>
 <87ioz855o0.fsf@gergely.risko.hu>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <87ioz855o0.fsf@gergely.risko.hu>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gergely Risko <gergely@risko.hu>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>

[Let's CC Andrew]

On Wed 14-08-13 23:22:23, Gergely Risko wrote:
> On Wed, 14 Aug 2013 20:49:56 +0200, Michal Hocko <mhocko@suse.cz> writes:
> 
> > On Wed 14-08-13 20:36:04, Michal Hocko wrote:
> >> On Wed 14-08-13 15:21:35, Gergely Risko wrote:
> >> > Fixed swap accounting option parsing to enable if called without argument.
> >> 
> >> We used to have [no]swapaccount but that one has been removed by a2c8990a
> >> (memsw: remove noswapaccount kernel parameter) so I do not think that
> >> swapaccount without any given value makes much sense these days.
> >
> > Now that I am reading your changelog again it says this is a fix. Have
> > you experienced any troubles because of the parameter semantic change?
> 
> Yeah, I experienced trouble, I was new to all of this containers +
> cgroups + namespaces thingies and while trying out stuff it was totally
> impossible for me to enable swap accounting and I didn't understand why.
> 
> In Debian swap accounting is off by default, even when you
> cgroup_enable=memory.  So you have to explicitly enable swapaccounting.
> 
> I've found the following documentation snippets all pointing to enable
> swap accounting by just simply adding "swapaccount" to the kernel
> command line.  They all state that "swapaccount" is enough, no need for
> "swapaccount=1" (actually some of them don't even mention =1 at all):
>   - make menuconfig documentation for swap accounting,
>   - /usr/share/doc/lxc/README.Debian from the lxc package,

I've submitted a report with patch
(http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=719774)

>   - Documentation/kernel-parameters.txt:
> 	swapaccount[=0|1]
> 			[KNL] Enable accounting of swap in memory resource
> 			controller if no parameter or 1 is given or disable
> 			it if 0 is given (See Documentation/cgroups/memory.txt),
>   - the comment in the source code just above the line ("consider enabled
>     if no parameter or 1 is given").

Ohh, I have totally missed those left-overs. I would rather fix the doc
than reintroduce the handling without any value.
---
From 7daf56dd94f7436acf956375e4be6c1482094251 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Thu, 15 Aug 2013 09:40:31 +0200
Subject: [PATCH] memcg: get rid of swapaccount leftovers

swapaccount kernel parameter without any values has been removed by
a2c8990a (memsw: remove noswapaccount kernel parameter) but it seems
that we didn't get rid of all the left overs.

Make sure that menuconfig help text and kernel-parameters.txt are clear
about value for the paramter and remove the stalled comment which is not
very much useful on its own.

Reported-by: Gergely Risko <gergely@risko.hu>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 Documentation/kernel-parameters.txt |    2 +-
 init/Kconfig                        |    2 +-
 mm/memcontrol.c                     |    1 -
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 2fe6e76..6a95a03 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2941,7 +2941,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			improve throughput, but will also increase the
 			amount of memory reserved for use by the client.
 
-	swapaccount[=0|1]
+	swapaccount=[0|1]
 			[KNL] Enable accounting of swap in memory resource
 			controller if no parameter or 1 is given or disable
 			it if 0 is given (See Documentation/cgroups/memory.txt)
diff --git a/init/Kconfig b/init/Kconfig
index 2bee57c..49cd8af 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -915,7 +915,7 @@ config MEMCG_SWAP_ENABLED
 	  Memory Resource Controller Swap Extension comes with its price in
 	  a bigger memory consumption. General purpose distribution kernels
 	  which want to enable the feature but keep it disabled by default
-	  and let the user enable it by swapaccount boot command line
+	  and let the user enable it by swapaccount=1 boot command line
 	  parameter should have this option unselected.
 	  For those who want to have the feature enabled by default should
 	  select this option (if, for some reason, they need to disable it
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b73988a..61e9827 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6785,7 +6785,6 @@ struct cgroup_subsys mem_cgroup_subsys = {
 #ifdef CONFIG_MEMCG_SWAP
 static int __init enable_swap_account(char *s)
 {
-	/* consider enabled if no parameter or 1 is given */
 	if (!strcmp(s, "1"))
 		really_do_swap_account = 1;
 	else if (!strcmp(s, "0"))
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
