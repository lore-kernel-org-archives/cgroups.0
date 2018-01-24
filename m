From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch -mm 3/4] mm, memcg: replace memory.oom_group with policy
 tunable
Date: Wed, 24 Jan 2018 14:18:03 -0800
Message-ID: <20180124221803.GC17457@devbig577.frc2.facebook.com>
References: <20180117154155.GU3460072@devbig577.frc2.facebook.com>
 <alpine.DEB.2.10.1801171348190.86895@chino.kir.corp.google.com>
 <alpine.DEB.2.10.1801191251080.177541@chino.kir.corp.google.com>
 <20180120123251.GB1096857@devbig577.frc2.facebook.com>
 <alpine.DEB.2.10.1801221420120.16871@chino.kir.corp.google.com>
 <20180123155301.GS1526@dhcp22.suse.cz>
 <alpine.DEB.2.10.1801231416330.254281@chino.kir.corp.google.com>
 <20180124082041.GD1526@dhcp22.suse.cz>
 <alpine.DEB.2.10.1801241340310.24330@chino.kir.corp.google.com>
 <20180124140805.b4eb437c6fe9dadb67a32e8a@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KXfsWa+nTJfbUdDk3LVPIDZSNdARiqFsMYvv8Fyu5qU=;
        b=KU1WfzOkFYBv5nLm5O7OAKimZucYkBMRfIzxlNLUBFXm44zpuKWBNtlk8cIUiViOeZ
         SD4wkEBIKYmWdoqn5vgsMvFSowQSmTDuoYdkxRwKpfYlXLyhdcGGmWFBFZf2ag2P28tg
         9GoFAjmRJub5K0DE9LOrraKQaYLahYnfke7mq36JLvvfOaNIULZFaabeU296YIQKAF//
         LbipQR4pvmzXcbioLVnDX5Ft+7qilwtKY5RoNFwiV7lYmngDbQ3nEqvvXpLCGPmyOYYa
         XNpztpo1Ucgy5ftNR3bemMDmYxoai50oUZBNWBpmr+NfdmDUrX79r+dHFnMPU7aNotS4
         cgqQ==
Content-Disposition: inline
In-Reply-To: <20180124140805.b4eb437c6fe9dadb67a32e8a@linux-foundation.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <guro@fb.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

Hello, Andrew.

On Wed, Jan 24, 2018 at 02:08:05PM -0800, Andrew Morton wrote:
> Can we please try to narrow the scope of this issue by concentrating on
> the userspace interfaces?  David believes that the mount option and
> memory.oom_group will disappear again in the near future, others
> disagree.

I'm confident that the interface is gonna age fine.

Thanks.

-- 
tejun
