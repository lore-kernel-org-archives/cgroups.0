From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 03/11] cgroup, sched: let cpu serve the same files as cpuacct
Date: Tue, 15 Jan 2013 18:19:58 +0800
Message-ID: <CAFj3OHWB8GF9UYcLdObptrY+BfB=EEwbBtsf17M1=6qfZt+k6g@mail.gmail.com>
References: <1357731938-8417-1-git-send-email-glommer@parallels.com>
	<1357731938-8417-4-git-send-email-glommer@parallels.com>
	<CAFj3OHW5J8ypLZdW16AfiYR5y2S54mQxm5qka4m_3qsoGdD11A@mail.gmail.com>
	<50F41C50.6090000@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=hapTikbHaCDuRForIUg/quQvKA8NKE0rL3pihEv3iOs=;
        b=XPZYYHo7DPaJWzvRcmgmbNLtLj+BQReKyJlDEFvSvkTvZqtc3BwRg6UUAis4oFgCMw
         F8b0QwoRirB19nsmWXaKPHuM6Lk4OXmLA/npXwbHUvEByz26i6M66BhtvEtQWYjd2Onl
         lwoQOQP4e+vQSwVrc+7KFFxQUX/bcttLPvdkCs94KgNAp8LnCuuXgdR/Blkd72C61gas
         UqNznkG1SLfg7Og7tXDboY4zEeXXjf6KXQRq/261TkPHb2mMsF1KHQX045o+hpKSvFiZ
         QoePYySpwM0Yc9ncQRoMofNwI/e6LVpCV5Dfv2feDq4Yty7D2JWEIL8j0EvECw55YGNC
         y4mA==
In-Reply-To: <50F41C50.6090000-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>

On Mon, Jan 14, 2013 at 10:55 PM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> On 01/14/2013 12:34 AM, Sha Zhengju wrote:
>>> +               struct kernel_cpustat *kcpustat = this_cpu_ptr(ca->cpustat);
>>> > +
>>> >                 kcpustat = this_cpu_ptr(ca->cpustat);
>> Is this reassignment unnecessary?
>>
>>
> No.
>

No?  No!

In task_group_account_field(), the following two hunks have the
similar behavior but different codes, there must be a trial in one of
them.

Hunk #1:
+#ifdef CONFIG_CGROUP_SCHED
+       rcu_read_lock();
+       tg = container_of(task_subsys_state(p, cpu_cgroup_subsys_id),
+                         struct task_group, css);

+       while (tg && (tg != &root_task_group)) {
+               struct kernel_cpustat *kcpustat =
this_cpu_ptr(tg->cpustat);   **HERE**
+
+               kcpustat->cpustat[index] += tmp;
+               tg = tg->parent;
+       }
+       rcu_read_unlock();
+#endif

Hunk #2:
#ifdef CONFIG_CGROUP_CPUACCT
        if (unlikely(!cpuacct_subsys.active))
                return;

        rcu_read_lock();
        ca = task_ca(p);
        while (ca && (ca != &root_cpuacct)) {
+               struct kernel_cpustat *kcpustat =
this_cpu_ptr(ca->cpustat); **HERE**
+
                kcpustat = this_cpu_ptr(ca->cpustat);   **HERE, which
is unnecessary**
                kcpustat->cpustat[index] += tmp;
                ca = parent_ca(ca);
        }
        rcu_read_unlock();
#endif


Also you can prove it by the following testcase.
#include <stdio.h>

int main(void)
{
        int i = 0;
        int array[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
        int *index = &array[0];

        while (i < 10) {
                int *ptr = index;

                printf("ptr=%d  %p, index = %d\n", *ptr, ptr, *index);
                index ++;
                i++;
                sleep(1);
        }

        return 0;
}

-- 
Thanks,
Sha
