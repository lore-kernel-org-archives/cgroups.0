From: Pratik Sampat <psampat-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Subject: Re: [RFC 0/5] kernel: Introduce CPU Namespace
Date: Thu, 21 Oct 2021 13:14:10 +0530
Message-ID: <bd1811cc-0e04-9e44-0b46-02689ff9a238@linux.ibm.com>
References: <20211009151243.8825-1-psampat@linux.ibm.com>
 <20211011101124.d5mm7skqfhe5g35h@wittgenstein>
 <a0f9ed06-1e5d-d3d0-21a5-710c8e27749c@linux.ibm.com>
 <YWirxCjschoRJQ14@slm.duckdns.org>
 <b5f8505c-38d5-af6f-0de7-4f9df7ae9b9b@linux.ibm.com>
 <YW2g73Lwmrhjg/sv@slm.duckdns.org>
 <77854748-081f-46c7-df51-357ca78b83b3@linux.ibm.com>
 <YXBFVCc61nCG5rto@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=uT4wjLPIFzFEl8waL4bVFZNbPI9aXaW6qIoccd8uwWI=;
 b=PCvLitr3hW5l+7lcPhGe/8CR/U6UXAwL2M1QTEvym95Tq+InQsB5zuAGQfjypEorIbeQ
 bqzhGC9crxX/i7nOwTgTWxeIppcaa9pMWuN5XK+liS2YKCQW9nXWYQRpQjOQNyNEqXIw
 JG1KDKMfYn1lgw571Zq0e8Vjow9bYTUzTlhCiE9f90LJU77DSREsyqS+6M1psCSQIb0t
 DI5Wver4FUvZX1OBHPVBESzPRsoAXBHCPLuqbb3Ote/6zvsndKITNM7LuM6v8StBM+yS
 8UGgiEiLsJFOZ/cCWgUSu2eAxsM25LXQlZcOPFsngxf4fRKtENVexxK+9ggi1zzIopr1 ZA== 
Content-Language: en-US
In-Reply-To: <YXBFVCc61nCG5rto-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pratik.r.sampat-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hello Tejun,


On 20/10/21 10:05 pm, Tejun Heo wrote:
> Hello,
>
> On Wed, Oct 20, 2021 at 04:14:25PM +0530, Pratik Sampat wrote:
>> As you have elucidated, it doesn't like an easy feat to
>> define metrics like ballpark numbers as there are many variables
>> involved.
> Yeah, it gets tricky and we want to get the basics right from the get go.
>
>> For the CPU example, cpusets control the resource space whereas
>> period-quota control resource time. These seem like two vectors on
>> different axes.
>> Conveying these restrictions in one metric doesn't seem easy. Some
>> container runtime convert the period-quota time dimension to X CPUs
>> worth of runtime space dimension. However, we need to carefully model
>> what a ballpark metric in this sense would be and provide clearer
>> constraints as both of these restrictions can be active at a given
>> point in time and can influence how something is run.
> So, for CPU, the important functional number is the number of threads needed
> to saturate available resources and that one is pretty easy.

I'm speculating, and please correct correct me if I'm wrong; suggesting
an optimal number of threads to spawn to saturate the available
resources can get convoluted right?

In the nginx example illustrated in the cover patch, it worked best
when the thread count was N+1 (N worker threads 1 master thread),
however different applications can work better with a different
configuration of threads spawned based on its usecase and
multi-threading requirements.

Eventually looking at the load we maybe able to suggest more/less
threads to spawn, but initially we may have to have to suggest threads
to spawn as direct function of N CPUs available or N CPUs worth of
runtime available?

> The other
> metric would be the maximum available fractions of CPUs available to the
> cgroup subtree if the cgroup stays saturating. This number is trickier as it
> has to consider how much others are using but would be determined by the
> smaller of what would be available through cpu.weight and cpu.max.

I agree, this would be a very useful metric to have. Having the
knowledge for how much further we can scale when we're saturating our
limits keeping in mind of the other running applications can possibly
be really useful not just for the applications itself but also for the
container orchestrators as well.

> IO likely is in a similar boat. We can calculate metrics showing the
> rbps/riops/wbps/wiops available to a given cgroup subtree. This would factor
> in the limits from io.max and the resulting distribution from io.weight in
> iocost's case (iocost will give a % number but we can translate that to
> bps/iops numbers).

Yes, that's a useful metric to expose this way as well.

>> Restrictions for memory are even more complicated to model as you have
>> pointed out as well.
> Yeah, this one is the most challenging.
>
> Thanks.
>
Thank you,
Pratik

