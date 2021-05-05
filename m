From: Abel Wu <wuyun.abel@bytedance.com>
Subject: Re: [Phishing Risk] [External] Re: [PATCH 2/3] cgroup/cpuset:
 introduce cpuset.mems.migration
Date: Wed, 5 May 2021 13:06:09 +0800
Message-ID: <55582805-5103-96c0-d8e8-e6d0b01beff3@bytedance.com>
References: <20210426065946.40491-1-wuyun.abel@bytedance.com>
 <20210426065946.40491-3-wuyun.abel@bytedance.com>
 <YIgjE6CgU4nDsJiR@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7gpK7P2CpPVVCbVLUyVVTrI01QfMpCG4qxYH2m0q/WY=;
        b=hRMfiR1c8aF8nkaibSuLvPsQ8VyCx/qSncGkzxu18vorhQYjFwpROhAEbXYMCNfquk
         R79aCKblQiB16JvI81QOiFG7hoE+vwWFzuhbV1jcmU/QB6LmQwc8IoHRHHgrHKr1AooE
         osQlLpZYwvRJRTQEWQKzZE0vUJAkPSCwibEEASukSg4xW9ERGzKZ40/yoQH+95owSb6v
         iLEPDrI5blgVJviaQyBNxrHi4u/g5MffBYnIDhQOKoi0ygD8CMEeF9UCIMm87nzMRxHJ
         P8UUlfcrr05jevKCiccoYy4X4FyQ6RYZzLzqVTr8I8qEmKxi4cqZReJU1TEVcBJWusH4
         /VZg==
In-Reply-To: <YIgjE6CgU4nDsJiR@slm.duckdns.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
To: Tejun Heo <tj@kernel.org>, hannes@cmpxchg.org
Cc: akpm@linux-foundation.org, lizefan.x@bytedance.com, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

ping :)

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
>=20
> Johannes, what are your thoughts?
>=20
> Thanks.
>=20
