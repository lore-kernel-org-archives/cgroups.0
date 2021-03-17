From: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/4] cgroup: Fix 'usage_usec' time in root's cpu.stat
Date: Wed, 17 Mar 2021 18:13:02 -0400
Message-ID: <87tup9l98x.fsf@oracle.com>
References: <20210217120004.7984-1-arbn@yandex-team.com>
 <20210217120004.7984-2-arbn@yandex-team.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : content-type :
 mime-version; s=corp-2020-01-29;
 bh=zGYuXZfD+zniSD/XaAZxvizQ5334X7661tTFtRc0g54=;
 b=RFlEBHmRZnhoj4yDk/PYccsESg4qawsvfwsEPpg5wVQWLtLPzWoYiKz+4q7bfDm6WrBz
 kO41shph65s3p/pK6nTLN2UBImSalbZ9G2vLVji+drbUfyjyzLBXD9TeW8+oljnYTlOW
 3ag2N5fzItNGlIblycWO1/XS2y41MnMxtrA+3vS54xXuWFVylUZiZJkUo2qbCV4tLhl8
 w58LBAZBPRjUVjL99XJ2vKr/bHZQH4ajamnLEDUkBB+hqmcbkN0JfJnU23KjW/hqb9vP
 Tn3/MfJQHwrHSvpxkjsyB04/IfUgxPnIQXHMfp4K0Fliq6NiaUBQ5ZSm2k1YM8kDcXEC 8w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zGYuXZfD+zniSD/XaAZxvizQ5334X7661tTFtRc0g54=;
 b=odnBb62aq8fyrOBrKwq2Wi6/UGSbFZA66iASyR5j4IZeHpuFcOdzPMk88MQQhNU8IHOsh35e/Wf//jIBgp2GlV9yprumbfnCLJJjligoy2Vzel93ppBDQMCl+isA+I+8ps7YXmch84RHtNHViUcq9AZpS8yaV5cLufQ31gmQgm8=
In-Reply-To: <20210217120004.7984-2-arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Boris Burkov <boris-UrQYPotlwNs@public.gmane.org>, Bharata B Rao <bharata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org> writes:

> Global CPUTIME_USER counter already includes CPUTIME_GUEST
> Also CPUTIME_NICE already includes CPUTIME_GUEST_NICE.
>
> Remove additions of CPUTIME_GUEST[_NICE] to total ->sum_exec_runtime
> to not account them twice.

Yes, that's just wrong.  usage_usec looks ok now.

Reviewed-by: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
