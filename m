From: Hao Jia <jiahao.os@bytedance.com>
Subject: Re: [External] Re: [PATCH] cgroup/rstat: record the cumulative
 per-cpu time of cgroup and its descendants
Date: Mon, 7 Aug 2023 11:36:22 +0800
Message-ID: <2ee4f673-8218-ac72-684f-3cd78c46f750@bytedance.com>
References: <20230717093612.40846-1-jiahao.os@bytedance.com>
 <ZLWb-LsBD041hMvr@slm.duckdns.org>
 <2655026d-6ae4-c14c-95b0-4177eefa434f@bytedance.com>
 <ZLcJ1nH8KzWzoQWj@slm.duckdns.org>
 <b4424767-dce7-08a9-3759-43cc9dfa4273@bytedance.com>
 <3d2b68bf-9f40-c779-dcfd-4cf9939edecc@bytedance.com>
 <ZMKs_GpHEW6Pfusj@slm.duckdns.org> <ZMrNHf2tg8AZ2F0z@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1691379388; x=1691984188;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WAmHsv0aooR3nX10HEjLL5tP/plsIB0hDyj15nET4fc=;
        b=HX/bG4KLwTRh5wjISv7jDf/BZhZZfMUQIkKKTpsE4Z/nEdgem5yGJQ+klykQb7Br0q
         y7EA4Xwz6bfgAGBQ4je7kw+PXiEnHaeArh2+vVWRJ5R9GbwnzOWeJoAemOa10kykp9xs
         sr7uBgapdp0vnVjhZdiUHAXUpwVoJqEWqfYiAHpIZuPu3bL/MJ/MEeLVObazbIxMmrPE
         ULlmAFuVXJtd3P6tz4I0Ken9ItLgysJzH3OhNswJQO8BKFVzsjN4sPM8mUk0t0qifGfh
         FFZ5MOWXOM+mbM3Pa2SRYH6Udxq6Z3Uu8YbpxsE+pFrs64y9fepLwckCpV2uWOFy/AW1
         apDQ==
In-Reply-To: <ZMrNHf2tg8AZ2F0z@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: lizefan.x@bytedance.com, hannes@cmpxchg.org, mkoutny@suse.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org



On 2023/8/3 Tejun Heo wrote:
> I couldn't come up with an answer. Let's go ahead with adding the field but
> can you please do the followings?
> 

Thank you for your suggestion. I am very willing to do it.

> * Name it to something like subtree_bstat instead of cumul_bstat. The
>    counters are all cumulative.

I did it in v2 patch.

> 
> * Are you sure the upward propagation logic is correct? It's calculating
>    global delta and then propagating to the per-cpu delta of the parent. Is
>    that correct because the two delta calculations always end up the same?

Sorry, I made a mistake and misled you. These two deltas are not always 
equal.

I found and reproduced a bug case:
We build /sys/fs/cgroup/test /sys/fs/cgroup/test/t1, 
/sys/fs/cgroup/test/t1/tt1 in turn.
And there are only tasks in /sys/fs/cgroup/test/t1/tt1. After applying 
this patch, some operations and corresponding data changes are as follows:

Step 1、cat /sys/fs/cgroup/test/t1/tt1/cpu.stat
*cpu 6* current flush cgroup /test/t1/tt1
per-cpu delta utime 0 stime 0 sum_exec_runtime 257341
/test/t1/tt1 cumul_bstat(cpu 6) utime 0 stime 0 sum_exec_runtime 257341
/test/t1/tt1 cgrp->bstat utime 0 stime 0 sum_exec_runtime 257341
if (cgroup_parent(parent)) {
     cgrp delta utime 0 stime 0 sum_exec_runtime 257341
     parent(/test/t1) ->bstat utime 0 stime 0 sum_exec_runtime 257341
     parent(/test/t1) last_bstat utime 0 stime 0 sum_exec_runtime 0
     parent(/test/t1) cumul_bstat utime 0 stime 0 sum_exec_runtime 257341
}


Step 2、cat /sys/fs/cgroup/test/t1/tt1/cpu.stat
*cpu 12* current flush cgroup /test/t1/tt1
per-cpu delta utime 0 stime 1000000 sum_exec_runtime 747042
/test/t1/tt1 cumul_bstat utime 0 stime 1000000 sum_exec_runtime 747042
/test/t1/tt1 cgrp->bstat utime 0 stime 1000000 sum_exec_runtime 1004383
if (cgroup_parent(parent)) {
     cgrp delta utime 0 stime 1000000 sum_exec_runtime 747042
     parent(/test/t1) ->bstat utime 0 stime 1000000 sum_exec_runtime 1004383
     parent(/test/t1) last_bstat utime 0 stime 0 sum_exec_runtime 0
     parent(/test/t1) cumul_bstat utime 0 stime 1000000 sum_exec_runtime 
747042
}


Step 3、cat /sys/fs/cgroup/test/cpu.stat
(cgroup fulsh /test/t1/tt1 -> /test/t1 -> /test in turn)

*cpu 6*  current flush cgroup /test/t1/tt1
per-cpu delta utime 0 stime 0 sum_exec_runtime 263468
/test/t1/tt1 cumul_bstat(cpu 6) utime 0 stime 0 sum_exec_runtime 520809
/test/t1/tt1 cgrp->bstat utime 0 stime 1000000 sum_exec_runtime 1267851
if (cgroup_parent(parent)) {
     cgrp delta utime 0 stime 0 sum_exec_runtime 263468
     parent(/test/t1) ->bstat utime 0 stime 1000000 sum_exec_runtime 1267851
     parent(/test/t1) last_bstat utime 0 stime 0 sum_exec_runtime 0
     parent(/test/t1) cumul_bstat utime 0 stime 0 sum_exec_runtime 520809
}

*cpu 6* current flush cgroup /test/t1
per-cpu delta utime 0 stime 0 sum_exec_runtime 0
/test/t1 cumul_bstat(cpu 6) utime 0 stime 0 sum_exec_runtime 520809
/test/t1 cgrp->bstat utime 0 stime 1000000 sum_exec_runtime 1267851
if (cgroup_parent(parent)) {
     cgrp delta utime 0 stime 1000000 sum_exec_runtime 1267851  <---
     parent(/test) ->bstat utime 0 stime 1000000 sum_exec_runtime 1267851
     parent(/test) last_bstat utime 0 stime 0 sum_exec_runtime 0
     parent(/test) cumul_bstat (cpu 6) utime 0 stime 1000000 
sum_exec_runtime 1267851 <--- *error*
******
   Here cgrp delta is *not equal* to per-cpu delta.
   The frequency of cgroup (/test) and its chiled cgroup (/test/t1/tt1) 
  flush is inconsistent.
   In other words (when we call cgroup_base_stat_flush(), we will not 
necessarily flush to the highest-level cgroup except root(like step 1 
and 2 above)).
   Therefore, cgrp delta may contain the cumulative value of multiple 
per-cpu deltas.

   The correct value of parent(/test) cumul_bstat should be utime 0 
stime 0 sum_exec_runtime 520809.
******
}

*cpu 6* current flush cgroup /test
per-cpu delta utime 0 stime 0 sum_exec_runtime 0
cumul_bstat utime 0 stime 1000000 sum_exec_runtime 1267851
/test ->bstat utime 0 stime 1000000 sum_exec_runtime 1267851
	cgroup_parent(parent) is NULL end.


So we should add a per-cpu variable subtree_last_bstat similar to 
cgrp->last_bstat to record the last value.

I have sent v2 patch, please review it again.
v2 link:
https://lore.kernel.org/all/20230807032930.87785-1-jiahao.os@bytedance.com


> * Please add a comment explaining that the field is not currently used
>    outside of being read from bpf / drgn and what not and that we're still
>    trying to determine how to expose that in the cgroupfs interface.


Thanks, I did it in v2 patch.

Thanks,
Hao
