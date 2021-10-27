From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC] cpuset: Make cpusets get restored on hotplug
Date: Tue, 26 Oct 2021 22:35:35 -0400
Message-ID: <4637ebd4-61ef-5ad6-d2bd-976663f5c4a1@redhat.com>
References: <972a5c1b-6721-ac20-cec5-617af67e617d@redhat.com>
 <20211026235808.34168-1-21cnbao@gmail.com>
 <f795f8be-a184-408a-0b5a-553d26061385@redhat.com>
 <CAGsJ_4wZJyKh+FUsmL8TMaCHofmr9J5UCzk3YYEYckD8ZWZW+w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635302145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZGUktUxKSDawe5cfrBBp7LiAKurPgQ7WEWiThb4tO84=;
        b=AnXggKiMLWnBBVx4FJ8HdZnkvwEG30Cx2DX56eyZ4FbNd7Wvvf/CIytZfCcw6QqXs4tmrx
        duAjVynq+bclCENpQ1UTYpptrhfARrtKPg+8rtjcrGY1132Nt/boQeUwxCfpD2sWhxRjna
        0zfQR4dGv4F2wtHa8+28i8CpbcRzghQ=
In-Reply-To: <CAGsJ_4wZJyKh+FUsmL8TMaCHofmr9J5UCzk3YYEYckD8ZWZW+w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Barry Song <21cnbao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org, jsbarnes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, kerrnel-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, vpillai-tWEdnPwa2b6ifxm/DiOjgA@public.gmane.org

On 10/26/21 10:21 PM, Barry Song wrote:
> On Wed, Oct 27, 2021 at 2:06 PM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>
>> On 10/26/21 7:58 PM, Barry Song wrote:
>>>> I think Tejun is concerned about a change in the default behavior of
>>>> cpuset v1.
>>>>
>>>> There is a special v2 mode for cpuset that is enabled by the mount
>>>> option "cpuset_v2_mode". This causes the cpuset v1 to adopt some of the
>>>> v2 behavior. I introduced this v2 mode a while back to address, I think,
>>>> a similar concern. Could you try that to see if it is able to address
>>>> your problem? If not, you can make some code adjustment within the
>>>> framework of the v2 mode. As long as it is an opt-in, I think we are
>>>> open to further change.
>>> I am also able to reproduce on Ubuntu 21.04 LTS.
>>>
>>> all docker will be put in this cgroups and its child cgroups:
>>> /sys/fs/cgroup/cpuset/docker
>>>
>>> disabling and enabling SMT by:
>>> echo off > /sys/devices/system/cpu/smt/control
>>> echo on > /sys/devices/system/cpu/smt/control
>>>
>>> or unpluging and pluging CPUs by:
>>> echo 0 > /sys/devices/system/cpu/cpuX/online
>>> echo 1 > /sys/devices/system/cpu/cpuX/online
>>>
>>> then all docker images will lose some CPUs.
>>>
>>> So should we document the broken behaviours somewhere?
>> Is the special cpuset_v2_mode mount option able to fix the issue?
>>
>> This mode is documented in
>>
>> Documentation/admin-guide/cgroup-v1/cpuset.rst:
>>
>> The cpuset.effective_cpus and cpuset.effective_mems files are
>> normally read-only copies of cpuset.cpus and cpuset.mems files
>> respectively.  If the cpuset cgroup filesystem is mounted with the
>> special "cpuset_v2_mode" option, the behavior of these files will become
>> similar to the corresponding files in cpuset v2.  In other words, hotplug
>> events will not change cpuset.cpus and cpuset.mems.  Those events will
>> only affect cpuset.effective_cpus and cpuset.effective_mems which show
>> the actual cpus and memory nodes that are currently used by this cpuset.
>> See Documentation/admin-guide/cgroup-v2.rst for more information about
>> cpuset v2 behavior.
>>
>> Maybe we can make it more visible.
> Is it possible to make cpuset_v2_mode true in default? not quite sure if
> it will harm something.

The cpuset_v2_mode is a change in v1 behavior and that is why it is an 
opt-in as we don't want to break existing applications that have a 
dependency on the current v1 behavior. If users switch to use cgroup v2, 
they get the new behavior. Alternately, they can modify the system 
startup script to use the v2 behavior by using the mount option. I don't 
think we are going to change the v1 default behavior.

Cheers,
Longman

