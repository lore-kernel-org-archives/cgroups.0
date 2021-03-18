From: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cpu/hotplug: wait for cpuset_hotplug_work to finish
 on cpu onlining
Date: Thu, 18 Mar 2021 15:12:25 -0400
Message-ID: <87a6r0uvhi.fsf@oracle.com>
References: <20210212003032.2037750-1-aklimov@redhat.com>
 <87tuqhrs3d.fsf@oracle.com>
 <CAFBcO+99Ax5MuOtzNx=NrmnUN=+913Sc-DV83ObOi01A=kkN3w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : content-type :
 mime-version; s=corp-2020-01-29;
 bh=k381lxwLG2fnstlsplMWqZjJew5AP+0V8oe6V2+EYwE=;
 b=HsVTTUU1EXtHxNSXeSMxPD1EXmioXLiHx665MD8wz3gWrcGrk0XvcOo9k1CJvzxQPZxA
 MtdDiks6vcbWQsVRXWlWmzDs4jHiJbKjhAnLxnMkAdQh8b3Nf1ZN5knLLCh+ix3Ad7On
 jRfeWmuwRQFjsQtg/sd8Hodn00RsHHrkKgsfMaImIVeRQcimKxL7Z/P4HgHbI2Bwt3V4
 nDcn1VrHz6pnTBRKoIynKS0oegoz7go2qly8kee5ib+QYODufTOsPCjlVZVei2c7kRDs
 AGrnwppi+emr6icre1JstUBE9LQ2Jv1VGzXuKKLFZhLlq722fBgNcmOfbWUQ5lgVhMfq /w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k381lxwLG2fnstlsplMWqZjJew5AP+0V8oe6V2+EYwE=;
 b=C6aRsDgtrww45gnbuJ+sxvYEGrKacpdTz0RJXRGUjVE5Kb2GnDlz7wF7C+xnnVBDtJwb5q0kM4any6BYiyozF+6NeL8dVwsiTuGjYZGYQ8XygZyVyAEPmQrMPRXGEvc7fZEnuMRNzCXdjqgTEqO6Acj1lxxr3a8V/TiA6i0hzmU=
In-Reply-To: <CAFBcO+99Ax5MuOtzNx=NrmnUN=+913Sc-DV83ObOi01A=kkN3w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexey Klimov <aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, yury.norov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, Joshua Baker <jobaker-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, audralmitchel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Alexey Klimov <klimov.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Alexey Klimov <aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
> The first section of comment seems problematic to me with regards to such move:
>
>                  * As this needs to hold the cpu maps lock it's impossible
>                  * to call device_offline() because that ends up calling
>                  * cpu_down() which takes cpu maps lock. cpu maps lock
>                  * needs to be held as this might race against in kernel
>                  * abusers of the hotplug machinery (thermal management).
>
> Cpu maps lock is released in cpu_maps_update_done() hence we will move
> dev->offline out of cpu maps lock. Maybe I misunderstood the comment
> and it relates to calling cpu_down_maps_locked() under lock to avoid
> race?

Yes, that's what I take from the comment, the cpu maps lock protects
against racing hotplug operations.
