From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv13 0/3] rdmacg: IB/core: rdma controller support
Date: Mon, 9 Jan 2017 14:01:26 -0600
Message-ID: <CAG53R5U0F6J5zAU8oWXDSS0YgnvaRxnD=++v=LLFfNRxvz_5jg@mail.gmail.com>
References: <1480705637-2986-1-git-send-email-pandit.parav@gmail.com> <20170109130221.GD10904@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=Qcid2OCiCdcNOLloZzP72MsDv2cgbW8Tjw1xvl4KxG0=;
        b=YkeMMSXVySe7XwL6rtxBZRmhJXbN2dWOSoDG1+Iw9hi8Kv4HCuHOFMHWWhYDq8Y48g
         nlh9l82XNRSgdeHVFq+16JOhZQmpLyz300rkAcNy2WX/Pz5yzIOQm4eNcWNHmxrRtzd4
         U8w0kCEVBbIyUCGRie3rzFqxEJK8SAGNhcdqnXA153CdzJCdj9Tzm0OnMrGCk89EctRb
         BjMZL1YZdj+44rHC5CWaQYslVewB2Zq+SpICtAWklHtBc3+fa3STW/VxcjyNxxNrgYSM
         AFOsxijGnC5hgNFuDXy/tl/pCM5rTgF4++Y8NEZgmcSBOrJ5cV3Z/0CC0S3WMXcUcc3c
         viaA==
In-Reply-To: <20170109130221.GD10904@mtj.duckdns.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Christoph Hellwig <hch@lst.de>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org

Hi Tejun,

On Mon, Jan 9, 2017 at 7:02 AM, Tejun Heo <tj@kernel.org> wrote:
> On Fri, Dec 02, 2016 at 07:07:14PM +0000, Parav Pandit wrote:
>> Patch is generated and tested against below Doug's linux-rdma
>> git tree.
>> URL: git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
>> Branch: master
>>
>> Patchset is also compiled and tested against below Tejun's cgroup tree
>> using cgroup v2 mode.
>> URL: git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
>> Branch: master
>
> Except for the minor nits, all look good to me.  Can you please
> refresh on top of cgroup/for-4.11 and the rdma devel branch?  Please
> note that cgroup/for-4.11 moved the cgroup source files under
> kernel/cgroup/.
>
Thanks for the review.
I will generate new patch in sometime this week with for-4.11 to
address comments and rebase.
I will be renaming cgroup_rdma.c to kernel/cgroup/rdma.c (similar to pids.c)

I will keep the header file name include/linux/cgroup_rdma.h as it is.

> Thanks!
>
> --
> tejun
