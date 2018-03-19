From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v5 1/2] cpuset: Enable cpuset controller in default
 hierarchy
Date: Mon, 19 Mar 2018 08:59:37 -0700
Message-ID: <20180319155937.GQ2943022@devbig577.frc2.facebook.com>
References: <1521148842-15486-1-git-send-email-longman@redhat.com>
 <1521148842-15486-2-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AriMpbPmhFykEuV9cKv6WH/lAYzTqQXMm/EzcTM+nb0=;
        b=bLQsGZWN+/V6Z5tEBi9Hm9KrE6r/H14bP2eOIOGL6FvBIX5wpnDA62ntZhOQAqJanZ
         EPnWTeZYVwZNWaDNGUr6kYffX870XYKTnlQK4q/orgOv+zuJiDrBX+osiWiHyGhcqywU
         QSt8XPKJNfe8DyKRS5gugovF/s45T09QnzhxBt1fkOQWGCwz8tbmvC+c8JBlAc6oXhaM
         zCItuMqLsK6IeXlDSJdYolrJm9dBrvv8LPRFwhvhZxpyiF9uUhrnWDGa2LKUqqfOB0zC
         GZDJ+EYFVhkvlT1YzyxgYhDnmlCAQKuuCyOuKvhmyPkC/09wQnT/oHM07oWUDZw23fzN
         HiMg==
Content-Disposition: inline
In-Reply-To: <1521148842-15486-2-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

Hello, Waiman.

This looks great.  A couple nitpicks below.

> +     5-3. Cpuset
> +       5.3-1. Cpuset Interface Files

Can we put cpuset below pid?  It feels weird to break up cpu, memory
and io as they represent the three major resources and are in a
similar fashion.

> +  cpuset.effective_cpus
> +	A read-only multiple values file which exists on non-root
> +	cgroups.
> +
> +	It lists the onlined CPUs that are actually allowed to be
> +	used by tasks within the current cgroup. It is a subset of
> +	"cpuset.cpus".  Its value will be affected by CPU hotplug
> +	events.

Can we do cpuset.cpus.availble which lists the cpus available to the
cgroup instead of the eventual computed mask for the cgroup?  That'd
be more useful as it doesn't lose the information by and'ing what's
available with the cgroup's mask and it's trivial to determine the
effective from the two masks.

> +  cpuset.effective_mems
> +	A read-only multiple values file which exists on non-root
> +	cgroups.
> +
> +	It lists the onlined memory nodes that are actually allowed
> +	to be used by tasks within the current cgroup.  It is a subset
> +	of "cpuset.mems".  Its value will be affected by memory nodes
> +	hotplug events.

Ditto.

> +static struct cftype dfl_files[] = {
> +	{
> +		.name = "cpus",
> +		.seq_show = cpuset_common_seq_show,
> +		.write = cpuset_write_resmask,
> +		.max_write_len = (100U + 6 * NR_CPUS),
> +		.private = FILE_CPULIST,
> +	},

Is it missing CFTYPE_NOT_ON_ROOT?  Other files too.

Thanks.

-- 
tejun
