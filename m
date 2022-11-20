From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH] cgroup: Fix typo in comment
Date: Sun, 20 Nov 2022 11:25:11 -0500
Message-ID: <77e79fad98b945f4f3f72b584d10fe01e187b8a8.camel@HansenPartnership.com>
References: <20221120155134.57193-1-haifeng.xu@shopee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1668961514;
        bh=n1RHYaSr7YVqpR8H4s00LHMTau2igcsd/5bJkmmJeNU=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=pRHgB9QTxpHTbMYjOUJS8PqOUVjx2KvI2Lxodd+h9qHf0pQCvDVJi7WkHXSAY19Qm
         MljcSA6rjBNuSm2tuErOP7ZWZsPcKfTh5o7JQojVBC+BAK9Njz1B1vWK3Y4wq5cgCi
         VVKcVitj2q63UqJCdmm4jJ8ALaWB2yXLXsIXOodY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1668961514;
        bh=n1RHYaSr7YVqpR8H4s00LHMTau2igcsd/5bJkmmJeNU=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=pRHgB9QTxpHTbMYjOUJS8PqOUVjx2KvI2Lxodd+h9qHf0pQCvDVJi7WkHXSAY19Qm
         MljcSA6rjBNuSm2tuErOP7ZWZsPcKfTh5o7JQojVBC+BAK9Njz1B1vWK3Y4wq5cgCi
         VVKcVitj2q63UqJCdmm4jJ8ALaWB2yXLXsIXOodY=
In-Reply-To: <20221120155134.57193-1-haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "haifeng.xu" <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, 2022-11-20 at 15:51 +0000, haifeng.xu wrote:
> Replace iff with if.

You can't do this without a more detailed analysis.  iff means if and
only if (logical implies in both directions), which appears to be more
correct in the code being patched than if, which is logical implies in
only one direction only.

James

