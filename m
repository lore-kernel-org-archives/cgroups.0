From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v11 7/8] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Sun, 12 Jun 2022 07:49:55 -1000
Message-ID: <YqYnQ4U4t6j/3UaL@slm.duckdns.org>
References: <20220510153413.400020-1-longman@redhat.com>
 <20220510153413.400020-8-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cX/8ziMeK45ox+UcvZwAkANNXl3ViVJCTAY7BoIDC9g=;
        b=ZNHpDRCIVg04yWKFQl5Us2As61s+pXeR4lsY92xVrDkk6imXnuwyuIisMOGvIeIGxd
         UvUQVa4cGrHsfK+hrkzKtoYgoFEOSIxRsMURxjDSRjGACqfWn7/dvweFPJsMOkrPBRpR
         iA5XsNAId11fOFa4E2cR+sKI30/M/jtzbtHiYNrYgi9ZhzrWPAyQdnFgV5ZMdLVoLnwa
         FDDQgbhlu8/E64e1QdJtdDKu4xmWBiHVWN7oTvvkD7FBAGPnbKjZ77qy09wvbncWw1rH
         W4PWLjJkm1uMXK8esCcS1J5utUQ1jjSpSeAhAj8FyImJCUY97wQRjpr9Xw6bHfpGujvB
         h1jQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220510153413.400020-8-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>

Hello,

On Tue, May 10, 2022 at 11:34:12AM -0400, Waiman Long wrote:
> +	External events like hotplug or changes to "cpuset.cpus" can
> +	cause a valid partition root to become invalid and vice versa.
> +	Note that a task cannot be moved to a cgroup with empty
> +	"cpuset.cpus.effective".
> +
> +	For a valid partition root or an invalid partition root with
> +	the exclusivity rule enabled, changes made to "cpuset.cpus"
> +	that violate the exclusivity rule will not be allowed.

My memory is failing but this is the same thing that we were discussing
before, right? The point was that the different behaviors re. system events
and config actions seemed unncessary and IIRC Michal was of the same opinion
(please correct me if I'm misremembering).

> +	A valid non-root parent partition may distribute out all its CPUs
> +	to its child partitions when there is no task associated with it.

I'm probably forgetting something. Was this necessary because of threaded
cgroup support because otherwise the above condition is superflous?

Thanks.

-- 
tejun
