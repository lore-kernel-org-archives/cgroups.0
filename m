From: Jarkko Sakkinen <jarkko@kernel.org>
Subject: Re: [PATCH v2 13/18] x86/sgx: Add helper to grab pages from an
 arbitrary EPC LRU
Date: Thu, 8 Dec 2022 09:56:57 +0000
Message-ID: <Y5G06eSnWRAOJMty@kernel.org>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-14-kristen@linux.intel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670493421;
        bh=0YONDyXSVa33MyT3Y1l44dW3jNZREl8JU1hVtA1zMfc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FCSyXRUaBuN5Gfn5yMzGv4WNYwCtUjmYth2dtuI2WPqWJmXCbUCNNo4MJjxsRQ7ml
         25QzxXJWThQe16pB9msMXeV0V57sqf/XAySKr4f75hUXFY2JcCfdIksFAZ/ZPyTy26
         6qk6jXvM50+/jZ+dD8dNsPtT0HPYua0aq+PQDwRZz6q6DFvr05138ugmelxchXQVBM
         iG2Mjy+BK5qKg/aunxPyWAWnPDMNRYj4WmIDc3a/B5trq9ndv5eGo2WT+/23TAmAr8
         nqalOGJABkT5Y9hC3StQq0HehSbsEBdrd71JX42YX0hF4I0DK6mFYiNbhKJsxb2Tpc
         OeVJD4rNFw2Ng==
Content-Disposition: inline
In-Reply-To: <20221202183655.3767674-14-kristen@linux.intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: dave.hansen@linux.intel.com, tj@kernel.org, linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, cgroups@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, zhiquan1.li@intel.com, Sean Christopherson <seanjc@google.com>

On Fri, Dec 02, 2022 at 10:36:49AM -0800, Kristen Carlson Accardi wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Move the isolation loop into a standalone helper, sgx_isolate_pages(),
> in preparation for existence of multiple LRUs.  Expose the helper to
> other SGX code so that it can be called from the EPC cgroup code, e.g.
> to isolate pages from a single cgroup LRU.  Exposing the isolation loop
> allows the cgroup iteration logic to be wholly encapsulated within the
> cgroup code.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> Cc: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 68 +++++++++++++++++++++-------------
>  arch/x86/kernel/cpu/sgx/sgx.h  |  2 +
>  2 files changed, 44 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index c947b4ae06f3..a59550fa150b 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -280,7 +280,46 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
>  }
>  
>  /**
> - * sgx_reclaim_pages() - Reclaim EPC pages from the consumers
> + * sgx_isolate_epc_pages() - Isolate pages from an LRU for reclaim
> + * @lru:	LRU from which to reclaim
> + * @nr_to_scan:	Number of pages to scan for reclaim
> + * @dst:	Destination list to hold the isolated pages
> + */
> +void sgx_isolate_epc_pages(struct sgx_epc_lru_lists *lru, int *nr_to_scan,
> +			   struct list_head *dst)

Why not instead return the number of pages scanned, and pass
'int nr_to_scan'?

That would just be more idiomatic choice.

BR, Jarkko
