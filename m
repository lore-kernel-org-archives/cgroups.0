From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 8/9] cgroup/cpuset: Documentation update for partition
Date: Mon, 10 Jul 2023 20:21:43 -0400
Message-ID: <6d5aee58-f558-868c-76e0-0b58f8332110@redhat.com>
References: <20230627143508.1576882-1-longman@redhat.com>
 <20230627143508.1576882-9-longman@redhat.com>
 <ZKx4ZJowRhRtjZxB@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689034909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3lffsLwd9raQCh04kyVM/H+XhSacCMhW6kPfQWTCBjE=;
        b=QqvpdXlChr2hJa9bGbDD1AfRdDnBRAPEeXjtNP1fxJXB2Pa/3RYcb5pEJqDyNkJeYnOQQ4
        kJz8bW6qDSRTY7NpEr67BFDh4uo+2tyOh+lvcNjpLJaG+4tO8sUkRLjFOCrv/jI5UghS9T
        trPn00pJK3sMCzlYAcB4yt3BhT6PfuI=
Content-Language: en-US
In-Reply-To: <ZKx4ZJowRhRtjZxB-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mrunal Patel <mpatel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ryan Phillips <rphillips-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brent Rowsell <browsell-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Hunt <pehunt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 7/10/23 17:30, Tejun Heo wrote:
> Hello,
>
> On Tue, Jun 27, 2023 at 10:35:07AM -0400, Waiman Long wrote:
> ...
>> +	There are two types of partitions - local and remote.  A local
>> +	partition is one whose parent cgroup is also a valid partition
>> +	root.  A remote partition is one whose parent cgroup is not a
>> +	valid partition root itself.  Writing to "cpuset.cpus.exclusive"
>> +	is not mandatory for the creation of a local partition as its
>> +	"cpuset.cpus.exclusive" file will be filled in automatically if
>> +	it is not set.	The automaticaly set value will be based on its
>> +	"cpuset.cpus" value.  Writing the proper "cpuset.cpus.exclusive"
>> +	values down the cgroup hierarchy is mandatory for the creation
>> +	of a remote partition.
> Wouldn't a partition root's cpus.exclusive always contain all of the CPUs in
> its cpus? Would it make sense for cpus.exclusive to be different from .cpus?
>
> Thanks.

In auto-filled case, it should be the same as cpuset.cpus. I will 
clarify that in the documentation. Thanks for catching that.

Cheers,
Longman

