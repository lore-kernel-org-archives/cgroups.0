From: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [cgroup:for-next 3/3] include/linux/misc_cgroup.h:98:15: warning:
 no previous prototype for function 'misc_cg_res_total_usage'
Date: Sun, 4 Apr 2021 17:27:41 -0700
Message-ID: <CAHVum0d1A7pbVEOy8U6iCXCtf8YOfAEkAXwhhyFgkxXHFPGjFQ@mail.gmail.com>
References: <202104050523.t4Om6TmY-lkp@intel.com> <YGo+f3XoA4CtRAPt@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZF918p7w2NV7GDL6H66e14qUO918kYzYBoimRTX60mw=;
        b=B6aS04PjlBqAA2vflWypWTUhJI210MxW1PaPH1BDPRndkBlXgPSIvRcj4swDoEnRfe
         w+7CBj5c2TykbIXuD7EO51fppLYfu97EaJvdj6CK2LyrV94bYp6YD0UblBLsQE6p3Ujd
         thmdDtdqEunD6gglL47FCsEe5cOjfs+Bi8SlOdoduJt1/Te3Fq27sXeaEAC37xBME2kN
         hpoYyPFllmrsv+xns6mHWoOkGLtQ8bm0KAcUnAm22pOvICyBCh2QCsc9B4VOTIcU+9kC
         Z623CHribd6n+QENTCr/qvwQtpOpWibsePCCtqIrQeH2YhZsNC1Ly3WWV1yzOJPZb2KD
         SGuw==
In-Reply-To: <YGo+f3XoA4CtRAPt-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, clang-built-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Sun, Apr 4, 2021 at 3:32 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Applied the following patch to cgroup/for-5.13.
>
> Thanks.
> ----- 8< -----
> From dd3f4e4972f146a685930ccfed95e4e1d13d952a Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date: Sun, 4 Apr 2021 18:29:37 -0400
> Subject: [PATCH] cgroup: misc: mark dummy misc_cg_res_total_usage() static
>  inline
>
> The dummy implementation was missing static inline triggering the following
> compile warning on llvm.
>
>    In file included from arch/x86/kvm/svm/sev.c:17:
> >> include/linux/misc_cgroup.h:98:15: warning: no previous prototype for function 'misc_cg_res_total_usage' [-Wmissing-prototypes]
>    unsigned long misc_cg_res_total_usage(enum misc_res_type type)
>                  ^
>    include/linux/misc_cgroup.h:98:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
>    unsigned long misc_cg_res_total_usage(enum misc_res_type type)
>    ^
>    static
>    1 warning generated.
>
> Add it.
>
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  include/linux/misc_cgroup.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
> index c5af592481c0..da2367e2ac1e 100644
> --- a/include/linux/misc_cgroup.h
> +++ b/include/linux/misc_cgroup.h
> @@ -95,7 +95,7 @@ static inline void put_misc_cg(struct misc_cg *cg)
>
>  #else /* !CONFIG_CGROUP_MISC */
>
> -unsigned long misc_cg_res_total_usage(enum misc_res_type type)
> +static inline unsigned long misc_cg_res_total_usage(enum misc_res_type type)
>  {
>         return 0;
>  }
> --
> 2.31.1
>

Thanks for the quick patch Tejun. Sorry about the issue.
