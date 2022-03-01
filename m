From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: Explanation for difference between memcg swap accounting and
 smaps_rollup
Date: Tue, 1 Mar 2022 11:53:35 -0500
Message-ID: <Yh5Pj5Z6pXbUyfio@cmpxchg.org>
References: <12f7d0bef9340035b82a007cc37bd09c48d86c3f.camel@sipsolutions.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NBf4zMMtjHDXxe1QGY4+VAhDQU0P1h16it+M1Z5ezfk=;
        b=JlsDWggs0x19ThNsAcnAVPOtWKVoCdk27Gb/UtoTg5zblhrKphPa6ffd7zsHRqZdW9
         WeTSHEoX+wjpaAMYfetDfCwhDuBKy/xZc7004bh3Rfj5JA+tFuC0DkqxXasX+DC7VhUw
         78D71MUvqHc0ByixFnc8lAIHomB1zt0avWk3qw3fNik0nkORny6KgGP2qfxa/pQj317B
         hRy1+w6M9mx/vJwiHTuHWR70vS2izBh4TljfNt4WsiziktHJBW9ew8YPcKRqLDPBq2dE
         vKLXPDJ/+nrLU8EEX+Gp8oZGuza3Cs4YsFP7hiUdgPO+xX38LQXHyM6asHW6gZEMSVTz
         vy6Q==
Content-Disposition: inline
In-Reply-To: <12f7d0bef9340035b82a007cc37bd09c48d86c3f.camel-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Benjamin Berg <benjamin-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Anita Zhang <the.anitazha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi Benjamin,

On Fri, Feb 25, 2022 at 05:10:05PM +0100, Benjamin Berg wrote:
> Hi,
> 
> I am seeing memory.swap.current usages for the gnome-shell cgroup that
> seem high if I compare them to smaps_rollup for the contained
> processes. As I don't have an explanation, I thought I would ask here
> (shared memory?).
> 
> What I am seeing is (see below, after a tail /dev/zero):
> 
> memory.swap.current:
>   686MiB
> "Swap" lines from /proc/$pid/smaps_rollup added up:
>   435MiB
> 
> We should be moving launched applications out of the shell cgroup
> before doing execve(), so I think we can rule out that as a possible
> explanation.
>
> I am mostly curious as we currently do swap based kills using systemd-
> oomd. So if swap accounting for GNOME Shell is high, then it makes it a
> more likely target unfortunately.

Shared memory is one option. For example, when you access tmpfs files
with open() read() write() close() instead of mmap().

Another option is swapcache. When swap space is plentiful, the kernel
makes it hold on to copies of pages even after they've been swapped
back in. This way, the next time they need to get "swapped out", it
doesn't require any IO, it can just drop the in-memory copy. From an
smaps POV, swapped in pages are Rss, not Swap. But their swap copies
still contribute to memory.swap.current, hence the discrepancy.

In terms of OOM killing, the kernel will stop keeping swap copies
around when more than half of swap space is used. That should give
plenty of headroom toward the OOM killing thresholds.

If you want to poke around on your machine, here is a drgn script that
tallies up the cache-only swap entries:

---
#!/usr/bin/drgn

MAX_SWAPFILES=25
SWAP_HAS_CACHE=0x40

swapcache=0
for i in range(MAX_SWAPFILES):
    si = prog['swap_info'][i]
    if si:
        for offset in range(si.max.value_()):
            if si.swap_map[offset].value_() == SWAP_HAS_CACHE:
                swapcache += 1
print("Cache-only swap space: %.2fM" % (swapcache * 4 / 1024.0))
