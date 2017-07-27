From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: add cgroup.stat interface with basic hierarchy
 stats
Date: Thu, 27 Jul 2017 12:22:43 -0400
Message-ID: <20170727162243.GF742618@devbig577.frc2.facebook.com>
References: <20170727161420.2552-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/l4rSKOowHuApLBuEX0cMkBkt1GTJWiMj3hsVkfhCO8=;
        b=qQS99dohkOobWBvq8GaKGAMqUMamTUHS6V1601WsbVhq2NYTLTVyrWvpMXu1houBO6
         XX6I4em7MBQW0HJK3ggh5r064AwRvEsmEx16T7Xp307M7H7EBARPaJYnwvfGrj1Q4aY9
         yRJ5HPPUKrdwwqp45sSUQZjJzThtM3DlCzFMkklNtMwPOWP4YqY6tdHBiMXko1/r7xjg
         DOqwz6YvfoPgmq6Y1RoDzvJl7ID8EWnhFHK2Eh8gEnGml0K8HtFf+afHrlirjwSknf11
         E7rrROeFf6PkJQaM4+HYV67xXeGgz4KXgdlT4Ut+ouN0Rdxu+dYPyQbXwXlvgU9uxGO7
         6veA==
Content-Disposition: inline
In-Reply-To: <20170727161420.2552-1-guro@fb.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: cgroups@vger.kernel.org, Zefan Li <lizefan@huawei.com>, Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, kernel-team@fb.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Thu, Jul 27, 2017 at 05:14:20PM +0100, Roman Gushchin wrote:
> Add a cgroup.stat interface to the base cgroup control files
> with the following metrics:
> 
> nr_descendants		total number of descendant cgroups
> nr_dying_descendants	total number of dying descendant cgroups
> max_descendant_depth	maximum descent depth below the current cgroup

Yeah, this'd be great to have.  Some comments below.

> +  cgroup.stat
> +	A read-only flat-keyed file with the following entries:
> +
> +	  nr_descendants
> +		Total number of descendant cgroups.
> +
> +	  nr_dying_descendants
> +		Total number of dying descendant cgroups.

Can you please go into more detail on what's going on with dying
descendants here?

> +static int cgroup_stats_show(struct seq_file *seq, void *v)
> +{
> +	struct cgroup_subsys_state *css;
> +	unsigned long total = 0;
> +	unsigned long offline = 0;
> +	int max_level = 0;
> +
> +	rcu_read_lock();
> +	css_for_each_descendant_pre(css, seq_css(seq)) {
> +		if (css == seq_css(seq))
> +			continue;
> +		++total;

Let's do post increment for consistency.

> +		if (!(css->flags & CSS_ONLINE))
> +			++offline;
> +		if (css->cgroup->level > max_level)
> +			max_level = css->cgroup->level;
> +	}
> +	rcu_read_unlock();

I wonder whether we want to keep these counters in sync instead of
trying to gather the number on read.  Walking all descendants can get
expensive pretty quickly and things like nr_descendants will be useful
for other purposes too.

Thanks.

-- 
tejun
