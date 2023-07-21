From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/misc: Store atomic64_t reads to u64
Date: Fri, 21 Jul 2023 08:10:44 -1000
Message-ID: <ZLrKJAyea-U5Lsiy@slm.duckdns.org>
References: <ZLcXmvDKheCRYOjG@slm.duckdns.org>
 <20230721120231.13916-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689963046; x=1690567846;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=45g6O9ZlJ9a46173hb9oD6WT0Gj5jDz2sDLA6BPWNec=;
        b=XU6YpFKPBbH37FVtZHEnptSRL3P3lrRfAIIxJ3QCDkfv56XTKiavtaE0iCqLTm1EAO
         /RmpapIvZqwgHjlnwe3v7/BAqJhlwdaC9UBDEdyP52asiRdv77jN/FbOHaJigcxI7+KX
         to4rHwtUxx4KimsHgPF+JAbDI2MWrQkRBcrgf/Dt77/xACrwezXxlq1sl0UFMsbq5iZl
         9OaS+4ukOVqSlVkZRCUsR24FH/hj14KVi2+45Xcchj9j/j89PstpJXLfX4JCTJ8zubAk
         f26L7HbfpDFFiUGvojF8dEyUzBdzM8/rbKgnjwX75YppW9YOGpfVrprimMo9Z5orXJ6F
         JC8w==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230721120231.13916-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

On Fri, Jul 21, 2023 at 05:02:31AM -0700, Haitao Huang wrote:
> Change 'new_usage' type to u64 so it can be compared with unsigned 'max'
> and 'capacity' properly even if the value crosses the signed boundary.
> 
> Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Applied to cgroup/for-6.6.

Thanks.

-- 
tejun
