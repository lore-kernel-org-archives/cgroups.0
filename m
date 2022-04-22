From: Vasily Averin <vvs@openvz.org>
Subject: Re: [PATCH memcg RFC] net: set proper memcg for net_init hooks
 allocations
Date: Fri, 22 Apr 2022 23:01:12 +0300
Message-ID: <964ae72a-0484-67de-8143-a9a2d492a520@openvz.org>
References: <46c1c59e-1368-620d-e57a-f35c2c82084d@linux.dev>
 <55605876-d05a-8be3-a6ae-ec26de9ee178@openvz.org>
 <CALvZod47PARcupR4P41p5XJRfCaTqSuy-cfXs7Ky9=-aJQuoFA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=uID8iZcNLBme4rZdpwP2elgnitNvjR/PYrEFPkEMrt4=;
        b=K87wFhFCqh3RUSfcjyHWaJ/5OlWIaCtbKiOBy/+lg00oDsHo00dI9Rz913ownD+DBL
         47j/1FQaoHEzvRGxNbrxGsgl7+D50V85YT1FdoRMTvK7qMkmsNqF9izOyRDx+dPlVcrN
         PuU5VqnxQaMP1XvJIEFREriWuLui4ThOlm6RCIy09TlUR3zrwFtmnqN//0XUrW33aZyh
         HKhKRwmvqOV03Ak4cj8WgBUbW7mMsZ2Dg0uMMOqoASX+5BJ0q9R/08Zvy/VmFiAMWiAq
         NlhqszFUOsK5gPC6/k2K5W00Ot+1S6YmXD7AVIwsTs2LI83qY3/jotSduWfGx+K0rKII
         rUQQ==
Content-Language: en-US
In-Reply-To: <CALvZod47PARcupR4P41p5XJRfCaTqSuy-cfXs7Ky9=-aJQuoFA@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <roman.gushchin@linux.dev>, kernel@openvz.org, LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, Florian Westphal <fw@strlen.de>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>

On 4/21/22 18:56, Shakeel Butt wrote:
> On Sat, Apr 16, 2022 at 11:39 PM Vasily Averin <vvs@openvz.org> wrote:
>> @@ -1147,7 +1148,13 @@ static int __register_pernet_operations(struct list_head *list,
>>                  * setup_net() and cleanup_net() are not possible.
>>                  */
>>                 for_each_net(net) {
>> +                       struct mem_cgroup *old, *memcg = NULL;
>> +#ifdef CONFIG_MEMCG
>> +                       memcg = (net == &init_net) ? root_mem_cgroup : mem_cgroup_from_obj(net);
> 
> memcg from obj is unstable, so you need a reference on memcg. You can
> introduce get_mem_cgroup_from_kmem() which works for both
> MEMCG_DATA_OBJCGS and MEMCG_DATA_KMEM. For uncharged objects (like
> init_net) it should return NULL.

Could you please elaborate with more details?
It seems to me mem_cgroup_from_obj() does everything exactly as you say:
- for slab objects it returns memcg taken from according slab->memcg_data
- for ex-slab objects (i.e. page->memcg_data & MEMCG_DATA_OBJCGS)
    page_memcg_check() returns NULL
- for kmem objects (i.e. page->memcg_data & MEMCG_DATA_KMEM) 
    page_memcg_check() returns objcg->memcg
- in another cases
    page_memcg_check() returns page->memcg_data,
    so for uncharged objects like init_net NULL should be returned.

I can introduce exported get_mem_cgroup_from_kmem(), however it should only
call mem_cgroup_from_obj(), perhaps under read_rcu_lock/unlock.

Do you mean something like this?

--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1768,4 +1768,14 @@ static inline struct mem_cgroup *mem_cgroup_from_obj(void *p)
 
 #endif /* CONFIG_MEMCG_KMEM */
 
+static inline struct mem_cgroup *get_mem_cgroup_from_kmem(void *p)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_obj(p);
+	rcu_read_unlock();
+
+	return memcg;
+}
 #endif /* _LINUX_MEMCONTROL_H */
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index a5b5bb99c644..4003c47965c9 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -26,6 +26,7 @@
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
 
+#include <linux/sched/mm.h>
 /*
  *	Our network namespace constructor/destructor lists
  */
@@ -1147,7 +1148,14 @@ static int __register_pernet_operations(struct list_head *list,
 		 * setup_net() and cleanup_net() are not possible.
 		 */
 		for_each_net(net) {
+			struct mem_cgroup *old, *memcg;
+
+			memcg = get_mem_cgroup_from_kmem(net);
+			if (memcg == NULL)
+				memcg = root_mem_cgroup;
+			old = set_active_memcg(memcg);
 			error = ops_init(ops, net);
+			set_active_memcg(old);
 			if (error)
 				goto out_undo;
 			list_add_tail(&net->exit_list, &net_exit_list);
