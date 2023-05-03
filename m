From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 5/6] sched/deadline: Create DL BW alloc, free & check
 overflow interface
Date: Wed, 3 May 2023 13:45:24 -0400
Message-ID: <5a64fdd5-ee1a-7609-99a9-a8d1e282e393@redhat.com>
References: <20230503072228.115707-1-juri.lelli@redhat.com>
 <20230503072228.115707-6-juri.lelli@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683135930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i+1daImuCgAFQ62zz1n0R8N9/43jAwavxjwtDs1QPpw=;
        b=M41QegfpV+70HZ4DUbNQqfbYVju4PefYqYGauOZybahXoWlyYzdtHoBr44/esieFWj+pKo
        BloZvmTb15rdjbNmH/0GP14BG7Us2H1B/uB1E0o1xwwMC2IEwNScsFyx0nyR3rDQckaTLF
        3RH+tDvnkZb0WR+OgYeCzT3nLD/MSzM=
Content-Language: en-US
In-Reply-To: <20230503072228.115707-6-juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>

On 5/3/23 03:22, Juri Lelli wrote:
> From: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>
>
> Rework the existing dl_cpu_busy() interface which offers DL BW overflow
> checking and per-task DL BW allocation.
>
> Add dl_bw_free() as an interface to be able to free DL BW.
> It will be used to allow freeing of the DL BW request done during
> cpuset_can_attach() in case multiple controllers are attached to the
> cgroup next to the cpuset controller and one of the non-cpuset
> can_attach() fails.
>
> dl_bw_alloc() (and dl_bw_free()) now take a `u64 dl_bw` parameter
> instead of `struct task_struct *p` used in dl_cpu_busy().  This allows
> to allocate DL BW for a set of tasks too rater than only for a single

Typo: "rater" => "rather".

Cheers,
Longman


