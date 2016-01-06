From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv1 2/6] IB/core: Added members to support rdma cgroup
Date: Thu, 7 Jan 2016 04:46:19 +0530
Message-ID: <CAG53R5VVK4jhyXJT9XLFdjz-amzkLGhugvozWzoYNcBua-KsNg@mail.gmail.com>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
	<1452020286-9508-3-git-send-email-pandit.parav@gmail.com>
	<20160105215656.GI5995@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=HKq1x6SV8JxaxwsXsvqSKmt8+RxTL9fWfGJVRe5uB78=;
        b=CQCSIiTuWdHThPvA7oxl5nu29rxLPR2VoB9/vxd5ExyEaSHtfHmwst92YCyWxsk10V
         700cfiQp9yPjZb0DKtczH8CgAfSYB9fetlyuEpVYQs7Powo4XuqtCECPtjTSm4kvay87
         ehvgpgu+vKetK9BgKCrjsjKKnJxXz6t6n+gtsscunPRhOuXchLc4M567finDkzZKVpUn
         2XP3VQO8Y39xBsBrzoGmP/bu6LqbnO3Xa8lmM1NBoxEyEKvRiBWPebOSs90kqx27vzHJ
         7bjsd+ZQCMGzsnPY9biQE/Xf1US/dnVD8atLmBEpqmnqmkVFUV6lwC3DljsXJq5uxPIh
         gywg==
In-Reply-To: <20160105215656.GI5995@mtj.duckdns.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On Wed, Jan 6, 2016 at 3:26 AM, Tejun Heo <tj@kernel.org> wrote:
> On Wed, Jan 06, 2016 at 12:28:02AM +0530, Parav Pandit wrote:
>> Added function pointer table to store resource pool specific
>> operation for each resource type (verb and hw).
>> Added list node to link device to rdma cgroup so that it can
>> participate in resource accounting and limit configuration.
>
> Is there any point in splitting patches 1 and 2 from 3?
>
Patch 2 is in IB stack, so I separated that patch out from 1. That
makes it 3 patches.
If you think single patch is easier to review, let me know, I can
respin to have one patch for these 3 smaller patches.

> --
> tejun
