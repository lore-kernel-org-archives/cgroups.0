From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next] cgroup/cpuset: fix kernel-doc
Date: Wed, 2 Aug 2023 09:37:24 -1000
Message-ID: <ZMqwdM4mfj6pOUyq@slm.duckdns.org>
References: <20230802030412.173344-1-caixinchen1@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691005047; x=1691609847;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ISzIgGhTLcZdgPj3UkOAFHUdMQQ45Q4Ef86Im/scO/I=;
        b=piacTQspru1LaGeL+sb6/aBbUFMAImUJ0qdSJvQ3bYNPK5Nktiy3VArW4b1TD2xl0M
         2AMkphtlcAppMzUuG4qJLhRx/pbw1f+XIqb5wb4bEL07WeXrHQWbfyjyR16yUYi+HDZR
         U5M5DHJUNBHtVTWOcc4tENIHSjT6W9MLPTDtJqycV0OfV/txQcegxA6S1Gpa9Rxl4kbg
         alhFQSdR8ZM+Y6A1sWGSYnd64CdCS1jLX4+A+OrTsO2TohbNnJIiUUWfEC1nTCzaXq5H
         NeHY5bTpSq/+ZCn4uQeNok3ahoz5C3pyiAh258+BL5pbPkQwhuI05F6fuBxtmMB9vsac
         23Ug==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230802030412.173344-1-caixinchen1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Cai Xinchen <caixinchen1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Aug 02, 2023 at 03:04:12AM +0000, Cai Xinchen wrote:
> Add kernel-doc of param @rotor to fix warnings:
> 
> kernel/cgroup/cpuset.c:4162: warning: Function parameter or member
> 'rotor' not described in 'cpuset_spread_node'
> kernel/cgroup/cpuset.c:3771: warning: Function parameter or member
> 'work' not described in 'cpuset_hotplug_workfn'
> 
> Signed-off-by: Cai Xinchen <caixinchen1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.6.

Thanks.

-- 
tejun
