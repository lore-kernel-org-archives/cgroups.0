From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [External] Re: [PATCH] cgroup/rstat: record the cumulative
 per-cpu time of cgroup and its descendants
Date: Tue, 18 Jul 2023 11:53:26 -1000
Message-ID: <ZLcJ1nH8KzWzoQWj@slm.duckdns.org>
References: <20230717093612.40846-1-jiahao.os@bytedance.com>
 <ZLWb-LsBD041hMvr@slm.duckdns.org>
 <2655026d-6ae4-c14c-95b0-4177eefa434f@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689717209; x=1692309209;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hSi1Ye4tnidz3swlAKJl5aSHuZF44JYEhatv2BKTlOQ=;
        b=SZ0tTu6wpG2yNC7ys9W1/E8S7xaA6eRzb41+qynFT6suIRQZeKbOi/JHgHB2znyz8z
         sUXssVqsuJP79/tRbGRSdAxYoaLQyXa6sNibrztdE7BEm/gXgZlwo7jGSTxBQtgBSoNw
         P4GAbZI5hNvN10ddluCGqgqbmEB5PMDz4Hp1Vj9REZzygM2MS72ejDUlmt+iG5AyPuI/
         AG+lCdH0/6kVacWDcXfg62XMDmnOA+SE8ABAWGn9ktSCp5k8m5BvLQs5h4qRVA/ecBvP
         xY1uHKVfNHWnUQ1SkV7uDA8afxAbyaeycd4JwPnApcmgJjFSv4xHlIM9djPegdDlI8G3
         kQbw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2655026d-6ae4-c14c-95b0-4177eefa434f-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Jia <jiahao.os-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jul 18, 2023 at 06:08:50PM +0800, Hao Jia wrote:
> https://github.com/jiaozhouxiaojia/cgv2-stat-percpu_test/tree/main

Isn't that just adding the same numbers twice and verifying that? Maybe I'm
misunderstanding you. Here's a simpler case:

  # cd /sys/fs/cgroup
  # mkdir -p asdf/test0
  # grep usage_usec asdf/test0/cpu.stat
  usage_usec 0
  # echo $$ > asdf/test0/cgroup.procs
  # stress -c 1 & sleep 1; kill %%
  [1] 122329
  stress: info: [122329] dispatching hogs: 1 cpu, 0 io, 0 vm, 0 hdd
  # grep usage_usec asdf/test0/cpu.stat
  usage_usec 1000956
  [1]+  Terminated              stress -c 1
  # grep usage_usec asdf/cpu.stat
  usage_usec 1002548
  # echo $$ > /sys/fs/cgroup/cgroup.procs
  # rmdir asdf/test0
  # grep usage_usec asdf/cpu.stat
  usage_usec 1006338

So, we run `stress -c 1` for 1 second in the asdf/test0 cgroup and
asdf/cpu.stat correctly reports the cumulative usage. After removing
asdf/test0 cgroup, asdf's usage_usec is still there. What's missing here?
What are you adding?

Thanks.

-- 
tejun
