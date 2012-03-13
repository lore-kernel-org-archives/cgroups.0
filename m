From: Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH v2 02/13] memcg: Kernel memory accounting infrastructure.
Date: Tue, 13 Mar 2012 10:00:58 -0700
Message-ID: <xr93d38g77w5.fsf@gthelen.mtv.corp.google.com>
References: <1331325556-16447-1-git-send-email-ssouhlal@FreeBSD.org>
	<1331325556-16447-3-git-send-email-ssouhlal@FreeBSD.org>
	<4F5C5E54.2020408@parallels.com>
	<20120313152446.28b0d696.kamezawa.hiroyu@jp.fujitsu.com>
	<4F5F236A.1070609@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        bh=XHHB83yI/FbBFLMYhyPa4RhISx3Mf5B/hyOZ45cTYFw=;
        b=lsCPX6nVCl4mt9IHDJEArWVHr8gtNmxJXXxWcZLfA9caOBImyIE8MNPKmCSuxjNP5v
         dnnIxV9S0exhG+MmaP2csNc6yafWU4uasDQj4izludozYAsYe9IYuD1+nI1/oPZMtVFB
         JH7iPBBkQQAUimneXOnpI5FFx4I4A9htw0Ar89qIcrU3o9+ZcVnQmW+SWws/9mrj4QR6
         fg5Xi6ZHgZkaUQ5iqeBX045neLQCe235Ck9i8FateXq2ThV74oIuwUNEBkYupdEfKZDn
         js+NLt3vdStqg6AqwmRjVZMuPZPfG7ZFrNcbIjVZcJaSCQcX/nHkgK+200zaeP5Glfod
         Q9GQ==
In-Reply-To: <4F5F236A.1070609@parallels.com> (Glauber Costa's message of
	"Tue, 13 Mar 2012 14:37:30 +0400")
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Suleiman Souhlal <ssouhlal@FreeBSD.org>, cgroups@vger.kernel.org, suleiman@google.com, penberg@kernel.org, cl@linux.com, yinghan@google.com, hughd@google.com, peterz@infradead.org, dan.magenheimer@oracle.com, hannes@cmpxchg.org, mgorman@suse.de, James.Bottomley@HansenPartnership.com, linux-mm@kvack.org, devel@openvz.org, linux-kernel@vger.kernel.org, rientjes@google.com

Glauber Costa <glommer@parallels.com> writes:
> 2) For the kernel itself, we are mostly concerned that a malicious container may
> pin into memory big amounts of kernel memory which is, ultimately,
> unreclaimable. In particular, with overcommit allowed scenarios, you can fill
> the whole physical memory (or at least a significant part) with those objects,
> well beyond your softlimit allowance, making the creation of further containers
> impossible.
> With user memory, you can reclaim the cgroup back to its place. With kernel
> memory, you can't.

In overcommit situations the page allocator starts failing even though
memcg page can charge pages.  When page allocations fail the oom killer
plays a role.  Page allocations can fail even without malicious usage of
kernel memory (e.g. lots of mlock or anon without swap can fill a
machine).  I assume that the kernel memory pinned the malicious
containers will be freed or at least become reclaimable once the
processes in malicious containers are killed (oom or otherwise).  We
have been making use of the oom killer to save a system from
irreconcilable overcommit situations.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
