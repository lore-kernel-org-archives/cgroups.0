From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 5/6] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Wed, 11 Aug 2021 08:15:39 -1000
Message-ID: <YRQTy7eo5jOlHTc6@slm.duckdns.org>
References: <20210811030607.13824-1-longman@redhat.com>
 <20210811030607.13824-6-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ym/H6d8WW77SzOZbzzokiM0xg1UPIyiB60qBZGBJt7Y=;
        b=RnEVMsbaVXQl/0zBT1Pq4JA9Akvg664fiiU+SEcDZs6yqp8ZR2/NqgItGTwqC819y8
         zDra0nlCGVmzZTiP159TqJSrdPBdaIykcQ4E/s6RciOVsfc53jD3fq2xgQ7V38AOpck5
         FrZrL2VtgBhRaGiinA1ZlkiQ0PsQftoXTyf+Sjkz7kercQyhq6LsA4OGP/Xsm3YRsevJ
         07RXQ6BQxfga8qV82P97on+PcbzYNsB7c3y3eGthDxlz+w4Euqu9LlQ7I9azElNw3avS
         2enI75z+wQDqdpnwZZwWRHmUKj68vP7LMV/V6Z5+njWj6sPDqUxhHDR5jfJwYTk090Jd
         yi8w==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210811030607.13824-6-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>

Hello,

On Tue, Aug 10, 2021 at 11:06:06PM -0400, Waiman Long wrote:
> +	Poll and inotify events are triggered whenever the state
> +	of "cpuset.cpus.partition" changes.  That includes changes
> +	caused by write to "cpuset.cpus.partition" and cpu hotplug.
> +	This will allow a user space agent to monitor changes caused
> +	by hotplug events.

It might be useful to emphasize that this is the primary mechanism to
signify errors and thus should always be monitored.

Thanks.

-- 
tejun
