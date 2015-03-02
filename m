From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 2/2] cpusets,isolcpus: add file to show isolated cpus
 in cpuset
Date: Mon, 2 Mar 2015 14:15:39 +0800
Message-ID: <54F4000B.5000901@huawei.com>
References: <1424882288-2910-1-git-send-email-riel@redhat.com> <1424882288-2910-3-git-send-email-riel@redhat.com> <54EEFE15.3010005@huawei.com> <20150226121231.6fcba7e8@annuminas.surriel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150226121231.6fcba7e8-XDFsmL65zczMw9PXcw3sFBL4W9x8LtSr@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Rik,

> Subject: cpusets,isolcpus: add file to show isolated cpus in cpuset
> 
> The previous patch makes it so the code skips over isolcpus when
> building scheduler load balancing domains. This makes it hard to
> see for a user which of the CPUs in a cpuset are participating in
> load balancing, and which ones are isolated cpus.
> 
> Add a cpuset.isolcpus file with info on which cpus in a cpuset are
> isolated CPUs.
> 
> This file is read-only for now. In the future we could extend things
> so isolcpus can be changed at run time, for the root (system wide)
> cpuset only.
> 

One Question, why not add a /sys/devices/system/cpu/isolated instead?
