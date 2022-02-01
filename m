From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/3] lib/vsprintf: Avoid redundant work with 0 size
Date: Tue, 1 Feb 2022 11:01:51 -0500
Message-ID: <a4a3366e-1e7b-7d2b-5e05-46a308d09978@redhat.com>
References: <20220129205315.478628-1-longman@redhat.com>
 <20220129205315.478628-2-longman@redhat.com>
 <d99b3c4b-7b6e-529-6e4b-b91b65c92d81@google.com>
 <Yfe5Bb3U6Uil7Y6g@smile.fi.intel.com> <Yfe6SfG4CqzWSaMM@smile.fi.intel.com>
 <Yfe7Q5cx+MoaOev/@smile.fi.intel.com>
 <c33b6435-1b27-32af-b14c-0f3a0318dcca@redhat.com>
 <f3bcf541-e77b-ca93-ef5c-862f4de99366@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643731349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0lOsjYnjuXJjkQQPkdLRQ4+5wRRHj/4IS9YqFDRMAvI=;
        b=Jw3E49V/j4fkG+DDj3JcaDr2A8lPGKvcAVLj4fDbXsW7xycaMHDmaakfis8MM9BGYM4OEF
        lUkqdRZY7IT5hWwAkxd5FNNPFufOnVNYWGYy7piY7YfMgcIHE0xqCg9r5NiAFDNJBaV2jM
        90K7jMrhN9cbp06zYZyaS4NkL9RUON4=
Content-Language: en-US
In-Reply-To: <f3bcf541-e77b-ca93-ef5c-862f4de99366-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 2/1/22 02:12, Rasmus Villemoes wrote:
> On 31/01/2022 19.48, Waiman Long wrote:
>> On 1/31/22 05:34, Andy Shevchenko wrote:
>>> Also it seems currently the kernel documentation is not aligned with
>>> the code
>>>
>>>     "If @size is == 0 the function returns 0."
>>>
>>> It should mention the (theoretical?) possibility of getting negative
>>> value,
>>> if vsnprintf() returns negative value.
>> AFAICS, the kernel's vsnprintf() function will not return -1.
> Even if it did, the "i < size" comparison in vscnprintf() is "int v
> size_t", so integer promotion says that even if i were negative, that
> comparison would be false, so we wouldn't forward that negative value
> anyway.
>
>> So in that
>> sense it is not fully POSIX compliant.
> Of course it's not, but not because it doesn't return -1. POSIX just
> says to return that in case of an error, and as a matter of QoI, the
> kernel's implementation simply can't (and must not) fail. There are
> other cases where we don't follow POSIX/C, e.g. in some corner cases
> around field length and precision (documented in test_printf.c), and the
> non-support of %n (and floating point and handling of wchar_t*), and the
> whole %p<> extension etc.
>
> Rasmus
>
Thanks for the clarification.

Cheers,
Longman

