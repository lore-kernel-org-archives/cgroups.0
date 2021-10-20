From: Pratik Sampat <psampat-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Subject: Re: [RFC 0/5] kernel: Introduce CPU Namespace
Date: Wed, 20 Oct 2021 16:14:25 +0530
Message-ID: <77854748-081f-46c7-df51-357ca78b83b3@linux.ibm.com>
References: <20211009151243.8825-1-psampat@linux.ibm.com>
 <20211011101124.d5mm7skqfhe5g35h@wittgenstein>
 <a0f9ed06-1e5d-d3d0-21a5-710c8e27749c@linux.ibm.com>
 <YWirxCjschoRJQ14@slm.duckdns.org>
 <b5f8505c-38d5-af6f-0de7-4f9df7ae9b9b@linux.ibm.com>
 <YW2g73Lwmrhjg/sv@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=SD+SCg0skNn/G8bPIH66EtOVwTbj3NFy6mI+5VN/Q5s=;
 b=PZZppYkh/ARYtQF6DTllxaxC2TsLrFX66Zh88bWos3rMX2NYk5Q2jZsEAY7M5L7hsz90
 4MCfmaeeBUIQi8wDabhMjZ+GvPLNh9c4jqFmdvZXznQFyDNf4JHe2mSeA2PpiEKYmbMk
 WIiQFsuEUMBlsyB8tqoyfc4/NU9JtUM6sVrbr3KEUWKZdmyB7pxIuiZcB6s7mZf+Ga2N
 9NuKu1p7TIhplQ6/Jeivs8OGZj7XE2Dyyupj11TrgsAKScodKsFr5GRuTaj3xwyxGBmb
 LtZ+RXQkhbnGMAnAdGSekEDjtpJYMpiV4vFEcmdCkQj9wMnbFDszulmjpGpyx88Ud0RI JQ== 
Content-Language: en-US
In-Reply-To: <YW2g73Lwmrhjg/sv-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pratik.r.sampat-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org



On 18/10/21 9:59 pm, Tejun Heo wrote:
> (cc'ing Johannes for memory sizing part)
>
> Hello,
>
> On Mon, Oct 18, 2021 at 08:59:16PM +0530, Pratik Sampat wrote:
> ...
>> Also, I agree with your point about variability of requirements. If the
>> interface we give even though it is in conjunction with the limits set,
>> if the applications have to derive metrics from this or from other
>> kernel information regardless; then the interface would not be useful.
>> If the solution to this problem lies in userspace, then I'm all for it
>> as well. However, the intention is to probe if this could potentially be
>> solved in cleanly in the kernel.
> Just to be clear, avoiding application changes would have to involve
> userspace (at least parameterization from it), and I think to set that as a
> goal for kernel would be more of a distraction. Please note that we should
> definitely provide metrics which actually capture what's going on in terms
> of resource availability in a way which can be used to size workloads
> automatically.
>
>> Yes, these shortcomings exist even without containerization, on a
>> dynamically loaded multi-tenant system it becomes very difficult to
>> determine what is the maximum amount resource that can be requested
>> before we hurt our own performance.
> As I mentioned before, feedback loop on PSI can work really well in finding
> the saturation points for cpu/mem/io and regulating workload size
> automatically and dynamically. While such dynamic sizing can work without
> any other inputs, it sucks to have to probe the entire range each time and
> it'd be really useful if the kernel can provide ballpark numbers that are
> needed to estimate the saturation points.
>
> What gets challenging is that there doesn't seem to be a good way to
> consistently describe availability for each of the three resources and the
> different distribution rules they may be under.
>
> e.g. For CPU, the affinity restrictions from cpuset determines the maximum
> number of threads that a workload would need to saturate the available CPUs.
> However, conveying the results of cpu.max and cpu.weight controls isn't as
> straight-fowrads.
>
> For memory, it's even trickier because in a lot of cases it's impossible to
> tell how much memory is actually available without trying to use them as
> active workingset can only be learned by trying to reclaim memory.
>
> IO is in somewhat similar boat as CPU in that there are both io.max and
> io.weight. However, if io.cost is in use and configured according to the
> hardware, we can map those two in terms iocost.
>
> Another thing is that the dynamic nature of these control mechanisms means
> that the numbers can keep changing moment to moment and we'd need to provide
> some time averaged numbers. We can probably take the same approach as PSI
> and load-avgs and provide running avgs of a few time intervals.

As you have elucidated, it doesn't like an easy feat to
define metrics like ballpark numbers as there are many variables
involved.

For the CPU example, cpusets control the resource space whereas
period-quota control resource time. These seem like two vectors on
different axes.
Conveying these restrictions in one metric doesn't seem easy. Some
container runtime convert the period-quota time dimension to X CPUs
worth of runtime space dimension. However, we need to carefully model
what a ballpark metric in this sense would be and provide clearer
constraints as both of these restrictions can be active at a given
point in time and can influence how something is run.

Restrictions for memory are even more complicated to model as you have
pointed out as well.

I would also request using this mail thread to suggest if there are
more such metrics which would be useful to expose from the kernel?
This would probably not solve the coherency problem but maybe it could
help entice the userspace applications to look at the cgroup interface
as there could be more relevant metrics that would help them tune for
performance.

>
>> The question that I have essentially tries to understand the
>> implications of overloading existing interface's definitions to be
>> context sensitive.
>> The way that the prototype works today is that it does not interfere
>> with the information when the system boots or even when it is run in a
>> new namespace.
>> The effects are only observed when restrictions are applied to it.
>> Therefore, what would potentially break if interfaces like these are
>> made to divulge information based on restrictions rather than the whole
>> system view?
> I don't think the problem is that something would necessarily break by doing
> that. It's more that it's a dead-end approach which won't get us far for all
> the reasons that have been discussed so far. It'd be more productive to
> focus on long term solutions and leave backward compatibility to the domains
> where they can actually be solved by applying the necessary local knoweldge
> to emulate and fake whatever necessary numbers.

Sure, understood. If the only goal is backward compatibility then its
best to let existing solutions help emulate and/or fake this
information to the applications.

Thank you again for all the feedback.

