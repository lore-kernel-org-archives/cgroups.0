From: "Jarkko Sakkinen" <jarkko@kernel.org>
Subject: Re: [PATCH v3 17/28] x86/sgx: fix a NULL pointer
Date: Mon, 17 Jul 2023 12:49:27 +0000
Message-ID: <CU4GKARPLGU5.1CVBNY9N4K28F@seitikki>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
 <20230712230202.47929-18-haitao.huang@linux.intel.com>
 <CU4GJG1NRTUD.275UVHM8W2VED@seitikki>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689598172;
        bh=FzCc29B7tSBEcJAG9hiePGHLv8t23C1X2FNVDh8fwck=;
        h=Date:To:Cc:Subject:From:References:In-Reply-To:From;
        b=GPIVtST5cI3Gk0QPUa/Vbf3KaCgRK+8E/5AZn3ng7ExtBCSEECQ21eAdMLEnfzciB
         RZDaAthD+8xP0Oi4jsDR+YVstLZXpK3qNn6q3QFaGgT2c1XLBNiCh6eCco8/GTJ+DE
         ni8P9WBy+ZBfLOlOUjMcwfW9K0um6mIzLetwb5tAiYTqBtO7gH0umKu0+SE5kT7mUB
         nyOfw9TfxanSw0qk//eQ6hZ85Up/UFJos2Ak7OZS8x3nFOpjgV/41zWhUPkxE47YWO
         ddOXNGK9BhJJvjnHX6oeFKhtd7ToS8W9dw1iPtf/MwKgiyJwhczpsa+npFovhmT1LL
         whEntvnwlujoQ==
In-Reply-To: <CU4GJG1NRTUD.275UVHM8W2VED@seitikki>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jarkko Sakkinen <jarkko@kernel.org>, Haitao Huang <haitao.huang@linux.intel.com>, dave.hansen@linux.intel.com, tj@kernel.org, linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, cgroups@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc: kai.huang@intel.com, reinette.chatre@intel.com, zhiquan1.li@intel.com, kristen@linux.intel.com, seanjc@google.com

On Mon Jul 17, 2023 at 12:48 PM UTC, Jarkko Sakkinen wrote:
> On Wed Jul 12, 2023 at 11:01 PM UTC, Haitao Huang wrote:
> > Under heavy load, the SGX EPC reclaimers (ksgxd or future EPC cgroup
> > worker) may reclaim SECS EPC page for an enclave and set
> > encl->secs.epc_page to NULL. But the SECS EPC page is required for EAUG
> > in #PF handler and is used without checking for NULL and reloading.
> >
> > Fix this by checking if SECS is loaded before EAUG and load it if it wa=
s
> > reclaimed.
> >
> > Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
>
> A bug fix should be 1/*.

And a fixes tag.

Or is there a bug that is momentized by the earlier patches? This patch
feels confusing to say the least.

BR, Jarkko
