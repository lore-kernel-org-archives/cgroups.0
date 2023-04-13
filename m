From: Michael Honaker <mchonaker-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cgroup: Clarification around usage_in_bytes and its relation to the
 page counter
Date: Wed, 12 Apr 2023 21:22:07 -0400
Message-ID: <CAAKLMZ1fM1d4Drw0D2AkEwAG9iFOyT9qboy1REWtwS6Q00BA6Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681348939; x=1683940939;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yuLz9iUc1y0EzGD8AvN7Y9hf2MbqyBOWJrZZ7t76bGM=;
        b=Qm1WsHGG7Yawgtzf4UmTBwdzPBribr4bXLa944+d8dBqQyTYUQfDHQZajmMCidQnYP
         xxG5hyrsJ2DK2CdZYveJeig/i6zy/sZrjcBmabkbeSIMyEFp++itkqfydZVNXe1Xwalf
         GwmnvJaELevvy9wCBHSGrGpeZy3su2Ctk+vz0EeQ1emZnnqtL8VPrGgjv+EOD4tVAZKw
         K6KcRffpQddB4a3aHCnM2MLlY4SMpNcrxIF6I/VByUKw7OBIzoCx18lRrzYobBBdisIz
         9efZAtqGXAEit6kb/SQ9r3xk8M9yDb40noKlzK+qv9CqBfC3IYeinDiA16mzgJPo4cEZ
         MlAA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

This is my first posting to the LKML, so please let me know if this
should be asked
elsewhere or if there is anything else wrong with my email. I'd like
to confirm my understanding on an issue
I've been encountering.

I have been trying to get an accurate measurement of memory usage of a
non-root cgroup, specifically a Kubernetes container, and noticed some
inconsistencies when comparing the
value of `memory.usage_in_bytes` with the information in
`memory.stat`. After further investigation of
the cgroup docs (/admin-guide/cgroups/memory.rst#usage_in_bytes) and
an old LMKL thread ("real meaning
of memory.usage_in_bytes"), I came to the understanding that
`usage_in_bytes` actually shows the value
of the resource counter which is an overestimation due to the counter
being split into per-cpu chunks
for caching, and that the real usage can be calculated from RSS+Cache
gathered from `memory.stat`.
I've created cadvisor issue #3286
(https://github.com/google/cadvisor/issues/3286) which goes into
greater detail on my investigation with examples.

Is the above understanding still correct with the new page counters?
If so, could any memory
allocations be reflected in `usage_in_bytes` but not in `stat` for
child cgroups? I want to ensure I'm not
missing anything by only monitoring the `stat` file.

Thank you for any clarification or corrections.
