From: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH 9/9] sched/psi: add PSI_IRQ to track IRQ/SOFTIRQ pressure
Date: Fri, 22 Jul 2022 11:30:53 +0800
Message-ID: <65d9f79b-be9b-e21e-0624-5c9f2cc0c0b2@bytedance.com>
References: <20220721040439.2651-1-zhouchengming@bytedance.com>
 <20220721040439.2651-10-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/6Cb+8ADjWlGk1byx/gAv/ihrtjQyQM76AvewJ6raf0=;
        b=BEcZ5flLoTHKRlHcKGFXMGAK7PHpb1lCc5CBQgqqBDPQZQov25dfqyGsbsOsMv58tC
         UWjpwrPMbpT9fbLDpnXgRFmNstXP+69Ef2iw0cbtTSsGmRVSpa5ezEmPAM9zAdbntHmQ
         vudbUgEwJCcqnJZluroo91MVQykacN2gKArJBnEZD3JkVhIOqU7bGDha8UJ9nZLUeWjw
         TVammewdtB4Ni44XWU8JPxA4Vs7a1tnJuCT6gtRAi9rKZUOKxupeFCKPBQ7q3iitiObT
         fhJbN/aP282dSdyT8SEFzcZKp3w8dJnV7XULvZvmq9IOZAn6IuznR44/ylYwVWiVXr06
         zAQg==
Content-Language: en-US
In-Reply-To: <20220721040439.2651-10-zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Chengming,

On 7/21/22 12:04 PM, Chengming Zhou Wrote:
> Now PSI already tracked workload pressure stall information for
> CPU, memory and IO. Apart from these, IRQ/SOFTIRQ could have
> obvious impact on some workload productivity, such as web service
> workload.
> 
> When CONFIG_IRQ_TIME_ACCOUNTING, we can get IRQ/SOFTIRQ delta time
> from update_rq_clock_task(), in which we can record that delta
> to CPU curr task's cgroups as PSI_IRQ_FULL status.

The {soft,}irq affection should be equal to all the runnable tasks
on that cpu, not only rq->curr. Further I think irqstall is per-cpu
rather than per-cgroup.

Abel
