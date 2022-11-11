From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [RFC PATCH 0/2] cpuset: Skip possible unwanted CPU-mask updates.
Date: Fri, 11 Nov 2022 17:49:37 +0100
Message-ID: <Y259IcCb937bw3AZ@linutronix.de>
References: <20221102105530.1795429-1-bigeasy@linutronix.de>
 <d0b43b7d-54d3-00bd-abe0-78212ee9355a@redhat.com>
 <Y25rcHYzix+kAJF9@linutronix.de>
 <6948de71-a3e3-b6c2-bc67-1bb39cbdff69@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1668185378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=by5QqL9du6glqSYYKGtrnRKbCf8L3MRSLJ1pR1GLmhU=;
        b=1idBG7W72aOfhjnPjmpTrC+XQm01QjleZeeywZhW9FqSM8vO0jtzcH5/qdm9f2MT3idOv8
        wv29xZwiFvLHqEl7mE9jiSrqFJX45oII4Xt/pfKXsZXrtSZ1Cil+SfvL/FUSQZ9HT8QYI+
        wEjh3wiTAdWikzAEO8zONhNRlv31f4UXekIuv5TMYCD+LgKTn2HzvjD41NWJfUhweK1nbE
        PXZx/7O8jtBkAXNL1OP+nUnSfm4nCgApb0x9AIh427y+O/tec9H60TUtkWJXv7M9Jo+FpG
        t/C2jiA26FnJ42s4FytOUgLOrR7fp2/M6uTzyu4PcWU1jPKxXOkgIMb9P62vog==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1668185378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=by5QqL9du6glqSYYKGtrnRKbCf8L3MRSLJ1pR1GLmhU=;
        b=qxpl5BK/7KQuq4cV7JAAwdZPpn9yRQ6248uMdajM8qFsJpVLhT3oiZqUoFnv+1YwIhfhQX
        JSYy8Y6eNs3dsRBg==
Content-Disposition: inline
In-Reply-To: <6948de71-a3e3-b6c2-bc67-1bb39cbdff69-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

On 2022-11-11 11:37:03 [-0500], Waiman Long wrote:
> 
> On 11/11/22 10:34, Sebastian Andrzej Siewior wrote:
> > On 2022-11-02 09:20:48 [-0400], Waiman Long wrote:
> > Hi,
> > 
> > > Yes, that is a known issue which is especially problematic when cgroup v2 is
> > > used. That is why I have recently posted a set of patches to enable
> > > persistent user requested affinity and they have been merged into tip:
> > > 
> > > 851a723e45d1 sched: Always clear user_cpus_ptr in do_set_cpus_allowed()
> > > da019032819a sched: Enforce user requested affinity
> > > 8f9ea86fdf99 sched: Always preserve the user requested cpumask
> > > 713a2e21a513 sched: Introduce affinity_context
> > > 5584e8ac2c68 sched: Add __releases annotations to affine_move_task()
> > > They should be able to address the problem that you list here. Please let me
> > > know if there are still problem remaining.
> > Thank you. This solves the most pressing issue. The CPU-mask is still
> > reset upon activation of the cpuset controller.
> > This is due to the set_cpus_allowed_ptr() in cpuset_attach().
> > 
> > Is is possible to push these patches stable?
> 
> Actually, I prefer to not call set_cpus_allowed_ptr() if the cpumask of the
> old and new cpusets are the same. That will save some cpu cycles. Similarly
> for node_mask. If there is any changes in the cpumask, we have to call
> set_cpus_allowed_ptr(). I will work out a patch to that effect when I have
> spare cycle.

But couldn't we skip that set_cpus_allowed_ptr() if the current mask is
a subset of the new mask and keep the behavior that the mask isn't
changed if the cgroup's mask changes but is still a subset?
That cpuset_attach() callback is only invoked while the task is
initially added to the cgroup which happens during enabling of the
controller. Or do I miss another common usecase?

> Thanks,
> Longman

Sebastian
