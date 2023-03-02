From: Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 2/6] mm/memcg: Disable threshold event handlers on
 PREEMPT_RT
Date: Thu, 02 Mar 2023 19:52:11 +0000
Message-ID: <xhsmhmt4vnd78.mognet@vschneid.remote.csb>
References: <20220226204144.1008339-1-bigeasy@linutronix.de>
 <20220226204144.1008339-3-bigeasy@linutronix.de>
 <xhsmh4jr4pbzc.mognet@vschneid.remote.csb>
 <ZABUMit05SZBDXRQ@dhcp22.suse.cz>
 <xhsmh1qm7pibs.mognet@vschneid.remote.csb>
 <ZACHa4wrtwpQbmP2@dhcp22.suse.cz>
 <xhsmhy1ofnxna.mognet@vschneid.remote.csb>
 <ZACdBuVBHZ/AMAh/@dhcp22.suse.cz>
 <xhsmhv8jjnrwu.mognet@vschneid.remote.csb>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677786735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KwpX3YFb316Y6Yz0MMigE20cUWOeVNyriSBJ2SDd4TE=;
        b=GqtNoW/DN3JOJuswvA+ExgNcSfKlgoqRCvLy1rphrdM8pDNLtfrw8Ybrzv5Cylnbug3MJl
        elJ1Bu3cFQ/4oYhy8CPlr6hytgbFJYrt0+IYqSr/6rBXx3AUIv5r6kCFldnbx8+D1MesRR
        RoUGcpDz6ACIRgmgwfp7capDbZ+QiW4=
In-Reply-To: <xhsmhv8jjnrwu.mognet-lVOlpLwaOlUmbyhZVYo91WPO1xz+ivuR@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 02/03/23 14:34, Valentin Schneider wrote:
> On 02/03/23 13:56, Michal Hocko wrote:
>> What I am trying to evaluate here is whether it makes sense to support
>> and maintain a non-trivial code for something that might be working
>> sub-optimally or even not working properly in some corner cases. The
>> price for the maintenance is certainly not free.
>
> That's also what I'm trying to make sense of. Either way this will be
> frankenkernel territory, the cgroupv1 ship has already sailed for upstream
> IMO.

So, if someone ends up in a similar situation and considers kludging those
notifications back in:

Don't.


Have a look at:

  memcg_check_events()
  `\
    mem_cgroup_threshold()
    `\
      __mem_cgroup_threshold()
      `\
        eventfd_signal()

Having IRQs off, percpu reads, and the the eventfd signal is a nice recipe
for disaster.

The OOM notification sits outside of that, but any other memcg notification
will cause pain.

