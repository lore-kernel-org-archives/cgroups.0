From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup/cpuset: Keep current cpus list if cpus
 affinity was explicitly set
Date: Thu, 28 Jul 2022 09:02:55 -1000
Message-ID: <YuLdX7BYGvo57LNU@slm.duckdns.org>
References: <20220728005815.1715522-1-longman@redhat.com>
 <YuLF+xXaCzwWi2BR@slm.duckdns.org>
 <1ae1cc6c-dca9-4958-6b22-24a5777c5e8d@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=PWjIAmKrG0eGARGnUAKYiT1lYkiSHVZ1Sr+4FZSAYxg=;
        b=ksr0sVCDXJtHVWTGYRs6udLXbSRcNqPqF8cH0ACW6cKjvQVmA5weo37e+Eopue0wU/
         ZNvMmqCx3FhEnbbDzsNh5oM30sf4voiO5TOuZGgUwgIUWbd8HVNH0EJpf1igfj7nCThO
         uYXY03CYxCcobHkUVOKBQLudEOxJJhMpvI7tE0Cfkt6zJyV7DkrjtHLIdRAk0meelh7d
         po6PXn9dUzyB3g83pYcmcs0a9NJiSxXWLJs02p8RIWAiEiW/HLMvB4AtTtJPKxrw7Wj/
         QEKX3x1t+/Dh2lcam+fpLLLXo+LGfU78S78F4HECzGv9eJMNzRr9L6+EJWY25fFknMmi
         TaBw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1ae1cc6c-dca9-4958-6b22-24a5777c5e8d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Thu, Jul 28, 2022 at 02:57:28PM -0400, Waiman Long wrote:
> There can be a counter argument that if a user found out that there is not
> enough cpus in a cpuset to meet its performance target, one can always
> increase the number of cpus in the cpuset. Generalizing this behavior to all
> the tasks irrespective if they have explicitly set cpus affinity before will
> disallow this use case.

This is nasty. The real solution here is separating out what user requested
and the mask that cpuset (or cpu hotplug) needs to apply on top. ie.
remember what the user requested in a separate cpumask and compute the
intersection into p->cpus_maks whenever something changes and apply
fallbacks on that final mask. Multiple parties updating the same variable is
never gonna lead to anything consistent and we're patching up for whatever
the immediate use case seems to need at the moment. That said, I'm not
necessarily against patching it up but if you're interested in delving into
it deeper, that'd be great.

Thanks.

-- 
tejun
