From: Waiman Long <longman@redhat.com>
Subject: Re: [RFC PATCH 0/5] cgroup/cpuset: A new "isolcpus" paritition
Date: Wed, 12 Apr 2023 16:33:29 -0400
Message-ID: <e38f72aa-9705-cf0c-a565-fb790f16c53e@redhat.com>
References: <20230412153758.3088111-1-longman@redhat.com>
 <ZDcGVebCpyktxyWh@slm.duckdns.org>
 <1ce6a073-e573-0c32-c3d8-f67f3d389a28@redhat.com>
 <ZDcS_yVCgh6g1LoM@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681331612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KF6ZGxBbkIfjD9DhMutgQoIKoNocc290sfEndcP1qNU=;
        b=JKotMA0carq9nAyhIvHRVarJiYktUV2YG+bumf6+C1iEv8GZbbbeWcSPyssioD9XUAwdjw
        zrOQ8U4bF6ebjRhoINyrg9QrTBsRL7GL816WVB14EfGajq8M498JM14emuUIP6apOSTNIe
        y4+6zH0plZvMLho4R4fdPyzUK7pY+fs=
Content-Language: en-US
In-Reply-To: <ZDcS_yVCgh6g1LoM@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>

On 4/12/23 16:22, Tejun Heo wrote:
> Hello, Waiman.
>
> On Wed, Apr 12, 2023 at 03:52:36PM -0400, Waiman Long wrote:
>> There is still a distribution hierarchy as the list of isolation CPUs have
>> to be distributed down to the target cgroup through the hierarchy. For
>> example,
>>
>> cgroup root
>>    +- isolcpus  (cpus 8,9; isolcpus)
>>    +- user.slice (cpus 1-9; ecpus 1-7; member)
>>       +- user-x.slice (cpus 8,9; ecpus 8,9; isolated)
>>       +- user-y.slice (cpus 1,2; ecpus 1,2; member)
>>
>> OTOH, I do agree that this can be somewhat hacky. That is why I post it as a
>> RFC to solicit feedback.
> Wouldn't it be possible to make it hierarchical by adding another cpumask to
> cpuset which lists the cpus which are allowed in the hierarchy but not used
> unless claimed by an isolated domain?

I think we can. You mean having a new "cpuset.cpus.isolated" cgroupfs 
file. So there will be one in the root cgroup that defines all the 
isolated CPUs one can have. It is then distributed down the hierarchy 
and can be claimed only if a cgroup becomes an "isolated" partition. 
There will be a slight change in the semantics of an "isolated" 
partition, but I doubt there will be much users out there.

If you are OK with this approach, I can modify my patch series to do that.

Cheers,
Longman

