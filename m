From: Abel Wu <wuyun.abel@bytedance.com>
Subject: Re: [PATCH 2/3] cgroup/cpuset: introduce cpuset.mems.migration
Date: Wed, 28 Apr 2021 15:24:42 +0800
Message-ID: <67632345-9c30-9e87-f9b2-ba4e18b5ae91@bytedance.com>
References: <20210426065946.40491-1-wuyun.abel@bytedance.com>
 <20210426065946.40491-3-wuyun.abel@bytedance.com>
 <YIgjE6CgU4nDsJiR@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ocOiwhnINfr+vKnvSHIfg9Nbg66LG1Qzz5IHcV/tGpI=;
        b=eVN+NK23/ESRrBYM2lxx0JJdpsKDZ22tgKcqU4ZQ5DFwQMOPQ935OCwLL4eRBcpt6b
         HxY//w+DZIIaMWpUPH0oGLw+/OhMrGPu2xNL9RubfJ+do06n4Pr9hmubQyF6wksegxHI
         SzBNqNn/9rVxc0B+YiHhTFWCvQRyGNvaPm3/R6+1Lx6QOsEQzQyUP9Ix1O5XFrv8+59a
         DV+QdW1aWQ/po8Y377Yl3+PbWy8EY3IQEC6z7wh5BB55uwIDQW/lbzaZGc3kjFBRLTJE
         SZoq9XsQy7+XmDFdzb/xmHW04Iu8A410Ai1Fq4A4ST8qN2msmz6C+2phGOV76KgvnIaR
         nBZQ==
In-Reply-To: <YIgjE6CgU4nDsJiR@slm.duckdns.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Hello Tejun, thanks for your review,

On 4/27/21 10:43 PM, Tejun Heo wrote:
> Hello,
>=20
> On Mon, Apr 26, 2021 at 02:59:45PM +0800, Abel Wu wrote:
>> When a NUMA node is assigned to numa-service, the workload
>> on that node needs to be moved away fast and complete. The
>> main aspects we cared about on the eviction are as follows:
>>
>> a) it should complete soon enough so that numa-services
>>     won=E2=80=99t wait too long to hurt user experience
>> b) the workloads to be evicted could have massive usage on
>>     memory, and migrating such amount of memory may lead to
>>     a sudden severe performance drop lasting tens of seconds
>>     that some certain workloads may not afford
>> c) the impact of the eviction should be limited within the
>>     source and destination nodes
>> d) cgroup interface is preferred
>>
>> So we come to a thought that:
>>
>> 1) fire up numa-services without waiting for memory migration
>> 2) memory migration can be done asynchronously by using spare
>>     memory bandwidth
>>
>> AutoNUMA seems to be a solution, but its scope is global which
>> violates c&d. And cpuset.memory_migrate performs in a synchronous
>=20
> I don't think d) in itself is a valid requirement. How does it violate c)?
Yes, d) is more like a preference, since we operate in cgroup level.
Process/thread level interfaces are also acceptable.
AutoNUMA violates c) in its global effect that not only the source
and destination nodes, the processes running on other nodes would
also suffer from unwanted overhead due to numa faults.
And besides the global effect, one-shot mode migration is expected
in this scenario, like cpuset.memory_migrate, rather than autonuma's
periodic behavior.
>=20
>> fashion which breaks a&b. So a mixture of them, the new cgroup2
>> interface cpuset.mems.migration, is introduced.
>>
>> The new cpuset.mems.migration supports three modes:
>>
>>   - "none" mode, meaning migration disabled
>>   - "sync" mode, which is exactly the same as the cgroup v1
>>     interface cpuset.memory_migrate
>>   - "lazy" mode, when walking through all the pages, unlike
>>     cpuset.memory_migrate, it only sets pages to protnone,
>>     and numa faults triggered by later touch will handle the
>>     movement.
>=20
> cpuset is already involved in NUMA allocation but it always felt like
> something bolted on - it's weird to have cpu to NUMA node settings at glo=
bal
> level and then to have possibly conflicting direct NUMA configuration via
> cpuset. My preference would be putting as much configuration as possible =
on
> the mm / autonuma side and let cpuset's node confinements further restrict
> their operations rather than cpuset having its own set of policy
> configurations.
Such conflicting configuration exists in our system in order to
reduce TCO, and yet we haven't found a proper way to get rid of
it. Say a numa-service occupies the whole memory of a node but
still leave some cpus free. The free cpus may be assigned to some
services, the ones that are not memory latency sensitive and are
forbidden to use local memory. Thoughts?

Thanks,
	Abel
>=20
> Johannes, what are your thoughts?
>=20
> Thanks.
>=20
