From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 02/18] cgroup/misc: Add SGX EPC resource type and
 export APIs for SGX driver
Date: Mon, 25 Sep 2023 08:50:17 -1000
Message-ID: <ZRHWaZB5BeXt2EcY@slm.duckdns.org>
References: <20230923030657.16148-1-haitao.huang@linux.intel.com>
 <20230923030657.16148-3-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695667820; x=1696272620; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FS6Sm1WF5Sz2XYLA9mMdoZkfL6tjoxQpUMHovY5b5ok=;
        b=WArYuSizFbQch4iYYOBhbeOvqWchppb5jh7GoQ/2nYKVSP++XKuZ3AeE9lsZ7ZxtoA
         ZgsBp/IZ2sSKOuA3qFU7/IYaOdqOgGwcBNUQXhdUO3Tga5iHSsrceir8EOtZpzDHMv79
         w8o1YI0MzecUKu2TmblpCGWqF51MlG04HchbGsMgSKhsNOftHfMrwa40mfxtwrApY9Tq
         HHLt7Mas9OkbE3eBT91Bi/TXDIBOgjFS+1DTNV8Q18tBh7Lv4bHvekkPOJuglYXbMycG
         LwGGoyJeYryzIgcNdlJs3DwAUJVB0aXwwGpMgzHyKENxTyRMmkMLFMc6om6fwTjJ+cmE
         pUrQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230923030657.16148-3-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org

On Fri, Sep 22, 2023 at 08:06:41PM -0700, Haitao Huang wrote:
> From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> 
> Add SGX EPC memory, MISC_CG_RES_SGX_EPC, to be a valid resource type
> for the misc controller.
> 
> Add per resource type private data so that SGX can store additional per
> cgroup data in misc_cg->misc_cg_res[MISC_CG_RES_SGX_EPC].
> 
> Export misc_cg_root() so the SGX driver can initialize and add those
> additional structures to the root misc cgroup as part of initialization
> for EPC cgroup support. This bootstraps the same additional
> initialization for non-root cgroups in the 'alloc()' callback added in the
> previous patch.
> 
> The SGX driver, as the EPC memory provider, will have a background
> worker to reclaim EPC pages to make room for new allocations in the same
> cgroup when its usage counter reaches near the limit controlled by the
> cgroup and its ancestors. Therefore it needs to do a walk from the
> current cgroup up to the root. To enable this walk, move parent_misc()
> into misc_cgroup.h and make inline to make this function available to
> SGX, rename it to misc_cg_parent(), and update kernel/cgroup/misc.c to
> use the new name.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
