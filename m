From: Sasha Levin <Alexander.Levin@microsoft.com>
Subject: Re: Re: general protection fault in __mem_cgroup_free
Date: Fri, 6 Apr 2018 20:05:30 +0000
Message-ID: <MW2PR2101MB1034209365406E2E8296819AFBBA0@MW2PR2101MB1034.namprd21.prod.outlook.com>
References: <20180403105048.GK5501@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=4uur7pidm6YAqpXcavestF8obadBeQoJG6vfv3oN8pA=;
 b=BoYeGU2zdHU+PATXIeBreo2R6fHgMFgI4hRCuJugnWBGg+gGQbqQUYBVR7O6+131nnxEcPGF29gSXJy5QVcsI8ITE+yR9aqpCy/YY8kaIQINoRmFzF/1gtoCIkM47qHoLkLdZZ50oVxlMEBYS+gQ1Wfeo5Aqz/jF0q53w76zvc0=
In-Reply-To: <20180403105048.GK5501@dhcp22.suse.cz>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sasha Levin <Alexander.Levin@microsoft.com>, Michal Hocko <mhocko@kernel.org>, Michal Hocko <mhocko@suse.com>, syzbot <syzbot+8a5de3cce7cdc70e9ebe@syzkaller.appspotmail.com>
Cc: "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 00f3ca2c2d66 mm: memcontrol: per-lruvec stats infrastructure=
.

The bot has also determined it's probably a bug fixing patch. (score: 37.85=
69)

The bot has tested the following trees: v4.16, v4.15.15, v4.14.32.

v4.16: Build OK!
v4.15.15: Failed to apply! Possible dependencies:
    a983b5ebee57 ("mm: memcontrol: fix excessive complexity in memory.stat =
reporting")

v4.14.32: Failed to apply! Possible dependencies:
    a983b5ebee57 ("mm: memcontrol: fix excessive complexity in memory.stat =
reporting")

