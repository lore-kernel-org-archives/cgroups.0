From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v10 6/9] sched/fair: Add sched group latency support
Date: Tue, 21 Feb 2023 16:01:22 +0100
Message-ID: <Y/TcwkmiVXJmQ9nw@hirez.programming.kicks-ass.net>
References: <20230113141234.260128-1-vincent.guittot@linaro.org>
 <20230113141234.260128-7-vincent.guittot@linaro.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bCEktfZQBYOidtJzxUm4n6P8jzrl5z+36FM412yPsqs=; b=JDpD0PpWH3pnX8EYDtfDPUDLIy
        S10rBhUk23wKDrJcvT4gwTBjEdQTEO8uKioDDQMoHCwBLn3wlR476k9xVsrPQKWksABn/2jpJ7R4w
        aPbh/wOeH17i+dXF6Adx64cKbCrkz18407TYKbZn7U8vkTXkOtqi374xKlqiF0ra5RjDIbuSPOM70
        6DelKoWS68hL6HpdwmIstsS/hXfpR8N301EpkJ++hWFXgZztyyV9tvQ4ILrVoPRAjwLvYIeKBwW9R
        kVnvhJmGZU1oAwH9+P+00TX9twcvYMbmkfzBR6yZ+6ulIy60wp/Q7BKKcereIOrFkKYtQnv0mPFD+
        zyRULY4A==;
Content-Disposition: inline
In-Reply-To: <20230113141234.260128-7-vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, parth-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org, chris.hyser-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, patrick.bellasi-X6neQFFVdzGsTnJN9+BGXg@public.gmane.org, David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, timj-mXXj517/zsQ@public.gmane.org, kprateek.nayak-5C7GfCeVMHo@public.gmane.org, yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, youssefesmat-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org

On Fri, Jan 13, 2023 at 03:12:31PM +0100, Vincent Guittot wrote:

> +static s64 cpu_latency_nice_read_s64(struct cgroup_subsys_state *css,
> +				    struct cftype *cft)
> +{
> +	int prio, delta, last_delta = INT_MAX;
> +	s64 weight;
> +
> +	weight = css_tg(css)->latency_offset * NICE_LATENCY_WEIGHT_MAX;
> +	weight = div_s64(weight, get_sleep_latency(false));
> +
> +	/* Find the closest nice value to the current weight */

This comment isn't entirely accurate, since we only have the nice_write
interface below, this will be an exact match. The thing with weight is
that we first had the raw weight value interface and then the nice
interface had to map random values back to a 'nice' value.

Arguably we can simply store the raw nice value in write and print it
out again here.

> +	for (prio = 0; prio < ARRAY_SIZE(sched_latency_to_weight); prio++) {
> +		delta = abs(sched_latency_to_weight[prio] - weight);
> +		if (delta >= last_delta)
> +			break;
> +		last_delta = delta;
> +	}
> +
> +	return LATENCY_TO_NICE(prio-1);
> +}
> +
> +static int cpu_latency_nice_write_s64(struct cgroup_subsys_state *css,
> +				     struct cftype *cft, s64 nice)
> +{
> +	s64 latency_offset;
> +	long weight;
> +	int idx;
> +
> +	if (nice < MIN_LATENCY_NICE || nice > MAX_LATENCY_NICE)
> +		return -ERANGE;
> +
> +	idx = NICE_TO_LATENCY(nice);
> +	idx = array_index_nospec(idx, LATENCY_NICE_WIDTH);
> +	weight = sched_latency_to_weight[idx];
> +
> +	latency_offset = weight * get_sleep_latency(false);
> +	latency_offset = div_s64(latency_offset, NICE_LATENCY_WEIGHT_MAX);
> +
> +	return sched_group_set_latency(css_tg(css), latency_offset);
> +}
