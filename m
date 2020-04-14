From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg: expose vmpressure knobs
Date: Tue, 14 Apr 2020 23:55:25 +0100
Message-ID: <20200414225525.GA1892067@chrisdown.name>
References: <20200413215750.7239-1-lmoiseichuk@magicleap.com>
 <20200413215750.7239-2-lmoiseichuk@magicleap.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c8qoDjMoKh8m7k69YSal4t9Yzh8UqpaGOqxo2kh4+H4=;
        b=qUOTrLKP5lkD+hzSEZLpsh2KQaBFsVU/EEodUWabGWRaIAOxSAA6Fky7NKOSZ1UPR3
         KWeEOVeGQt5g+r3W8cYBFDYtCbD3yqd4wkOln8yW3EbPswE3I0zAIvmvIAuKKrHLRf8j
         YNCY0b2m8MjDExYGkz21fWnOsPZs4GHRqaZdg=
Content-Disposition: inline
In-Reply-To: <20200413215750.7239-2-lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: svc_lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vinmenon-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Leonid Moiseichuk <lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>

svc_lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org writes:
>From: Leonid Moiseichuk <lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>
>
>Populating memcg vmpressure controls with legacy defaults:
>- memory.pressure_window (512 or SWAP_CLUSTER_MAX * 16)
>- memory.pressure_level_critical_prio (3)
>- memory.pressure_level_medium (60)
>- memory.pressure_level_critical (95)
>
>Signed-off-by: Leonid Moiseichuk <lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>

I'm against this even in the abstract, cgroup v1 is deprecated and its 
interface frozen, and vmpressure is pretty much already supplanted by PSI, 
which actually works (whereas vmpressure often doesn't since it mostly ends up 
just measuring reclaim efficiency, rather than actual memory pressure).

Without an extremely compelling reason to expose these, this just muddles the 
situation.
