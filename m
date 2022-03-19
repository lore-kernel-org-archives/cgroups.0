From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH -next 00/11] support concurrent sync io for bfq on a
 specail occasion
Date: Sat, 19 Mar 2022 10:34:53 +0800
Message-ID: <3325eb4b-5513-694f-df59-364cb1c86eb5@huawei.com>
References: <20220305091205.4188398-1-yukuai3@huawei.com>
 <e299180e-cdbd-0837-8478-5e397ac8166b@huawei.com>
 <11fda851-a552-97ea-d083-d0288c17ba53@huawei.com>
 <1AE1457D-AAE1-4A13-8593-451E9396028A@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1AE1457D-AAE1-4A13-8593-451E9396028A@linaro.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Paolo Valente <paolo.valente@linaro.org>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, cgroups@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, yi.zhang@huawei.com

在 2022/03/18 20:38, Paolo Valente 写道:
> Hi,
> could you please add pointers to the thread(s) where we have already revised this series (if we have). I don't see any reference to that in this cover letter.

Hi,

Ok, sorry for that, following is the previours threads.

This is a new patchset after RFC
- Fix some term in commit messages and comments
- Add some cleanup patches

New RFC: use a new solution, and it has little relevance to
previous versions.
https://lore.kernel.org/lkml/20211127101132.486806-1-yukuai3@huawei.com/T/
- as suggested by Paolo, count root group into
'num_groups_with_pending_reqs' instead of handling root group
separately.
- Change the patchset title
- New changes about when to modify 'num_groups_with_pending_reqs'

Orignal v4:
https://lore.kernel.org/lkml/20211014014556.3597008-2-yukuai3@huawei.com/t/
  - fix a compile warning when CONFIG_BLK_CGROUP is not enabled.

Orignal v3:
https://www.spinics.net/lists/linux-block/msg74836.html
  - Instead of tracking each queue in root group, tracking root group
  directly just like non-root group does.
  - remove patch 3,4 from these series.

Orignal v2:
https://lore.kernel.org/lkml/20210806020826.1407257-1-yukuai3@huawei.com/
- as suggested by Paolo, add support to track if root_group have any
  pending requests, and use that to handle the situation when only one
  group is activated while root group doesn't have any pending requests.
  - modify commit message in patch 2
