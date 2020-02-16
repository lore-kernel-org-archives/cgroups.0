From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v12 7/9] hugetlb: support file_region coalescing again
Date: Sat, 15 Feb 2020 17:29:59 -0800 (PST)
Message-ID: <alpine.DEB.2.21.2002151729470.244463@chino.kir.corp.google.com>
References: <20200211213128.73302-1-almasrymina@google.com> <20200211213128.73302-7-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=H1J2XGmudHXtmp+DJfVLIIqWxd4GHWG0D55ayu8ofeI=;
        b=gFq89J3C6y2E3dC6eJosGCejVHswqtg68Tow44UbrH2gVrpogK7qFB1KHIIqqUr7bn
         tF6i1gknCrbwVMRuZQ5ME8rn/UmTXJDDfhHRV6pW2PIY5pqan+jFUw+/kb92UAgwLVbj
         T/G17QADHWbAVrR3b1QVTsvF3ed/aWsXDnw5zV2uSZHZk/45sRr34UPnEUrZgMEdy6J6
         YqeWVAyXZWILuihYlGoDPXdNP++ifAKU+tFKpgmi8EBlQR2AX2NbhCSBXI96xRW5tjuA
         ImAmKQCewP/SSbyC0hOD2KKx7/xtU+uyWnFN+4DYSnSZDjveEXzbpjxCsl1eW+3zXMKv
         iahQ==
In-Reply-To: <20200211213128.73302-7-almasrymina@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mina Almasry <almasrymina@google.com>
Cc: mike.kravetz@oracle.com, shuah@kernel.org, shakeelb@google.com, gthelen@google.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org

On Tue, 11 Feb 2020, Mina Almasry wrote:

> An earlier patch in this series disabled file_region coalescing in order
> to hang the hugetlb_cgroup uncharge info on the file_region entries.
> 
> This patch re-adds support for coalescing of file_region entries.
> Essentially everytime we add an entry, we call a recursive function that
> tries to coalesce the added region with the regions next to it. The
> worst case call depth for this function is 3: one to coalesce with the
> region next to it, one to coalesce to the region prev, and one to reach
> the base case.
> 
> This is an important performance optimization as private mappings add
> their entries page by page, and we could incur big performance costs for
> large mappings with lots of file_region entries in their resv_map.
> 
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Acked-by: David Rientjes <rientjes@google.com>
