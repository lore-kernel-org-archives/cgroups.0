From: David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH 3/3] KVM: use vcalloc/__vcalloc for very large allocations
Date: Tue, 8 Mar 2022 15:25:11 +0100
Message-ID: <d170ca91-4913-900c-1d2b-b8fc63076124@redhat.com>
References: <20220308105918.615575-1-pbonzini@redhat.com>
 <20220308105918.615575-4-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646749515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kumltRP5xoYTs9zCrvASai08H9k31B5+7rHSh9VugPY=;
        b=aN7D5xEulCZO4qN5dGw0dpoS6gsjmzUc/Uu5dRThH8THuJ03gvhVJ5t2oCX9AT1rFAzJbz
        VIzI9nfc13VS5F1Wb6vXSMroz0Wc+YKQBzpw6p3UYNPuTKF6SehruKMB5Ows1Cn5j2p1U7
        tTqCE2aO47szaAdMARSxBX4OKHTJHro=
Content-Language: en-US
In-Reply-To: <20220308105918.615575-4-pbonzini@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, stable@vger.kernel.org

On 08.03.22 11:59, Paolo Bonzini wrote:
> Allocations whose size is related to the memslot size can be arbitrarily
> large.  Do not use kvzalloc/kvcalloc, as those are limited to "not crazy"
> sizes that fit in 32 bits.  Now that it is available, they can use either
> vcalloc or __vcalloc, the latter if accounting is required.
> 
> Cc: stable@vger.kernel.org
> Cc: kvm@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls")

?

Reviewed-by: David Hildenbrand <david@redhat.com>


-- 
Thanks,

David / dhildenb

