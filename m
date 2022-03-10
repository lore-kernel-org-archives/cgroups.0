From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] KVM: use vcalloc/__vcalloc for very large
 allocations
Date: Wed, 9 Mar 2022 20:18:14 -0800
Message-ID: <20220309201814.241f39d9ed2f6671c636ece4@linux-foundation.org>
References: <20220308105918.615575-1-pbonzini@redhat.com>
        <20220308105918.615575-4-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646885895;
        bh=6iSEJ3wU3FzUZTv0RzpHgZNG0F9nHjVBdsz7P6dvBMA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oA40XrOAotQlxjyxfmZX6SWY05dOajakzPs0J6WPXeSEmIxnP48zQfs7IjgUHnSGC
         VnsuFcTcEa7qlci4CQSScUpiNJomY96FDfGDBwwkod5zGwQUNiRdL4KUlrE2F4f+h+
         T4PJImeuf2zRADaazJhmGjz2hnrAHgQCTPgL9yfc=
In-Reply-To: <20220308105918.615575-4-pbonzini@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, stable@vger.kernel.org

On Tue,  8 Mar 2022 05:59:18 -0500 Paolo Bonzini <pbonzini@redhat.com> wrote:

> Allocations whose size is related to the memslot size can be arbitrarily
> large.  Do not use kvzalloc/kvcalloc, as those are limited to "not crazy"
> sizes that fit in 32 bits.  Now that it is available, they can use either
> vcalloc or __vcalloc, the latter if accounting is required.
> 
> Cc: stable@vger.kernel.org

Please fully describe the end user visible runtime effects when
proposing a -stable backport.  And when not proposing a -stable
backport, come to that...


