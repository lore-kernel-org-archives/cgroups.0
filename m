From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 2/3] percpu: fix this_cpu_sub() subtrahend casting for
 unsigneds
Date: Tue, 29 Oct 2013 10:26:44 -0400
Message-ID: <20131029142644.GB1548@cmpxchg.org>
References: <1382895017-19067-1-git-send-email-gthelen@google.com>
 <1382895017-19067-3-git-send-email-gthelen@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=Jcl7wRr7M1JyuLZiOtu1SKauIJkRc36Jn1UbG/+2dCE=;
	b=qt7qf4F7Gj/yKm8DcuQZLQUQV/yJnHaQ18f2OCFEIrCccaYrfzx3arC/c7LRXyIcft/6cLwaslkNhqBu7Ld97P7TqyC+gkQSRDPH/g1QgDzHRCQPHyUzadZjA5AozdJZY49YTJcsIJ3zRbqtaVubn2KYMfaYc4/BQB4BqrZwCKo=;
Content-Disposition: inline
In-Reply-To: <1382895017-19067-3-git-send-email-gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Sun, Oct 27, 2013 at 10:30:16AM -0700, Greg Thelen wrote:
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
>   __this_cpu_sub_return()
>   this_cpu_sub_return()
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
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

FWIW:

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
