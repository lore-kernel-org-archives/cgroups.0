From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 2/4] mm/page_owner: Use scnprintf() to avoid excessive
 buffer overrun check
Date: Thu, 3 Feb 2022 13:49:02 -0500
Message-ID: <42cca916-d4c8-daa1-4a91-60738c499c89@redhat.com>
References: <20220131192308.608837-5-longman@redhat.com>
 <20220202203036.744010-3-longman@redhat.com>
 <5c03fa31-35a5-4cbc-6b0e-872d5db82a41@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643914152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xvwI014RI3T9gp2AWaO1azWgkMohE5MRNXNJ2U28y3Q=;
        b=CGwYX2/ytROtX0a4EVA7ZzbZ/H0TVDn2l8l+6e6eWp6VvHvhSlfD+6fZTiE8LSU56PLCXs
        Jh6bLs0cNRXZS3JD3S81CkWx5MTzs4p1TfMr4atA4lQ93H1knhNS5g+fLLRp9+DAyBdJW9
        6ls4IOzNC3D6e63JxfyoRhBNLBwDWNA=
Content-Language: en-US
In-Reply-To: <5c03fa31-35a5-4cbc-6b0e-872d5db82a41-AlSwsSmVLrQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 2/3/22 10:46, Vlastimil Babka wrote:
> On 2/2/22 21:30, Waiman Long wrote:
>> The snprintf() function can return a length greater than the given
>> input size. That will require a check for buffer overrun after each
>> invocation of snprintf(). scnprintf(), on the other hand, will never
>> return a greater length. By using scnprintf() in selected places, we
>> can avoid some buffer overrun checks except after stack_depot_snprint()
>> and after the last snprintf().
>>
>> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> Reviewed-by: Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Looks like this will work, but note that if the purpose of patch 1/4 was
> that after the first scnprintf() that overflows the following calls will be
> short-cut thanks to passing the size as 0, AFAICS that won't work. Because
> scnprintf() returns the number without trailing zero, 'ret' will be 'count -
> 1' after the overflow, so 'count - ret' will be 1, never 0.

Yes, I am aware of that. Patch 1 is just a micro-optimization for the 
very rare case.

Cheers,
Longman


