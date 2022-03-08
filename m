From: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/3] mm: vmalloc: introduce array allocation functions
Date: Tue,  8 Mar 2022 05:59:15 -0500
Message-ID: <20220308105918.615575-1-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646737166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3yqdS8zAEjaJjs00ZY9U4Ql4/aCVM8MsMEwUnD+zf4Q=;
        b=gmxuOCBH0GYQ9xycyAssx2/7ahDXce5OBPi2NrUCH2L/q5PcL7TlBLuwx+T+ikRhSMeAne
        VMSZs2Wy0OuzAageMDARFxzoW56iV0odV9Q/nhKyj0REwEHk8SMzoBoA0wo+lX1FOhvhVe
        u9bZZYFgfc6Kqh65Cicuseh3y+uqQxA=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The first patch in this series introduces four array allocation
functions to replace vmalloc(array_size()) and vzalloc(array_size()),
of which Linux has dozens of occurrences.  The Functions take care of
the multiplication and overflow check, result in simpler code and make
it easier for developers to avoid overflow bugs.

The other two patches start to apply the functions in the mm/ and KVM
areas.  In the case of KVM, it is also important to switch from kvcalloc
to __vcalloc; the allocation size is driven by userspace and can be larger
than 4GiB, which has been forbidden by the kv*alloc functions since 5.15.

Paolo

Paolo Bonzini (3):
  mm: vmalloc: introduce array allocation functions
  mm: use vmalloc_array and vcalloc for array allocations
  KVM: use __vcalloc for very large allocations

 arch/powerpc/kvm/book3s_hv_uvmem.c |  2 +-
 arch/x86/kvm/mmu/page_track.c      |  7 +++--
 arch/x86/kvm/x86.c                 |  4 +--
 include/linux/vmalloc.h            |  5 +++
 mm/percpu-stats.c                  |  2 +-
 mm/swap_cgroup.c                   |  4 +--
 mm/util.c                          | 50 ++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c                |  4 +--
 9 files changed, 66 insertions(+), 12 deletions(-)

-- 
2.31.1

