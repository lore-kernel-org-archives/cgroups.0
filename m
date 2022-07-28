From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup/cpuset: Keep current cpus list if cpus
 affinity was explicitly set
Date: Thu, 28 Jul 2022 17:23:55 +0200
Message-ID: <20220728152355.GB25894@blackbody.suse.cz>
References: <20220728005815.1715522-1-longman@redhat.com>
 <20220728144420.GA27407@blackbody.suse.cz>
 <a58852b4-313a-9271-f31d-f79a91ec188b@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1659021837; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SRF9MyYDxSMz1004MAxo6xxMYmTRoIn6prKJRfvdun8=;
        b=Q1KNd85cVzSSFmi42M5onWHVuxuR4JxQDTShGHvzT1UF7YE5YJzw5A621cajhDejtlunGg
        cF3/xOafEk+snEKjU50p1two9rp8NCu6vZNHWEk4ViJjp6+mM/vvZjVfLrpXYqEsSJgAXV
        9/tOOOmYkta+W2r/j5AnczQdehm85hc=
Content-Disposition: inline
In-Reply-To: <a58852b4-313a-9271-f31d-f79a91ec188b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jul 28, 2022 at 10:59:01AM -0400, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Cgroup v1 doesn't have this problem.

v1 analogy would be:

	echo 2-3 >$dst/cpuset.cpus
	# job runs in $dst
	# one task T in $dst sets affinity just to one cpu
	# I rethink my config, I want to allow $dst more space
	echo 2-5 >$dst/cpuset.cpus

Most tasks in $dst happily utilize the new cpus but it breaks affinity
for T -- this must have been broken since ever.

(Or I'd argue that per-thread affinities are just recommendations, if I
have a task for nohz CPU, I should enforce its placement with cpuset
from the beginning.)

Michal
