From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3][0/6] memcg: prevent -ENOMEM in pre_destroy()
Date: Thu, 28 Jun 2012 09:06:25 -0700
Message-ID: <CAOS58YNuSMjDB00UgOPjGCSFcRx-gjvMrW+e4uW0ug8WMsuFSw@mail.gmail.com>
References: <4FACDED0.3020400@jp.fujitsu.com>
	<20120621202043.GD4642@google.com>
	<4FE3ADDD.9060908@jp.fujitsu.com>
	<20120627175818.GM15811@google.com>
	<4FEC16EF.40408@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=b3b4O12XEJWuFRHHalByHKk8e0oFVYKwImxpVPbB2UA=;
        b=MBDN++kNwl7NrV6wYG0vWJoHogPHoCQaDG+YnfQH4Od3ce7XK9vQg0jZ5jfA6e+EXZ
         UJJbuXY4fnTRmpjrd1DZMlMIstAHSwjJAKtM7nsWX4UhHMhDYK/wFLyTXhoCSerFSKyp
         CMRz2eSuAsock6JUhnQibcz+OII7Z1lOErbDtRF+TsumtkJXB/3+Hh4VxpL4KnUoELcI
         dxNZIGjOG/PB00hK10m0wa3xQkhJl184y9jXoFO7puEq4OHgslmad3lDdBUCJK616ru6
         CF02+ubpSlV8Z+pGNeCghppwjXO4sWjQlgcNgimAFUaLPNQj2r2GnT+9cuvYUPr1nZtv
         au7A==
In-Reply-To: <4FEC16EF.40408-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hiroyuki Kamezawa <kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, KAME.

On Thu, Jun 28, 2012 at 1:33 AM, Kamezawa Hiroyuki
<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
>> Ooh, once memcg drops the __DEPRECATED_clear_css_refs, cgroup_rmdir()
>> will mark the cgroup dead before start calling pre_destroy() and none
>> of the above will happen.
>>
>
> Hm, threads which touches memcg should hold memcg's reference count rather
> than css.
> Right ? IIUC, one of reason is a reference from kswapd etc...hm. I'll check
> it.

Not sure I'm following. I meant that css_tryget() will always fail
once pre_destroy() calls being for the cgroup, so no new child or
reference can be created for it after that point.

Thanks.

-- 
tejun
