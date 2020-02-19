From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: asynchronous reclaim for memory.high
Date: Wed, 19 Feb 2020 14:17:05 -0500
Message-ID: <20200219191705.GA1357312@chrisdown.name>
References: <20200219181219.54356-1-hannes@cmpxchg.org>
 <20200219183731.GC11847@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rANX/Xd0q5oumfVjHme1j9P+031qDgStPNCqoS/CWNk=;
        b=HSImXs472qEzrnVI+WL7Nop5RBlDH02Ti0aEwsTdZ4cSXbYVeBHGUJ469Zly4yC2gR
         jBMOl0dEmEC36yW5IHEYw0JYVWKAnqu8OxEHSMuV/K+joeaLqY3cLHhwcgZsCGoXuMjX
         t8PEhn5xfL7/e2amuMCadASeZa+BmzA8yLgCo=
Content-Disposition: inline
In-Reply-To: <20200219183731.GC11847-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Michal Hocko writes:
>On Wed 19-02-20 13:12:19, Johannes Weiner wrote:
>> We have received regression reports from users whose workloads moved
>> into containers and subsequently encountered new latencies. For some
>> users these were a nuisance, but for some it meant missing their SLA
>> response times. We tracked those delays down to cgroup limits, which
>> inject direct reclaim stalls into the workload where previously all
>> reclaim was handled my kswapd.
>
>I am curious why is this unexpected when the high limit is explicitly
>documented as a throttling mechanism.

Throttling is what one expects if one's workload does not respect the high 
threshold (ie. if it's not possible to reclaim the requisite number of pages), 
but you don't expect throttling just because you're brushing up against the 
threshold, because we only reclaim at certain points (eg. return to usermode).

That is, the workload may be well-behaved and it's just we didn't get around to 
completing reclaim yet. In that case, throttling the workload when there's no 
evidence it's misbehaving seems unduly harsh, hence the ~4% grace, with 
exponential penalties as there's more evidence the workload is pathological.

So sure, memory.high is a throttling mechanism if you *exceed* the stated 
bounds of your allocation, but this is about even those applications which are 
well-behaved, and just brushing against the bounds of it, as is expected on a 
system where the bottleneck is at the cgroup rather than being global.
