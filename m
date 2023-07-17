From: "Jarkko Sakkinen" <jarkko@kernel.org>
Subject: Re: [PATCH v3 04/28] x86/sgx: Use sgx_epc_lru_lists for existing
 active page list
Date: Mon, 17 Jul 2023 12:47:01 +0000
Message-ID: <CU4GIFHMTA8N.2GV3WIA7HAVOE@seitikki>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
 <20230712230202.47929-5-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689598026;
        bh=DckZWJU+9gB0L1R/ZazMtJ82YVYplEoWf3KaQjLD6dY=;
        h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
        b=GxFhbOoWkaE8XZyWfTeqyPcRuUGAo7XO5YYNV4wiIjXf+UQYXXFmI/KUEe72128DU
         +Rcv139B2DGaOv6ot7waQgcCAaiPXwh5xSMOCusTNRuc/hVic77IkbSJdlCTC+Ngkf
         DP+mDEClHLiI07zTH2TQbyufugHQj2Or4TZm+xwsCbFlMR5Vn4nrITxUbgbr0n5oF8
         QaSj1YmA+IYosxwf1y3VsgXT4THX2GmQwALrk5fLlOJ4h6pp+JiF2rjIhMxuf4w9uu
         hyovDYvjyLTYV/etju2l1z9rXwaBMOnuGSP5eSg/wPikX8QX3AFZx/a83tmDwOJNCI
         7+6Ucre9E1eXQ==
In-Reply-To: <20230712230202.47929-5-haitao.huang@linux.intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Haitao Huang <haitao.huang@linux.intel.com>, dave.hansen@linux.intel.com, tj@kernel.org, linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, cgroups@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc: kai.huang@intel.com, reinette.chatre@intel.com, Kristen Carlson Accardi <kristen@linux.intel.com>, zhiquan1.li@intel.com, seanjc@google.com

On Wed Jul 12, 2023 at 11:01 PM UTC, Haitao Huang wrote:
> From: Kristen Carlson Accardi <kristen@linux.intel.com>
>
> Replace the existing sgx_active_page_list and its spinlock with
> a global sgx_epc_lru_lists struct.

Similarly as the previous patch, I would extend this story a tiny
bit forward to see the connection with the follow-up patches.

BR, Jarkko
