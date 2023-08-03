From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm/memcg: fix wrong function name above
 obj_cgroup_charge_zswap()
Date: Thu, 3 Aug 2023 10:08:55 -0400
Message-ID: <20230803140855.GA219857@cmpxchg.org>
References: <20230803120021.762279-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20221208.gappssmtp.com; s=20221208; t=1691071737; x=1691676537;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4X70XiZqAzKDHaedlFT+O6kVH6sN4dN95C3n7UPaI38=;
        b=T1AVtnxqWcjaufF6bv7ocvKEpv91EiKq2B0bub6zitZRPI7irFp95rXVUQQBisS3mx
         9C8bHB8K2hIQK1UwCdmzg8TBRyKaqfPcX7wXtW3/iGZ1QfYbL1R3I0ay50EyUPU6kLps
         Gv01kO8HtQNFGy0JNctEC+XIBX+lfXDebDOB+ZW3dS9lACnW1+4d64cVQSmnH817WGVa
         pNzE59AxqqBagCEyBO188I6O24sotquYt+4zwTIA2SQ3YCW4BzMD48+MhEcNraVkUhd8
         qfVFVmk8aKW+cWZgjVzUrsumGsWCkjQIrqVHqRTLkLK/nCViDhjUCBrvCiMpSYb2AXtm
         TScw==
Content-Disposition: inline
In-Reply-To: <20230803120021.762279-1-linmiaohe@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: akpm@linux-foundation.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, muchun.song@linux.dev, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Aug 03, 2023 at 08:00:21PM +0800, Miaohe Lin wrote:
> The correct function name is obj_cgroup_may_zswap(). Correct the comment.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
