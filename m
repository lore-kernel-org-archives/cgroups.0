From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 3/3] memcg: use __this_cpu_sub() to dec stats to avoid
 incorrect subtrahend casting
Date: Tue, 29 Oct 2013 10:28:50 -0400
Message-ID: <20131029142850.GC1548@cmpxchg.org>
References: <1382895017-19067-1-git-send-email-gthelen@google.com>
 <1382895017-19067-4-git-send-email-gthelen@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=/E6nQxbRgGl3ExiQd8ni+c6I9tXk4nRg0IFDQDfkt4Q=;
	b=iwji+rbDyDRTtk/rHVbU7CKEtdPzxLfkyNe8YJO2KaciibEc4aUZLJz48iI3AOLBntYgY50cwd4XYppRS4PcLHpYE2eYqbW/3BMiS5tIYDNiiObKRXf1hMDM+hmJEj4B6LNUIBo1HEqpbmTaP5OY1HLYIX84JHwOop8fn2waHTw=;
Content-Disposition: inline
In-Reply-To: <1382895017-19067-4-git-send-email-gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Sun, Oct 27, 2013 at 10:30:17AM -0700, Greg Thelen wrote:
> As of v3.11-9444-g3ea67d0 "memcg: add per cgroup writeback pages
> accounting" memcg counter errors are possible when moving charged
> memory to a different memcg.  Charge movement occurs when processing
> writes to memory.force_empty, moving tasks to a memcg with
> memcg.move_charge_at_immigrate=1, or memcg deletion.  An example
> showing error after memory.force_empty:
>   $ cd /sys/fs/cgroup/memory
>   $ mkdir x
>   $ rm /data/tmp/file
>   $ (echo $BASHPID >> x/tasks && exec mmap_writer /data/tmp/file 1M) &
>   [1] 13600
>   $ grep ^mapped x/memory.stat
>   mapped_file 1048576
>   $ echo 13600 > tasks
>   $ echo 1 > x/memory.force_empty
>   $ grep ^mapped x/memory.stat
>   mapped_file 4503599627370496
> 
> mapped_file should end with 0.
>   4503599627370496 == 0x10,0000,0000,0000 == 0x100,0000,0000 pages
>   1048576          == 0x10,0000           == 0x100 pages
> 
> This issue only affects the source memcg on 64 bit machines; the
> destination memcg counters are correct.  So the rmdir case is not too
> important because such counters are soon disappearing with the entire
> memcg.  But the memcg.force_empty and
> memory.move_charge_at_immigrate=1 cases are larger problems as the
> bogus counters are visible for the (possibly long) remaining life of
> the source memcg.
> 
> The problem is due to memcg use of __this_cpu_from(.., -nr_pages),
> which is subtly wrong because it subtracts the unsigned int nr_pages
> (either -1 or -512 for THP) from a signed long percpu counter.  When
> nr_pages=-1, -nr_pages=0xffffffff.  On 64 bit machines
> stat->count[idx] is signed 64 bit.  So memcg's attempt to simply
> decrement a count (e.g. from 1 to 0) boils down to:
>   long count = 1
>   unsigned int nr_pages = 1
>   count += -nr_pages  /* -nr_pages == 0xffff,ffff */
>   count is now 0x1,0000,0000 instead of 0
> 
> The fix is to subtract the unsigned page count rather than adding its
> negation.  This only works once "percpu: fix this_cpu_sub() subtrahend
> casting for unsigneds" is applied to fix this_cpu_sub().
> 
> Signed-off-by: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Huh, it looked so innocent...  At first I thought 2/3 would fix this
case as well but the cast happens only after the negation, so the sign
extension does not happen.  Alright, then.

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
