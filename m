From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/3] mm: vmalloc: introduce array allocation functions
Date: Tue, 8 Mar 2022 14:55:39 +0100
Message-ID: <77a34051-2672-88cf-99dd-60f5acfb905e@redhat.com>
References: <20220308105918.615575-1-pbonzini@redhat.com>
 <20220308105918.615575-2-pbonzini@redhat.com>
 <Yidefp4G/Hk2Twfy@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646747743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1IBDuOS2fA0Ut8e4IiZznBpFVrC7yMpgLFek2NZWFfs=;
        b=T9jdB2dl3v0/ZLlYNeb/oV5yazRPOl3B0PMh7i0TVzuoN7zaGGMzmOc9so1ojgD0wqGcD+
        73HiKHAH3CxBWesrCftjhqI6Wv5YuDHTTBFMd8aUBltsxyeQZ9DTiwLUM+rgvpkVKqrOlv
        DQc7v2LxRtC0qDkT72WjrIYEU9Dt6VY=
Content-Language: en-US
In-Reply-To: <Yidefp4G/Hk2Twfy@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko@suse.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, stable@vger.kernel.org

On 3/8/22 14:47, Michal Hocko wrote:
> Seems useful
> Acked-by: Michal Hocko<mhocko@suse.com>
> 
> Is there any reason you haven't used __alloc_size(1, 2) annotation?

It's enough to have them in the header:

>> +extern void *__vmalloc_array(size_t n, size_t size, gfp_t flags) __alloc_size(1, 2);
>> +extern void *vmalloc_array(size_t n, size_t size) __alloc_size(1, 2);
>> +extern void *__vcalloc(size_t n, size_t size, gfp_t flags) __alloc_size(1, 2);
>> +extern void *vcalloc(size_t n, size_t size) __alloc_size(1, 2);

Thanks for the quick review!

Paolo

