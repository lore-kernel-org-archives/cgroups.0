From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v12 5/9] hugetlb_cgroup: add accounting for shared
 mappings
Date: Sat, 15 Feb 2020 17:29:06 -0800 (PST)
Message-ID: <alpine.DEB.2.21.2002151728250.244463@chino.kir.corp.google.com>
References: <20200211213128.73302-1-almasrymina@google.com> <20200211213128.73302-5-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=vFO8RYQ8FlPE3NMfWDMQg3z8BnL2LFOQ1aCp2wNf0j0=;
        b=UT5y7eB27mtmBLa9qTJY5GoNQuboQGZtdwfzReReOwUaVVOzs3n/h9Ba5B4+RntXCc
         W1HLiL5YMb1prRJyisKY/4AyutIk6MxcInq+taUJe61ASvIaUoTX0W1yeVlJTkr2L0yy
         Z3GZggc+OUPDOdBhQ0DJ6Ykh4gvxbTjTWcMManFakBmoxbGTXMvJ4M3UFkEjFGElSKiK
         eN1DWddOuAh6EgdiDyjMRu2QKSwZyN8l5Lyk1v5HDOtCCBbEl0Zg2qdgq3RGqYmGsGq0
         tHcRjJPPPzpU9hR1e2942b2sR9rjzicAMAJmllqUTzPah+NVj/FQiWIRoWMnJmEdNM/l
         7h5g==
In-Reply-To: <20200211213128.73302-5-almasrymina@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mina Almasry <almasrymina@google.com>
Cc: mike.kravetz@oracle.com, shuah@kernel.org, shakeelb@google.com, gthelen@google.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org

On Tue, 11 Feb 2020, Mina Almasry wrote:

> For shared mappings, the pointer to the hugetlb_cgroup to uncharge lives
> in the resv_map entries, in file_region->reservation_counter.
> 
> After a call to region_chg, we charge the approprate hugetlb_cgroup, and if
> successful, we pass on the hugetlb_cgroup info to a follow up region_add call.
> When a file_region entry is added to the resv_map via region_add, we put the
> pointer to that cgroup in file_region->reservation_counter. If charging doesn't
> succeed, we report the error to the caller, so that the kernel fails the
> reservation.
> 
> On region_del, which is when the hugetlb memory is unreserved, we also uncharge
> the file_region->reservation_counter.
> 
> Signed-off-by: Mina Almasry <almasrymina@google.com>
> 

Does this develop a dependency on hugetlb_cgroup.h in hugetlb.h?  Or maybe 
we only need a forward declaration of struct file_region there?
