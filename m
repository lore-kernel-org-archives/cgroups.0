From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: Re: [PATCH] doc: cgroup: correct the wrong information about measure
 of memory pressure
Date: Tue, 19 Feb 2019 08:47:02 -0800
Message-ID: <79dc6298-a062-51e0-64d0-9696dc602767@linux.alibaba.com>
References: <1550278564-81540-1-git-send-email-yang.shi@linux.alibaba.com>
 <20190218210504.GT50184@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190218210504.GT50184@devbig004.ftw2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: hannes@cmpxchg.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org



On 2/18/19 1:05 PM, Tejun Heo wrote:
> On Sat, Feb 16, 2019 at 08:56:04AM +0800, Yang Shi wrote:
>> Since PSI has implemented some kind of measure of memory pressure, the
>> statement about lack of such measure is not true anymore.
>>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Jonathan Corbet <corbet@lwn.net>
>> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
>> ---
>>   Documentation/admin-guide/cgroup-v2.rst | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
>> index 7bf3f12..9a92013 100644
>> --- a/Documentation/admin-guide/cgroup-v2.rst
>> +++ b/Documentation/admin-guide/cgroup-v2.rst
>> @@ -1310,8 +1310,7 @@ network to a file can use all available memory but can also operate as
>>   performant with a small amount of memory.  A measure of memory
>>   pressure - how much the workload is being impacted due to lack of
>>   memory - is necessary to determine whether a workload needs more
>> -memory; unfortunately, memory pressure monitoring mechanism isn't
>> -implemented yet.
>> +memory.
> Maybe refer to PSI?

I thought so too, but the above "memory.pressure" has already referred 
to PSI. So, I was not sure if we should duplicate PSI information.

Thanks,
Yang

>
> Thanks.
>

