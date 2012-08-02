From: Christoph Lameter <cl@linux.com>
Subject: Re: [RFC PATCH 01/23 V2] node_states: introduce N_MEMORY
Date: Thu, 2 Aug 2012 11:01:00 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1208021100230.23049@router.home>
References: <1343875991-7533-1-git-send-email-laijs@cn.fujitsu.com> <1343875991-7533-2-git-send-email-laijs@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1343923273; bh=gFHbtHTlKH/sHVT+fnwIq9aKVvuILdRXmRHWzyGd7Bo=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=J3G9xzrsxFGT0l2hlqxhR9cVSPoWbIinWCgHvM88jB77vZOn/tNvMrrYgm+OYQ9yuViPD+moi0IUP9z4jPHP/4Lh0O3arAgTlX9ak9YRYwvmMvFJUpjjUec8y7Gtu/Q5p4e64It0uErfhR9XlgPMtKtu/kSHAGV4BrYGvQAYuQo=
In-Reply-To: <1343875991-7533-2-git-send-email-laijs@cn.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Paul Menage <paul@paulmenage.org>, Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matt Fleming <matt.fleming@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>, Bjorn Helgaas <bhelgaas@google.com>, Wanlong Gao <gaowanlong@cn.fujitsu.com>, Petr Holasek <pholasek@redhat.com>, Djalal

On Thu, 2 Aug 2012, Lai Jiangshan wrote:

> In one word, we need a N_MEMORY. We just intrude it as an alias to
> N_HIGH_MEMORY and fix all im-proper usages of N_HIGH_MEMORY in late patches.

Good idea to clean this up.

Acked-by: Christoph Lameter <cl@linux.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
