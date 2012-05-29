From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v3 16/28] memcg: kmem controller charge/uncharge
 infrastructure
Date: Tue, 29 May 2012 09:47:38 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1205290944040.4666@router.home>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-17-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1338302862; bh=MBlP9E3IvI25ss39I0kwyP1ky5cCztzJ5rK0MtXEmAU=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=ROvS8uVVUkOOwwQ26BnhxrZXtwT/OlVfAp6rDR1yx3ocnkKQ5NxRHf0EWzAR1SCjdy4PpnLHWEntaaULkEE6io1HxaqG117X+OEbxL7rrH9RnNGHx5GwD1SLX89KC5XIdjDM/6yISCrArHc7DlymCZ7hknZsry3Ymgl7OXBP+1A=
In-Reply-To: <1337951028-3427-17-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>, Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@cs.helsinki.fi>

On Fri, 25 May 2012, Glauber Costa wrote:

> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -696,7 +696,7 @@ config CGROUP_MEM_RES_CTLR_SWAP_ENABLED
>  	  then swapaccount=0 does the trick).
>  config CGROUP_MEM_RES_CTLR_KMEM
>  	bool "Memory Resource Controller Kernel Memory accounting (EXPERIMENTAL)"
> -	depends on CGROUP_MEM_RES_CTLR && EXPERIMENTAL
> +	depends on CGROUP_MEM_RES_CTLR && EXPERIMENTAL && !SLOB
>  	default n

Ok so SLOB is not supported at all.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
