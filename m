From: Christoph Lameter <cl@linux.com>
Subject: Re: [RFC PATCH 16/23 V2] numa: add CONFIG_MOVABLE_NODE for
 movable-dedicated node
Date: Thu, 2 Aug 2012 11:06:32 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1208021105540.23049@router.home>
References: <1343875991-7533-1-git-send-email-laijs@cn.fujitsu.com> <1343875991-7533-17-git-send-email-laijs@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1343923606; bh=h4OWc4FK9uuTIB37huR9w6sLT6XwjzKZSHwqxln5G4o=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=j9uyeuuvL6+ZrSkvm0zPV/0sExeW+4bTf0vewh1cowSq57KLtVE2cPjaNq2lovdNlHsuiCTkcVmwjgyJM+qlYnjhNgNEJd21dIeSg7rktzTCL81le+BlatSLIBjesImgiFSikO0Jn8on56gkpzaxgNLbTux/oXtOmLqWaVBv8Y0=
In-Reply-To: <1343875991-7533-17-git-send-email-laijs@cn.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Paul Menage <paul@paulmenage.org>, Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matt Fleming <matt.fleming@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>, Bjorn Helgaas <bhelgaas@google.com>, Wanlong Gao <gaowanlong@cn.fujitsu.com>, Petr Holasek <pholasek@redhat.com>, Djalal

On Thu, 2 Aug 2012, Lai Jiangshan wrote:

> +++ b/include/linux/nodemask.h
> @@ -380,7 +380,11 @@ enum node_states {
>  #else
>  	N_HIGH_MEMORY = N_NORMAL_MEMORY,
>  #endif
> +#ifdef CONFIG_MOVABLE_NODE
> +	N_MEMORY,		/* The node has memory(regular, high, movable) */

I like these comments. Could you add some to each of the different node
states and defined their purpose?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
