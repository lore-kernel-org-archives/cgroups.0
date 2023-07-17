From: "Jarkko Sakkinen" <jarkko@kernel.org>
Subject: Re: [PATCH v3 01/28] x86/sgx: Store struct sgx_encl when allocating
 new VA pages
Date: Mon, 17 Jul 2023 11:14:56 +0000
Message-ID: <CU4EJXH6STEZ.20R6EOX7V3XGD@seitikki>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
 <20230712230202.47929-2-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689592501;
        bh=jQaqrSCg/yz5THxsM9cGnoZroPykdynjBcPlSG9vNuk=;
        h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
        b=biVF7s9jcxMdUb2BNF9qZV5HtosaQalGOMAHtL4rHUPEpnq91DGXn039B5C6Cnk4D
         ZDGEtBMAhLOQRwl6lIW+Zv6UhejI96Lz8bLsEjJiBaiIu2HLW+yFSrgtZdjXy+wXRV
         vwMyz9EawHrE40q6tPROYq5yMLOKotg0Um/vk16UgL/Rdt/uP9kMiImhKhngT/mcCc
         XwEQOxPLuR/eKw4HzDcXIWJbf+a1irlyFJM1wAtOHCJ/CWHxeAcbWlt55tVxcbu534
         j9zH0Ggcj/mIULA/QUqd5AsxHezqVSOVMIs9NJUIe+JPVKyxbnhBP0c/SbXTdozyZr
         LfPjYFzHfuLtQ==
In-Reply-To: <20230712230202.47929-2-haitao.huang@linux.intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Haitao Huang <haitao.huang@linux.intel.com>, dave.hansen@linux.intel.com, tj@kernel.org, linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, cgroups@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc: kai.huang@intel.com, reinette.chatre@intel.com, zhiquan1.li@intel.com, kristen@linux.intel.com, seanjc@google.com

On Wed Jul 12, 2023 at 11:01 PM UTC, Haitao Huang wrote:
> In a later patch, when a cgroup has exceeded the max capacity for EPC pag=
es
> and there are no more Enclave EPC pages associated with the cgroup that c=
an
> be reclaimed, the only pages still associated with an enclave will be the
> unreclaimable Version Array (VA) pages or SECS pages, and the entire
> enclave will need to be killed to free up those pages.
>
> Currently, given an enclave pointer it is easy to find the associated VA
> pages and free them, however, OOM killing an enclave based on cgroup limi=
ts
> will require examining a cgroup's unreclaimable page list, and finding an
> enclave given a SECS page or a VA page. This will require a backpointer
> from a page to an enclave, including for VA pages.
>
> When allocating new Version Array (VA) pages, pass the struct sgx_encl of
> the enclave that is allocating the page. sgx_alloc_epc_page() will store
> this value in the owner field of the struct sgx_epc_page.  In a later
> patch, VA pages will be placed in an unreclaimable queue, and then when t=
he
> cgroup max limit is reached and there are no more reclaimable pages and t=
he
> enclave must be OOM killed, all the VA pages associated with that enclave
> can be uncharged and freed.
>
> To avoid casting needed to access the two types of owners: sgx_encl for V=
A
> pages, sgx_encl_page for other pages, replace 'owner' field in sgx_epc_pa=
ge
> with a union of the two types.

I think the action taken is correct but the reasoning is a bit
convoluted.

Why not instead put something like:

"Because struct sgx_epc_page instances of VA pages are not owned by an
sgx_encl_page instance in the first place, mark their owner as sgx_encl,
in order to make it reachable from the unreclaimable list."

The code change itself, and rest of the paragraphs do look reasonable.

BR, Jarkko
