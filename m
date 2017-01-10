From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv14 0/3] rdmacg: IB/core: rdma controller support
Date: Tue, 10 Jan 2017 11:15:05 -0500
Message-ID: <20170110161505.GF6666@htj.duckdns.org>
References: <1484006535-4245-1-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hGdAhPi4hTl7nMdBjzyOE7/NOvHf67a7/6TtNJJzQ38=;
        b=VEHWe3a7Qzs2mWcSoebykjm7dVA4PcytFsv7VEhn9bKC9+riKMszpN7ZEqcShlfJTe
         beI5SvkADAS4E16QRG5fh36mypzwED2qncARhdIlCw3+srMQ70HXiwy/MWIylA/VkiYx
         nIjpPCELdhZXJu1ZmY5k/ihz9n6nclL0Cj6ytj4iDE9d85V+X1qP1unMaWByyVA4Hp9j
         kGjWZdXfIr2lhf8JQsnZwl9VfcfqvSnVLxNIdkl+4GWqvOvf2qAelIhkisIqxfnVDVUN
         sepVj7THqB5UcJvWcjabzQ/B/C888qJU8NHXv5mKluXqkrynEnyFFFargm7hkYHmtZfA
         3RRw==
Content-Disposition: inline
In-Reply-To: <1484006535-4245-1-git-send-email-pandit.parav@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, hch@lst.de, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com, corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On Tue, Jan 10, 2017 at 12:02:12AM +0000, Parav Pandit wrote:
> Patchset is compiled and tested against below Tejun's cgroup tree
> using cgroup v1 and v2 mode.
> URL: git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
> Branch: for-4.11

Applied 1-3 to cgroup/for-4.11-rdmacg.

Thanks.

-- 
tejun
