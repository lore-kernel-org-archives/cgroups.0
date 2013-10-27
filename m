From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] percpu counter: cast this_cpu_sub() adjustment
Date: Sun, 27 Oct 2013 07:22:55 -0400
Message-ID: <20131027112255.GB14934@mtj.dyndns.org>
References: <1382859876-28196-1-git-send-email-gthelen@google.com>
 <1382859876-28196-3-git-send-email-gthelen@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=0ziW5PA/TthxQeAE0bMBlvk8h4SKFLBfoRw/FOv5+ao=;
        b=K3WrY9PPs/b+Tsci+oqIr4VHpXbX7w4C+r+LPd8Cx4vdaZoiVw24IFDCUt8UnDGPW0
         PorwunVPyE59sRFzjMW4W/HyOLpoZv1uAdvbSQWJipclJEsp8a1ILMd5J7YUDAnYkoC4
         1fzpp8YDhMoPoaqYSvOcH4QOwpcuqeEsrK30yT98OvK6hPHh7B+YrI+lp2HZaPqeni0S
         F3jqvEkl1HtoUH5NdQu0BH4IPN8wvJURaWGgXtIji/2IXXAvzXvlS2rpHkhXB8oceMQ/
         Q2vsHoPPuf3qlDUQdAc+YR2hV86SSeRzAmCEOM6j8N2sAl/45azj2LrvBf/fj6/zJBV3
         J0rA==
Content-Disposition: inline
In-Reply-To: <1382859876-28196-3-git-send-email-gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Lameter <cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Sun, Oct 27, 2013 at 12:44:35AM -0700, Greg Thelen wrote:
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

Ouch, nice catch.

 Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

We probably want to cc stable for this and the next one.  How should
these be routed?  I can take these through percpu tree or mm works
too.  Either way, it'd be best to route them together.

Thanks.

-- 
tejun
