From: Tejun Heo <tj@kernel.org>
Subject: Re: pids.current with invalid value for hours [5.0.0 rc3 git]
Date: Fri, 25 Jan 2019 08:37:31 -0800
Message-ID: <20190125163731.GJ50184@devbig004.ftw2.facebook.com>
References: <df806a77-3327-9db5-8be2-976fde1c84e5@gmail.com>
 <20190117122535.njcbqhlmzozdkncw@mikami>
 <1d36b181-cbaf-6694-1a31-2f7f55d15675@gmail.com>
 <96ef6615-a5df-30af-b4dc-417a18ca63f1@gmail.com>
 <1cdbef13-564d-61a6-95f4-579d2cad243d@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=RYL7pbha6AtxQjHD3ZK0n6qiStyqrgkMrnAlVCP0NNE=;
        b=hZvlbsqyaKWNVGRewUWJIxOTzlUYhWS2zbX7SH2tizlgJpQpx60Q9lFUr1KAvxcC/o
         1hPJlxzXj2+3gfQcXN2m7hvMawtI4t9aj1dEem45TLpkEql/eZmnG/q1Rj1mzVyhtxwr
         HV7sN0Yf6DRbhWtZYwjdL3tBn7xcNcxE0m4fXAVJgEjZPCK1VAIW74UMrRR1vLSuVj0h
         HyosUDdb9lBIVd02NWUS0S1pWyvOPCIyUMbdo++pIUAlLLlAg3hl9wVbLnyV7iSiBQWQ
         Cmfs2mFJwxet2D8u3OAyjG/l6Soc19pDLR4LD+aJZAPHD4x6jylVAxQ/YGkiG692WER7
         s73w==
Content-Disposition: inline
In-Reply-To: <1cdbef13-564d-61a6-95f4-579d2cad243d@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
Cc: cgroups@vger.kernel.org, Aleksa Sarai <asarai@suse.de>, Jay Kamat <jgkamat@fb.com>, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org

On Fri, Jan 25, 2019 at 08:52:11AM +0100, Arkadiusz Miśkiewicz wrote:
> On 24/01/2019 12:21, Arkadiusz Miśkiewicz wrote:
> > On 17/01/2019 14:17, Arkadiusz Miśkiewicz wrote:
> >> On 17/01/2019 13:25, Aleksa Sarai wrote:
> >>> On 2019-01-17, Arkadiusz Miśkiewicz <a.miskiewicz@gmail.com> wrote:
> >>>> Using kernel 4.19.13.
> >>>>
> >>>> For one cgroup I noticed weird behaviour:
> >>>>
> >>>> # cat pids.current
> >>>> 60
> >>>> # cat cgroup.procs
> >>>> #
> >>>
> >>> Are there any zombies in the cgroup? pids.current is linked up directly
> >>> to __put_task_struct (so exit(2) won't decrease it, only the task_struct
> >>> actually being freed will decrease it).
> >>>
> >>
> >> There are no zombie processes.
> >>
> >> In mean time the problem shows on multiple servers and so far saw it
> >> only in cgroups that were OOMed.
> >>
> >> What has changed on these servers (yesterday) is turning on
> >> memory.oom.group=1 for all cgroups and changing memory.high from 1G to
> >> "max" (leaving memory.max=2G limit only).
> >>
> >> Previously there was no such problem.
> >>
> > 
> > I'm attaching reproducer. This time tried on different distribution
> > kernel (arch linux).
> > 
> > After 60s pids.current still shows 37 processes even if there are no
> > processes running (according to ps aux).
> 
> 
> The same test on 5.0.0-rc3-00104-gc04e2a780caf and it's easy to
> reproduce bug. No processes in cgroup but pids.current reports 91.

Can you please see whether the problem can be reproduced on the
current linux-next?

 git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

Thanks.

-- 
tejun
