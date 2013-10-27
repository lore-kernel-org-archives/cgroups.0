From: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] percpu counter: cast this_cpu_sub() adjustment
Date: Sun, 27 Oct 2013 10:12:02 -0700
Message-ID: <xr93iowi1vvh.fsf@gthelen.mtv.corp.google.com>
References: <1382859876-28196-1-git-send-email-gthelen@google.com>
	<1382859876-28196-3-git-send-email-gthelen@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        bh=A5HhOBTnveItJsY2Kfa299RaC67PoHOuPg5UcFkRHQY=;
        b=HH5jEN1/27NR6gtYwpE8703mhYV+SUnTGQxgp0WdJC4S9Q+Hqsyv5yVGUU2IZ+y4M3
         sN+N9bCm42V4hRIGQxEdtzdcUgrHrUJLy2EI43k/ZKxa9T4bDEADsiPJPzmmNjyEY4Zq
         FY1Lgav3aX1K5qEc/giH81EwwLCldU/qih98nCFRzyLPJ7iCFOOozsl1dwwsW4dkGAfM
         seEyDysn1AhMlQUuR9FNp5rd20+qWCToVGMNBFz1BhdaGKLf50b/e3WFcVJpt9FupNqW
         FjoERd87ZfxZUFlPiVMJAfI7GLbWQKc3nvlTfM+ys6977oQhv7NZ/AvJg8LXmhzfI1Rx
         Vuhw==
In-Reply-To: <1382859876-28196-3-git-send-email-gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> (Greg
	Thelen's message of "Sun, 27 Oct 2013 00:44:35 -0700")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christoph Lameter <cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Sun, Oct 27 2013, Greg Thelen wrote:

> this_cpu_sub() is implemented as negation and addition.
>
> This patch casts the adjustment to the counter type before negation to
> sign extend the adjustment.  This helps in cases where the counter
> type is wider than an unsigned adjustment.  An alternative to this
> patch is to declare such operations unsupported, but it seemed useful
> to avoid surprises.
>
> This patch specifically helps the following example:
>   unsigned int delta = 1
>   preempt_disable()
>   this_cpu_write(long_counter, 0)
>   this_cpu_sub(long_counter, delta)
>   preempt_enable()
>
> Before this change long_counter on a 64 bit machine ends with value
> 0xffffffff, rather than 0xffffffffffffffff.  This is because
> this_cpu_sub(pcp, delta) boils down to this_cpu_add(pcp, -delta),
> which is basically:
>   long_counter = 0 + 0xffffffff
>
> Also apply the same cast to:
>   __this_cpu_sub()
>   this_cpu_sub_return()
>   and __this_cpu_sub_return()
>
> All percpu_test.ko passes, especially the following cases which
> previously failed:
>
>   l -= ui_one;
>   __this_cpu_sub(long_counter, ui_one);
>   CHECK(l, long_counter, -1);
>
>   l -= ui_one;
>   this_cpu_sub(long_counter, ui_one);
>   CHECK(l, long_counter, -1);
>   CHECK(l, long_counter, 0xffffffffffffffff);
>
>   ul -= ui_one;
>   __this_cpu_sub(ulong_counter, ui_one);
>   CHECK(ul, ulong_counter, -1);
>   CHECK(ul, ulong_counter, 0xffffffffffffffff);
>
>   ul = this_cpu_sub_return(ulong_counter, ui_one);
>   CHECK(ul, ulong_counter, 2);
>
>   ul = __this_cpu_sub_return(ulong_counter, ui_one);
>   CHECK(ul, ulong_counter, 1);
>
> Signed-off-by: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/include/asm/percpu.h | 3 ++-
>  include/linux/percpu.h        | 8 ++++----
>  lib/percpu_test.c             | 2 +-
>  3 files changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
> index 0da5200..b3e18f8 100644
> --- a/arch/x86/include/asm/percpu.h
> +++ b/arch/x86/include/asm/percpu.h
> @@ -128,7 +128,8 @@ do {							\
>  do {									\
>  	typedef typeof(var) pao_T__;					\
>  	const int pao_ID__ = (__builtin_constant_p(val) &&		\
> -			      ((val) == 1 || (val) == -1)) ? (val) : 0;	\
> +			      ((val) == 1 || (val) == -1)) ?		\
> +				(int)(val) : 0;				\
>  	if (0) {							\
>  		pao_T__ pao_tmp__;					\
>  		pao_tmp__ = (val);					\
> diff --git a/include/linux/percpu.h b/include/linux/percpu.h
> index cc88172..c74088a 100644
> --- a/include/linux/percpu.h
> +++ b/include/linux/percpu.h
> @@ -332,7 +332,7 @@ do {									\
>  #endif
>  
>  #ifndef this_cpu_sub
> -# define this_cpu_sub(pcp, val)		this_cpu_add((pcp), -(val))
> +# define this_cpu_sub(pcp, val)		this_cpu_add((pcp), -(typeof(pcp))(val))
>  #endif
>  
>  #ifndef this_cpu_inc
> @@ -418,7 +418,7 @@ do {									\
>  # define this_cpu_add_return(pcp, val)	__pcpu_size_call_return2(this_cpu_add_return_, pcp, val)
>  #endif
>  
> -#define this_cpu_sub_return(pcp, val)	this_cpu_add_return(pcp, -(val))
> +#define this_cpu_sub_return(pcp, val)	this_cpu_add_return(pcp, -(typeof(pcp))(val))
>  #define this_cpu_inc_return(pcp)	this_cpu_add_return(pcp, 1)
>  #define this_cpu_dec_return(pcp)	this_cpu_add_return(pcp, -1)
>  
> @@ -586,7 +586,7 @@ do {									\
>  #endif
>  
>  #ifndef __this_cpu_sub
> -# define __this_cpu_sub(pcp, val)	__this_cpu_add((pcp), -(val))
> +# define __this_cpu_sub(pcp, val)	__this_cpu_add((pcp), -(typeof(pcp))(val))
>  #endif
>  
>  #ifndef __this_cpu_inc
> @@ -668,7 +668,7 @@ do {									\
>  	__pcpu_size_call_return2(__this_cpu_add_return_, pcp, val)
>  #endif
>  
> -#define __this_cpu_sub_return(pcp, val)	__this_cpu_add_return(pcp, -(val))
> +#define __this_cpu_sub_return(pcp, val)	__this_cpu_add_return(pcp, -(typeof(pcp))(val))
>  #define __this_cpu_inc_return(pcp)	__this_cpu_add_return(pcp, 1)
>  #define __this_cpu_dec_return(pcp)	__this_cpu_add_return(pcp, -1)
>  
> diff --git a/lib/percpu_test.c b/lib/percpu_test.c
> index 1ebeb44..8ab4231 100644
> --- a/lib/percpu_test.c
> +++ b/lib/percpu_test.c
> @@ -118,7 +118,7 @@ static int __init percpu_test_init(void)
>  	CHECK(ul, ulong_counter, 2);
>  
>  	ul = __this_cpu_sub_return(ulong_counter, ui_one);
> -	CHECK(ul, ulong_counter, 0);
> +	CHECK(ul, ulong_counter, 1);
>  
>  	preempt_enable();

Oops.  This update to percpu_test.c doesn't belong in this patch.  It
should be moved to the earlier patch 1/3.  I'll repost the series with
this update and the suggested changes to patch titles.
