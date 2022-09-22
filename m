From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 00/20] Add Cgroup support for SGX EPC memory
Date: Thu, 22 Sep 2022 09:08:01 -1000
Message-ID: <YyyykUJQtYbPVctn@slm.duckdns.org>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
 <YyyeSVSk/lWdo/W4@slm.duckdns.org>
 <4b8605533e5deade739249bfb341ab9c06d56a1e.camel@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=DvLvACHlAehE0+/VISWaqhZ6RLsIF/LLtwXH5V+If6Y=;
        b=I3mXtIhfq/vSa3NTg9CoLzXQ4wtZVzpkQp4NFGSLsGHabPDFNmdDQhjyHZNrA1OgTk
         pWJaRnAyD3Ifad+db9xlYczOmpeVFRVLSh2dfe6AKDry63Lg+WCDmv2K3GfmPfEv2beM
         XTNX3BXFx8VAYtLQpp5zpoPNdxyvFG41hNXWU/9IKYPzIG7jUdXAseS6TR+C1indYYr7
         wEoZwGA7DkPFttTQ0hTeIAKJrzIrBrJEffyEU3na7PJUGkFqejc80iapPhMRAwyA8R9l
         xOBt/YBpqs9lfKSx0R3TmKlOGxft9wmmx7QupyLi+TNkgWF6HCbtudeBA4PnZlK3OxgF
         s3tw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4b8605533e5deade739249bfb341ab9c06d56a1e.camel-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Hello,

On Thu, Sep 22, 2022 at 11:59:14AM -0700, Kristen Carlson Accardi wrote:
> Thanks for your question. The SGX EPC memory is a global shared
> resource that can be over committed. The SGX EPC controller should be
> used similarly to the normal memory controller. Normally when there is
> pressure on EPC memory, the reclaimer thread will write out pages from
> EPC memory to a backing RAM that is allocated per enclave. It is
> possible currently for even a single enclave to force all the other
> enclaves to have their epc pages written to backing RAM by allocating
> all the available system EPC memory. This can cause performance issues
> for the enclaves when they have to fault to load pages page in.

Can you please give more concrete examples? I'd love to hear how the SGX EPC
memory is typically used in what amounts and what's the performance
implications when they get reclaimed and so on. ie. Please describe a
realistic usage scenario of contention with sufficient details on how the
system is set up, what the applications are using the SGX EPC memory for and
how much, how the contention on memory affects the users and so on.

Thank you.

-- 
tejun
