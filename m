From: Zefan Li <lizefan@huawei.com>
Subject: Re: [PATCH 1/2] cpusets,isolcpus: exclude isolcpus from load balancing
 in cpusets
Date: Sat, 28 Feb 2015 11:21:42 +0800
Message-ID: <54F13446.8090808@huawei.com>
References: <1424882288-2910-1-git-send-email-riel@redhat.com> <1424882288-2910-2-git-send-email-riel@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424882288-2910-2-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Clark Williams <williams@redhat.com>, Ingo Molnar <mingo@redhat.com>, Luiz Capitulino <lcapitulino@redhat.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, cgroups@vger.kernel.org

On 2015/2/26 0:38, riel@redhat.com wrote:
> From: Rik van Riel <riel@redhat.com>
> 
> Ensure that cpus specified with the isolcpus= boot commandline
> option stay outside of the load balancing in the kernel scheduler.
> 
> Operations like load balancing can introduce unwanted latencies,
> which is exactly what the isolcpus= commandline is there to prevent.
> 
> Previously, simply creating a new cpuset, without even touching the
> cpuset.cpus field inside the new cpuset, would undo the effects of
> isolcpus=, by creating a scheduler domain spanning the whole system,
> and setting up load balancing inside that domain. The cpuset root
> cpuset.cpus file is read-only, so there was not even a way to undo
> that effect.
> 
> This does not impact the majority of cpusets users, since isolcpus=
> is a fairly specialized feature used for realtime purposes.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Clark Williams <williams@redhat.com>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Luiz Capitulino <lcapitulino@redhat.com>
> Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
> Cc: cgroups@vger.kernel.org
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Tested-by: David Rientjes <rientjes@google.com>

Acked-by: Zefan Li <lizefan@huawei.com>
