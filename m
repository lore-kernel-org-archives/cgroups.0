From: Carlos Bilbao <carlos.bilbao-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH] blk-iocost: fix seq_printf compile type mismatch error
Date: Mon, 31 Jul 2023 10:04:14 -0500
Message-ID: <7f451eb2-6e62-9e49-c47a-e0de59cc7ebf@amd.com>
References: <20230717141852.153965-1-carlos.bilbao@amd.com>
 <93557f79-c12c-3c3f-2c25-9ba50a618daa@amd.com>
 <ZLstYbAzqkqwIRzy@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Bazck+NSeWS8nQUxV63068N65y644YleC1gT1b/6Hs=;
 b=A/bLWs5DHGfNVorZL0MUvfyhsId7QIGgj83MEseDYpY37Rm0gV2eMmsgcVnYEdobB31R5FABMnFEGSPDRcQxXQjtWNNETZPyfVDBLS9xGYobL9+VAp29D+rRzY1XznC71oPY7ivvqOn/TzA+4fO7IiVU4S/BO/JmakYRa0Pqa+0=
Content-Language: en-US
In-Reply-To: <ZLstYbAzqkqwIRzy-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amd <amd-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>

On 7/21/23 20:14, Tejun Heo wrote:
> On Fri, Jul 21, 2023 at 05:32:04PM -0500, Carlos Bilbao wrote:
>> On 7/17/23 9:18 AM, Carlos Bilbao wrote:
>>> From: amd <amd-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
>>>
>>> Fix two type mismatch errors encountered while compiling blk-iocost.c with
>>> GCC version 13.1.1 that involved constant operator WEIGHT_ONE. Cast the
>>> result of the division operation to (unsigned int) to match the expected
>>> format specifier %u in two seq_printf invocations.
>>>
>>> Reviewed-by: Carlos Bilbao <carlos.bilbao-5C7GfCeVMHo@public.gmane.org>
>> This should have been:
>>
>> Signed-off-by: Carlos Bilbao <carlos.bilbao-5C7GfCeVMHo@public.gmane.org>
> 
> Carlos, can you please retest the current linus#master?
> 

Yes, that version compiled successfully without changes in my compiler. The
kernel that gave me said error was a custom v6.1.0-rc4 (Obtained from:
https://github.com/coconut-svsm/linux/tree/svsm-host)

> Thanks.
> 

Thanks,
Carlos
