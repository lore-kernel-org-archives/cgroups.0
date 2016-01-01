From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Lockdep warning at cset_cgroup_from_root()
Date: Thu, 31 Dec 2015 22:16:42 -0500
Message-ID: <20160101031642.GB3660@htj.duckdns.org>
References: <201601011210.BEB82753.OFtOMLJHFOSQVF@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=3nzwhJZ95OV01trzU1eRpJViN6hdWSgfnCOks1gkLBQ=;
        b=U6jPsUumMmew3sKzOW/fH4sG/DvvpUR3LAooiA9zS1pTrfRI+wrw/bbirKQkZHJ+wF
         xBR4OAa01Vi4HvQRn7lmwcyd6AU9AY9mdtX+PSOvrdGBiubw4yDxInI0fPp4MfK0ZlZE
         cjjuzONMQP8l/pUPF78tJ5BygR3O2cQrq5CTBuBCARt1OkmVUhXxo1O1NQ79QQ+4BOH5
         InOAU52smanXENhqM0VnJLmafzsAZDbAZAKcJn3RDJB50zeamkIBV4tOXvTEEmYcvWis
         W+s12kcYbcwua8lJvmRZfYkDICgFlw5JKIs+VNL/5couEOTAsBWf2YMzl4ITozvi8Kgu
         2wdg==
Content-Disposition: inline
In-Reply-To: <201601011210.BEB82753.OFtOMLJHFOSQVF-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Fri, Jan 01, 2016 at 12:10:08PM +0900, Tetsuo Handa wrote:
> I booted a CONFIG_PREEMPT_NONE=y && CONFIG_SMP=n kernel, and got flood of
> below warning.
> The location is lockdep_assert_held(&css_set_lock) in cset_cgroup_from_root()
> in kernel/cgroup.c. linux.git as of 9c982e86dbdb does not hit this warning.

Just applied the fix patch in cgroup/for-4.5.

Thanks.

-- 
tejun
