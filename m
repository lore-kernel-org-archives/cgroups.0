From: Haggai Eran <haggaie@mellanox.com>
Subject: Re: [PATCHv9 2/3] IB/core: added support to use rdma cgroup
 controller
Date: Wed, 2 Mar 2016 13:28:16 +0200
Message-ID: <56D6CE50.6060200@mellanox.com>
References: <1456859137-13646-1-git-send-email-pandit.parav@gmail.com>
 <1456859137-13646-3-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1; h=From:To:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=7WauGJuOAuju0j4YGy1jRop+BlBUe5Z0qMyqG6LDswA=;
 b=NSmoosIkVd8slrHjxGz2YEAlilqrVYGHMOML/mIpCbWvT/buHu+zlcLvgCdu46EOMMFI6O++JrLLZ/h6Dele6HUArK78XWHRYmUsUE3NPmJqOAHe4bvn3o26taOtwspqDXL6Z5qJQPzmTWzD5pfK8O8yhC6eJ6d0Gxf4eL0pHZQ=
In-Reply-To: <1456859137-13646-3-git-send-email-pandit.parav@gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Parav Pandit <pandit.parav@gmail.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com
Cc: corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On 01/03/2016 21:05, Parav Pandit wrote:
> Added support APIs for IB core to register/unregister every IB/RDMA
> device with rdma cgroup for tracking verbs and hw resources.
> IB core registers with rdma cgroup controller and also defines
> resources that can be accounted.
> Added support APIs for uverbs layer to make use of rdma controller.
> Added uverbs layer to perform resource charge/uncharge functionality.
> Added support during query_device uverb operation to ensure it
> returns resource limits by honoring rdma cgroup configured limits.
> 
> Signed-off-by: Parav Pandit <pandit.parav@gmail.com>

Looks good to me. Thanks.

Reviewed-by: Haggai Eran <haggaie@mellanox.com>

