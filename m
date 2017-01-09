From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv13 1/3] rdmacg: Added rdma cgroup controller
Date: Mon, 9 Jan 2017 07:58:58 -0500
Message-ID: <20170109125858.GB10904@mtj.duckdns.org>
References: <1480705637-2986-1-git-send-email-pandit.parav@gmail.com>
 <1480705637-2986-2-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=w3RXGUocxqxxVsO5wY52Can1n2X/+jTSUEAXcsRZcN0=;
        b=jve3X6qwFmelo113c94mWOCNamdV1IFsuywvLhLqocfNk5JmXVSTOba13J5KC+takq
         zzKaTtXiLpQx5Yio1WJxWpp/x9fQApZBqCT7ZTOXHRk0MxXISO4ldy3dCKIvB+/h8rUe
         18z41DvlsMdJHgacGA6+7fB8ubwgCD4mQmxiQP8xwF2wzufjjLqKjcbNps0puhz1BBkM
         IRulLZKS572J6vmrRFpGFi5BrAM0abOkcbBvSCIDe2vCy/lnaE67OAKpem5u0AQQwWDw
         p1gQ7WPwohJKvi1fRy5NQDj2AHsC5jLsOGzKgfw2CEIrPgR0iESK6b54le/j7fifsgSD
         xIZA==
Content-Disposition: inline
In-Reply-To: <1480705637-2986-2-git-send-email-pandit.parav@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, hch@lst.de, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com, corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

Hello, Parav.

Looks good to me.  Just one minor nit below.

> +static void rdmacg_uncharge_hirerchy(struct rdma_cgroup *cg,

 hierarchy

Other than that, looks good to me.

Thanks.

-- 
tejun
