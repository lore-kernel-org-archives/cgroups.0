From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2] blk-throttle: simplify logic by token bucket algorithm
Date: Tue, 15 Oct 2013 10:19:37 -0600
Message-ID: <20131015161937.GU541@kernel.dk>
References: <1381574794-7639-1-git-send-email-zhiguohong@tencent.com>
 <1381741757-20888-1-git-send-email-zhiguohong@tencent.com>
 <20131014133620.GF4722@htj.dyndns.org>
 <CAA7+ByWPM2Pizm+dP1AxPM7Ut-w=AtRfD2GkCK-0OVh+C2Twkg@mail.gmail.com>
 <20131014135929.GH4722@htj.dyndns.org>
 <CAA7+ByU0ZbtZF=jCaU86MEx0xVg+kouRZ3ocVCrMxyBz0T7ufA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAA7+ByU0ZbtZF=jCaU86MEx0xVg+kouRZ3ocVCrMxyBz0T7ufA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hong zhi guo <honkiko@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, vgoyal@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Hong Zhiguo <zhiguohong@tencent.com>

On Tue, Oct 15 2013, Hong zhi guo wrote:
> Hi, Tejun,
> 
> I did the test for 3 levels hierarchy. It works.
> 
> Preparation
> ============
> 1) mount subsys blkio with "__DEVEL__sane_behavior"
> 2) Create 3 levels of directories under the blkio mount point:
>     mkdir 1
>     mkdir 1/2
>     mkdir 1/2/3
> 3) start 3 bash sessions, write their PIDs into:
>     1/cgroup.procs
>     1/2/cgroup.procs
>     1/2/3/cgroup.procs
> 4) prepare 3 10MB files on sdb(ext4 fs)
> 
> Note: in below hierarchy graph:
>     "[50k]" means configured value for read_bps_device is 50kB/s
>     "(50k)" means bandwidth reported by dd is 50kB/s
> 
> Test A: 1 process throttled by ancestor group
> =============================================
> Hierarchy set-up:
>     (echo "8:16 204800" > 1/blkio.throttle.read_bps_device)
>     1 [200k]
>     `-- 2 [-]
>         `-- 3 [-]
> 
> dd within group 3:
>     (drop cache then: dd if=10M-file-3 of=/dev/null)
> Result:
>     206kB/s (I did same test without the token-bucket patch, The
> result is 205kB/s)
> 
> dd within group 2:
>     (drop cache then: dd if=10M-file-2 of=/dev/null)
> Result:
>     205kB/s
> 
> 
> Test B: 3 processes in 3 levels of hierarchy
> =============================================
> Hierarchy set-up:
>     echo "8:16 204800" > 1/blkio.throttle.read_bps_device
>     echo "8:16 102400" > 1/2/blkio.throttle.read_bps_device
>     echo "8:16 51200"  > 1/2/3/blkio.throttle.read_bps_device
>     1 [200k]
>     `-- 2 [100k]
>         `-- 3 [50k]
> start 3 dd processes from 3 bash sessions
>     (dd if=10M-file-x of=/dev/null)
> Result:
>     1 (103k)
>     `-- 2 (51.9k)
>         `-- 3 (51.4k)

Thanks for doing this testing, and the work to move to a token based
system. It makes a lot of sense. I've been investigating a token based
scheduler for blk-mq as well, since that could feasibly be made to scale
as well.

-- 
Jens Axboe
