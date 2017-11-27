From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v3] cpuset: Enable cpuset controller in default hierarchy
Date: Mon, 27 Nov 2017 16:19:57 -0500
Message-ID: <8a5ba419-2b02-5b6a-462f-34106cc575ab@redhat.com>
References: <1507324230-22996-1-git-send-email-longman@redhat.com>
 <20171127210411.GS983427@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171127210411.GS983427@devbig577.frc2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Mike Galbraith <efault@gmx.de>, Christian Brauner <christian.brauner@canonical.com>, =?UTF-8?Q?St=c3=a9phane_Graber?= <stgraber@ubuntu.com>, Serge Hallyn <serge@hallyn.com>

On 11/27/2017 04:04 PM, Tejun Heo wrote:
> Hello, Waiman.
>
> Sorry about the long delay.
>
> On Fri, Oct 06, 2017 at 05:10:30PM -0400, Waiman Long wrote:
>> +Cpuset Interface Files
>> +~~~~~~~~~~~~~~~~~~~~~~
>> +
>> +  cpuset.cpus
>> +	A read-write multiple values file which exists on non-root
>> +	cgroups.
>> +
>> +	It lists the CPUs allowed to be used by tasks within this
>> +	cgroup.  The CPU numbers are comma-separated numbers or
>> +	ranges.  For example:
>> +
>> +	  # cat cpuset.cpus
>> +	  0-4,6,8-10
>> +
>> +	An empty value indicates that the cgroup is using the same
>> +	setting as the nearest cgroup ancestor with a non-empty
>> +	"cpuset.cpus" or all the available CPUs if none is found.
>> +
>> +	The value of "cpuset.cpus" stays constant until the next update
>> +	and won't be affected by any CPU hotplug events.
>> +
>> +  cpuset.effective_cpus
> Can we do cpuset.ecpus in the fashion of euid, egid..?

Sure.
>> +  cpuset.effective_mems
> Ditto.

Sure.

>> +  cpuset.flags
>> +	A read-write multiple values file which exists on non-root
>> +	cgroups.
>> +
>> +	It lists the flags that are set (with a '+' prefix) and those
>> +	that are not set (with a '-' prefix).	The currently supported
>> +	flag is:
>> +
>> +	  mem_migrate
>> +		When it is not set, an allocated memory page will
>> +		stay in whatever node it was allocated independent
>> +		of changes in "cpuset.mems".
>> +
>> +		When it is set, tasks with memory pages not in
>> +		"cpuset.mems" will have those pages migrated over to
>> +		memory nodes specified in "cpuset.mems".  Any changes
>> +		to "cpuset.mems" will cause pages in nodes that are
>> +		no longer valid to be migrated over to the newly
>> +		valid nodes.
> Let's start just with [e]cpus and [e]mems.  The flags interface looks
> fine but the implementations of these features are really bad and
> cgroup2 doesn't migrate resources for other controllers either anyway.

That is added because the mem_migrate feature is used in libvirt, I
think. I am thinking of add a "[EXPERIMENTAL]" tag to the flags to
indicate that it is subject to change.

Cheers,
Longman
