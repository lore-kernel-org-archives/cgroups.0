From: Carlos Bilbao <carlos.bilbao-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH] blk-iocost: fix seq_printf compile type mismatch error
Date: Tue, 18 Jul 2023 10:37:23 -0500
Message-ID: <7044d6b3-a5d1-572d-a755-74f8d4fd31c5@amd.com>
References: <20230717141852.153965-1-carlos.bilbao@amd.com>
 <ZLWNHuTGk0fy8pjE@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V7XHEmfyWtTbSEl7bLivWOkRxdzNXEMVg3qG+Go3LlA=;
 b=fPW+EOBC/QjKl1LI2/ls5Bs5At/UQRyTrGyrmFeCq4Jx/+53vLVvBjb2WJhb1MKeU80j0FozOFHu+d+D6Cy/f4SFVeJ62E9sqEVmMcml8hMCIMTKjn+4YQ231loQj6u9Dy77SMOtMQkfIQ4HhxLnowPr5/ycKqKzojCdZRtM/4A=
Content-Language: en-US
In-Reply-To: <ZLWNHuTGk0fy8pjE-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amd <amd-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>

On 7/17/23 13:49, Tejun Heo wrote:
> On Mon, Jul 17, 2023 at 09:18:52AM -0500, Carlos Bilbao wrote:
>> From: amd <amd-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
>>
>> Fix two type mismatch errors encountered while compiling blk-iocost.c with
>> GCC version 13.1.1 that involved constant operator WEIGHT_ONE. Cast the
>> result of the division operation to (unsigned int) to match the expected
>> format specifier %u in two seq_printf invocations.
> 
> Can you detail the warnings? Was that on 32bit compiles?

The concrete error was: "format ‘%u’ expects argument of type ‘unsigned
int’, but argument 3 has type ‘long unsigned int’". If I run:

$ echo | cpp -dM | grep __LP64__
#define __LP64__ 1

which makes me believe it is not 32 bits.

> 
> Thanks.
> 

Thanks,
Carlos
