From: Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] memcg: remove KMEM_ACCOUNTED_ACTIVATED
Date: Mon, 2 Dec 2013 22:26:48 +0400
Message-ID: <CAA6-i6rWsZNQmFY5L-=yc6TaTGyg4hP4qn9gMZVsu8wWJ=1ywg@mail.gmail.com>
References: <1385989693-28788-1-git-send-email-vdavydov@parallels.com>
	<20131202181501.GA5524@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=xvBpmzyOZV1TRo/oy6emPz82pat0HYVIedQJv86zLaQ=;
        b=OF90lGpsWEujNuH01kBA/199CWMq6iqvV7RrND8e67xe4UYPvkHsETuWOQigCOx2fk
         tttGJg3lvVcXC+eHHL22JwObPUI7zI4OSuHIWmuQ7nCcyPWmumzY8jMNLDqZhwTb6oFm
         Zl8AVLTWpcHCzOWetK2vWk2Mj0PToGARLrSNTdMZ7Ice3lCMRotudQzwF8h+9Sc/UXeW
         5tAKT634oOpZIWTcoipKHduAYATytMS6ZMZ61PHjoomHM6DnN8O/0DZ7bW0ZHn/vWK4f
         D6BdQlkkcG3OjOUh1ri+avEsLhvQ61oTsVM+Hrmrp7Dm5cPasRQu39mwI1Jlf7GCxNzq
         1j8g==
In-Reply-To: <20131202181501.GA5524-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On Mon, Dec 2, 2013 at 10:15 PM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> [CCing Glauber - please do so in other posts for kmem related changes]
>
> On Mon 02-12-13 17:08:13, Vladimir Davydov wrote:
>> The KMEM_ACCOUNTED_ACTIVATED was introduced by commit a8964b9b ("memcg:
>> use static branches when code not in use") in order to guarantee that
>> static_key_slow_inc(&memcg_kmem_enabled_key) will be called only once
>> for each memory cgroup when its kmem limit is set. The point is that at
>> that time the memcg_update_kmem_limit() function's workflow looked like
>> this:
>>
>>       bool must_inc_static_branch = false;
>>
>>       cgroup_lock();
>>       mutex_lock(&set_limit_mutex);
>>       if (!memcg->kmem_account_flags && val != RESOURCE_MAX) {
>>               /* The kmem limit is set for the first time */
>>               ret = res_counter_set_limit(&memcg->kmem, val);
>>
>>               memcg_kmem_set_activated(memcg);
>>               must_inc_static_branch = true;
>>       } else
>>               ret = res_counter_set_limit(&memcg->kmem, val);
>>       mutex_unlock(&set_limit_mutex);
>>       cgroup_unlock();
>>
>>       if (must_inc_static_branch) {
>>               /* We can't do this under cgroup_lock */
>>               static_key_slow_inc(&memcg_kmem_enabled_key);
>>               memcg_kmem_set_active(memcg);
>>       }
>>
>> Today, we don't use cgroup_lock in memcg_update_kmem_limit(), and
>> static_key_slow_inc() is called under the set_limit_mutex, but the
>> leftover from the above-mentioned commit is still here. Let's remove it.
>
> OK, so I have looked there again and 692e89abd154b (memcg: increment
> static branch right after limit set) which went in after cgroup_mutex
> has been removed. It came along with the following comment.
>                 /*
>                  * setting the active bit after the inc will guarantee no one
>                  * starts accounting before all call sites are patched
>                  */
>
> This suggests that the flag is needed after all because we have
> to be sure that _all_ the places have to be patched. AFAIU
> memcg_kmem_newpage_charge might see the static key already patched so
> it would do a charge but memcg_kmem_commit_charge would still see it
> unpatched and so the charge won't be committed.
>
> Or am I missing something?

You are correct. This flag is there due to the way we are using static branches.
The patching of one call site is atomic, but the patching of all of
them are not.
Therefore we need to use a two-flag scheme to guarantee that in the first time
we turn the static branches on, there will be a clear point after
which we're going
to start accounting.





-- 
E Mare, Libertas
