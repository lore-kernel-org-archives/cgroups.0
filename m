From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: pids.current with invalid value for hours [5.0.0 rc3 git]
Date: Sat, 26 Jan 2019 15:10:38 +0900
Message-ID: <72aa8863-a534-b8df-6b9e-f69cf4dd5c4d@i-love.sakura.ne.jp>
References: <df806a77-3327-9db5-8be2-976fde1c84e5@gmail.com>
 <20190117122535.njcbqhlmzozdkncw@mikami>
 <1d36b181-cbaf-6694-1a31-2f7f55d15675@gmail.com>
 <96ef6615-a5df-30af-b4dc-417a18ca63f1@gmail.com>
 <1cdbef13-564d-61a6-95f4-579d2cad243d@gmail.com>
 <20190125163731.GJ50184@devbig004.ftw2.facebook.com>
 <a95d004a-4358-7efc-6d21-12aac4411b32@gmail.com>
 <480296c4-ed7a-3265-e84a-298e42a0f1d5@I-love.SAKURA.ne.jp>
 <6da6ca69-5a6e-a9f6-d091-f89a8488982a@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6da6ca69-5a6e-a9f6-d091-f89a8488982a@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: =?UTF-8?Q?Arkadiusz_Mi=c5=9bkiewicz?= <a.miskiewicz@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, Aleksa Sarai <asarai@suse.de>, Jay Kamat <jgkamat@fb.com>, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>

On 2019/01/26 11:41, Arkadiusz Mi=C5=9Bkiewicz wrote:
> dmesg:
> http://ixion.pld-linux.org/~arekm/cgroup-oom-2.txt

What is wrong with this output? It seems to me that the OOM killer is killi=
ng
processes as soon as python 3 fork()s one. Although "potentially unexpected
fatal signal 7." messages due to handling SIGBUS at get_signal() after the
OOM reaper reclaimed the OOM victim's memory is a bit noisy, I don't think
that something is wrong.

  Jan 26 03:33:49 xps kernel: python3 invoked oom-killer: gfp_mask=3D0x6000=
c0(GFP_KERNEL), order=3D0, oom_score_adj=3D0
  Jan 26 03:33:52 xps kernel: potentially unexpected fatal signal 7.

You seem to be monitoring cgroup statistic values for only 1 minute, but
since the fork bombs might take longer than 1 minute, I'm not sure that
the statistic values after terminating cg.py and waited for a while (e.g.
1 minute) is still showing unexpected values.

