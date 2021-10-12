From: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH memcg] mm/page_alloc.c: avoid statistic update with 0
Date: Tue, 12 Oct 2021 13:09:27 +0200
Message-ID: <0a707990-f12c-3c60-2a96-e1d531e100a6@redhat.com>
References: <b2371951-bb8a-e62e-8d33-10830bbf6275@virtuozzo.com>
 <29155011-f884-b0e5-218e-911039568acb@suse.cz>
 <f52c5cd3-9b74-0fd5-2b7b-83ca21c52b2a@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634036971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A4tr+WT1IxgZxfPSMgT77kTtr4zb6xglyk4OS2F3Jl0=;
        b=U6PCpwePlMj9vVRkz4zszyay/Y4GV8kyR5/C61F/GjVCRp3vbM78WjLc43jgpesD//XZMK
        lb7fssI1Z5+cbCGMGW9QrY3L/rEPcna7ph5zuPYtxJOUWCyOE10bHCeN2acIvpZSfrOaj0
        N2yqFwukx2zvTQmgwdWHAZpH4Ghiz1c=
In-Reply-To: <f52c5cd3-9b74-0fd5-2b7b-83ca21c52b2a-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 12.10.21 12:42, Vasily Averin wrote:
> On 08.10.2021 14:47, Vlastimil Babka wrote:
>> On 10/8/21 11:24, Vasily Averin wrote:
>>> __alloc_pages_bulk can call __count_zid_vm_events and zone_statistics
>>> with nr_account = 0.
>>
>> But that's not a bug, right? Just an effective no-op that's not commonly
>> happening, so is it worth the check?
> 
> Why not?
> 
> Yes, it's not a bug, it just makes the kernel a bit more efficient in a very unlikely case.
> However, it looks strange and makes uninformed code reviewers like me worry about possible
> problems inside the affected functions. No one else calls these functions from 0.
>   

If it's not a BUG we'd better leave "Fixes:" tags away., it tends to 
confuse people looking for actual BUGs.

I'm also not sure if this micro-optimization is worth it. "bit more 
efficient in a very unlikely case" doesn't sound very compelling ... and 
personally I'd assume accounting functions can deal with a delta of 0.

-- 
Thanks,

David / dhildenb

