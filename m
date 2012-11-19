From: Daniel Wagner <wagi@monom.org>
Subject: Re: [PATCH 2/3] netcls_cgroup: introduce cgroup_cls_state->is_local
Date: Mon, 19 Nov 2012 13:54:26 +0100
Message-ID: <50AA2C02.1000702@monom.org>
References: <1353123062-23193-1-git-send-email-tj@kernel.org> <1353123062-23193-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1353123062-23193-3-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: serge.hallyn@canonical.com, ebiederm@xmission.com, nhorman@tuxdriver.com, tgraf@suug.ch, davem@davemloft.net, lizefan@huawei.com, cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org

Hi Tejun,

On 17.11.2012 04:31, Tejun Heo wrote:
> -static int write_classid(struct cgroup *cgrp, struct cftype *cft, u64 value)
> +static int write_classid(struct cgroup *cgrp, struct cftype *cft,
> +			 const char *buf)
>   {
> +	struct cgroup_cls_state *cs = cgrp_cls_state(cgrp);
> +	s64 v;
> +
> +	if (sscanf(buf, "%lld", &v) != 1)
> +		return -EINVAL;
> +

This changes the user API slightly. cgroup_write_u64() uses 
simple_stroull() to parse the string. simple_stroull() allows to use 
either 0x1234 or 1234 as input. sscanf() will only handle the later type 
of input.

I noticed this because my test script stopped working:

    mkdir /sys/fs/cgroup/net_cls/a
    echo 0x100002 > /sys/fs/cgroup/net_cls/a/net_cls.classid # 10:2

    tc qdisc add dev $DEV root handle 10: htb
    tc class add dev $DEV parent 10: classid 10:2 htb rate 1mbit
    tc qdisc add dev $DEV parent 10:2 handle 20: sfq perturb 10

I am not completely sure if my setup is 100% correct, but at least
it seems to make something :)

cheers,
daniel
