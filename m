From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: add cpu.stat_percpu
Date: Tue, 11 Jan 2022 13:49:59 +0100
Message-ID: <Yd189wHB2LJcK1Pv@hirez.programming.kicks-ass.net>
References: <20220107234138.1765668-1-joshdon@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=W5BA8bVjbfO+zVPSB0b1V93TDMPABwb7zzlwyo/Fyu8=; b=iiIkc3leMxv70UeLMw0yGiGQs7
        E6r0A3ny4GRM6CVlsCg4uoCJnMk0HUJoz+PJ667IPpG46j2VMzjtdt08X3TFwORiaQHC4zvBHBW0C
        95EGXjc0HpgtJEllAruGRUEEN8uSCpyOJp6/UxyE8FG94ihqw2igLi2ioIuEl9H8JM1thv5rPA3k+
        H5/NduHj6i80KbHiAZQ4EO1zmrpBDOS/kbYnDlYqHkU3I7SsFjqYtbFi2mxfJzMsSZJnMwqqPei+A
        JEOc/c10EFQ47KzJJEhpmeggCRzVmh1cT/uTb77yKbMxeMJWjORA/j3rKHpzy8kkFLZts5gfE96Ez
        f9FHI8OA==;
Content-Disposition: inline
In-Reply-To: <20220107234138.1765668-1-joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jan 07, 2022 at 03:41:37PM -0800, Josh Don wrote:

> +	seq_puts(seq, "usage_usec");
> +	for_each_possible_cpu(cpu) {
> +		cached_bstat = per_cpu_ptr(&cached_percpu_stats, cpu);
> +		val = cached_bstat->cputime.sum_exec_runtime;
> +		do_div(val, NSEC_PER_USEC);
> +		seq_printf(seq, " %llu", val);
> +	}
> +	seq_puts(seq, "\n");
> +
> +	seq_puts(seq, "user_usec");
> +	for_each_possible_cpu(cpu) {
> +		cached_bstat = per_cpu_ptr(&cached_percpu_stats, cpu);
> +		val = cached_bstat->cputime.utime;
> +		do_div(val, NSEC_PER_USEC);
> +		seq_printf(seq, " %llu", val);
> +	}
> +	seq_puts(seq, "\n");
> +
> +	seq_puts(seq, "system_usec");
> +	for_each_possible_cpu(cpu) {
> +		cached_bstat = per_cpu_ptr(&cached_percpu_stats, cpu);
> +		val = cached_bstat->cputime.stime;
> +		do_div(val, NSEC_PER_USEC);
> +		seq_printf(seq, " %llu", val);
> +	}
> +	seq_puts(seq, "\n");

This is an anti-pattern; given enough CPUs (easy) this will trivially
overflow the 1 page seq buffer.

People are already struggling to fix existing ABI, lets not make the
problem worse.
