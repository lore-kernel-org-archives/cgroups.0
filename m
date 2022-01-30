From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/3] lib/vsprintf: Avoid redundant work with 0 size
Date: Sun, 30 Jan 2022 15:57:14 -0500
Message-ID: <53f74ef1-e097-ea2a-84ef-2d34367e60eb@redhat.com>
References: <20220129205315.478628-1-longman@redhat.com>
 <20220129205315.478628-2-longman@redhat.com>
 <d99b3c4b-7b6e-529-6e4b-b91b65c92d81@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643576246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CYWsjFfFSt2RF45PXlVv4n8PSHaq7o1llJS6PLtLhlI=;
        b=ZcCYjN0VICs6GHKyc43gECTd7sSHjxqa2m5QQTZ3R6WRl+/c4NhjCHaPpaid5wLB1l492R
        oINShXGWa3IKGUSWmCsrKDxRBOs6my5z80KQzwKRc9W/Hey/63K8n85lkBLsZMmT7MG08x
        VHzlBOZV3yfP98EkFRBHVa2YIzeXrkE=
Content-Language: en-US
In-Reply-To: <d99b3c4b-7b6e-529-6e4b-b91b65c92d81-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 1/30/22 15:49, David Rientjes wrote:
> On Sat, 29 Jan 2022, Waiman Long wrote:
>
>> For *scnprintf(), vsnprintf() is always called even if the input size is
>> 0. That is a waste of time, so just return 0 in this case.
>>
>> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>   lib/vsprintf.c | 8 +++++---
>>   1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
>> index 3b8129dd374c..a65df546fb06 100644
>> --- a/lib/vsprintf.c
>> +++ b/lib/vsprintf.c
>> @@ -2895,13 +2895,15 @@ int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
>>   {
>>   	int i;
>>   
>> +	if (!size)
>> +		return 0;
> Nit: any reason this shouldn't be unlikely()?  If the conditional for
> i < size is likely(), this seems assumed already?

Good suggestion. Will make the change in the next version.

Cheers,
Longman

