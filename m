From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 8/9] cgroup/cpuset: Documentation update for partition
Date: Mon, 10 Jul 2023 11:30:12 -1000
Message-ID: <ZKx4ZJowRhRtjZxB@slm.duckdns.org>
References: <20230627143508.1576882-1-longman@redhat.com>
 <20230627143508.1576882-9-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689024614; x=1691616614;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EuY7YWF+Kh1UKEuVmzs1ImB1X2StsWyaHb8EJ2edbSU=;
        b=b3unhp+1fEq1qyFirSnAUKqpNzuFjhYYSuty9IalbkDlKvc7XoIUkCzsQX53+qqMso
         NwXyfA1g9Xij5ua20EZYWee/MO0shqL3wMkRZAmF3/qpeczM4vPXnasiWO7nmM4zPbpr
         0hXqvIK9ovnj6bBskOJYe09WNUA7ZqVrWMXhlSpXhpAhs0U/uUmVhjPB3K5UT9VZvAox
         7vtXOPRSOOHV8Ak+7M8NJNupp2LhUxzIWpQk6ViFHF13n0NiADBRyjZyT1Y1TJstujDg
         qypPLEV3FJqR1rVskyvFRj9wLqdVoPTFtB/kSQLbNmTPRoK8nmjff2VZGWr2tnc4YlPm
         3/2A==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230627143508.1576882-9-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Mrunal Patel <mpatel@redhat.com>, Ryan Phillips <rphillips@redhat.com>, Brent Rowsell <browsell@redhat.com>, Peter Hunt <pehunt@redhat.com>, Phil Auld <pauld@redhat.com>

Hello,

On Tue, Jun 27, 2023 at 10:35:07AM -0400, Waiman Long wrote:
...
> +	There are two types of partitions - local and remote.  A local
> +	partition is one whose parent cgroup is also a valid partition
> +	root.  A remote partition is one whose parent cgroup is not a
> +	valid partition root itself.  Writing to "cpuset.cpus.exclusive"
> +	is not mandatory for the creation of a local partition as its
> +	"cpuset.cpus.exclusive" file will be filled in automatically if
> +	it is not set.	The automaticaly set value will be based on its
> +	"cpuset.cpus" value.  Writing the proper "cpuset.cpus.exclusive"
> +	values down the cgroup hierarchy is mandatory for the creation
> +	of a remote partition.

Wouldn't a partition root's cpus.exclusive always contain all of the CPUs in
its cpus? Would it make sense for cpus.exclusive to be different from .cpus?

Thanks.

-- 
tejun
