From: Haggai Eran <haggaie@mellanox.com>
Subject: Re: [PATCHv7 2/3] IB/core: added support to use rdma cgroup
 controller
Date: Tue, 1 Mar 2016 11:08:22 +0200
Message-ID: <56D55C06.8090102@mellanox.com>
References: <1456668821-25799-1-git-send-email-pandit.parav@gmail.com>
 <1456668821-25799-3-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1; h=From:To:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=kSBSLaDHNQSxSRAhOGYUjcaIhze6pQqrB8iJofyFFzQ=;
 b=JUftwiyPU4IsgS+93WwIH8Kv+bknSaQGlyetMT8f49skOT+pTzXkW9SKfgeEX6SloV8soVRLjkbzNcu1DMAH73PqZ89sjGkMDa3b+2tuZvVIT2MYl/7+3KnsjudTy3u4WpSThCYM0GiRmmbGkoG8X4eKm2iSyDqAO5arig0003E=
In-Reply-To: <1456668821-25799-3-git-send-email-pandit.parav@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Parav Pandit <pandit.parav@gmail.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com
Cc: corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On 28/02/2016 16:13, Parav Pandit wrote:
> +void ib_rdmacg_query_limit(struct ib_device *device, int *limits, int max_count)
> +{
> +	rdmacg_query_limit(&device->cg_device, limits);
> +}
> +EXPORT_SYMBOL(ib_rdmacg_query_limit);

You can remove the max_count parameter here as well.
