From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -next] writeback: fix -Wformat compilation warnings
Date: Thu, 14 Nov 2019 11:21:18 -0800
Message-ID: <20191114192118.GK4163745@devbig004.ftw2.facebook.com>
References: <1573751861-10303-1-git-send-email-cai@lca.pw>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=V8JOYrhFKJZsjLpy3zbICgm56f832zoaBb4LCM6R/wE=;
        b=SSPWq/TOhRhkWt64BoCNntBWMb/TucJ3AIdHYBXY2nyWahkTra09hFT8GSEsnolfnM
         xD4C/j9iKWF72fTVou2+nt+/RsWRC+pDpOOaOTEmLX/TiN06RAsPWbN1SGpX2IGMDH+A
         5WlVvsj2+2L0ufhWln/MYkO13Ie8z2hOaGr6N6H1Sw3QVcIaSwEbn/pxeaKEc8NZMTIq
         5xmtxuj3Rk2WBNAhicO9mPb+pg7s8lub70oiaCN0Kwe6rdb92t+SjQvGsMiyB2THTDrc
         uSN/dNw4lQuOeskHze8uTQtjD5stAKCzHc0EPVaiszH2k3oZ1IH0C37Lguc88/qZe+wV
         R6vw==
Content-Disposition: inline
In-Reply-To: <1573751861-10303-1-git-send-email-cai@lca.pw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qian Cai <cai@lca.pw>
Cc: jack@suse.cz, gregkh@linuxfoundation.org, cgroups@vger.kernel.org, heiko.carstens@de.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com, linux-s390@vger.kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org

On Thu, Nov 14, 2019 at 12:17:41PM -0500, Qian Cai wrote:
> The commit f05499a06fb4 ("writeback: use ino_t for inodes in
> tracepoints") introduced a lot of GCC compilation warnings on s390,
> 
> In file included from ./include/trace/define_trace.h:102,
>                  from ./include/trace/events/writeback.h:904,
>                  from fs/fs-writeback.c:82:
> ./include/trace/events/writeback.h: In function
> 'trace_raw_output_writeback_page_template':
> ./include/trace/events/writeback.h:76:12: warning: format '%lu' expects
> argument of type 'long unsigned int', but argument 4 has type 'ino_t'
> {aka 'unsigned int'} [-Wformat=]
>   TP_printk("bdi %s: ino=%lu index=%lu",
>             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> ./include/trace/trace_events.h:360:22: note: in definition of macro
> 'DECLARE_EVENT_CLASS'
>   trace_seq_printf(s, print);     \
>                       ^~~~~
> ./include/trace/events/writeback.h:76:2: note: in expansion of macro
> 'TP_printk'
>   TP_printk("bdi %s: ino=%lu index=%lu",
>   ^~~~~~~~~
> 
> Fix them by adding necessary casts where ino_t could be either "unsigned
> int" or "unsigned long".
> 
> Fixes: f05499a06fb4 ("writeback: use ino_t for inodes in tracepoints")
> Signed-off-by: Qian Cai <cai@lca.pw>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
