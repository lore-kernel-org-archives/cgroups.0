From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 17/26] cgroup/misc: Add notifier block list support for
 css events
Date: Mon, 14 Nov 2022 13:11:35 -1000
Message-ID: <Y3LLJypIUOSGKujT@slm.duckdns.org>
References: <20221111183532.3676646-1-kristen@linux.intel.com>
 <20221111183532.3676646-18-kristen@linux.intel.com>
 <Y3LES3rUIZ/PtwzV@slm.duckdns.org>
 <6f7afaa6811cbda30d12c38d73d4b261ab733a9f.camel@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=odpYU+Z5Izh+YHmos1vrgNoom8ekbwoJE8YvWsljqKw=;
        b=bx3cCmBrKBUoh+0kQwPoowY4cSqbreKadVtsFwrVH+COOjVGRnKnHVGpPqhTVj511F
         /FdrjdB1vLPzt+WsmB96m4uW65K5c/GorCcjiUVX4tPPrhXuIowIVzdnqpWHRP2JUjka
         DPtRHI3/byuPmYgQ0NlrmDc/BVD2EO5PvLdOdTsuPL64nLIv+6yUraqBsWXvs8W/uaHO
         AnEJz5iuRNEYU+AziFZnaQvZVXamOr1vRUdTLv1l4/53FgXSXvocr5OviBotIOXgJTQ3
         0xnjV23Xp9aWmqcWHmpPItLrvKE4qaLFFUWShIydcJ3EXINIHQgkI/XSUV65/uX0TFb0
         ZqjA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6f7afaa6811cbda30d12c38d73d4b261ab733a9f.camel-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

Hello,

On Mon, Nov 14, 2022 at 03:10:05PM -0800, Kristen Carlson Accardi wrote:
> Makes no difference to me TBH - I believe they will be functionally
> equivalent and from a downstream user perspective equally as easy to
> use, so whatever you think is easiest for you to maintain.

Yeah, functionally they should be equivalent. Hmm... Let's go with the ops
table so that it's more explicit.

Thanks.

-- 
tejun
