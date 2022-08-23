From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v6 1/4] mm: add NR_SECONDARY_PAGETABLE to count
 secondary page table uses.
Date: Mon, 22 Aug 2022 17:08:19 -0700
Message-ID: <20220822170819.60d888a5d3e23f40fd1b2e16@linux-foundation.org>
References: <20220628220938.3657876-1-yosryahmed@google.com>
        <20220628220938.3657876-2-yosryahmed@google.com>
        <20220817102408.7b048f198a736f053ced2862@linux-foundation.org>
        <CAJD7tkZQ07dZtcTSirj0qLawaE3Ndyn-385m_kL09=gsfO9QwA@mail.gmail.com>
        <CAJD7tkYiVBsWfwQ6qZ3NVzW=3UPTAjSmR5aYgT2M3gk+5Hq0_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661213301;
        bh=ql3WhYwvtGyV0nnW4S8Tm+rGjMLwd8ee87bzIsZn2ms=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vRwnTZRxoiSrk0tZjUMMz0NWpy3KJjQW1Gzwl4s5BxfTEsZyNaPKh3ddH+egMSRAD
         2sR4hnNN+xm0NXU8iGalWA3ooH8VIUWkt4psle8L7uIrU6rbO7bDLYXnhrZRLNscHk
         bIFHQN8LlfFrHCUIGNFAHen8hRb613xJNDRLoVjU=
In-Reply-To: <CAJD7tkYiVBsWfwQ6qZ3NVzW=3UPTAjSmR5aYgT2M3gk+5Hq0_Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Alexandru Elisei <alexandru.elisei-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oliver Upton <oupton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Huang-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Shaoqin <shaoqin.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel@v>

On Mon, 22 Aug 2022 17:04:57 -0700 Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> > SecondaryPageTables is too long (unfortunately), it messes up the
> > formatting in node_read_meminfo() and meminfo_proc_show(). I would
> > prefer "secondary" as well, but I don't know if breaking the format in
> > this way is okay.
> 
> Any thoughts here Andrew? Change to SecondaryPageTables anyway? Change
> all to use "sec" instead of "secondary"? Leave as-is?

Leave as-is, I guess.  
