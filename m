From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/2] cgroups: add an nproc subsystem
Date: Mon, 9 Mar 2015 09:49:45 +0800
Message-ID: <54FCFC39.6050900@huawei.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com> <1425010639-16492-1-git-send-email-cyphar@cyphar.com> <1425010639-16492-3-git-send-email-cyphar@cyphar.com> <20150302152205.GC17694@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150302152205.GC17694-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Tejun,

On 2015/3/2 23:22, Tejun Heo wrote:
> Hello,
> 
> On Fri, Feb 27, 2015 at 03:17:19PM +1100, Aleksa Sarai wrote:
>> +config CGROUP_NPROC
>> +	bool "Process number limiting on cgroups"
>> +	depends on PAGE_COUNTER
>> +	help
>> +	  This options enables the setting of process number limits in the scope
>> +	  of a cgroup. Any attempt to fork more processes than is allowed in the
>> +	  cgroup will fail. This allows for more basic resource limitation that
>> +	  applies to a cgroup, similar to RLIMIT_NPROC (except that instead of
>> +	  applying to a process tree it applies to a cgroup).
> 
> Please reflect the rationale from this discussion thread in the commit
> message and help text.  Also, I'd much prefer to name it pids
> controller after the resource it's controlling.
> 

Seems we are going to accept this feature. Is it because kmemcg won't be able
to fullfill this requirement? And that's because kmemcg can only and will only
be able to control global kernel memory usage? 

I thought there will be some control file like kmem.pids.max, which will
translate the number of processes to the kernel memory needed, and fail memory
allocation if we reach the limit, for example make task_struct slab return
NULL.
