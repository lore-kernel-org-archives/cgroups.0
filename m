From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v10 1/4] cgroups: use bitmask to filter for_each_subsys
Date: Wed, 13 May 2015 15:44:51 +1000
Message-ID: <CAOviyah2kjtaRBFRcd3cAb1DeYX11Ks_KVfwXPMXK5BENSqOiA@mail.gmail.com>
References: <1429446154-10660-1-git-send-email-cyphar@cyphar.com>
	<1429446154-10660-2-git-send-email-cyphar@cyphar.com>
	<20150422152551.GA10738@htj.duckdns.org>
	<20150422154212.GE3007@worktop.Skamania.guest>
	<20150422160258.GE10738@htj.duckdns.org>
	<CAOviyagvVTKjRp4wxyNo4Oke-w=Wbda+UyHAN-ih9yFX-8jqmw@mail.gmail.com>
	<20150426160909.GC1499@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150426160909.GC1499-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Hi Tejun,

> Hmmmm... You can either convert all masks to ulong (which is fine) or
> do something like the following.
>
> #define for_each_subsys_which(ss_mask, ss, ssid)            \
>     unsigned long __tmp_mask = (ss_mask);                   \
>     for_each_set_bit(ssid, &__tmp_mask, CGROUP_SUBSYS_COUNT)\
>             if ((ss) = group_subsys[ssid] && false)         \
>                     ;                                       \
>              else

I think I'll just do casting and manually make new variables where
required. The above (and similar) doesn't work very well, generates
warnings like crazy and breaks stuff like:

    if (...)
        for_each_subsys_which(...)

--
Aleksa Sarai (cyphar)
www.cyphar.com
