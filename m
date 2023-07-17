From: "Jarkko Sakkinen" <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 17/28] x86/sgx: fix a NULL pointer
Date: Mon, 17 Jul 2023 12:48:20 +0000
Message-ID: <CU4GJG1NRTUD.275UVHM8W2VED@seitikki>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
 <20230712230202.47929-18-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689598105;
        bh=A4cMOdH0f8JrbGRr5KW6McF6cl+fnJRBJd96Af+AB08=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=mwhWpHAGDXxZqPasp1PkfMsnnzIAFbK4/RVuYvSRy9ADhvApy9XQI7mMjxPGa2Iop
         3lXImAps3cVri7p5c3KiqZIoTIYCLCmzFaR/WPORy1szPSuUUqIEXTD/fjt+GuLSbM
         2oIKrcQW71NO5xN+emgjND+D92GjZggnou9WTwFQ9iMtgnVhZDHMJLpeiAuneW+XRZ
         luQeV51aqmFcIBYV+0CHjcVmcqWjSF7ofIq3NDOeWRwCodj85lSGPoagHQFJTwIi08
         FNjZJXN5tchPKwyXxudlKTnAunNbnosGQ3W1n8TpMk0zBVlqqaLEh82NeaHpqtuoec
         uSN4KONr0IC+Q==
In-Reply-To: <20230712230202.47929-18-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Wed Jul 12, 2023 at 11:01 PM UTC, Haitao Huang wrote:
> Under heavy load, the SGX EPC reclaimers (ksgxd or future EPC cgroup
> worker) may reclaim SECS EPC page for an enclave and set
> encl->secs.epc_page to NULL. But the SECS EPC page is required for EAUG
> in #PF handler and is used without checking for NULL and reloading.
>
> Fix this by checking if SECS is loaded before EAUG and load it if it was
> reclaimed.
>
> Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

A bug fix should be 1/*.

BR, Jarkko

