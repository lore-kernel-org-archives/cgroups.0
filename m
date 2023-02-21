From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: Re: [PATCH] mm/memcg: Skip high limit check in root memcg
Date: Tue, 21 Feb 2023 18:29:39 +0800
Message-ID: <82918a12-d83e-10c0-0e04-eec26657b699@shopee.com>
References: <20230210094550.5125-1-haifeng.xu@shopee.com>
 <Y+uvRKo7OQ02yB4K@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------Spvi9DJXN5O0V9DKveeK2Vsh"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com;
        h=in-reply-to:from:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=A6bq0cNZ1AfAVAWRtxraIczrguYU6xxumxI1OimKFcQ=;
        b=cTvBJZUXrr8VeSPaAd/OQA+aC9rJ1ogQGfjpWHh5OAYclK7SrwdWvEquQUueynfkvQ
         a3efwTPEAnGZBc0WnVX/Sf/cIN+IQouc4MrvflZTyKcv7Wume1MEDzSGxZcZysDAl+sE
         SVWMotA2T640xagoe44Qxr516z/1JAgBGMCO6Yp6ztVQcG3cGpzJlaeEmGcuk8WubaJW
         M/ALr4Xy17oe3KDqnqcWC5HaLx4BGaYDFhLCc7a7Fnivk1b9R9AqoyS65x3kUBhySLhF
         xVsCampZ1JzrKo55JLoUti7ABpU3exb9EdtbLC8mylSTrCs0xQaJfHgG7jYo3KA9dnEV
         MzYg==
In-Reply-To: <Y+uvRKo7OQ02yB4K@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: hannes@cmpxchg.org, shakeelb@google.com, muchun.song@linux.dev, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------Spvi9DJXN5O0V9DKveeK2Vsh
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2023/2/14 23:56, Michal Hocko wrote:
> On Fri 10-02-23 09:45:50, Haifeng Xu wrote:
>> The high limit checks the memory usage from given memcg to root memcg.
>> However, there is no limit in root memcg. So this check makes no sense
>> and we can ignore it.
> 
> Is this check actually addining any benefit? Have you measured aby
> performance gains by this change?
> 
>> Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
>> ---
>>  mm/memcontrol.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 73afff8062f9..a31a56598f29 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -2780,6 +2780,10 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>>  	do {
>>  		bool mem_high, swap_high;
>>  
>> +		/* There is no need for root memcg to check high limit */
>> +		if (mem_cgroup_is_root(memcg))
>> +			break;
>> +
>>  		mem_high = page_counter_read(&memcg->memory) >
>>  			READ_ONCE(memcg->memory.high);
>>  		swap_high = page_counter_read(&memcg->swap) >
>> -- 
>> 2.25.1
> 

test steps:
1. mkdir -p /sys/fs/cgroup/memory/test
2. echo $$ > /sys/fs/cgroup/memory/test/cgroup.procs
3. ./mmap_test

The test result show that with or without the patch, the time taken is almost the same.
--------------Spvi9DJXN5O0V9DKveeK2Vsh
Content-Type: text/plain; charset=UTF-8; name="mmap_test.c"
Content-Disposition: attachment; filename="mmap_test.c"
Content-Transfer-Encoding: base64

I2luY2x1ZGUgPHN5cy9tbWFuLmg+CiNpbmNsdWRlIDxzeXMvdHlwZXMuaD4KI2luY2x1ZGUg
PHVuaXN0ZC5oPgojaW5jbHVkZSA8c3RkbGliLmg+CiNpbmNsdWRlIDxzdGRpby5oPgojaW5j
bHVkZSA8ZmNudGwuaD4KI2luY2x1ZGUgPGN0eXBlLmg+CiNpbmNsdWRlIDxzdHJpbmcuaD4K
I2luY2x1ZGUgPGludHR5cGVzLmg+CgojZGVmaW5lIFNJWkUgKDUgKiAxMDI0ICogMTAyNCAq
IDEwMjQpCgppbnQ2NF90IGN1cnJlbnRfdGltZV9tcygpIHsKICAgICBzdHJ1Y3QgdGltZXZh
bCB0aW1lOwogICAgIGdldHRpbWVvZmRheSgmdGltZSwgTlVMTCk7CiAgICAgaW50NjRfdCBz
MSA9IChpbnQ2NF90KSh0aW1lLnR2X3NlYykgKiAxMDAwOwogICAgIGludDY0X3QgczIgPSAo
dGltZS50dl91c2VjIC8gMTAwMCk7CiAgICAgcmV0dXJuIHMxICsgczI7Cn0KCmludCBtYWlu
KGludCBhcmdjLCBjaGFyKiBhcmd2W10pCnsKICAgICAgICB2b2lkICogYnVmOwogICAgICAg
IHNpemVfdCBzaXplID0gU0laRTsKICAgICAgICBpbnQ2NF90IHN0YXJ0LCBjb3N0OwoKICAg
ICAgICBidWYgPSBtbWFwKE5VTEwsIHNpemUsIFBST1RfUkVBRCB8IFBST1RfV1JJVEUsIE1B
UF9QUklWQVRFIHwgTUFQX0FOT04sIDAsIDApOwogICAgICAgIGlmIChidWYgPCAwICkgewog
ICAgICAgICAgICAgICAgcHJpbnRmKCJtbWFwIGZhaWxlZFxuIik7CiAgICAgICAgICAgICAg
ICBleGl0KC0xKTsKICAgICAgICB9CgogICAgICAgIHN0YXJ0ID0gY3VycmVudF90aW1lX21z
KCk7CgogICAgICAgIG1sb2NrKGJ1Ziwgc2l6ZSk7CgogICAgICAgIGNvc3QgPSBjdXJyZW50
X3RpbWVfbXMoKSAtIHN0YXJ0OwogICAgICAgIHByaW50ZigiY29zdDogJSIgUFJJZDY0ICIg
bXNcbiIsIGNvc3QpOwoKICAgICAgICBtdW5tYXAoYnVmLCBzaXplKTsKCiAgICAgICAgcmV0
dXJuIDA7Cn0K

--------------Spvi9DJXN5O0V9DKveeK2Vsh--
