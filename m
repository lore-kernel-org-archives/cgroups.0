From: Waiman Long <llong@redhat.com>
Subject: Re: [PATCH 4/4] driver core: Allow showing cpu as offline if not
 valid in cpuset context
Date: Mon, 14 Jun 2021 12:32:01 -0400
Message-ID: <ad33a662-7ebe-fb92-4459-5dd85a013501@redhat.com>
References: <20210614152306.25668-1-longman@redhat.com>
 <20210614152306.25668-5-longman@redhat.com> <YMd7PEU0KPulsgMz@kroah.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623688326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DISslyfLGhpMa3WyA2T18Pg0TsQiGkTpC7aVUBeR5IM=;
        b=dKdMLoGjSmR0Adm2DSdyJzQunyIysRnhLtepuL5cTxScG8+oLBSRGTLyT+BETCy4AyPz2A
        e28RS67c0CX9WwHr4a/YTTpzHqBhVOhtIZ4+scF05Ori91iXsxWDLQ7oT8TaL7VpyvC5Eq
        E7B7FSy2fprVtDv+u6x4G5CwdaIe8tE=
In-Reply-To: <YMd7PEU0KPulsgMz@kroah.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Iurii Zaikin <yzaikin@google.com>, x86@kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org

On 6/14/21 11:52 AM, Greg KH wrote:
> On Mon, Jun 14, 2021 at 11:23:06AM -0400, Waiman Long wrote:
>> Make /sys/devices/system/cpu/cpu<n>/online file to show a cpu as
>> offline if it is not a valid cpu in a proper cpuset context when the
>> cpuset_bound_cpuinfo sysctl parameter is turned on.
> This says _what_ you are doing, but I do not understand _why_ you want
> to do this.
>
> What is going to use this information?  And now you are showing more
> files than you previously did, so what userspace tool is now going to
> break?

One reason that is provided by the customer asking for this 
functionality is because some applications use the number of cpu cores 
for licensing purpose. Even though the applications are running in a 
container with a smaller set of cpus, they may still charge as if all 
the cpus are available. They ended up using a bind mount to mount over 
the cpuX/online file.

I should have included this information in the patchset.


>
>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   drivers/base/core.c | 14 ++++++++++++++
>>   1 file changed, 14 insertions(+)
>>
>> diff --git a/drivers/base/core.c b/drivers/base/core.c
>> index 54ba506e5a89..176b927fade2 100644
>> --- a/drivers/base/core.c
>> +++ b/drivers/base/core.c
>> @@ -29,6 +29,7 @@
>>   #include <linux/sched/mm.h>
>>   #include <linux/sysfs.h>
>>   #include <linux/dma-map-ops.h> /* for dma_default_coherent */
>> +#include <linux/cpuset.h>
>>   
>>   #include "base.h"
>>   #include "power/power.h"
>> @@ -2378,11 +2379,24 @@ static ssize_t uevent_store(struct device *dev, struct device_attribute *attr,
>>   }
>>   static DEVICE_ATTR_RW(uevent);
>>   
>> +static bool is_device_cpu(struct device *dev)
>> +{
>> +	return dev->bus && dev->bus->dev_name
>> +			&& !strcmp(dev->bus->dev_name, "cpu");
>> +}
> No, this is not ok, there is a reason we did not put RTTI in struct
> devices, so don't try to fake one here please.
>
>> +
>>   static ssize_t online_show(struct device *dev, struct device_attribute *attr,
>>   			   char *buf)
>>   {
>>   	bool val;
>>   
>> +	/*
>> +	 * Show a cpu as offline if the cpu number is not valid in a
>> +	 * proper cpuset bounding cpuinfo context.
>> +	 */
>> +	if (is_device_cpu(dev) && !cpuset_current_cpu_valid(dev->id))
>> +		return sysfs_emit(buf, "0\n");
> Why are you changing the driver core for a single random, tiny set of
> devices?  The device code for those devices can handle this just fine,
> do NOT modify the driver core for each individual driver type, that way
> lies madness.
>
> This change is not ok, sorry.

OK, thanks for the comments. I will see if there is alternative way of 
doing it.

Cheers,
Longman

