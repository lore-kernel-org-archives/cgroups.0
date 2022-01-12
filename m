From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 3/3] sched/core: Force idle accounting per cgroup
Date: Wed, 12 Jan 2022 10:42:22 -1000
Message-ID: <Yd89Lv3VuaaFVm4h@slm.duckdns.org>
References: <1641894961-9241-1-git-send-email-CruzZhao@linux.alibaba.com>
 <1641894961-9241-4-git-send-email-CruzZhao@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HO7qMaYrtwZh1fXZ2JialerphvW3Ld7mXY4ozQ74kp8=;
        b=T//gm9B2hHMRxudRJ5GrIEq6vQlBYHNIMACX99yWLgykrZKNX5UGa2PRk/IKsheR9g
         SWsPtR+wGtZy0Blm7u2k70b9UNWVcT/RT09nQceitwss3Y5RfmnBn6zAjT7l60cTCdXt
         iZQrIaOMIfkVahpM0KMcnLkUCH5L+MTWJZMExT952E4p5H3TMJIEzmpAYFQgCLChvT+z
         KgOhRQ+jgbOZe3oAFhAcNabmstwsLyXc5p1cyFMrEsK4i1iYf4DUxdzvsHp03iqY0jG4
         OucI73fRpoq/TsjOvrQBp6OGrF4X+l4m5tzLK6hHSeqkuXV2AWYjJRZLrmeGcWRZz98E
         JINA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1641894961-9241-4-git-send-email-CruzZhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Cruz Zhao <CruzZhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, Jan 11, 2022 at 05:56:01PM +0800, Cruz Zhao wrote:
> +#ifdef CONFIG_SCHED_CORE
> +void cpuacct_account_forceidle(int cpu, struct task_struct *tsk, u64 cputime)
> +{
> +	struct cpuacct *ca;
> +	u64 *fi;
> +
> +	rcu_read_lock();
> +	/*
> +	 * We have hold rq->core->__lock here, which protects ca->forceidle
> +	 * percpu.
> +	 */
> +	for (ca = task_ca(tsk); ca; ca = parent_ca(ca)) {
> +		fi = per_cpu_ptr(ca->forceidle, cpu);
> +		*fi += cputime;
> +	}

Please don't do this. Use rstat and integrate it with other stats.

Thanks.

-- 
tejun
