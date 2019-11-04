From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 0/2] cgroup: Sync cgroup id and inode number
Date: Mon, 4 Nov 2019 08:49:03 -0800
Message-ID: <20191104164903.GQ3622521@devbig004.ftw2.facebook.com>
References: <20191104084520.398584-1-namhyung@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Tolm0KjoKvfRTvG4VjDhlcLgC6/zdCu4XmFbBPjTkwY=;
        b=QDb28cZajsvYgqeWWWhRnDIReogocXA/kxJfrHS6albWdfSNMVrp+8MS/zWWV5k5+T
         rNv853PHTXdFaUyuxjCXFUyIRcT4ZvKLScrh0pCo04OU5kBwlAITLvKP0d1iTcxYJE5a
         qYIUCczhmyFKKcc2Sf3hIhNvHcN0fcrf7e+f3ZLWrccNxGJN7imun8WvZrw6VF+9OWBX
         41opJ+xmjK2J1Nu+/iVZoCce5+jor1RKkjrOQ/bez2sFnLjFRPr9yM9pLYWx2bjPNNBz
         +3lzIOElaS/CRtT7q/u4sXn9CX/MB357yZYyb1r718eM6SUk+k9Wr/oaYgKxq7kY+svp
         Wrew==
Content-Disposition: inline
In-Reply-To: <20191104084520.398584-1-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Namhyung Kim <namhyung@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Song Liu <liu.song.a23@gmail.com>, cgroups@vger.kernel.org

On Mon, Nov 04, 2019 at 05:45:18PM +0900, Namhyung Kim wrote:
> Hello,
> 
> This patchset changes cgroup inode number and id management to be in
> sync with kernfs.  The cgroup inode number is managed by kernfs but
> cgroup id is allocated by a separate idr.  The idea is to have a
> single id for internal usage, inode number and file handle which can
> be accessed from userspace.  Actually this work is from Tejun who also
> provided the idea.  I just took over the work and fixed some errors
> and finally was able to run perf for testing.
> 
> The background of this work is that I want to add cgroup sampling
> feature in the perf event subsystem.  As Tejun mentioned that using
> cgroup id is not enough and it'd better using file handle instead.
> But getting file handle in perf NMI handler is not possible so I want
> to get the info from a cgroup node.
> 
> The first patch converted kernfs id into a single 64bit number and in
> the second patch cgroup uses the kernfs id as cgroup id.
> 
> The patches are based on the for-next branch in Tejun's cgroup tree.
> Tested with tools/testing/selftests/cgroup/test_stress.sh.

Sorry about the delay.  I'm still working on the patch series and the
draft patches currently posted aren't quite correct (e.g. netprio is
now trying to allocate arrays which use u64 values as index and that
u64 value can start with 33rd bit set from the get-go).

So, please hold on w/ this series for now.

Thanks.

-- 
tejun
