Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7153D9DB6
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 21:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788556476; cv=pass; b=iME2WvqfxvUYh0VplXh8aWeJ69TPlBiE1WvVBoj+vK6QOb8tv7zfVqSFtLAt7EGFp8l4emw2Otwf7V+0qsAjdi1Nkdmi5aAneBkjTUzP0VxPOyDgslHlBeXPB88yKcDUlJfWCub9UHpOlYg/A0FNGrLXpdSVVGYYwPMnIdcpDfA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788556476; c=relaxed/simple;
	bh=J9VFtep/IWj2GJMw0Sea79KrUdo7vEVbhUOsxUM+97o=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=QITsgkeLplcDw209ZSMQluSPmjRWvk0VlTsxynRa8cka0KiTl4TLCsyoCnYh7jHFFACk6mvmfOGxBqwpwyxC/wJzU1ItbK4HP7WxrXEDATx2uJLGLeFtOTTmYrs4tCBIRd0NBNz+JoKSpQEBwwTIodDDyLWWdrtlWzGrHIKcG5Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QssxZsWT; arc=pass smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QssxZsWT"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-495590dde14so21310785e9.0
        for <cgroups@vger.kernel.org>; Fri, 04 Sep 2026 14:14:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788556473; cv=none;
        d=google.com; s=arc-20260327;
        b=Uyv7PFdwLz4jEQluaXvnp6LFJRd7qfPp8Lu4ZbXqRvCYkRvX/w38mFDHcq8PdtmrpC
         jMyN1njY+m2RR3uYRfQUt+nbHtZpVY3Xfzsa7P50+S545I1y7jrsPIcvvdPUPu7I/wmN
         ClpsSJxYp4wxct+C2A4Eybl43yCabgGz4qwozVJw8rC9/ZqoSo3mEECHltaptJtfYgA8
         6nZhQqOT1FSBUwu6EZcBQCSnuBDZdpQtqdP2MTsX4iKRSlfP/CaU5NzxNVLzEgh7fmh0
         77IplCGnEQ8mEi8dX08/O7c/kn//UbFzbSl6jXDiyXuY0iXdPSc4eERwfWUf/mZZOV8z
         O8fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=bvjoQwE4ZDaiwAW0jTIm2X9dCshUZub+PI63iQkxm4U=;
        fh=JI3unwZIj+cvNQ5UC6ZyVWKlybe/0f+k8GnsTIe1q+Y=;
        b=Ng8dbH6KFHuCpuv3WRshDKNk2DWJdjoajbFUb62T3/HQnPo8GlKqHOK/T7YRTnXHx2
         oAqFXEzoG7ASd2TmqmqhhZV6vcgeMMX6oJP6/JmunQuuZRpqwfbUX8RwFyX3D9/2VZ/B
         rC2XcYkXOxUAJNjAlPcFNA6itICljhYhTI5yXBnfj/RkOEHpJ9txeDm10In/qq0mcrtJ
         LqGTqzYCLjOje23kd6k5JJbv7twkeEREmP8OV1fpMjfjcoVvwOY94UDFmeSa+i/NWJNA
         8eCO+vvMI2euU1LEbKOYZWZTEyBwRh2SGTbhj3X0qgSxlnAoMsURE7Bn9DIin6w/EdHb
         ut4A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788556473; x=1789161273; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bvjoQwE4ZDaiwAW0jTIm2X9dCshUZub+PI63iQkxm4U=;
        b=QssxZsWTt/t2Gvz6toYE8sG1n4g9FPjtmhU/EtdsGzm2jd9O8T11r/X7x1/GBGPZlk
         W8Uif77noYUVx1BChjgxunPSt3rIAfthyqmbfnV1ZD19V/11YLcSFYoPpAdWxY8+k+kF
         1dAvU+ywbGbOW9zmgnQenjJDt1IKhnmGM8IOLNTt4ETSExa6+bboBqa6tFPbK6tMPrG5
         wd0b0J4ExIbVmz65GySMc7zG3j+ehZCQ7UMjPQnSkin3H6CNkxDuhWPQ2u8B2tHvmw9M
         uf6CPHUzPWq9TnQ3NZb+S481sA7ex/D17nZt7hoflQd3uOzWkkmrRhyOrc2klvqVgLzW
         +K5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788556473; x=1789161273;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=bvjoQwE4ZDaiwAW0jTIm2X9dCshUZub+PI63iQkxm4U=;
        b=quUHBAqFmjpZPMdR0D0nMvdS+WWcEwEnMxWu1xsxlFLRqTmaths/+SMFVcu7knboQV
         XUhrwB5RXl86FW2zLua4vDcjYTZ3Ug9MMjTWvCtQU4qHd0Z4FXSUw0EEq36d3WrbUHyM
         UQuZPlz3PV95UKa2m+fbicX1cyoIzSAzXPx18cXFLfgl09USm9MMDQWMmdUbaSfiOMhE
         2nLuwmgq6enyLMUArlpNC05eICdanpZcj67By+gmdp/T/vXnsKLxQAsIRdzpu6e15XVs
         uwe0ZXG9bEkK3YixmW+afqom1zKIWej69NMctqYQVLEcB8qxdB/WwywDnCSylLaffcK1
         CIHA==
X-Forwarded-Encrypted: i=1; AKwUvByTAz9OjhjcuZow2LAd5lDWscJHjNoUMTs4GHi/wEtqsPPb36FwEnZ1G0aoRUTW6fe8WlEuinuX@vger.kernel.org
X-Gm-Message-State: AFuF++m64sIpHu4+Dw7L82t6cWYryju+kXI3zlaHmlcg4AOlow3Ftm3N
	Rvt/oZeUEJgEie4d6V5Vkr77zNGMhfPb+PLNSltMdSrrmPo8tZTa7h9HgCJfBXvtLmYAcgEwkfb
	ubS8zagIiIdgjhmVF58udDvHRl9wG4JS6kpkvlms=
X-Gm-Gg: AYBFou3SBIkVKnmO5a2eBRyaG4QCeSV0Wr+AO75BivPHPnJHErNVg0P4ttkrEfoVGFL
	pcAxTxkjLL8I7LCCZrMy8ItNlvP2QKpVDHrnN8VmdsU/K2x9pABUwnvwEX5GrlEb+nTDtOLZniv
	gQTCyfbFcrmxV0QtxzalMXZo3sUWB15Mo2F/SbGTFqqauqqtSDgQgca2ht15mCBWeW8yAnaBp0o
	DJ+yoio25rpK9gXrdFJnTfqs0izp3Y35jNLKb4scTkbm5GAxWxfWJHztn7zq9zj27Mo3ePheFfG
	HyvRJ6hr7beLDdd+2CQCy7z13/ts7QpDKCFCse5x5HYaIYRL3s/gfBi7UqG1Mxcj1Vrpxa3X1yo
	D
X-Received: by 2002:a05:6000:29d9:b0:484:3310:710f with SMTP id
 ffacd0b85a97d-485872934dcmr13557408f8f.27.1788556472698; Fri, 04 Sep 2026
 14:14:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 4 Sep 2026 14:14:20 -0700
X-Gm-Features: AcwNN1VfnacCjCOIsG0-NjVV5-93v6OYjHgRMeo0vufw1HSKHHIhU85YeFRiLtM
Message-ID: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
Subject: Path forward for Virtualized Swap?
To: Kairui Song <kasong@tencent.com>
Cc: Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"

To Kairui, Johannes, Yosry, Chris, David, Andrew, and other (z)swap folks -
I need some help here.

I'd like to ask for a decision, or failing that, the specific thing that
would get us to one. I'd much rather work against a concrete objection than
keep respinning into silence.

Quick recap: today a swapped-out page holds a disk slot even when the data
never reaches disk, like zswap or zero-filled pages. My patch series
(latest version at [10]) puts a virtual entry in the page table instead and
resolves the backing separately, so zswap stops reserving disk it never
uses and can work on machines with no storage swap space at all.

I've been working on this since April 2025, going through 10 revisions (6
on the original design ([1] through [6]) and 4 on the swap-table-based
rewrite ([7] through [10])). I also gave a talk on it at LPC [11].

Throughout the process, I've been very receptive to reviewers - including
parties whose use cases are very different from my own, like zram users and
the ghost-swapfile-style deployments that want zswap with no backing disk
at all - and the current design reflects that:

* Kairui asked that this be optional, not a replacement [12]. It is now:
  vswap is opt-in behind the vswap= cmdline parameter, and with vswap=off
  the existing swap paths aren't touched at all.

* Kairui also pointed out that if I kept shrinking the metadata I'd "end up
  reimplementing the swap table format" [12]. I took that feedback, and
  reworked the entire series on top of swap table.

* Per Chris' requests, I've figured out ways to minimize memory overhead
  [13]. On a zswap-only setup there's almost 0 overhead now, because the
  vtable is merged with zswap's xarray rather than sitting on top of it.
  The indirection is paid for by the tree we delete.

* Johannes pointed out that a physical cluster backing only vswap entries
  still had to allocate a memcg_table, which was an overhead regression
  against my older design on the zswap writeback case [14] (since a swap
  entry occupies multiple levels). I've also fixed this.

* I've spent a lot of time chasing regressions on setups we don't even run
  at Meta - zram in particular [6]. And if anyone's still worried after all
  that, vswap=off keeps the old swap code available.

Numbers are in the v4 cover letter [10]. In terms of performance, vswap is
on par or better than baseline on zswap across memhog, usemem and kernel
build, and vswap=off tracks baseline within noise. I've even included an
A/B experiment on a real production workload (Instagram/django): throughput
on par, latency slightly better, and the swapfile footprint for every zswap
user on the host goes away.

Now, on xswap. Baoquan's working on a series [15] that covers some of the
same ground, and the VM_SPARSE cluster_info idea in it is genuinely good.
I've been reviewing that lineage since July [16] and I'd like whatever
lands to end up with the best parts of both. From my perspective the
differences are:

1. Userspace knobs. xswap asks the admin for a size (a percent of RAM) plus
   a per-device limit to tune afterwards. I'm not aware of any use case
   that needs those, and I don't think users have a good way to answer the
   question anyway - sizing swap for compressed memory depends on memory
   size, workload, and compression ratio all at once. That's precisely the
   provisioning problem vswap exists to remove. The kernel should be as
   transparent and dynamic as possible here, and not add knobs unless
   there's a use case for them.

2. Writeback support. Writeback is core functionality for zswap, not an
   add-on, and a design needs to account for it from the start. This came
   up before, in the discussion around Chris' ghost swapfile RFC [17]: for
   a solution here to be acceptable, it has to work with the primary
   usecase and support disk writeback. Without it, whatever zswap won't
   take (incompressible pages especially) has nowhere to go, and cold
   compressed data can never leave RAM.

3. Cgroup charging behavior. vswap/xswap shouldn't be charged against the
   swap usage counter. It's fundamentally a different resource from
   physical swapfile space, and memory.swap.* should read 0 when nothing is
   on disk [18]. I made the longer argument for this in [19].

4. Data structure (xarray vs sparse vmalloc array). Even with xarray, vswap
   is already on par with or beating baseline. I like the sparse array
   idea, but why are we landing an optimization before the feature itself,
   without any A/B data showing the difference matters?

One thing I do want to be clear about: I'm glad other people care about
this problem. Chris' ghost swapfile and Baoquan's xswap are both going
after the same set of problems, and that's a good sign. It means this is
real and shared, not something only Meta runs into.

What's been harder is the shape of the engagement. Alternatives keep
getting posted and pushed that don't cover all the requirements, while this
series sits without review. I don't think I'm owed anyone's interest in the
problems I care about. But I do think working code, with benchmarks and
production exposure behind it, deserves a fair hearing next to in-progress
proposals.

So what I'm asking for: I'd like us to converge rather than keep two series
in flight. My preference is that we land vswap first, then build Baoquan's
sparse array on top of it as an optimization. That gets the feature in, and
by then we'd have the A/B data to show whether the sparse array actually
beats the xarray.

If you think that's the wrong order, I'd genuinely like to understand why -
after 17 months and 10 revisions I still don't have a clear picture of the
objection.

[1] https://lore.kernel.org/all/20250407234223.1059191-1-nphamcs@gmail.com/
[2] https://lore.kernel.org/all/20250429233848.3093350-1-nphamcs@gmail.com/
[3] https://lore.kernel.org/all/20260208215839.87595-1-nphamcs@gmail.com/
[4] https://lore.kernel.org/all/20260318222953.441758-1-nphamcs@gmail.com/
[5] https://lore.kernel.org/all/20260320192735.748051-1-nphamcs@gmail.com/
[6] https://lore.kernel.org/all/20260505153854.1612033-1-nphamcs@gmail.com/
[7] https://lore.kernel.org/all/20260528212955.1912856-1-nphamcs@gmail.com/
[8] https://lore.kernel.org/all/20260612193738.2183968-1-nphamcs@gmail.com/
[9] https://lore.kernel.org/all/20260806184254.3790858-1-nphamcs@gmail.com/
[10] https://lore.kernel.org/all/20260825153238.2695446-1-nphamcs@gmail.com/
[11] https://lwn.net/Articles/1016136/
[12] https://lore.kernel.org/all/CAMgjq7AQNGK-a=AOgvn4-V+zGO21QMbMTVbrYSW_R2oDSLoC+A@mail.gmail.com/
[13] https://lore.kernel.org/all/CACePvbVXQWgcPD-bgK7iDba4NFLo2tT89ZbLOa03maJU4er4ag@mail.gmail.com/
[14] https://lore.kernel.org/all/aZyFxKGXc8J6PIij@cmpxchg.org/
[15] https://lore.kernel.org/all/20260827094509.1016740-1-hebaoquan@kylinos.cn/
[16] https://lore.kernel.org/lkml/CAKEwX=Pe+qMZd2xhnU-PAGQtgXkp56c-JwYCbt2Lux9htgB67Q@mail.gmail.com/
[17] https://lore.kernel.org/all/20251121114011.GA71307@cmpxchg.org/
[18] https://lore.kernel.org/all/anYIboHEUZb4fhHv@cmpxchg.org/
[19] https://lore.kernel.org/all/CAKEwX=P4syV38jAVCWq198r2OHXXc=xA-fx1dk6+qYef6yzxWQ@mail.gmail.com/
