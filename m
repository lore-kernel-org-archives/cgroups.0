From: "Jarkko Sakkinen" <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 18/28] cgroup/misc: Fix an overflow
Date: Mon, 17 Jul 2023 13:15:19 +0000
Message-ID: <CU4H43P3H35X.1BCA3CE4D1250@seitikki>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
 <20230712230202.47929-19-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689599723;
        bh=TPoLuNdok8xu469zt+gJUA+72duNsVIwHpKBEXyRj8U=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=eNDT/Gt2Zpla10k8gy1Fza+XuWfpc4fT2vL05ThKyjAfvKHwVhd2drBHf1OFuwNtS
         5kKARQIlTXZan+yWS97J8FbrysJ9uQC2SbPYeuE75MdNvX1SNSIxI2EkCvZx4uuK1u
         fU971SaXjOc9j5/tJFQ2ILNJu5GLfdWeOJMEFdzlV1ciUoTrPWH9k8ppua1iWbrR3b
         G1eifQQo1TKw4xPoeEkBDfluI37QQ3tmta+cjCBzS15mchxYAqUDklyIgr5TPXzRq6
         AcsberFs9b0a+0HS/80l0sZ8YSRfjOHsHJD8Br1KbXQ20hvl7AA/bFUAU0qUOoxrL9
         VuDThiaCVZgMQ==
In-Reply-To: <20230712230202.47929-19-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org

On Wed Jul 12, 2023 at 11:01 PM UTC, Haitao Huang wrote:
> Overflow may happen in misc_cg_try_charge if new_usage becomes above
> INT_MAX, for example, on platforms with large SGX EPC sizes.
>
> Change type of new_usage to long from int and check overflow.
>
> Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

As are bug fixes, this is also precursory work that SGX cgroups patches
should build on top of. Therefore, it should be in the very beginning,
right after any possible bug fixes to the existing code.

BR, Jarkko


