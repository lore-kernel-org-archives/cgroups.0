From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 1/5] cgroup: record ancestor IDs and reimplement
 cgroup_is_descendant() using it
Date: Tue, 17 Nov 2015 23:54:54 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1511172353350.13966@nerf40.vanv.qr>
References: <1447789240-29394-1-git-send-email-tj@kernel.org> <1447789240-29394-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447789240-29394-2-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: davem@davemloft.net, pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu, lizefan@huawei.com, hannes@cmpxchg.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, daniel@iogearbox.net, daniel.wagner@bmw-carit.de, nhorman@tuxdriver.com


On Tuesday 2015-11-17 20:40, Tejun Heo wrote:
>+static inline bool cgroup_is_descendant(struct cgroup *cgrp,
>+					struct cgroup *ancestor)

(const struct group *cgrp, const struct group *ancestor)

>+{
>+	if (cgrp->root != ancestor->root || cgrp->level < ancestor->level)
>+		return false;
>+	return cgrp->ancestor_ids[ancestor->level] == ancestor->id;
>+}
