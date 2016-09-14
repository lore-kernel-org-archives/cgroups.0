From: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Subject: blkcg throttle settings page cache writes
Date: Wed, 14 Sep 2016 11:25:49 +0300
Message-ID: <57D9098D.3020403@kyup.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, SiteGround Operations <operations-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>

Hello,

I'm observing blkcg throttle limits to not apply on writes which go
through the page cache. E.g. I have a container whose write iops limits
are set to 300 I then run a fio job with direct=0 (the default) and can
see that writes/s (via iostat) are around 6-7k. Tracing confirmed thae
AIO that fio is submitting is being handled by a kworker thread, which
is in the root cgroup and as such has no lio limits. Direct writes/reads
work as expected and are throttled.

After Paolo Valente's patch
(https://patchwork.kernel.org/patch/9249247/) I was left with the
impression that bios submitted would just carry the information of the
submitted throughout the storage stack. Apparently this is not the case.
I also went through an old thread I started on dm-devel dealing with
this exact problem (even before Paolo's patch), where Vivel Goyal hinted
at this particular problem :
https://www.redhat.com/archives/dm-devel/2016-March/msg00012.html

So Tejun, my question is what is the problem for the blkcg information
to be transferred alongside the bio (which I believed to be happening
with the blkcg_association calls) so that even buffered writes are
throttled via the cgroup policies? Or are the numbers I'm seeing in
iostat actually the writes to the page-cache and not the underlying
block device?

Regards,
Nikolay
