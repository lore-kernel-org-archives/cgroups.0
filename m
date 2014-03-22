From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 0/3] Per cgroup swap file support
Date: Sat, 22 Mar 2014 11:43:24 -0400
Message-ID: <20140322154324.GK4407@cmpxchg.org>
References: <1395442234-7493-1-git-send-email-yuzhao@google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=g10VG8cVr1NtNr3jzFX1UnLs74bMZKfOU0nwZ3D4Pmo=;
	b=CKqy9E1mpbP+cDMrfQdOtr+mIf419YAwpCoUm6yg0Z6tSpMC8S03IpdexyEwMd2DbInE9HrudC8uFAjyiCN184Slb+JHlHflnCDY8/K17ZthX+p9g9MkUxwFQyx2ucZTMcP2+BJM5trDkrqzirGI10WKm8aZ3zRiBMi9aqyO8QQ=;
Content-Disposition: inline
In-Reply-To: <1395442234-7493-1-git-send-email-yuzhao@google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Zhao <yuzhao@google.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, jamieliu@google.com, suleiman@google.com

Hello Yu!

On Fri, Mar 21, 2014 at 03:50:31PM -0700, Yu Zhao wrote:
> This series of patches adds support to configure a cgroup to swap to a
> particular file by using control file memory.swapfile.
> 
> A value of "default" in memory.swapfile indicates that this cgroup should
> use the default, system-wide, swap files. A value of "none" indicates that
> this cgroup should never swap. Other values are interpreted as the path
> to a private swap file that can only be used by the owner (and its children).
> 
> The swap file has to be created and swapon() has to be done on it with
> SWAP_FLAG_PRIVATE, before it can be used. This flag ensures that the swap
> file is private and does not get used by others.
> 
> Jamie Liu (1):
>   swap: do not store private swap files on swap_list
> 
> Suleiman Souhlal (2):
>   mm/swap: support per memory cgroup swapfiles
>   swap: Increase the maximum number of swap files to 8192.
> 
>  Documentation/cgroups/memory.txt  |  15 ++
>  arch/x86/include/asm/pgtable_64.h |  63 ++++++--
>  include/linux/memcontrol.h        |   2 +
>  include/linux/swap.h              |  45 +++---
>  mm/memcontrol.c                   |  76 ++++++++++
>  mm/memory.c                       |   3 +-
>  mm/shmem.c                        |   2 +-
>  mm/swap_state.c                   |   2 +-
>  mm/swapfile.c                     | 307 +++++++++++++++++++++++++++++++-------
>  mm/vmscan.c                       |   2 +-
>  10 files changed, 423 insertions(+), 94 deletions(-)

For feature patches like this, please include a rationale.  What is
this functionality good for, and who is going to use this?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
