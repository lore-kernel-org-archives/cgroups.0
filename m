From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: add cpu.stat_percpu
Date: Wed, 12 Jan 2022 10:23:55 -1000
Message-ID: <Yd8429VrPCay9cn4@slm.duckdns.org>
References: <20220107234138.1765668-1-joshdon@google.com>
 <Yd189wHB2LJcK1Pv@hirez.programming.kicks-ass.net>
 <CABk29NuGs_9uxgbv678W=BGGinZNiUHO5T57FHGbOG+HP-FT2g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n6vNoI1/a0MDiqXuZ0zXzZQChQHHajU4edJoNcbDIdQ=;
        b=EYBoAiBSvbXwh/dJ5H4rNhojPuxcAibbjsPJvRAzDkRKcXllebozoVEKaSp/nQJpu/
         PAv1LWNyiMTdsL1r1GASsvdIAsGwCfl4jI664YuTM8ZkV/JB4SBEdANOJijQp3wU/CSF
         uU4pB0uPisW9xxGAtpS9g1OFpvBvS92rtOJXAK5Prk3QRLn+blfi6Pmwrb/BqHHeX95F
         85BbQPrXuFfinz5LJF1/9B5Dxf3ujA+ugfdRtIseKhCk4X9a/BJazZE9GjyLpHyveBhV
         tdA0SURCSyxHi416HaDCKFnaueOmPDRZm86kOAbhep7nEmvZLhV8XikCqilTvD1Wgosp
         DcBA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CABk29NuGs_9uxgbv678W=BGGinZNiUHO5T57FHGbOG+HP-FT2g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Tue, Jan 11, 2022 at 03:38:20PM -0800, Josh Don wrote:
> Is the concern there just the extra overhead from making multiple
> trips into this handler and re-allocating the buffer until it is large
> enough to take all the output? In that case, we could pre-allocate
> with a size of the right order of magnitude, similar to /proc/stat.
> 
> Lack of per-cpu stats is a gap between cgroup v1 and v2, for which v2
> can easily support this interface given that it already tracks the
> stats percpu internally. I opted to dump them all in a single file
> here, to match the consolidation that occurred from cpuacct->cpu.stat.

Yeah, nack on this. That part was dropped intentionally. These text pseudo
files aren't a great medium for this sort of (potentially large) data dump
and they scale really badly with new fields which we may want to expose in
the future. For detailed introspection, a better route would be using bpf
and if that's inconvenient for some reason trying to make them more
convenient.

Thanks.

-- 
tejun
