From: Aleksa Sarai <asarai@suse.de>
Subject: Re: [PATCH v3 1/2] cgroup: apply common ancestor cgroup.procs
 restriction in cgroupv1
Date: Tue, 3 May 2016 11:44:47 +1000
Message-ID: <5728028F.5060906@suse.de>
References: <1462197681-6879-1-git-send-email-asarai@suse.de>
 <1462197681-6879-2-git-send-email-asarai@suse.de>
 <20160502160332.GQ7822@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160502160332.GQ7822@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, dev@opencontainers.org, Aleksa Sarai <cyphar@cyphar.com>

> So, you can't apply a new restriction like this retro-actively to
> cgroup v1 hierarchies.

Okay, understood. I'll see if it's possible to make this change safe 
without adding restrictions to cgroupv1 hierarchies.

-- 
Aleksa Sarai
Software Engineer (Containers)
SUSE Linux GmbH
https://www.cyphar.com/
