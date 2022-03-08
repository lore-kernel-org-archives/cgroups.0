From: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] mm: use vmalloc_array and vcalloc for array
 allocations
Date: Tue, 8 Mar 2022 15:27:38 +0100
Message-ID: <8d036ae0-9280-0d53-02dd-179ba46f908f@redhat.com>
References: <20220308105918.615575-1-pbonzini@redhat.com>
 <20220308105918.615575-3-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646749662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N/dhr5xlK4pqXG8WmMyzbGqgbqfGKBQGaX2lWQVYPyM=;
        b=ewTR1t91FHrT2tC5rpvG96tV0Eqca+vsj1xcBYY42s5d5nsDYC9fIMUYP5Rz/PC8Eq/ezB
        ImnOP1tUo2jFAmFphfQ+T1DussaaX5Y9FQ7VLu8cslqbi2VrSlkU5XY7R0uGbKVxjhUX0F
        fCUVCDr9ekz3OXO9NRL5oSfpfz4L4RU=
Content-Language: en-US
In-Reply-To: <20220308105918.615575-3-pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 08.03.22 11:59, Paolo Bonzini wrote:
> Instead of using array_size or just a multiply, use a function that
> takes care of both the multiplication and the overflow checks.
> 
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Signed-off-by: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Reviewed-by: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


-- 
Thanks,

David / dhildenb

