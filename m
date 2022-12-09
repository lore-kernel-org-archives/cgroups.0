From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH-block 3/3] blk-cgroup: Flush stats at blkgs destruction
 path
Date: Fri, 9 Dec 2022 10:58:32 -0500
Message-ID: <8641d4a4-4d60-0f31-120c-56628f477ba2@redhat.com>
References: <20221208220141.2625775-1-longman@redhat.com>
 <20221208220141.2625775-4-longman@redhat.com>
 <e8a09f5d-afce-608f-220b-6b32b3ae37b9@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670601517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XJPm4fwaRggOYMPWB+4OQhr2AoXrB0vtei9ZF45OHV8=;
        b=P/kRoZGJ3sfZDKob9s9hbZmclMguAm+O0rrbTY0xZhUTyjEOHmo9LLqWK93tjeTm5wRYm6
        ooBTX8OoA3twHIRQTvXMkQhnOZpbEZ2YEB9NuAq9TcAHS/HwScBtN7C2KpKDigS9B9zZ1L
        NoFRILfKcGP5Us8OL0tqeU6W4j30GWU=
Content-Language: en-US
In-Reply-To: <e8a09f5d-afce-608f-220b-6b32b3ae37b9-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, "Dennis Zhou (Facebook)" <dennisszhou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 12/8/22 18:00, Jens Axboe wrote:
> On 12/8/22 3:01?PM, Waiman Long wrote:
>> diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
>> index 793ecff29038..910e633869b0 100644
>> --- a/kernel/cgroup/rstat.c
>> +++ b/kernel/cgroup/rstat.c
>> @@ -281,6 +281,26 @@ void cgroup_rstat_flush_release(void)
>>   	spin_unlock_irq(&cgroup_rstat_lock);
>>   }
>>  =20
>> +/**
>> + * cgroup_rstat_css_cpu_flush - flush stats for the given css and cpu
>> + * @css: target css to be flush
>> + * @cpu: the cpu that holds the stats to be flush
>> + *
>> + * A lightweight rstat flush operation for a given css and cpu.
>> + * Only the cpu_lock is being held for mutual exclusion, the cgroup_rst=
at_lock
>> + * isn't used.
>> + */
>> +void cgroup_rstat_css_cpu_flush(struct cgroup_subsys_state *css, int cp=
u)
>> +{
>> +	raw_spinlock_t *cpu_lock =3D per_cpu_ptr(&cgroup_rstat_cpu_lock, cpu);
>> +
>> +	raw_spin_lock_irq(cpu_lock);
>> +	rcu_read_lock();
>> +	css->ss->css_rstat_flush(css, cpu);
>> +	rcu_read_unlock();
>> +	raw_spin_unlock_irq(cpu_lock);
>> +}
>> +
>>   int cgroup_rstat_init(struct cgroup *cgrp)
>>   {
>>   	int cpu;
> As I mentioned last time, raw_spin_lock_irq() will be equivalent to an
> RCU protected section anyway, so you don't need to do both. Just add a
> comment on why rcu_read_lock()/rcu_read_unlock() isn't needed inside the
> raw irq safe lock.

Yes, you are right.=C2=A0 We don't need rcu_read_lock() here. I put it ther=
e=20
to follow the locking pattern in cgroup_rstat_flush_locked(). I will=20
remove it in the next version.

Cheers,
Longman

