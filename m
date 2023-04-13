From: Waiman Long <longman@redhat.com>
Subject: Re: [RFC PATCH 0/5] cgroup/cpuset: A new "isolcpus" paritition
Date: Wed, 12 Apr 2023 21:55:46 -0400
Message-ID: <9862da55-5f41-24c3-f3bb-4045ccf24b2e@redhat.com>
References: <20230412153758.3088111-1-longman@redhat.com>
 <ZDcGVebCpyktxyWh@slm.duckdns.org>
 <1ce6a073-e573-0c32-c3d8-f67f3d389a28@redhat.com>
 <ZDcS_yVCgh6g1LoM@slm.duckdns.org>
 <e38f72aa-9705-cf0c-a565-fb790f16c53e@redhat.com>
 <ZDdG1K0kTETZMTCu@slm.duckdns.org>
 <cd4c3f92-4a01-e636-7390-8c6a3d0cfe6c@redhat.com>
 <ZDdNy2NAfj2_1CbW@slm.duckdns.org>
 <1b8d9128-d076-7d37-767d-11d6af314662@redhat.com>
 <ZDdYOI9LB87ra2t_@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681350951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QUAJoa4WsPFgOaywimIxgJmb0m1Gj0LU/rbMc/oiFgM=;
        b=WU229dn6x1HEQ+Cy6vOF9aqrodquqVtFR7dG0QYtHGlK2nmpoK0FjHDoBR2BKVDPu3tfwT
        +PspGC8+YEFsx6cNb1shDKuQ/QvVIbvldty1C9KXoGz5V1UW5uWan1yFCKtpOCRYijmr8E
        0yHNvRbOXXt815Wu6ibutrs4McY/pGk=
Content-Language: en-US
In-Reply-To: <ZDdYOI9LB87ra2t_@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>

On 4/12/23 21:17, Tejun Heo wrote:
> Hello, Waiman.
>
> On Wed, Apr 12, 2023 at 08:55:55PM -0400, Waiman Long wrote:
>>> Sounds a bit contrived. Does it need to be something defined in the root
>>> cgroup?
>> Yes, because we need to take away the isolated CPUs from the effective cpus
>> of the root cgroup. So it needs to start from the root. That is also why we
>> have the partition rule that the parent of a partition has to be a partition
>> root itself. With the new scheme, we don't need a special cgroup to hold the
> I'm following. The root is already a partition root and the cgroupfs control
> knobs are owned by the parent, so the root cgroup would own the first level
> cgroups' cpuset.cpus.reserve knobs. If the root cgroup wants to assign some
> CPUs exclusively to a first level cgroup, it can then set that cgroup's
> reserve knob accordingly (or maybe the better name is
> cpuset.cpus.exclusive), which will take those CPUs out of the root cgroup's
> partition and give them to the first level cgroup. The first level cgroup
> then is free to do whatever with those CPUs that now belong exclusively to
> the cgroup subtree.

I am OK with the cpuset.cpus.reserve name, but not that much with the 
cpuset.cpus.exclusive name as it can get confused with cgroup v1's 
cpuset.cpu_exclusive. Of course, I prefer the cpuset.cpus.isolated name 
a bit more. Once an isolated CPU gets used in an isolated partition, it 
is exclusive and it can't be used in another isolated partition.

Since we will allow users to set cpuset.cpus.reserve to whatever value 
they want. The distribution of isolated CPUs is only valid if the cpus 
are present in its parent's cpuset.cpus.reserve and all the way up to 
the root. It is a bit expensive, but it should be a relatively rare 
operation.

>
>> isolated CPUs. The new root cgroup file will be enough to inform the system
>> what CPUs will have to be isolated.
>>
>> My current thinking is that the root's "cpuset.cpus.isolated" will start
>> with whatever have been set in the "isolcpus" or "nohz_full" boot command
>> line and can be extended from there but not shrank below that as there can
>> be additional isolation attributes with those isolated CPUs.
> I'm not sure we wanna tie with those automatically. I think it'd be
> confusing than helpful.

Yes, I am fine with taking this off for now.

Cheers,
Longman

