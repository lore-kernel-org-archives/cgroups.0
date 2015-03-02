From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 2/2] cpusets,isolcpus: add file to show isolated cpus
 in cpuset
Date: Mon, 2 Mar 2015 12:01:16 -0500
Message-ID: <20150302170116.GJ17694@htj.duckdns.org>
References: <1424882288-2910-1-git-send-email-riel@redhat.com>
 <1424882288-2910-3-git-send-email-riel@redhat.com>
 <54EEFE15.3010005@huawei.com>
 <20150226121231.6fcba7e8@annuminas.surriel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Zk4SqEKQuXww8Nd6PBCV/6DhzwRznktJxS6XRgGnSM4=;
        b=Ho+u1t60w88H7wQZg3fC/k7PYZB1H6+E1b1IRtcwc5KIZNPeacCG3NpwXex0BXermt
         U0mFKUEIa+4mcA+aqe+PRWFlc7lvZ+dRtybgTE1IHSQmOare8dChefnHwK5kA29TeJLw
         a58yKZRguPR728p8MtJi+9UndHhx1tYi/+1523LPCqbyREWZMSB+fIaUtWjSVhUfyyUe
         vK3ecfP6EqfpDbb4/Oa6foSNP6dKHEt31ewlwWWgAbRsrx6XQKFQ6igh2TYWOiNUF7jx
         /ROCW8+93As8lmMPTBhha/PGfXN7ILTVDQ5IGGf8Bzf/Ba5DFzCSyI1y3LtMBMdmTY6K
         5eMA==
Content-Disposition: inline
In-Reply-To: <20150226121231.6fcba7e8@annuminas.surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rik van Riel <riel@redhat.com>
Cc: Zefan Li <lizefan@huawei.com>, linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Clark Williams <williams@redhat.com>, Ingo Molnar <mingo@redhat.com>, Luiz Capitulino <lcapitulino@redhat.com>, David Rientjes <rientjes@google.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, cgroups@vger.kernel.org

On Thu, Feb 26, 2015 at 12:12:31PM -0500, Rik van Riel wrote:
> On Thu, 26 Feb 2015 19:05:57 +0800
> Zefan Li <lizefan@huawei.com> wrote:
> 
> > Make it return -ENOMEM ? Or make it a global variable and allocate memory for it
> > in cpuset_init().
> 
> Here you are. This addresses your concern, as well as the
> issue David Rientjes found earlier.
> 
> ---8<---
> 
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
> Acked-by: David Rientjes <rientjes@google.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Clark Williams <williams@redhat.com>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Luiz Capitulino <lcapitulino@redhat.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
> Cc: cgroups@vger.kernel.org
> Signed-off-by: Rik van Riel <riel@redhat.com>

Applied 1-2 to cgroup/for-4.1.

Thanks.

-- 
tejun
