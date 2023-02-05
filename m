From: Ofir Gal <ofir.gal@volumez.com>
Subject: [PATCH -next] blk-throttle: enable io throttle for root in cgroup v2
Date: Sun,  5 Feb 2023 17:55:41 +0200
Message-ID: <20230205155541.1320485-1-ofir.gal@volumez.com>
References: <YgMxjyVjMjmkMQU5@T590>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XqAgyTAjJKFseuP7AppMe5BCjztupRQBL+3m6KQShX4=;
 b=ScPN8ADuuKU6w1CM1Z3skUwZB3K+wS5oHfCR273L0Lokuf73HgomoPFp20ziFSiLG87HF9h/0JKM2GlvdvkzCyGVwEcuKoyWvVOEzQZMxELBWi6ksBIXNsqN8Ku9a3yg8DM1TPcTsO9zMHUiFogcYPmKPq4JAwTB9tJk92dRfaHYtQnpTrzur3qM05EGiq34NElfZ4s0nQZB7Pdhmuu26SBiVcrK6mXRTotiRTy87EhbstXmX67+SPeFswVy9HCHj9GRTXtx71kun4ov6wROiRjHzKN68nfo9gc5/Qw81Bs9wi4i8dlJzm08GGnss2wN58oQtQ/ZiDkceWn3ZL2dPg==
In-Reply-To: <YgMxjyVjMjmkMQU5@T590>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ming.lei@redhat.com
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, tj@kernel.org, yi.zhang@huawei.com, yukuai3@huawei.com, Ofir Gal <ofir@gal.software>

From: Ofir Gal <ofir@gal.software>

Hello Ming Lei,

I am trying to use cgroups v2 to throttle a media disk that is controlled by an NVME target.
Unfortunately, it cannot be done without setting the limit in the root cgroup.
It can be done via cgroups v1. Yu Kuai's patch allows this to be accomplished.

My setup consist from 3 servers.
Server #1:
    a. SSD media disk (needs to be throttled to 100K IOPs)
    b. NVME target controlling the SSD (1.a)

Server #2:
    a. NVME initiator is connected to Server #1 NVME target (1.b)

Server #3:
    a. NVME initiator is connected to Server #1 NVME target (1.b)

My setup accesses this media from multiple servers using NVMe over TCP,
but the initiator servers' workloads are unknown and can be changed dynamically. I need to limit the media disk to 100K IOPS on the target side.

I have tried to limit the SSD on Server #1, but it seems that the NVME target kworkers are not affected unless I use Yu Kuai's patch.

Can you elaborate on the issues with this patch or how the scenario described above can be done with cgroups v2?

Best regards, Ofir Gal.
