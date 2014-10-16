From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [patch 3/3] kernel: res_counter: remove the unused API
Date: Thu, 16 Oct 2014 09:20:34 +0200
Message-ID: <1413444034.2128.27.camel@x220>
References: <1413251163-8517-1-git-send-email-hannes@cmpxchg.org>
	 <1413251163-8517-4-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1413251163-8517-4-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Mon, 2014-10-13 at 21:46 -0400, Johannes Weiner wrote:
> All memory accounting and limiting has been switched over to the
> lockless page counters.  Bye, res_counter!
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Vladimir Davydov <vdavydov@parallels.com>
> Acked-by: Michal Hocko <mhocko@suse.cz>

This patch landed in today's linux-next (ie, next 20141016).

>  Documentation/cgroups/resource_counter.txt | 197 -------------------------
>  include/linux/res_counter.h                | 223 -----------------------------
>  init/Kconfig                               |   6 -
>  kernel/Makefile                            |   1 -
>  kernel/res_counter.c                       | 211 ---------------------------
>  5 files changed, 638 deletions(-)
>  delete mode 100644 Documentation/cgroups/resource_counter.txt
>  delete mode 100644 include/linux/res_counter.h
>  delete mode 100644 kernel/res_counter.c

There's a last reference to CONFIG_RESOURCE_COUNTERS in
Documentation/cgroups/memory.txt. That reference could be dropped too,
couldn't it?


Paul Bolle

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
