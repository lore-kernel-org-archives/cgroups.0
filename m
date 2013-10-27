From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] memcg: use __this_cpu_sub to decrement stats
Date: Sun, 27 Oct 2013 07:24:29 -0400
Message-ID: <20131027112429.GC14934@mtj.dyndns.org>
References: <1382859876-28196-1-git-send-email-gthelen@google.com>
 <1382859876-28196-4-git-send-email-gthelen@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=XxajNU1qbdSeG/YQraqVGBVUuyFqE08bN/+JXPplYa0=;
        b=OvNHdl/tYJvY1x//DbQkjCNimlYlJAUB5OIg1Puxf7tKgGLZq3ZWZme/9KzmJUNXu/
         PcnM+T+kfYYqcELYJQooPuKdthv/3ekpPFtVDBgebFP7ghAZQQQR6uN45+aN+cjmywrN
         4pi+/wPQxJhlXrfYEIR/7+qMkpZcoo8MyHaKIIw1/vU4LtQpbiOUZX6M+8LdGs0rtADW
         uU8a7PeQxW4hq6j4tF1LRm33QaV5okV1iZ2SuGe+oP23OuEbVGwwPi3ds8pp5El/k0jG
         nHKZnWDtv0OxVD/HQvReXpYAYhyDvUMFot9EyPKLM4H4JazUW7BDHuuP2R1yhfEvuKF6
         HyVQ==
Content-Disposition: inline
In-Reply-To: <1382859876-28196-4-git-send-email-gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Lameter <cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Sun, Oct 27, 2013 at 12:44:36AM -0700, Greg Thelen wrote:
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
> negation.  This only works with the "percpu counter: cast
> this_cpu_sub() adjustment" patch which fixes this_cpu_sub().
> 
> Signed-off-by: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

 Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
