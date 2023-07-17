From: "Jarkko Sakkinen" <jarkko@kernel.org>
Subject: Re: [PATCH v3 19/28] cgroup/misc: Add per resource callbacks for
 CSS events
Date: Mon, 17 Jul 2023 13:16:04 +0000
Message-ID: <CU4H4O6WHRY2.2Q6YGBQQFJBK5@seitikki>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
 <20230712230202.47929-20-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689599768;
        bh=yX5VD4argzEiOYVVZ5od4hN9Yb9EkGyUcdTxKzHkZWU=;
        h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
        b=Yv6zBWBYNM+sft7PEHdXi84Pv8RrkBtUbsBGNXVdel9FV09PWDVdkMJ6pebKorOGO
         K1KrFHyH4CJpBdELg4D2uEadYShlllNoHSKyJykPf5VGkeww4I6PN87EeIbTAfxoHf
         jbsz60Lzztz4ubmgxEa9/oDHbIZQN/9uxIDE1qBYYXzQeyEMJxg4APVq5OE2+plftT
         4Tbl80up8rDQrlY1A1gj2DIguS8mR2aHlDR+RnZtjkAoyiSt5bhzUpDueb2Z3pBY5l
         YdArnWftCLSItCTwW5IPZwspVX+BAeJE3ckvPK+kc1G8pe2yk12IJ6Q9iKiS4HL70L
         rUMU9bmfVHPDg==
In-Reply-To: <20230712230202.47929-20-haitao.huang@linux.intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Haitao Huang <haitao.huang@linux.intel.com>, dave.hansen@linux.intel.com, tj@kernel.org, linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, cgroups@vger.kernel.org, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: kai.huang@intel.com, reinette.chatre@intel.com, Kristen Carlson Accardi <kristen@linux.intel.com>, zhiquan1.li@intel.com

On Wed Jul 12, 2023 at 11:01 PM UTC, Haitao Huang wrote:
> From: Kristen Carlson Accardi <kristen@linux.intel.com>
>
> Consumers of the misc cgroup controller might need to perform separate
> actions for Cgroups Subsystem State(CSS) events: cgroup alloc and free.
> In addition, writes to the max value may also need separate action. Add
> the ability to allow downstream users to setup callbacks for these
> operations, and call the corresponding per-resource-type callback when
> appropriate.
>
> This code will be utilized by the SGX driver in a future patch.
>
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>

Ditto. Belongs to the head of the patch set.

BR, Jarkko
