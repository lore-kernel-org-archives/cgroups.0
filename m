From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2 11/29] cgroups: ability to stop res charge propagation
 on bounded ancestor
Date: Wed, 16 May 2012 10:16:51 +0400
Message-ID: <4FB34653.7060807@parallels.com>
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-12-git-send-email-glommer@parallels.com> <4FB1C6A1.1020602@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FB1C6A1.1020602-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>, Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On 05/15/2012 06:59 AM, KAMEZAWA Hiroyuki wrote:
> (2012/05/12 2:44), Glauber Costa wrote:
> 
>> From: Frederic Weisbecker<fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> Moving a task from a cgroup to another may require to substract its
>> resource charge from the old cgroup and add it to the new one.
>>
>> For this to happen, the uncharge/charge propagation can just stop when we
>> reach the common ancestor for the two cgroups.  Further the performance
>> reasons, we also want to avoid to temporarily overload the common
>> ancestors with a non-accurate resource counter usage if we charge first
>> the new cgroup and uncharge the old one thereafter.  This is going to be a
>> requirement for the coming max number of task subsystem.
>>
>> To solve this, provide a pair of new API that can charge/uncharge a
>> resource counter until we reach a given ancestor.
>>
>> Signed-off-by: Frederic Weisbecker<fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Acked-by: Paul Menage<paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>
>> Acked-by: Glauber Costa<glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>> Cc: Li Zefan<lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
>> Cc: Johannes Weiner<hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>> Cc: Aditya Kali<adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> Cc: Oleg Nesterov<oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Cc: Kay Sievers<kay.sievers-tD+1rO4QERM@public.gmane.org>
>> Cc: Tim Hockin<thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>
>> Cc: Tejun Heo<htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Acked-by: Kirill A. Shutemov<kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
>> Signed-off-by: Andrew Morton<akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> 
> 
> Where is this function called in this series ?
> 
> Thanks,
> -Kame
> 
It is not... anymore!
But I forgot the patch among the "pre-requisite" patches I had.

Thanks, this can be dropped.
