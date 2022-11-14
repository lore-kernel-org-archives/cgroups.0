From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 19/26] cgroup/misc: Expose parent_misc()
Date: Mon, 14 Nov 2022 12:30:45 -1000
Message-ID: <Y3LBlRAWuJXxDLPE@slm.duckdns.org>
References: <20221111183532.3676646-1-kristen@linux.intel.com>
 <20221111183532.3676646-20-kristen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PM4Mnl3gIRS9ItgIzisRcghqDI/wvSaorXokGJD69nY=;
        b=aSx1r9EQXkrLCtfhCbTxziyZEymtjJXWd6nQjhTrIVKG/W012vIcbmbmnefGJV2HVH
         N90bNNs58eIYZPh4zdOinuZJQS/U9iS9RLsX9R9UCh1EqFnaTK+GlxwEu+/eXzQkUidp
         iXTcSi/lL6U1+HZBDX7Ox55eXM44KHjf/Bx4UkFkizcCoDi8Kx5RC9v43hAC+AXPODfj
         XgfWR5sXTmr8nlvBHN/tK8FIx4rvy/M65iInCJo+wY70/+YyqBHN1ZRdkgmkwaKqbGSu
         GyA/DSFiuTrCcfnDOJfZbSXXHfX0njjFDBcFUqrHi6Sa2eS+5v+MTgXxf2ft5kcZcS6R
         1iAA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221111183532.3676646-20-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

On Fri, Nov 11, 2022 at 10:35:24AM -0800, Kristen Carlson Accardi wrote:
> To manage the SGX EPC memory via the misc controller, the SGX
> driver will need to be able to iterate over the misc cgroup
> hierarchy. Make parent_misc() available for a future patch
> that will utilize it.

Ditto with naming and maybe it'd be easier to make these simple accessors
inline?

Thanks.

-- 
tejun
