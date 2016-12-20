From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET] kernfs, cgroup: reimplement "cgroup.procs" reading
 for v2
Date: Tue, 20 Dec 2016 11:17:00 -0500
Message-ID: <20161220161700.GA15530@htj.duckdns.org>
References: <20161220161053.14994-1-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bzvxGLCBv3SVzMKyjCBFSieW57I8H/qRhPoN1c3X5Gk=;
        b=ur7Me5yHKeww69ROvaqsyV9Q0r4ZvI7VzYkdihYTHDBVIwbzKoiOIOIbb2oed9CUjf
         /PrpgRy66hMl+uvGYS2uApkBjWAUpeBtWuQPXJLPdLU3aAdh5tm+34BD23fVXCaC7GS+
         DHab7c2WtLBL/iYDDKQfcj5w64Jfm7fV2iqVXLggMmy82p8R7mwzct8qeUnNhZAWSpJC
         07jEtoTKhW3MvqhS8qaKmOysB98LWbJU8ViGStgxju28RZ5BSKMu907WwgAQNjVjY1up
         pMkH6w6dWiuwpjECk8oiTShkXQOqX0N/BBKotGbMDH5MGxG/yZJOxaESHspd6f9ev0zw
         zqvw==
Content-Disposition: inline
In-Reply-To: <20161220161053.14994-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh@linuxfoundation.org, lizefan@huawei.com, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com

On Tue, Dec 20, 2016 at 11:10:48AM -0500, Tejun Heo wrote:
> On cgroup v1, the pid listings in "cgroup.procs" and "tasks" are
> sorted which adds a lot of complications and overhead.  v2 doesn't
> have such requirement and has been intentionally using a modified
> sorting order so that the output doesn't look sorted to users.

Please ignore this thread.  git-send-email failed in the middle and I
resent the series.

Thanks.

-- 
tejun
