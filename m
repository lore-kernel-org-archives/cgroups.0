From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: Re: [Question] Do we need remote charging for cpu and cpuacct subsys?
Date: Fri, 2 Jul 2021 16:07:42 -0400
Message-ID: <20210702200742.wuhdg4dhpolher3t@oracle.com>
References: <60decdb6.1c69fb81.6130e.7642@mx.google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=b/pD1Och07MWekr/1nICfYdC3YRnv75biPh0Wx7DQM0=;
 b=S1t8f9bMYRp0Jm3k5JQUf5w2Mj9Q2Mxbf9t1zOR0nbQEi5JKmsJTFnJP/7TPjNDDVeAl
 vIhDNK1FP5shfgMMkXWoZ7KTeABSmdsZA3bxpjX3e0fw658ES8iuoB5l+nFEgxmYqe4t
 qOs0in/sS15e6yFWMNChmgfTHDfIgC+I+YToJg/8D34XOLEmvWMSOIavu0VVMNUkWHkb
 DYcNzjMYXilPWrTSH0WRlr4Q0OqLEj1WFDJ89m+uH6DKvfe0MpmOn8WweNqzTaDZJIeM
 Ih1rF15VGtqJfcnW/d6bjax6ZfXhp4PTMRXCfBOuIzh7u98DeaB98u2dtUkKYRovxcNR cA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/pD1Och07MWekr/1nICfYdC3YRnv75biPh0Wx7DQM0=;
 b=NIm5r+rhwnKVopcxKZXPToI33mLI7Dx2yuQtyHAli0NrofbhufQSDl+BsV63vhkhV2tCEfKzpe50nZ6MYHwQDwRqAQAwixwBjLWqBmgC0tmtdGQsIa1ivdiQm+jAnhpyvZYVeBCDOZ4IIIbv7+pmRl1BukJPUtMnHiLkUuI380I=
Content-Disposition: inline
In-Reply-To: <60decdb6.1c69fb81.6130e.7642@mx.google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Lee <haolee.swjtu@gmail.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, tj@kernel.org

Hello,

On Fri, Jul 02, 2021 at 08:26:27AM -0000, Hao Lee wrote:
> memcg currently has a remote charging mechanism that can charge usage to other
> memcg instead of the one the task belongs to.
> 
> In our environment, we need to account the cpu usage consumed by some kworkers
> to a specific cgroup. Thus, we want to introduce a remote-charging mechanism to
> cpu and cpuacct subsys in our kernel.

I also want to see this upstream, and am actually working on it right
now, have been for some time.

So far, this is needed to properly account multithreaded padata jobs,
memory reclaim, and net rx.  Android folks have raised this issue in the
past too, though I'm not aware of the specific kthreads that are giving
them problems.

So naturally, I'm curious about your use case and how it may be
different from these others.  What kworkers would you like to account?

> I want to know if the community has a plan to do this?
> What will the community approach look like?

There has been discussion about this here,

   https://lore.kernel.org/lkml/20200219214112.4kt573kyzbvmbvn3@ca-dmjordan1.us.oracle.com/

more recently here,

   https://lore.kernel.org/lkml/YGxjwKbec68sCcqo@slm.duckdns.org/

and we may talk about it at LPC:

   https://www.linuxplumbersconf.org/event/11/page/104-accepted-microconferences#cont-perform

> I think we need to move the active_memcg to a separated active_cgroup struct,
> and the latter will contain active_memcg, active_tg, and active_cpuacct.

I'm not seeing how that could work for cases that don't know the cgroup
when the remote charging period begins.  The only one I'm aware of
that's like that is net rx, where the work to process packets has to
start before their ultimate destination, and therefore cgroup, is known.

thanks,
Daniel
