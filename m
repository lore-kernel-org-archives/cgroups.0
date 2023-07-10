From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: update parent subparts cpumask while
 holding css refcnt
Date: Mon, 10 Jul 2023 11:40:36 -0400
Message-ID: <74f1906e-fe58-c745-a851-b160374f7acf@redhat.com>
References: <20230701065049.1758266-1-linmiaohe@huawei.com>
 <fbabnjfly5w6fxrhe3eu6ebspngz2hd3tqs6rrbropcdvylnhs@ayjdpq73kwui>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689003641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F0D7PqDIktc2dtIxI/bE8WlEAjuSUexO7v405cL9P8Q=;
        b=FGtFc4daP/I6htFOtuxKHYQK+w9/v7jL8DXxGMHBYDWPiZtarSyzWeadYtwuUU1FdsNNTo
        NmYlfxnCEPQqE3A4QavPqLFaDiL/nadnWpLhnAdCTF1bMU/qyP2eehRdBw2uYj2sHdJRWZ
        UT8jPMtvSufeEYfKkDxyxCjyhs65WqM=
Content-Language: en-US
In-Reply-To: <fbabnjfly5w6fxrhe3eu6ebspngz2hd3tqs6rrbropcdvylnhs@ayjdpq73kwui>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 7/10/23 11:11, Michal Koutn=C3=BD wrote:
> Hello.
>
> On Sat, Jul 01, 2023 at 02:50:49PM +0800, Miaohe Lin <linmiaohe-hv44wF8Li=
93QT0dZR+AlfA@public.gmane.org> wrote:
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1806,9 +1806,12 @@ static int update_cpumask(struct cpuset *cs, stru=
ct cpuset *trialcs,
>>   		cpuset_for_each_child(cp, css, parent)
>>   			if (is_partition_valid(cp) &&
>>   			    cpumask_intersects(trialcs->cpus_allowed, cp->cpus_allowed)) {
>> +				if (!css_tryget_online(&cp->css))
>> +					continue;
>>   				rcu_read_unlock();
>>   				update_parent_subparts_cpumask(cp, partcmd_invalidate, NULL, &tmp);
>>   				rcu_read_lock();
>> +				css_put(&cp->css);
> Apologies for a possibly noob question -- why is RCU read lock
> temporarily dropped within the loop?
> (Is it only because of callback_lock or cgroup_file_kn_lock (via
> notify_partition_change()) on PREEMPT_RT?)
>
>
>
> [
> OT question:
> 	cpuset_for_each_child(cp, css, parent)				(1)
> 		if (is_partition_valid(cp) &&
> 		    cpumask_intersects(trialcs->cpus_allowed, cp->cpus_allowed)) {
> 			if (!css_tryget_online(&cp->css))
> 				continue;
> 			rcu_read_unlock();
> 			update_parent_subparts_cpumask(cp, partcmd_invalidate, NULL, &tmp);
> 			  ...
> 			  update_tasks_cpumask(cp->parent)
> 			    ...
> 			    css_task_iter_start(&cp->parent->css, 0, &it);	(2)
> 			      ...
> 			rcu_read_lock();
> 			css_put(&cp->css);
> 		}
>
> May this touch each task same number of times as its depth within
> herarchy?

I believe the primary reason is because update_parent_subparts_cpumask()=20
can potential run for quite a while. So we don't want to hold the=20
rcu_read_lock for too long. There may also be a potential that=20
schedule() may be called.

Cheers,
Longman

