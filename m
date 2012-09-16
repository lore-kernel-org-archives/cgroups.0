From: Joseph Glanville <joseph.glanville@orionvm.com.au>
Subject: 3.6-rc5 cgroups blkio throttle + md regression
Date: Mon, 17 Sep 2012 03:31:27 +1000
Message-ID: <CAOzFzEhf2LfT0BCNPAgPgxZ3=pj2KvJ4Z6kP7XF8nnxag1dfvg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, NeilBrown <neilb@suse.de>

Hi,

When using cgroups blkio controller with bio throttling my shell hangs
attempting to write limits for md devices.
Standard sd devices work as expected but md devices cause the shell to
hang on io_wait.

For example:

echo 9:0 0 > blkio.throttle.read_bps_device

Where 9:0 => /dev/md0

I haven't started trying to narrow down when this occured yet, it
works fine on 3.2 and I will try out 3.5 etc shortly to see if I can
bisect where it stopped working.

Joseph.

-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
