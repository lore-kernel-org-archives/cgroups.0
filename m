From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/6] memcg: bypass root memcg page stat accounting
Date: Tue, 12 Mar 2013 18:06:13 +0800
Message-ID: <1363082773-3598-1-git-send-email-handai.szj@taobao.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer;
        bh=+3dLN+DndP8km22ZQ3MnwtGy1zaC0NKhCGIiLS9zdeA=;
        b=xuVMve3Yu0p/kNmcAfDmEYKdqFAbbsx2Q5LUSQih5Hq14ZSS6tjeot7HxKLQ144jVP
         Xf8mBuzdUFhSw5fEunH0IL36Q0OPTZUuWrwnkM7IDVuzezZ9DcXdqkIMwmuti2EWcLnO
         3mdr6cru/1rMAbZ8641ERZj54N1zm6bOJiHsWsrmDDZBYY4lvsGoh9oRsyXddSeSpZDT
         Wf7HafwRIGw/uni37xxBUY2q3kXT64rW/pbrY66THBRnil01tdpMA0LcXFVwOQBso/FT
         FPKcpd8wZsUAMziI6Y4gNEynUxAPnQPfTL+TRIzoS3j0zaxtSWYypcRf+SoGkISmXqex
         mCsQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: mhocko-AlSwsSmVLrQ@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Hi,

As we all know, if memcg is enabled but without any non-root memcgs,
all allocated pages belong to root memcg and go through root memcg
statistic routines which brings some overheads.

In this pathset we try to give up accounting stats of root memcg
including CACHE/RSS/SWAP/FILE_MAPPED/PGFAULT/PGMAJFAULT(First attempt
can be found here: https://lkml.org/lkml/2012/12/25/103). But we need
to pay special attention while showing these root memcg numbers in
memcg_stat_show(): as we don't account root memcg stats
anymore, the root_mem_cgroup->stat numbers are actually 0. But we can
fake these figures by using stats of global state and all other memcgs.
Take CACHE stats for example, that is for root memcg:

	nr(MEM_CGROUP_STAT_CACHE) = global_page_state(NR_FILE_PAGES) -
                              sum_of_all_memcg(MEM_CGROUP_STAT_CACHE);

On a 4g memory and 4-core i5 CPU machine, we run Mel's pft test for
performance numbers:

nomemcg  : memcg compile disabled.
vanilla  : memcg enabled, patch not applied.
optimized: memcg enabled, with patch applied.

             optimized    vanilla 
User          405.15      431.27 
System         71.71       73.00 
Elapsed       483.23      510.00 

             optimized    nomemcg 
User          405.15      390.68 
System         71.71       67.21 
Elapsed       483.23      466.15 

Note that elapsed time reduce considerably from 510 to 483 after pathes
have been applied(about ~5%). But there is still some gap between the
patched and memcg-disabled kernel, and we can also do some further works
here(the left-over stats like PGPGIN/PGPGOUT).

I split the patchset to several parts mainly based on their accounting
entry function for the convenience of review:

Sha Zhengju (6):
	memcg: use global stat directly for root memcg usage
	memcg: Don't account root memcg CACHE/RSS stats
	memcg: Don't account root memcg MEM_CGROUP_STAT_FILE_MAPPED stats
	memcg: Don't account root memcg swap stats
	memcg: Don't account root memcg PGFAULT/PGMAJFAULT
	memcg: disable memcg page stat accounting

 include/linux/memcontrol.h |   23 +++++++
 mm/memcontrol.c            |  149 +++++++++++++++++++++++++++++++++++++-------
 2 files changed, 149 insertions(+), 23 deletions(-) 
