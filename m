From: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Subject: Re: [RFC][PATCH] oom: Be less verbose if the oom_control event fd
 has listeners
Date: Thu, 05 Jun 2014 17:46:57 +0200
Message-ID: <539090F1.7090408@nod.at>
References: <1401976841-3899-1-git-send-email-richard@nod.at> <1401976841-3899-2-git-send-email-richard@nod.at> <20140605141841.GA23796@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140605141841.GA23796-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Am 05.06.2014 16:18, schrieb Oleg Nesterov:
> On 06/05, Richard Weinberger wrote:
>>
>> +int mem_cgroup_has_listeners(struct mem_cgroup *memcg)
>> +{
>> +	int ret = 0;
>> +
>> +	if (!memcg)
>> +		goto out;
>> +
>> +	spin_lock(&memcg_oom_lock);
>> +	ret = !list_empty(&memcg->oom_notify);
>> +	spin_unlock(&memcg_oom_lock);
>> +
>> +out:
>> +	return ret;
>> +}
> 
> Do we really need memcg_oom_lock to check list_empty() ? With or without
> this lock we can race with list_add/del anyway, and I guess we do not care.

Hmm, in mm/memcontrol.c all list_dev/add are under memcg_oom_lock.
What do I miss?

Thanks,
//richard
