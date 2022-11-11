From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [RFC PATCH 0/2] cpuset: Skip possible unwanted CPU-mask updates.
Date: Fri, 11 Nov 2022 16:34:08 +0100
Message-ID: <Y25rcHYzix+kAJF9@linutronix.de>
References: <20221102105530.1795429-1-bigeasy@linutronix.de>
 <d0b43b7d-54d3-00bd-abe0-78212ee9355a@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1668180850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=59Iz4/j0NOHHN0PdPEaGGuQ/fhXs7seeaEmnWOHDp2M=;
        b=UC5E0/wdAvQaO1L/gtvDbdCXHl/kOKFrL1zRJ8Pz7iMATdRmlU5Hhn06lzWztYbZkFRu01
        pixk2pSli683iWHKLw2kQ+VH9qKYAWaYmmb99QZmkP40cAe7VXTDUy+hFDk9Yy5ajlHrXM
        MYPX6Hst+r+TMNNO935n7sNO1ZksfR0/hfbHkKLIC49YpyCsX5/dzhF/26iiuOhPqRmfGw
        xFAPJWqUoU+Jq5Rq2l3G4HSSt2OcPGCHg8i2aNEHu1Y9cRjeKXdyOfiVJfIEgZXsruiDak
        dUM6XyOb5a7BRXCYcBnOAfNVWle912QQIznIjOYnCFqmbFDAgT2Lv9kh+Gp3qQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1668180850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=59Iz4/j0NOHHN0PdPEaGGuQ/fhXs7seeaEmnWOHDp2M=;
        b=cDYRWhTnoxSRtYCJuSO0Gang+LViOF8pM68k143EZTVhOZR2xjsr8dYSkEAFckIiIvw3xl
        9TvTqKp+hh+SAJAA==
Content-Disposition: inline
In-Reply-To: <d0b43b7d-54d3-00bd-abe0-78212ee9355a-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

On 2022-11-02 09:20:48 [-0400], Waiman Long wrote:
Hi,

> Yes, that is a known issue which is especially problematic when cgroup v2 is
> used. That is why I have recently posted a set of patches to enable
> persistent user requested affinity and they have been merged into tip:
> 
> 851a723e45d1 sched: Always clear user_cpus_ptr in do_set_cpus_allowed()
> da019032819a sched: Enforce user requested affinity
> 8f9ea86fdf99 sched: Always preserve the user requested cpumask
> 713a2e21a513 sched: Introduce affinity_context
> 5584e8ac2c68 sched: Add __releases annotations to affine_move_task()

> They should be able to address the problem that you list here. Please let me
> know if there are still problem remaining.

Thank you. This solves the most pressing issue. The CPU-mask is still
reset upon activation of the cpuset controller.
This is due to the set_cpus_allowed_ptr() in cpuset_attach().

Is is possible to push these patches stable?

> Thanks,
> Longman

Sebastian
