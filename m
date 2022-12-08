From: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 09/18] x86/sgx: Return the number of EPC pages that
 were successfully reclaimed
Date: Thu, 8 Dec 2022 09:30:13 +0000
Message-ID: <Y5Gupbkb7BmCJlGn@kernel.org>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-10-kristen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670491817;
        bh=KvDZ6QK3ZFSOs+gv7yHb4EU7Ui4QQ9oYslj/0R5XduM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DJtrzXc2jp78dAEJI54yfardbIC81q390prkd+5L8QNe/LbFbhqmoT18F+gAuZUp6
         JnwpeICGIWmpXw5dq2ylyazPdFRLEwqQCLvK/g96V9hB9yCdR7agb77GU87KrjYRt3
         vQlKv/ZmwAqeYBg7lP4o7z/8M5hJNnLjRq0NIYUnUzz9dIArnNfO+rNQ1KiwJdULF+
         iZTXzuN9Pf8J7YeWVxCfNG8GohARLfeqQRk3ej5I+l9RMfHeNM2b1NBKboSj1LrIWC
         6y0140hbVaIo6wXA+s7Uw+nMn4GK5g5nsuUZ0KBwGs5gf8BJNUW0p789Y4wX6T9xnK
         xAaHlFUmaOf8w==
Content-Disposition: inline
In-Reply-To: <20221202183655.3767674-10-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, Dec 02, 2022 at 10:36:45AM -0800, Kristen Carlson Accardi wrote:
> From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Return the number of reclaimed pages from sgx_reclaim_pages(), the EPC
> cgroup will use the result to track the success rate of its reclaim
> calls, e.g. to escalate to a more forceful reclaiming mode if necessary.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index f201ca85212f..a4a65eadfb79 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -291,7 +291,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
>   * problematic as it would increase the lock contention too much, which would
>   * halt forward progress.
>   */
> -static void __sgx_reclaim_pages(int nr_to_scan)
> +static int __sgx_reclaim_pages(int nr_to_scan)

Nit: I wonder if we should use ssize_t here?

If nothing else, it would document better than 'int'.

BR, Jarkko
