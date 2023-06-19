From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 2/2] sched: add throttled time stat for throttled
 children
Date: Mon, 19 Jun 2023 19:53:11 +0200
Message-ID: <rs46fzspb2w46zcbgdjysqd2rcfqs4yk55xyf5syvnf75rjhfe@ku6i5chn5qrq>
References: <20230612232748.3948659-1-joshdon@google.com>
 <20230612232748.3948659-2-joshdon@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="icuc2q4jvzwybeqp"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1687197192; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZIuFur/HcfWhT5DdI6dfHnQIRvcQlNpf5jwJtp/eN3s=;
        b=Re5KD9WLu+GeYv4h//LoyjUWFxbB9Iu1ah46eFj8lnpcZygGjrd8KMsnjy5+wFPb5rtsDW
        DpwXdSQWAlFSQoSh4P6p0i8dN6aUpYgv3C3Vobf/+qfFnJexoAU+cXDCd/C083H3oliYOf
        iHkT4rAB8xCQQrePLXgYRe0OT0azyTY=
Content-Disposition: inline
In-Reply-To: <20230612232748.3948659-2-joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Xiangling Kong <xiangling-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>


--icuc2q4jvzwybeqp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 12, 2023 at 04:27:48PM -0700, Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> We currently export the total throttled time for cgroups that are given
> a bandwidth limit.

I assume you refer to cpu.stat:throttled_usec (from struct
cfs_bandwidth) -- notice that the value is not properly hierarchical
despite v2 filename.

> This patch extends this accounting to also account the total time that
> each children cgroup has been throttled.

IIUC, this is visible on inner-nodes cpu cgroups (i.e. with no tasks)?

IOW, wouldn't you get the intended information if hierarchical summing
was added/fixed for cpu.stat:throttled_usec?

Thanks,
Michal

--icuc2q4jvzwybeqp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZJCWBQAKCRAGvrMr/1gc
joqPAP9/BBtJGar7Rx1bCxiaeV7A8Au3XlzUAVHwxn9zARidBQEA3vGFSuyZNsXN
mKBFqLKkUlhCp6znAuvFIB3pq5frRAk=
=P/O2
-----END PGP SIGNATURE-----

--icuc2q4jvzwybeqp--
