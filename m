From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v9 3/8] cpuset: Rebuild root domain deadline accounting
 information
Date: Thu, 25 Jul 2019 15:53:51 +0200
Message-ID: <20190725135351.GA108579@gmail.com>
References: <20190719140000.31694-1-juri.lelli@redhat.com>
 <20190719140000.31694-4-juri.lelli@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GCYwHJCLOsYoyyik86R2Z6x2q4egJ0xmOYkZtSr5Et4=;
        b=IS0yrIsbzCZQC1jP26jRFo0g4nOCtbeBYrhyWET/czx/N3PXQHriKYe1jqGFSnEARp
         gBcSwxE4pl/mFpnDgKRnZgJOdb+Eyyl3uQekvIU2tsrJV4jTZU6qZQbeHyIyaMMdg9N/
         YSZSQHty4Etpi/Qv507Y9gxmTqwz/awhhozgI7wxwb8Y61KY01bYAa/hit5+jPUtV6/q
         Ei2yMP5zgt3sIkgsi2XGczqjmf4Cle4wKQIZan6/brv6TH2vbBMoMquCb9akA+6lhZtw
         e2tjtuXzfBiU2wgE+DjXs+6pc0P6+tbSF/2MR0vCd03WoyjL0Xcn2ZGRIli0CZKpDZFA
         abFw==
Content-Disposition: inline
In-Reply-To: <20190719140000.31694-4-juri.lelli@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli@redhat.com>
Cc: peterz@infradead.org, mingo@redhat.com, rostedt@goodmis.org, tj@kernel.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, longman@redhat.com, dietmar.eggemann@arm.com, cgroups@vger.kernel.org


* Juri Lelli <juri.lelli@redhat.com> wrote:

> When the topology of root domains is modified by CPUset or CPUhotplug
> operations information about the current deadline bandwidth held in the
> root domain is lost.
> 
> This patch addresses the issue by recalculating the lost deadline
> bandwidth information by circling through the deadline tasks held in
> CPUsets and adding their current load to the root domain they are
> associated with.
> 
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Signed-off-by: Juri Lelli <juri.lelli@redhat.com>

Was this commit written by Mathieu? If yes then it's missing a From line. 
If not then the Signed-off-by should probably be changed to Acked-by or 
Reviewed-by?

Thanks,

	Ingo
