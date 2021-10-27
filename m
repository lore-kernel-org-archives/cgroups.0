From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC] cpuset: Make cpusets get restored on hotplug
Date: Tue, 26 Oct 2021 21:06:47 -0400
Message-ID: <f795f8be-a184-408a-0b5a-553d26061385@redhat.com>
References: <972a5c1b-6721-ac20-cec5-617af67e617d@redhat.com>
 <20211026235808.34168-1-21cnbao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635296815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d0sd05fNlpWtdgtTRa/aTogQfojInzQIx5Zn8GaYdz8=;
        b=IdvJpgCBPT/Hg8z0rosHQzW7l1Yw6kwunTcI2jJQp4dMki6GJlw4m3Hn3c+zNaWh5rapWI
        GoJxD8gojE8jKScAFEAkpNSF7i40LoSukInC+8s28r6mqpUCry848mloY4so3jD6eiRf6X
        8HuuMtV8CbLN0+MMYJoOi3fKZIpmWnk=
In-Reply-To: <20211026235808.34168-1-21cnbao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Barry Song <21cnbao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org, jsbarnes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, kerrnel-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vpillai-tWEdnPwa2b6ifxm/DiOjgA@public.gmane.org


On 10/26/21 7:58 PM, Barry Song wrote:
>> I think Tejun is concerned about a change in the default behavior of
>> cpuset v1.
>>
>> There is a special v2 mode for cpuset that is enabled by the mount
>> option "cpuset_v2_mode". This causes the cpuset v1 to adopt some of the
>> v2 behavior. I introduced this v2 mode a while back to address, I think,
>> a similar concern. Could you try that to see if it is able to address
>> your problem? If not, you can make some code adjustment within the
>> framework of the v2 mode. As long as it is an opt-in, I think we are
>> open to further change.
> I am also able to reproduce on Ubuntu 21.04 LTS.
>
> all docker will be put in this cgroups and its child cgroups:
> /sys/fs/cgroup/cpuset/docker
>
> disabling and enabling SMT by:
> echo off > /sys/devices/system/cpu/smt/control
> echo on > /sys/devices/system/cpu/smt/control
>
> or unpluging and pluging CPUs by:
> echo 0 > /sys/devices/system/cpu/cpuX/online
> echo 1 > /sys/devices/system/cpu/cpuX/online
>
> then all docker images will lose some CPUs.
>
> So should we document the broken behaviours somewhere?

Is the special cpuset_v2_mode mount option able to fix the issue?

This mode is documented in

Documentation/admin-guide/cgroup-v1/cpuset.rst:

The cpuset.effective_cpus and cpuset.effective_mems files are
normally read-only copies of cpuset.cpus and cpuset.mems files
respectively.  If the cpuset cgroup filesystem is mounted with the
special "cpuset_v2_mode" option, the behavior of these files will become
similar to the corresponding files in cpuset v2.  In other words, hotplug
events will not change cpuset.cpus and cpuset.mems.  Those events will
only affect cpuset.effective_cpus and cpuset.effective_mems which show
the actual cpus and memory nodes that are currently used by this cpuset.
See Documentation/admin-guide/cgroup-v2.rst for more information about
cpuset v2 behavior.

Maybe we can make it more visible.

Cheers,
Longman

