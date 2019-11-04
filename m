From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 2/2] cgroup: Use 64bit id from kernfs
Date: Mon, 04 Nov 2019 10:58:19 -0800 (PST)
Message-ID: <20191104.105819.2064664721682565230.davem@davemloft.net>
References: <20191104084520.398584-1-namhyung@kernel.org>
        <20191104084520.398584-3-namhyung@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191104084520.398584-3-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: namhyung@kernel.org
Cc: tj@kernel.org, hannes@cmpxchg.org, lizefan@huawei.com, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, rafael@kernel.org, liu.song.a23@gmail.com, cgroups@vger.kernel.org, nhorman@tuxdriver.com, netdev@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>
Date: Mon,  4 Nov 2019 17:45:20 +0900

> From: Tejun Heo <tj@kernel.org>
> 
> Use 64 bit id allocated by kernfs instead of using its own idr since
> it seems not used for saving any information no more.  So let's get
> rid of the cgroup_idr from cgroup_root.
> 
> The index of netprio_map is also changed to u64.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Tejun Heo <tj@kernel.org>
> [namhyung: split cgroup changes and fix netprio_map access]
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: David S. Miller <davem@davemloft.net>
