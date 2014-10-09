From: Raghavendra K T <raghavendra.kt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] cpusets: Make cpus_allowed and mems_allowed masks hotplug
 invariant
Date: Thu, 09 Oct 2014 15:12:30 +0530
Message-ID: <54365886.7010506@linux.vnet.ibm.com>
References: <CAC4Lta2AS6M5upg8n9Qu5+1pqCMF3j8_cYuLAS1DH9C_BQP0PA@mail.gmail.com> <54361922.8070808@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54361922.8070808-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: svaidy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paul McKenney <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 10/09/2014 10:42 AM, Preeti U Murthy wrote:
> Hi Raghu,

> remove_tasks_in_empty_cpuset() is called on the legacy hierarchy when
> the cpuset becomes empty, hence we require it. But you are right its not
> called on the default hierarchy.

My point was if legacy hierarchy follows unified hierarchy in effective
cpuset handling, we will never endup with a empty effective cpuset and
hence your patch could remove the remove_tasks_in_empty_cpuset() part
too..
