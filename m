From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cpuset: fix a locking issue in cpuset_migrate_mm()
Date: Thu, 27 Feb 2014 09:37:37 -0500
Message-ID: <20140227143737.GA19178@htj.dyndns.org>
References: <530F1117.1020605@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=LO2SRjo5oa9oJS9GP8RRlChlJ3ljUgEsDoyP+BKmM08=;
        b=mWQTOU4U05k9MKcQXrsJVNjk8d/oX5vr/1TDGm0gXk+gtuiPOEMyYBxlG94qYOyJSG
         +JReBr6ZIFME7zzLF8BfqTMhs3iXdewKLuNHEoqmFkSgs5jlzE1t4huWjSOFchIMNrTn
         e+AOGewO7cupYVbt0htyICOXShfunIu5Thu9JB4MQMaUY+HpJRJfmZE2ziMKareU7+TX
         e6cY39mM9dOLKD6Th7ExFWPjoxqofOO+1P5uqJrfoaYtRNGuW71ZiLJE1RRAX1dp+gUT
         VmV59Gdipl2wc0iIJWiDlWNRYOrTBQ73gB990kBEWq6dqmiIOE35v4VhxRd1Kzcrn9Vh
         yOYg==
Content-Disposition: inline
In-Reply-To: <530F1117.1020605-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Feb 27, 2014 at 06:19:03PM +0800, Li Zefan wrote:
> I can trigger a lockdep warning:
> 
>   # mount -t cgroup -o cpuset xxx /cgroup
>   # mkdir /cgroup/cpuset
>   # mkdir /cgroup/tmp
>   # echo 0 > /cgroup/tmp/cpuset.cpus
>   # echo 0 > /cgroup/tmp/cpuset.mems
>   # echo 1 > /cgroup/tmp/cpuset.memory_migrate
>   # echo $$ > /cgroup/tmp/tasks
>   # echo 1 > /cgruop/tmp/cpuset.mems
> 
>   ===============================
>   [ INFO: suspicious RCU usage. ]
>   3.14.0-rc1-0.1-default+ #32 Not tainted
>   -------------------------------
>   include/linux/cgroup.h:682 suspicious rcu_dereference_check() usage!
>   ...
>     [<ffffffff81582174>] dump_stack+0x72/0x86
>     [<ffffffff810b8f01>] lockdep_rcu_suspicious+0x101/0x140
>     [<ffffffff81105ba1>] cpuset_migrate_mm+0xb1/0xe0
>   ...
> 
> We used to hold cgroup_mutex when calling cpuset_migrate_mm(), but now
> we hold cpuset_mutex, which causes task_css() to complain.
> 
> This is not a false-positive but a real issue.
> 
> Holding cpuset_mutex won't prevent a task's cpuset from changing, and
> it won't prevent the original task->cgroup from destroying during this
> change.
> 
> Fixes: 5d21cc2db040 (cpuset: replace cgroup_mutex locking with cpuset internal locking)
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.9+
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.14-fixes.

Thanks.

-- 
tejun
