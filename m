From: "lujialin (A)" <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [question] Is it possible for userspace program to control cpu usage
 time of RT process through cgroup2 now?
Date: Sat, 24 Sep 2022 17:26:20 +0800
Message-ID: <0a83dcd5-b7fd-811c-b8d2-062115fa8c94@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Cgroup2 dose not support controling real-time processes and the cpu 
controller can only be enabled when all RT processes are in the root cgroup.

RT stuff was being overhauled when cpu controller interface for cgroup 
unified hierarchy was being implemented in 2017. It was decided that we 
would like to wait till the RT side settles down and proceed with an 
interface that better matches RT.

Is it possible for userspace program to control cpu usage time of RT 
process through cgroup2 now? If not, how is the current state looking 
and is there any proposed solution?

