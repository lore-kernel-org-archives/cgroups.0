From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC 0/5] kernel: Introduce CPU Namespace
Date: Sun, 10 Oct 2021 00:41:38 +0200
Message-ID: <20211009224138.GZ174703@worktop.programming.kicks-ass.net>
References: <20211009151243.8825-1-psampat@linux.ibm.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=irb6FRwPU2dQSsNxYUCgkPV+9G3ES5Ac2nbK8COEBzU=; b=DXMGHD/JX7AFdlaWO/D2GkVpwP
        QHCWfAPEgda5tzNYUSnnKZKCGkQknXnodDJbMYotyD8jaVhs69KREgh7jIBPVJ/5E16H/9bcgXTKD
        IroinWzWCbs73n5/onzduuOpL3gxMExtapMVaQDRRpCm+DFsvm9c3Pm+SfhOnfW5wzJefTXiU1YGc
        VgkiiMjqM65eIxzikDCe9D2I1XruRKUFEougWAdwFo2xqTsuoZ/gbloLdtivYIomIPmuJTli09DRS
        c3QhGj6d23zWxNrWup/YMnbaDJBwo5HH6sd5/tN9kVP1mZSgoEURfTGx2vX/FVt2MFL7+d9egwyvg
        cVv9mw4Q==;
Content-Disposition: inline
In-Reply-To: <20211009151243.8825-1-psampat@linux.ibm.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Pratik R. Sampat" <psampat@linux.ibm.com>
Cc: bristot@redhat.com, christian@brauner.io, ebiederm@xmission.com, lizefan.x@bytedance.com, tj@kernel.org, hannes@cmpxchg.org, mingo@kernel.org, juri.lelli@redhat.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, containers@lists.linux.dev, containers@lists.linux-foundation.org, pratik.r.sampat@gmail.com

On Sat, Oct 09, 2021 at 08:42:38PM +0530, Pratik R. Sampat wrote:

> Current shortcomings in the prototype:
> --------------------------------------
> 1. Containers also frequently use cfs period and quotas to restrict CPU
>    runtime also known as millicores in modern container runtimes.
>    The RFC interface currently does not account for this in
>    the scheme of things.
> 2. While /proc/stat is now namespace aware and userspace programs like
>    top will see the CPU utilization for their view of virtual CPUs;
>    if the system or any other application outside the namespace
>    bumps up the CPU utilization it will still show up in sys/user time.
>    This should ideally be shown as stolen time instead.
>    The current implementation plugs into the display of stats rather
>    than accounting which causes incorrect reporting of stolen time.
> 3. The current implementation assumes that no hotplug operations occur
>    within a container and hence the online and present cpus within a CPU
>    namespace are always the same and query the same CPU namespace mask
> 4. As this is a proof of concept, currently we do not differentiate
>    between cgroup cpus_allowed and effective_cpus and plugs them into
>    the same virtual CPU map of the namespace
> 5. As described in a fair use implication earlier, knowledge of the
>    CPU topology can potentially be taken an misused with a flood.
>    While scrambling the CPUset in the namespace can help by
>    obfuscation of information, the topology can still be roughly figured
>    out with the use of IPI latencies to determine siblings or far away
>    cores

6. completely destroys and ignores any machine topology information.
