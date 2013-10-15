From: Hong zhi guo <honkiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] blk-throttle: simplify logic by token bucket algorithm
Date: Tue, 15 Oct 2013 20:35:17 +0800
Message-ID: <CAA7+ByU0ZbtZF=jCaU86MEx0xVg+kouRZ3ocVCrMxyBz0T7ufA@mail.gmail.com>
References: <1381574794-7639-1-git-send-email-zhiguohong@tencent.com>
	<1381741757-20888-1-git-send-email-zhiguohong@tencent.com>
	<20131014133620.GF4722@htj.dyndns.org>
	<CAA7+ByWPM2Pizm+dP1AxPM7Ut-w=AtRfD2GkCK-0OVh+C2Twkg@mail.gmail.com>
	<20131014135929.GH4722@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=fa4EEef6/LpxZUufmMvK75Mn7vBrNgGD4xjwqUcmxtY=;
        b=OPIlPElJwfMRnEOFfUhD7uh4VO6ySZ9ANEwd+3N9y67MX0nWuD6EHusRl9eAeoWwqb
         OqxeTi0WYk7sVVny7agxwOMdnv0WWznm9Sx7S4iAJEKVj4VBL6utK5DujOpNyL87AEYP
         IClEAQDL9tI8wxhQ1bNUUmx78DM0tC//kY2MkzkXXffc3RvDA5sQJiSwX+2pLAnjRXcC
         tdvKi2gJtQZ3C5CYTQLwZw/gePUPQC23DlmnQ7IiD5c7RIUJzkJhKm1oEUP4DWjukMYD
         B+e9GK4GxJLC7NzJE+jSAJtzT0HWSdBE9OohfqqzrEXPkxFoY2LKswdgtXQ3+sM76rNj
         CiTw==
In-Reply-To: <20131014135929.GH4722-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Hi, Tejun,

I did the test for 3 levels hierarchy. It works.

Preparation
============
1) mount subsys blkio with "__DEVEL__sane_behavior"
2) Create 3 levels of directories under the blkio mount point:
    mkdir 1
    mkdir 1/2
    mkdir 1/2/3
3) start 3 bash sessions, write their PIDs into:
    1/cgroup.procs
    1/2/cgroup.procs
    1/2/3/cgroup.procs
4) prepare 3 10MB files on sdb(ext4 fs)

Note: in below hierarchy graph:
    "[50k]" means configured value for read_bps_device is 50kB/s
    "(50k)" means bandwidth reported by dd is 50kB/s

Test A: 1 process throttled by ancestor group
=============================================
Hierarchy set-up:
    (echo "8:16 204800" > 1/blkio.throttle.read_bps_device)
    1 [200k]
    `-- 2 [-]
        `-- 3 [-]

dd within group 3:
    (drop cache then: dd if=10M-file-3 of=/dev/null)
Result:
    206kB/s (I did same test without the token-bucket patch, The
result is 205kB/s)

dd within group 2:
    (drop cache then: dd if=10M-file-2 of=/dev/null)
Result:
    205kB/s


Test B: 3 processes in 3 levels of hierarchy
=============================================
Hierarchy set-up:
    echo "8:16 204800" > 1/blkio.throttle.read_bps_device
    echo "8:16 102400" > 1/2/blkio.throttle.read_bps_device
    echo "8:16 51200"  > 1/2/3/blkio.throttle.read_bps_device
    1 [200k]
    `-- 2 [100k]
        `-- 3 [50k]
start 3 dd processes from 3 bash sessions
    (dd if=10M-file-x of=/dev/null)
Result:
    1 (103k)
    `-- 2 (51.9k)
        `-- 3 (51.4k)


best regards
Hong Zhiguo
