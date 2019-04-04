From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: Re: [PATCH] cgroup: remove extra cgroup_migrate_finish() call
Date: Thu, 4 Apr 2019 14:30:39 -0400
Message-ID: <20190404183039.ynhstolbzdeq2tpp@ca-dmjordan1.us.oracle.com>
References: <20190403230354.117915-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=YOSgKawQbJ2vNpQpNCCdqDDQihrGtpjIkwq7F+qx4Lw=;
 b=bhdqKUN7BOCGezrb4osx0UDISWDcaDHTbFCl+JtEqA+TuJtv8Uq48E10yE54YMFORwdD
 RPufG3MuEA4v1f0EhJcnb4XAZwsHiVp+cKVtxBR/tgySYUsLZk+lgKO+kWENSgz3dyj2
 d+OqxL7UviAHWULi57Az/4HX2m9vA0JIyQTVYsIPuZKwgConM4p08PnpSFyNXGQrGgG0
 47t8nZoAHJQrPcQ+pljfm6t31RXx5Xa/PASD5K7WTNUvrGDkPOFwajbGT5ktLwWRaYpU
 dYYKCgoRe5FTwb9DiYhdyPPoEMGkMxFsNuCedZEgiERnMTGNS1gUq3I7UAOCvkctz0SH 0g== 
Content-Disposition: inline
In-Reply-To: <20190403230354.117915-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Apr 03, 2019 at 04:03:54PM -0700, Shakeel Butt wrote:
> The callers of cgroup_migrate_prepare_dst() correctly call
> cgroup_migrate_finish() for success and failure cases both. No need to
> call it in cgroup_migrate_prepare_dst() in failure case.

Calling cgroup_migrate_finish multiple times is a no-op, so thankfully it
wasn't causing any problems.  Looks good to me.

Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
