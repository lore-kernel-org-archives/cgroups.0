From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v14 00/12] Enable cpuset controller in default hierarchy
Date: Mon, 5 Nov 2018 17:57:59 +0100
Message-ID: <20181105165759.GE22431@hirez.programming.kicks-ass.net>
References: <1539635377-22335-1-git-send-email-longman@redhat.com>
 <20181105163656.GK4182586@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=8N9AblV9Wa3qf64I4Lx4g1cXc4FkR6iLu4HkGxAlMzM=; b=WLSxDH1QcoCw44DCmFYz3x3eG
        ThEd+s6wH9AeunMiaZxdfJPj+Xjx8yfDokbPyBqd+dhxekWVU6evXKEUPPt4kmLx1wkJtMqJvoy+i
        xCSEjwEYFmgcNWZaB8hrPBCxLIL1clEYgCFTstF01rYJ1xicuNCLdWjL3r2Y8zUMmz986m43F5oYz
        dALXQ+K8z2XzyxwJSvB6AVQ8R5c1po2RLQPVnl0ziMzMYTil4z2dmVXmlAO1fNkaDDb7D95vtiQQK
        HfLm/4GQnEDEH0LVSBfxzPFkAWpQugrcUxCn6qkaPkRbbwsKD3QTYYYP6QnJK37sF2EuLWIPi/pck
    
Content-Disposition: inline
In-Reply-To: <20181105163656.GK4182586@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Tom Hromatka <tom.hromatka@oracle.com>

On Mon, Nov 05, 2018 at 08:36:56AM -0800, Tejun Heo wrote:
> Hello,
> 
> So, this looks good to me.  Peter, I'm gonna roll the series into
> cgroup/for-4.21-cpuset.  Please holler if you have any objections /
> comments.

I'll try and have a look before LPC. Thanks!
