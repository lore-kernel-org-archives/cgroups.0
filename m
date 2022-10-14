From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] perf stat: Support old kernels for bperf cgroup
 counting
Date: Fri, 14 Oct 2022 06:40:56 -1000
Message-ID: <Y0mRGJx4Mc7t7fGB@slm.duckdns.org>
References: <Y0Sx2KWX4gPlLytq@slm.duckdns.org>
 <20221011052808.282394-1-namhyung@kernel.org>
 <Y0Wfl88objrECjSo@slm.duckdns.org>
 <Y0ljzN920sWalEHR@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bdQA2IQ/Zdiw0tfXrnTykfoypuZKZExhaq/VdDsyQcg=;
        b=lCZxuDQ0UPruEZ3c6zkM+o+qq6D1nO1fap4bCgiQi6n4b6TbYBoDGep63xEa6p+6rW
         pGtFf0jMeYoePHiirDy6OlVQFAYU6X/0q4u7KJkWUETFT8OVwV9kiiJQTbBK634iY4+o
         gcChe/p66whQgzhN44BnnLULT/bBd5I9GdAZ2oFfNP6QTTMqCDG2p/5Rz1divNDUdNk8
         ivCY6FR9gM7s7d2MOyIHRmcgTAyq5BzepvRQ/9ba6jdLX34SpmaflPJjZNYdYK/1I/E2
         1tPi3+nEkB8mvEwQJzulQFruvebnBL8Oqt9v+jLs+DcxuHOD8ojUteRDXLXKF0w15HSc
         5MNQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Y0ljzN920sWalEHR-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-perf-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Fri, Oct 14, 2022 at 10:27:40AM -0300, Arnaldo Carvalho de Melo wrote:
> Hey, I noticed that the perf build is broken for the
> tools/perf/util/bpf_skel/bperf_cgroup.bpf.c skell, so I tried using b4
> on this Namhyung patch, it ended up getting a newer version, by Tejun,
> that mixes up kernel code and tooling, which, when I tried to apply
> upstream didn't work.
> 
> Please try not to mix up kernel and tools/ changes in the same patch to
> avoid these issues.

I didn't write a newer version of this patch. What are you talking about?

-- 
tejun
