From: Suleiman Souhlal <suleiman@google.com>
Subject: Re: [RFC][PATCH 2/3] memcg: reduce size of struct page_cgroup.
Date: Mon, 19 Mar 2012 15:20:55 -0700
Message-ID: <CABCjUKAr+F=Pz-JCWfjGfyL4AcHt6m97p13=0VdwjeVm5SKW7w@mail.gmail.com>
References: <4F66E6A5.10804@jp.fujitsu.com>
	<4F66E7D7.4040406@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding:x-system-of-record;
        bh=QuMPt3vivE1H9tOV+7fmAVZTi1dbq8kzJ15fHnl3Rpo=;
        b=VAKCU5LP+F8lTIUvXrGcHKp1xEhSjvM3ZfvysYnzKYW2eDMAutMsWjvQXNNY7Qagqg
         9yqFfqpNcxjYSjwzBni8ylk7zMYG4q3NMvD4wkorPS5cULi41JnsLUvn2jiiGT/XKWvJ
         c13eTCixNjwD6ha4RGpaRJySefeLRJrHMMpHSoRU/ilPbH0NPcCkbbaRXy9IXhL1j4nM
         tdShXrgTEx4OkGOd7J/wPsi57qUpk9ItEViqpwx4tsHZRndFo2UvJdyYAquYUJQbDc0j
         rML5EYLGGlczYY12WJAssL13Wa6hxmo7u7plRR4XIbDHIuHWKarcWcVPr+awCXgeSffW
         YMTQ==
In-Reply-To: <4F66E7D7.4040406@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>, Han Ying <yinghan@google.com>, Glauber Costa <glommer@parallels.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, n-horiguchi@ah.jp.nec.com, khlebnikov@openvz.org, Tejun Heo <tj@kernel.org>

2012/3/19 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
> Now, page_cgroup->flags has only 3bits. Considering alignment of
> struct mem_cgroup, which is allocated by kmalloc(), we can encode
> pointer to mem_cgroup and flags into a word.
>
> After this patch, pc->flags is encoded as
>
> =A063 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 2 =A0 =A0 0
> =A0| pointer to memcg..........|flags|
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
> =A0include/linux/page_cgroup.h | =A0 15 ++++++++++++---
> =A01 files changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
> index 92768cb..bca5447 100644
> --- a/include/linux/page_cgroup.h
> +++ b/include/linux/page_cgroup.h
> @@ -1,6 +1,10 @@
> =A0#ifndef __LINUX_PAGE_CGROUP_H
> =A0#define __LINUX_PAGE_CGROUP_H
>
> +/*
> + * Because these flags are encoded into ->flags with a pointer,
> + * we cannot have too much flags.
> + */
> =A0enum {
> =A0 =A0 =A0 =A0/* flags for mem_cgroup */
> =A0 =A0 =A0 =A0PCG_LOCK, =A0/* Lock for pc->mem_cgroup and following bits=
. */
> @@ -9,6 +13,8 @@ enum {
> =A0 =A0 =A0 =A0__NR_PCG_FLAGS,
> =A0};
>
> +#define PCG_FLAGS_MASK ((1 << __NR_PCG_FLAGS) - 1)
> +
> =A0#ifndef __GENERATING_BOUNDS_H
> =A0#include <generated/bounds.h>
>
> @@ -21,10 +27,12 @@ enum {
> =A0* page_cgroup helps us identify information about the cgroup
> =A0* All page cgroups are allocated at boot or memory hotplug event,
> =A0* then the page cgroup for pfn always exists.
> + *
> + * flags and a pointer to memory cgroup are encoded into ->flags.
> + * Lower 3bits are used for flags and others are used for a pointer to m=
emcg.

Would it be worth adding a BUILD_BUG_ON(__NR_PCG_FLAGS > 3) ?

-- Suleiman

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
