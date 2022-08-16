From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 3/3] cgroup/cpuset: Keep user set cpus affinity
Date: Tue, 16 Aug 2022 18:11:03 -0400
Message-ID: <c10e4f69-9951-6c38-6e28-fafcaec00d89@redhat.com>
References: <20220816192734.67115-1-longman@redhat.com>
 <20220816192734.67115-4-longman@redhat.com>
 <Yvv66EWygCwHUCqy@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660687868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K219zFXEgyRo40dCsRP0DxF0BwKck2dNw2HkaSxa61Y=;
        b=YOwnwUsWH8chTMbCLhEv623pf4Va9tUrG9oe4Jb4XKlHiF2jW0/eR0Pds2pz7bzG3WGmLa
        SNkaocLHEhyZulg0xC3gUmoH7CPQVDbC3FcAzaZUPBC2Ji67FlT0sAUXkeIy/AgFw89mQi
        lzMuUrIQfD/dOkX6rwKMFNFJhs7gbys=
Content-Language: en-US
In-Reply-To: <Yvv66EWygCwHUCqy-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>


On 8/16/22 16:15, Tejun Heo wrote:
> On Tue, Aug 16, 2022 at 03:27:34PM -0400, Waiman Long wrote:
>> +static int cpuset_set_cpus_allowed_ptr(struct task_struct *p,
>> +				       const struct cpumask *mask)
>> +{
>> +	cpumask_var_t new_mask;
>> +	int ret;
>> +
>> +	if (!READ_ONCE(p->user_cpus_ptr)) {
>> +		ret = set_cpus_allowed_ptr(p, mask);
>> +		/*
>> +		 * If user_cpus_ptr becomes set now, we are racing with
>> +		 * a concurrent sched_setaffinity(). So use the newly
>> +		 * set user_cpus_ptr and retry again.
>> +		 *
>> +		 * TODO: We cannot detect change in the cpumask pointed to
>> +		 * by user_cpus_ptr. We will have to add a sequence number
>> +		 * if such a race needs to be addressed.
>> +		 */
> This is too ugly and obviously broken. Let's please do it properly.

Actually, there is similar construct in __sched_setaffinity():

again:
         retval = __set_cpus_allowed_ptr(p, new_mask, SCA_CHECK);
         if (retval)
                 goto out_free_new_mask;

         cpuset_cpus_allowed(p, cpus_allowed);
         if (!cpumask_subset(new_mask, cpus_allowed)) {
                 /*
                  * We must have raced with a concurrent cpuset update.
                  * Just reset the cpumask to the cpuset's cpus_allowed.
                  */
                 cpumask_copy(new_mask, cpus_allowed);
                 goto again;
         }

It is hard to synchronize different subsystems atomically without 
running into locking issue. Let me think about what can be done in this 
case.

Is using a sequence number to check for race with retry good enough?

Cheers,
Longman

