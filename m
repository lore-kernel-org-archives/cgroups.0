From: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 10/18] x86/sgx: Add option to ignore age of page
 during EPC reclaim
Date: Thu, 8 Dec 2022 09:37:48 +0000
Message-ID: <Y5GwbPu4cUs0/4Fi@kernel.org>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-11-kristen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670492273;
        bh=wYx2MO5YR6MseoVFegS6uhUtm5jWg22S6hWITNm5BM4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P8HFEZSYo9pu0gboQpt9k8bdF2m9KCt5kF1ymZ/H5G65QDagLY+dzTTppFobUWtFv
         NSyEtoj1nMd8euSMT+6GAVXcfB1FjOek03/GBlFLmzduklr7BWi4RRO5eC3N41T8hZ
         S8wXuQ5t0JK8Mho1XXB7C7TrE3lXvfhcgfttHemOU+DpHQ7EEfAYnEdoe1UJfxc2sk
         A0kthGwJ7QKTrOdQEKS4JAViEvlv5C7trtTLedyaySjodl/liolDvHUDKIetuIujmQ
         OtA3wBq3T7SvvMSqE4Vr5E9l3CmP5aqn3WPTWF2rzOpjx6lsxj9l5FoaENZr+pgaE4
         couMnWNctPAJA==
Content-Disposition: inline
In-Reply-To: <20221202183655.3767674-11-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, Dec 02, 2022 at 10:36:46AM -0800, Kristen Carlson Accardi wrote:
> From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Add a flag to sgx_reclaim_pages() to instruct it to ignore the age of
> page, i.e. reclaim the page even if it's young.  The EPC cgroup will use
> the flag to enforce its limits by draining the reclaimable lists before
> resorting to other measures, e.g. forcefully reclaimable "unreclaimable"
> pages by killing enclaves.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 46 +++++++++++++++++++++-------------
>  1 file changed, 29 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index a4a65eadfb79..db96483e2e74 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -31,6 +31,10 @@ static DEFINE_XARRAY(sgx_epc_address_space);
>   * with sgx_global_lru.lock acquired.
>   */
>  static struct sgx_epc_lru_lists sgx_global_lru;

Please, separate these by an empty line.

> +static inline struct sgx_epc_lru_lists *sgx_lru_lists(struct sgx_epc_page *epc_page)
> +{
> +	return &sgx_global_lru;
> +}

Should be named by the thing it returns, not by the type.

BR, Jarkko
