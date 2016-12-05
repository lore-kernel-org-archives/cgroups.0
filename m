From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv13 0/3] rdmacg: IB/core: rdma controller support
Date: Mon, 5 Dec 2016 14:35:28 -0500
Message-ID: <20161205193528.GC30331@mtj.duckdns.org>
References: <1480705637-2986-1-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MVtR1wNvK4LU7FQkf4G/7iHbXsVoo3tmzxFUlXfBNOc=;
        b=D0++MGSsmqalA/d6RUAwBaYVmCCmN8ycjW+LrUSeARTnAT/Kyqq+j+xVhKx/yid6PX
         rclREJXSMA9GhXmSAIz2ldc1mxIABUTSZCCcJUyO6KNVkZF8oE4iDR2ARdvUcVVpx6x5
         HwX9E3fKCER+f0wgXCJzE5WSN4XMGQ+Wn00kt0IoGTiQfrq46y3cDVSII50PY5xDPOdP
         X2GoSROaildCGgBDF3m48HwIyqke6CrWNgt90a9fmOt9PmY39NISwOM8a70JTJLZ9ZjT
         6geX9a9p5jJJv4HW9AHwMkx5XIg1Tc3a+DAo3/S3tAKpP5WfE2wBW1iZtf5q0N5x+P3e
         diLQ==
Content-Disposition: inline
In-Reply-To: <1480705637-2986-1-git-send-email-pandit.parav@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, hch@lst.de, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com, corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

Parav, it's a bit too late for this cycle.  Let's target v4.11.  I'll
review the patches after the merge window.  Please ping me if I don't.

Thanks.

-- 
tejun
