Received: from arkamax.eu (128-116-240-228.dyn.eolo.it [128.116.240.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06D82D6E64;
	Tue, 22 Sep 2026 07:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=128.116.240.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790060461; cv=none; b=Ea0EzlZEplMGU/fRkTGVgISuF0OwY5+L6FyeSQ8L2FW3ElegpkDaiD1h47b9A/AqtrcikFMkQ6QaRXCpauFgvfrkNZzMSXjiJ6f0y36c3vRlGVs/TNrLbPC5j3U3Bv9xaePFkTnomX93HdbFgBBM4vI4TbVY0KFsW3jknKbwT+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790060461; c=relaxed/simple;
	bh=CAqkmjgDHeT4KX/+1ZEXjoO4Q4rUYTtC11T8j0dN5JY=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=F1OB5f8FFt0RYr6kmuHu73sfxprvWa+QTvIsmvWZutcqK4bcPySJ9tFVX8JDNckK465VksvAvlzNkqz4QsgJMW0vfXHGwQ/WBmvc144h+ogbOOsWQvHgzM+qam5gWE0XlQn0sct4RC1Y9z1cp8IcI8PiuODRW1cHGWHIisREB6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arkamax.eu; spf=pass smtp.mailfrom=arkamax.eu; dkim=pass (2048-bit key) header.d=arkamax.eu header.i=@arkamax.eu header.b=moko7McD; arc=none smtp.client-ip=128.116.240.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arkamax.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arkamax.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arkamax.eu header.i=@arkamax.eu header.b="moko7McD"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; s=mail1; bh=CAqkmjgDHeT4KX
	/+1ZEXjoO4Q4rUYTtC11T8j0dN5JY=; h=in-reply-to:references:cc:to:from:
	subject:date; d=arkamax.eu; b=moko7McDOtrqA73bKVWMfH/KqhE2nuuAlrwgDNac
	U/Ii3p6hCzQO80nxemAF9YCTnAO93uRcLkK/DZBSJbbWqwdW6f3iG3aeCm+RTppZjw8uaH
	rQXcckVP3G9gvSqJcY1HgSFMLNZbBAWJIlFYd8kejdYKuZgEs6rMAZLFLJbQ25EM0Q84QA
	anzOEiXlgY1vgA7C0GhtP7b6Pk8xNDIOK7Ih9i4yyPRivN4giNbrG8bGWc9OLjCGVK16Ho
	9eAygNbPtgTo1BZm1j8OGOXvGNabPrqD57G6n/hEhSBgS8SX3Oidii1XZ/pGn6D7W7kg3x
	3MsZPp9DWhDbXzryyiC92A==
Received: from localhost (128-116-240-228.dyn.eolo.it [128.116.240.228])
	by arkamax.eu (OpenSMTPD) with ESMTPSA id 3b61ff78 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Tue, 22 Sep 2026 09:00:55 +0200 (CEST)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 22 Sep 2026 09:00:55 +0200
Message-Id: <DLLNH0LKS8DS.2V0TPX88A4M4J@arkamax.eu>
Subject: Re: [PATCH v2] nvmet: add cgroup_path to charge namespace I/O to a
 cgroup
From: "Maurizio Lombardi" <mlombard@arkamax.eu>
To: "yupeng" <yupeng0921@gmail.com>, "Christoph Hellwig" <hch@lst.de>, "Sagi
 Grimberg" <sagi@grimberg.me>, "Chaitanya Kulkarni" <kch@nvidia.com>
Cc: "Tejun Heo" <tj@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>,
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, "Josef Bacik"
 <josef@toxicpanda.com>, "Jens Axboe" <axboe@kernel.dk>,
 <cgroups@vger.kernel.org>, <linux-block@vger.kernel.org>,
 <linux-nvme@lists.infradead.org>, <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.22.0
References: <20260922065115.22508-1-yupeng0921@gmail.com>
In-Reply-To: <20260922065115.22508-1-yupeng0921@gmail.com>

On Tue Sep 22, 2026 at 8:51 AM CEST, yupeng wrote:
> From: Peng Yu <yupeng0921@gmail.com>
>
> Scenario:
> * Create multiple nvmet subsystems/namespaces.
> * The namespaces are backed by different LVM logical volumes.
> * Some of the logical volumes share the same physical volumes.
> * The subsystems are exported to different users.
> * We should provide each user a specific iops/bps quota, thus a noisy
>   neighbor won't impact the performance of other logical volumes.
>
> Implementation:
> * Add a `cgroup_path` attribute under the nvmet namespace folder, e.g.:
>   /sys/kernel/config/nvmet/subsystems/nqn.2026-09.io.test01:bdev/namespac=
es/1/cgroup_path
> * We can write a cgroup path to it, then that cgroup will control
>   the IOs used by the namespace.
> * Write an empty string to clear it.
> * The cgroup_path could be modified when the namespace is disabled.
> * Support both block device backed namespaces and file backed namespaces.
> * Only the direct io scenario is supported, enabling a namespace that
>   has both cgroup_path and buffered_io set fails with -EINVAL.
>
> Test:
> 1 Load kernel modules.
> sudo modprobe brd rd_nr=3D2 rd_size=3D1048576
> sudo modprobe nvmet
> sudo modprobe nvmet_tcp
> sudo modprobe nvme_tcp
>
> 2 The two brd devices are used for a bdev backed namespace and a file
> backed namespace, remember their major/minor.
> lsblk --noheadings --nodeps --output NAME,MAJ:MIN,SIZE /dev/ram0 /dev/ram=
1
> ram0   1:0      1G
> ram1   1:1      1G
>
> 3 Enable the io controller and create two cgroups, one for the bdev
> backed namespace, another for the file backed namespace.
> echo "+io" | sudo tee /sys/fs/cgroup/cgroup.subtree_control
> sudo mkdir -p /sys/fs/cgroup/nvmet-bdev
> sudo mkdir -p /sys/fs/cgroup/nvmet-file
>
> 4 Create a file system and a file on ram0.
> sudo mkfs.ext4 /dev/ram0
> sudo mkdir -p /mnt/nvmet-file
> sudo mount -o noatime /dev/ram0 /mnt/nvmet-file
> sudo dd if=3D/dev/zero of=3D/mnt/nvmet-file/ns.img bs=3D1M count=3D512 of=
lag=3Ddirect
>
> 5 Create the bdev backed subsystem and namespace.
> sudo mkdir -p /sys/kernel/config/nvmet/subsystems/nqn.2026-09.io.test01:b=
dev/namespaces/1
> echo 1 | sudo tee /sys/kernel/config/nvmet/subsystems/nqn.2026-09.io.test=
01:bdev/attr_allow_any_host
> echo /dev/ram1 | sudo tee /sys/kernel/config/nvmet/subsystems/nqn.2026-09=
.io.test01:bdev/namespaces/1/device_path
> echo /nvmet-bdev | sudo tee /sys/kernel/config/nvmet/subsystems/nqn.2026-=
09.io.test01:bdev/namespaces/1/cgroup_path
> echo 1 | sudo tee /sys/kernel/config/nvmet/subsystems/nqn.2026-09.io.test=
01:bdev/namespaces/1/enable
>
> 6 Create the file backed subsystem and namespace.
> sudo mkdir -p /sys/kernel/config/nvmet/subsystems/nqn.2026-09.io.test01:f=
ile/namespaces/1
> echo 1 | sudo tee /sys/kernel/config/nvmet/subsystems/nqn.2026-09.io.test=
01:file/attr_allow_any_host
> echo /mnt/nvmet-file/ns.img | sudo tee /sys/kernel/config/nvmet/subsystem=
s/nqn.2026-09.io.test01:file/namespaces/1/device_path
> echo /nvmet-file | sudo tee /sys/kernel/config/nvmet/subsystems/nqn.2026-=
09.io.test01:file/namespaces/1/cgroup_path
> echo 1 | sudo tee /sys/kernel/config/nvmet/subsystems/nqn.2026-09.io.test=
01:file/namespaces/1/enable
>
> 7 Export the two subsystems to 127.0.0.1.
> sudo mkdir -p /sys/kernel/config/nvmet/ports/1
> echo ipv4 | sudo tee /sys/kernel/config/nvmet/ports/1/addr_adrfam
> echo tcp | sudo tee /sys/kernel/config/nvmet/ports/1/addr_trtype
> echo 127.0.0.1 | sudo tee /sys/kernel/config/nvmet/ports/1/addr_traddr
> echo 4420 | sudo tee /sys/kernel/config/nvmet/ports/1/addr_trsvcid
> sudo ln -s /sys/kernel/config/nvmet/subsystems/nqn.2026-09.io.test01:bdev=
 /sys/kernel/config/nvmet/ports/1/subsystems/nqn.2026-09.io.test01:bdev
> sudo ln -s /sys/kernel/config/nvmet/subsystems/nqn.2026-09.io.test01:file=
 /sys/kernel/config/nvmet/ports/1/subsystems/nqn.2026-09.io.test01:file
>
> 8 Connect the two subsystems from 127.0.0.1.
> sudo nvme connect -t tcp -a 127.0.0.1 -s 4420 -n nqn.2026-09.io.test01:bd=
ev
> sudo nvme connect -t tcp -a 127.0.0.1 -s 4420 -n nqn.2026-09.io.test01:fi=
le
> sudo udevadm settle
>
> 9 Set riops to 20k and run fio.
> echo "1:1 riops=3D20000 wiops=3Dmax rbps=3Dmax wbps=3Dmax" | sudo tee /sy=
s/fs/cgroup/nvmet-bdev/io.max
> echo "1:0 riops=3D20000 wiops=3Dmax rbps=3Dmax wbps=3Dmax" | sudo tee /sy=
s/fs/cgroup/nvmet-file/io.max
>
> sudo fio --name=3Dt --filename=3D/dev/nvme0n1 --rw=3Drandread --bs=3D4k -=
-iodepth=3D32 --numjobs=3D1 \
> --direct=3D1 --ioengine=3Dlibaio --time_based --runtime=3D10 --ramp_time=
=3D3 \
> --group_reporting 2>/dev/null | grep -E '^ +(read|write): IOPS'
>   read: IOPS=3D20.0k, BW=3D78.1MiB/s (81.9MB/s)(781MiB/10001msec)
>
> sudo fio --name=3Dt --filename=3D/dev/nvme1n1 --rw=3Drandread --bs=3D4k -=
-iodepth=3D32 --numjobs=3D1 \
> --direct=3D1 --ioengine=3Dlibaio --time_based --runtime=3D10 --ramp_time=
=3D3 \
> --group_reporting 2>/dev/null | grep -E '^ +(read|write): IOPS'
>   read: IOPS=3D20.0k, BW=3D78.1MiB/s (81.9MB/s)(781MiB/10001msec)
>
> 10 Set rbps to 100M and run fio.
> echo "1:1 riops=3Dmax wiops=3Dmax rbps=3D104857600 wbps=3Dmax" | sudo tee=
 /sys/fs/cgroup/nvmet-bdev/io.max
> echo "1:0 riops=3Dmax wiops=3Dmax rbps=3D104857600 wbps=3Dmax" | sudo tee=
 /sys/fs/cgroup/nvmet-file/io.max
>
> sudo fio --name=3Dt --filename=3D/dev/nvme0n1 --rw=3Dread --bs=3D1M --iod=
epth=3D32 --numjobs=3D1 \
> --direct=3D1 --ioengine=3Dlibaio --time_based --runtime=3D10 --ramp_time=
=3D3 \
> --group_reporting 2>/dev/null | grep -E '^ +(read|write): IOPS'
>   read: IOPS=3D97, BW=3D100MiB/s (105MB/s)(1033MiB/10304msec)
>
> sudo fio --name=3Dt --filename=3D/dev/nvme1n1 --rw=3Dread --bs=3D1M --iod=
epth=3D32 --numjobs=3D1 \
> --direct=3D1 --ioengine=3Dlibaio --time_based --runtime=3D10 --ramp_time=
=3D3 \
> --group_reporting 2>/dev/null | grep -E '^ +(read|write): IOPS'
>   read: IOPS=3D97, BW=3D100MiB/s (105MB/s)(1031MiB/10297msec)
>
> 11 Set wiops to 20k and run fio.
> echo "1:1 riops=3Dmax wiops=3D20000 rbps=3Dmax wbps=3Dmax" | sudo tee /sy=
s/fs/cgroup/nvmet-bdev/io.max
> echo "1:0 riops=3Dmax wiops=3D20000 rbps=3Dmax wbps=3Dmax" | sudo tee /sy=
s/fs/cgroup/nvmet-file/io.max
>
> sudo fio --name=3Dt --filename=3D/dev/nvme0n1 --rw=3Drandwrite --bs=3D4k =
--iodepth=3D32 --numjobs=3D1 \
> --direct=3D1 --ioengine=3Dlibaio --time_based --runtime=3D10 --ramp_time=
=3D3 \
> --group_reporting 2>/dev/null | grep -E '^ +(read|write): IOPS'
>   write: IOPS=3D20.0k, BW=3D78.1MiB/s (81.9MB/s)(781MiB/10001msec); 0 zon=
e resets
>
> sudo fio --name=3Dt --filename=3D/dev/nvme1n1 --rw=3Drandwrite --bs=3D4k =
--iodepth=3D32 --numjobs=3D1 \
> --direct=3D1 --ioengine=3Dlibaio --time_based --runtime=3D10 --ramp_time=
=3D3 \
> --group_reporting 2>/dev/null | grep -E '^ +(read|write): IOPS'
>   write: IOPS=3D20.0k, BW=3D78.1MiB/s (81.9MB/s)(781MiB/10001msec); 0 zon=
e resets
>
> 12 Set wbps to 100M and run fio.
> echo "1:1 riops=3Dmax wiops=3Dmax rbps=3Dmax wbps=3D104857600" | sudo tee=
 /sys/fs/cgroup/nvmet-bdev/io.max
> echo "1:0 riops=3Dmax wiops=3Dmax rbps=3Dmax wbps=3D104857600" | sudo tee=
 /sys/fs/cgroup/nvmet-file/io.max
>
> sudo fio --name=3Dt --filename=3D/dev/nvme0n1 --rw=3Dwrite --bs=3D1M --io=
depth=3D32 --numjobs=3D1 \
> --direct=3D1 --ioengine=3Dlibaio --time_based --runtime=3D10 --ramp_time=
=3D3 \
> --group_reporting 2>/dev/null | grep -E '^ +(read|write): IOPS'
>   write: IOPS=3D97, BW=3D100MiB/s (105MB/s)(1031MiB/10305msec); 0 zone re=
sets
>
> sudo fio --name=3Dt --filename=3D/dev/nvme1n1 --rw=3Dwrite --bs=3D1M --io=
depth=3D32 --numjobs=3D1 \
> --direct=3D1 --ioengine=3Dlibaio --time_based --runtime=3D10 --ramp_time=
=3D3 \
> --group_reporting 2>/dev/null | grep -E '^ +(read|write): IOPS'
>   write: IOPS=3D97, BW=3D100MiB/s (105MB/s)(1032MiB/10297msec); 0 zone re=
sets
>
> 13 Cleanup the environment.
> sudo nvme disconnect -n nqn.2026-09.io.test01:bdev
> sudo nvme disconnect -n nqn.2026-09.io.test01:file
> sudo udevadm settle
>
> sudo rm -f /sys/kernel/config/nvmet/ports/1/subsystems/nqn.2026-09.io.tes=
t01:bdev
> sudo rm -f /sys/kernel/config/nvmet/ports/1/subsystems/nqn.2026-09.io.tes=
t01:file
> sudo rmdir /sys/kernel/config/nvmet/ports/1
>
> echo 0 | sudo tee /sys/kernel/config/nvmet/subsystems/nqn.2026-09.io.test=
01:bdev/namespaces/1/enable
> sudo rmdir /sys/kernel/config/nvmet/subsystems/nqn.2026-09.io.test01:bdev=
/namespaces/1
> sudo rmdir /sys/kernel/config/nvmet/subsystems/nqn.2026-09.io.test01:bdev
>
> echo 0 | sudo tee /sys/kernel/config/nvmet/subsystems/nqn.2026-09.io.test=
01:file/namespaces/1/enable
> sudo rmdir /sys/kernel/config/nvmet/subsystems/nqn.2026-09.io.test01:file=
/namespaces/1
> sudo rmdir /sys/kernel/config/nvmet/subsystems/nqn.2026-09.io.test01:file
>
> sudo umount /mnt/nvmet-file
> sudo rmdir /mnt/nvmet-file
> sudo modprobe -r brd
>
> sudo rmdir /sys/fs/cgroup/nvmet-bdev
> sudo rmdir /sys/fs/cgroup/nvmet-file
>
> sudo rmmod nvme_tcp
> sudo rmmod nvmet_tcp
> sudo rmmod nvmet

IMO the commit message should just explain the problem and its fix.
All those test details and commands belong to a cover letter.

Maurizio

>
> Signed-off-by: Peng Yu <yupeng0921@gmail.com>
> Assisted-by: Claude:claude-fable-5 [Claude Code]
> Assisted-by: Claude:claude-opus-5 [Claude Code]
> ---
>  drivers/nvme/target/configfs.c    | 59 ++++++++++++++++++++++++
>  drivers/nvme/target/core.c        | 75 +++++++++++++++++++++++++++++++
>  drivers/nvme/target/io-cmd-bdev.c | 18 +++++++-
>  drivers/nvme/target/io-cmd-file.c | 21 ++++++++-
>  drivers/nvme/target/nvmet.h       | 47 +++++++++++++++++++
>  drivers/nvme/target/zns.c         |  1 +
>  6 files changed, 218 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configf=
s.c
> index 6286e38436dd..829b92d04ad4 100644
> --- a/drivers/nvme/target/configfs.c
> +++ b/drivers/nvme/target/configfs.c
> @@ -561,6 +561,62 @@ static ssize_t nvmet_ns_device_path_store(struct con=
fig_item *item,
> =20
>  CONFIGFS_ATTR(nvmet_ns_, device_path);
> =20
> +#ifdef CONFIG_BLK_CGROUP
> +static ssize_t nvmet_ns_cgroup_path_show(struct config_item *item, char =
*page)
> +{
> +	struct nvmet_ns *ns =3D to_nvmet_ns(item);
> +	struct nvmet_subsys *subsys =3D ns->subsys;
> +	ssize_t ret;
> +
> +	mutex_lock(&subsys->lock);
> +	ret =3D snprintf(page, PAGE_SIZE, "%s\n", ns->cgroup_path ?: "");
> +	mutex_unlock(&subsys->lock);
> +	return ret;
> +}
> +
> +static ssize_t nvmet_ns_cgroup_path_store(struct config_item *item,
> +		const char *page, size_t count)
> +{
> +	struct nvmet_ns *ns =3D to_nvmet_ns(item);
> +	struct nvmet_subsys *subsys =3D ns->subsys;
> +	size_t len;
> +	int ret =3D count;
> +
> +	mutex_lock(&subsys->lock);
> +
> +	if (ns->enabled) {
> +		ret =3D -EBUSY;
> +		goto out_unlock;
> +	}
> +
> +	len =3D strcspn(page, "\n");
> +	if (!len) {
> +		/* An empty write clears the association. */
> +		kfree(ns->cgroup_path);
> +		ns->cgroup_path =3D NULL;
> +		goto out_unlock;
> +	}
> +
> +	if (page[0] !=3D '/' || len >=3D PATH_MAX) {
> +		ret =3D -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	kfree(ns->cgroup_path);
> +	ns->cgroup_path =3D kmemdup_nul(page, len, GFP_KERNEL);
> +	if (!ns->cgroup_path) {
> +		ret =3D -ENOMEM;
> +		goto out_unlock;
> +	}
> +
> +out_unlock:
> +	mutex_unlock(&subsys->lock);
> +	return ret;
> +}
> +
> +CONFIGFS_ATTR(nvmet_ns_, cgroup_path);
> +#endif /* CONFIG_BLK_CGROUP */
> +
>  #ifdef CONFIG_PCI_P2PDMA
>  static ssize_t nvmet_ns_p2pmem_show(struct config_item *item, char *page=
)
>  {
> @@ -833,6 +889,9 @@ static struct configfs_attribute *nvmet_ns_attrs[] =
=3D {
>  	&nvmet_ns_attr_buffered_io,
>  	&nvmet_ns_attr_revalidate_size,
>  	&nvmet_ns_attr_resv_enable,
> +#ifdef CONFIG_BLK_CGROUP
> +	&nvmet_ns_attr_cgroup_path,
> +#endif
>  #ifdef CONFIG_PCI_P2PDMA
>  	&nvmet_ns_attr_p2pmem,
>  #endif
> diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
> index 43871a8f56ca..3e4972513c3e 100644
> --- a/drivers/nvme/target/core.c
> +++ b/drivers/nvme/target/core.c
> @@ -4,6 +4,7 @@
>   * Copyright (c) 2015-2016 HGST, a Western Digital Company.
>   */
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +#include <linux/cgroup.h>
>  #include <linux/hex.h>
>  #include <linux/module.h>
>  #include <linux/random.h>
> @@ -474,8 +475,77 @@ void nvmet_put_namespace(struct nvmet_ns *ns)
>  	percpu_ref_put(&ns->ref);
>  }
> =20
> +#ifdef CONFIG_BLK_CGROUP
> +static int nvmet_blkcg_ns_enable(struct nvmet_ns *ns)
> +{
> +	struct cgroup_subsys_state *css;
> +	struct cgroup *cgrp;
> +
> +	if (!ns->cgroup_path)
> +		return 0;
> +
> +	/*
> +	 * Buffered writes will be handled by a separate thread,
> +	 * these IOs have no namespace/cgroup information at that time,
> +	 * so we don't support buffered io.
> +	 */
> +	if (ns->buffered_io) {
> +		pr_err("cgroup_path is not supported with buffered_io: %s\n",
> +		       ns->device_path);
> +		return -EINVAL;
> +	}
> +
> +	cgrp =3D cgroup_get_from_path(ns->cgroup_path);
> +	if (IS_ERR(cgrp)) {
> +		pr_err("failed to resolve cgroup path %s: %ld\n",
> +		       ns->cgroup_path, PTR_ERR(cgrp));
> +		return PTR_ERR(cgrp);
> +	}
> +
> +	css =3D cgroup_get_e_css(cgrp, &io_cgrp_subsys);
> +	if (!css || css->cgroup !=3D cgrp) {
> +		pr_err("the io controller is not enabled in cgroup %s\n",
> +		       ns->cgroup_path);
> +		if (css)
> +			css_put(css);
> +		cgroup_put(cgrp);
> +		return -EINVAL;
> +	}
> +	ns->blkcg_css =3D css;
> +	cgroup_put(cgrp);
> +	return 0;
> +}
> +
> +static void nvmet_blkcg_ns_disable(struct nvmet_ns *ns)
> +{
> +	if (ns->blkcg_css) {
> +		css_put(ns->blkcg_css);
> +		ns->blkcg_css =3D NULL;
> +	}
> +}
> +
> +static void nvmet_blkcg_ns_free(struct nvmet_ns *ns)
> +{
> +	kfree(ns->cgroup_path);
> +}
> +#else
> +static inline int nvmet_blkcg_ns_enable(struct nvmet_ns *ns)
> +{
> +	return 0;
> +}
> +
> +static inline void nvmet_blkcg_ns_disable(struct nvmet_ns *ns)
> +{
> +}
> +
> +static inline void nvmet_blkcg_ns_free(struct nvmet_ns *ns)
> +{
> +}
> +#endif /* CONFIG_BLK_CGROUP */
> +
>  static void nvmet_ns_dev_disable(struct nvmet_ns *ns)
>  {
> +	nvmet_blkcg_ns_disable(ns);
>  	nvmet_bdev_ns_disable(ns);
>  	nvmet_file_ns_disable(ns);
>  }
> @@ -602,6 +672,10 @@ int nvmet_ns_enable(struct nvmet_ns *ns)
>  	if (ret)
>  		goto out_unlock;
> =20
> +	ret =3D nvmet_blkcg_ns_enable(ns);
> +	if (ret)
> +		goto out_dev_disable;
> +
>  	ret =3D nvmet_p2pmem_ns_enable(ns);
>  	if (ret)
>  		goto out_dev_disable;
> @@ -699,6 +773,7 @@ void nvmet_ns_free(struct nvmet_ns *ns)
>  	up_write(&nvmet_ana_sem);
> =20
>  	kfree(ns->device_path);
> +	nvmet_blkcg_ns_free(ns);
>  	kfree(ns);
>  }
> =20
> diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-c=
md-bdev.c
> index f2d9e8901df4..0014e5ef2853 100644
> --- a/drivers/nvme/target/io-cmd-bdev.c
> +++ b/drivers/nvme/target/io-cmd-bdev.c
> @@ -297,6 +297,7 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *r=
eq)
>  		bio =3D bio_alloc(req->ns->bdev, bio_max_segs(sg_cnt), opf,
>  				GFP_KERNEL);
>  	}
> +	nvmet_blkcg_set_bio(req->ns, bio);
>  	bio->bi_iter.bi_sector =3D sector;
>  	bio->bi_private =3D req;
>  	bio->bi_end_io =3D nvmet_bio_done;
> @@ -322,6 +323,7 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *r=
eq)
> =20
>  			bio =3D bio_alloc(req->ns->bdev, bio_max_segs(sg_cnt),
>  					opf, GFP_KERNEL);
> +			nvmet_blkcg_set_bio(req->ns, bio);
>  			bio->bi_iter.bi_sector =3D sector;
> =20
>  			bio_chain(bio, prev);
> @@ -358,6 +360,7 @@ static void nvmet_bdev_execute_flush(struct nvmet_req=
 *req)
> =20
>  	bio_init(bio, req->ns->bdev, req->inline_bvec,
>  		 ARRAY_SIZE(req->inline_bvec), REQ_OP_WRITE | REQ_PREFLUSH);
> +	nvmet_blkcg_set_bio(req->ns, bio);
>  	bio->bi_private =3D req;
>  	bio->bi_end_io =3D nvmet_bio_done;
> =20
> @@ -366,10 +369,16 @@ static void nvmet_bdev_execute_flush(struct nvmet_r=
eq *req)
> =20
>  u16 nvmet_bdev_flush(struct nvmet_req *req)
>  {
> +	bool associated;
> +	int ret;
> +
>  	if (!bdev_write_cache(req->ns->bdev))
>  		return 0;
> =20
> -	if (blkdev_issue_flush(req->ns->bdev))
> +	associated =3D nvmet_blkcg_begin(req->ns);
> +	ret =3D blkdev_issue_flush(req->ns->bdev);
> +	nvmet_blkcg_end(associated);
> +	if (ret)
>  		return NVME_SC_INTERNAL | NVME_STATUS_DNR;
>  	return 0;
>  }
> @@ -380,9 +389,11 @@ static void nvmet_bdev_execute_discard(struct nvmet_=
req *req)
>  	struct nvme_dsm_range range;
>  	struct bio *bio =3D NULL;
>  	sector_t nr_sects;
> +	bool associated;
>  	int i;
>  	u16 status =3D NVME_SC_SUCCESS;
> =20
> +	associated =3D nvmet_blkcg_begin(ns);
>  	for (i =3D 0; i <=3D le32_to_cpu(req->cmd->dsm.nr); i++) {
>  		status =3D nvmet_copy_from_sgl(req, i * sizeof(range), &range,
>  				sizeof(range));
> @@ -394,6 +405,7 @@ static void nvmet_bdev_execute_discard(struct nvmet_r=
eq *req)
>  				nvmet_lba_to_sect(ns, range.slba), nr_sects,
>  				GFP_KERNEL, &bio);
>  	}
> +	nvmet_blkcg_end(associated);
> =20
>  	if (bio) {
>  		bio->bi_private =3D req;
> @@ -431,6 +443,7 @@ static void nvmet_bdev_execute_write_zeroes(struct nv=
met_req *req)
>  	struct bio *bio =3D NULL;
>  	sector_t sector;
>  	sector_t nr_sector;
> +	bool associated;
>  	int ret;
> =20
>  	if (!nvmet_check_transfer_len(req, 0))
> @@ -440,8 +453,11 @@ static void nvmet_bdev_execute_write_zeroes(struct n=
vmet_req *req)
>  	nr_sector =3D (((sector_t)le16_to_cpu(write_zeroes->length) + 1) <<
>  		(req->ns->blksize_shift - 9));
> =20
> +	associated =3D nvmet_blkcg_begin(req->ns);
>  	ret =3D __blkdev_issue_zeroout(req->ns->bdev, sector, nr_sector,
>  			GFP_KERNEL, &bio, 0);
> +	nvmet_blkcg_end(associated);
> +
>  	if (bio) {
>  		bio->bi_private =3D req;
>  		bio->bi_end_io =3D nvmet_bio_done;
> diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-c=
md-file.c
> index 0b22d183f927..570e65259ad8 100644
> --- a/drivers/nvme/target/io-cmd-file.c
> +++ b/drivers/nvme/target/io-cmd-file.c
> @@ -79,6 +79,8 @@ static ssize_t nvmet_file_submit_bvec(struct nvmet_req =
*req, loff_t pos,
>  	struct kiocb *iocb =3D &req->f.iocb;
>  	ssize_t (*call_iter)(struct kiocb *iocb, struct iov_iter *iter);
>  	struct iov_iter iter;
> +	bool associated;
> +	ssize_t ret;
>  	int rw;
> =20
>  	if (req->cmd->rw.opcode =3D=3D nvme_cmd_write) {
> @@ -97,7 +99,10 @@ static ssize_t nvmet_file_submit_bvec(struct nvmet_req=
 *req, loff_t pos,
>  	iocb->ki_filp =3D req->ns->file;
>  	iocb->ki_flags =3D ki_flags | iocb->ki_filp->f_iocb_flags;
> =20
> -	return call_iter(iocb, &iter);
> +	associated =3D nvmet_blkcg_begin(req->ns);
> +	ret =3D call_iter(iocb, &iter);
> +	nvmet_blkcg_end(associated);
> +	return ret;
>  }
> =20
>  static void nvmet_file_io_done(struct kiocb *iocb, long ret)
> @@ -251,7 +256,13 @@ static void nvmet_file_execute_rw(struct nvmet_req *=
req)
> =20
>  u16 nvmet_file_flush(struct nvmet_req *req)
>  {
> -	return errno_to_nvme_status(req, vfs_fsync(req->ns->file, 1));
> +	bool associated;
> +	int ret;
> +
> +	associated =3D nvmet_blkcg_begin(req->ns);
> +	ret =3D vfs_fsync(req->ns->file, 1);
> +	nvmet_blkcg_end(associated);
> +	return errno_to_nvme_status(req, ret);
>  }
> =20
>  static void nvmet_file_flush_work(struct work_struct *w)
> @@ -274,10 +285,12 @@ static void nvmet_file_execute_discard(struct nvmet=
_req *req)
>  	int mode =3D FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
>  	struct nvme_dsm_range range;
>  	loff_t offset, len;
> +	bool associated;
>  	u16 status =3D 0;
>  	int ret;
>  	int i;
> =20
> +	associated =3D nvmet_blkcg_begin(req->ns);
>  	for (i =3D 0; i <=3D le32_to_cpu(req->cmd->dsm.nr); i++) {
>  		status =3D nvmet_copy_from_sgl(req, i * sizeof(range), &range,
>  					sizeof(range));
> @@ -300,6 +313,7 @@ static void nvmet_file_execute_discard(struct nvmet_r=
eq *req)
>  			break;
>  		}
>  	}
> +	nvmet_blkcg_end(associated);
> =20
>  	nvmet_req_complete(req, status);
>  }
> @@ -336,6 +350,7 @@ static void nvmet_file_write_zeroes_work(struct work_=
struct *w)
>  	int mode =3D FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE;
>  	loff_t offset;
>  	loff_t len;
> +	bool associated;
>  	int ret;
> =20
>  	offset =3D le64_to_cpu(write_zeroes->slba) << req->ns->blksize_shift;
> @@ -347,7 +362,9 @@ static void nvmet_file_write_zeroes_work(struct work_=
struct *w)
>  		return;
>  	}
> =20
> +	associated =3D nvmet_blkcg_begin(req->ns);
>  	ret =3D vfs_fallocate(req->ns->file, mode, offset, len);
> +	nvmet_blkcg_end(associated);
>  	nvmet_req_complete(req, ret < 0 ? errno_to_nvme_status(req, ret) : 0);
>  }
> =20
> diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
> index dbda55895f4f..1ef7be97a244 100644
> --- a/drivers/nvme/target/nvmet.h
> +++ b/drivers/nvme/target/nvmet.h
> @@ -21,6 +21,7 @@
>  #include <linux/radix-tree.h>
>  #include <linux/t10-pi.h>
>  #include <linux/kfifo.h>
> +#include <linux/kthread.h>
> =20
>  #define NVMET_DEFAULT_VS		NVME_VS(2, 1, 0)
> =20
> @@ -115,6 +116,16 @@ struct nvmet_ns {
>  	struct nvmet_subsys	*subsys;
>  	const char		*device_path;
> =20
> +#ifdef CONFIG_BLK_CGROUP
> +	const char	*cgroup_path;
> +	/*
> +	 * Resolved from ->cgroup_path when the namespace is enabled and
> +	 * released when it is disabled, so it has the same lifetime and
> +	 * visibility rules as ->bdev and ->file.
> +	 */
> +	struct cgroup_subsys_state *blkcg_css;
> +#endif
> +
>  	struct config_group	device_group;
>  	struct config_group	group;
> =20
> @@ -732,6 +743,42 @@ void nvmet_bdev_execute_zone_mgmt_recv(struct nvmet_=
req *req);
>  void nvmet_bdev_execute_zone_mgmt_send(struct nvmet_req *req);
>  void nvmet_bdev_execute_zone_append(struct nvmet_req *req);
> =20
> +#ifdef CONFIG_BLK_CGROUP
> +static inline void nvmet_blkcg_set_bio(struct nvmet_ns *ns, struct bio *=
bio)
> +{
> +	if (ns->blkcg_css)
> +		bio_associate_blkg_from_css(bio, ns->blkcg_css);
> +}
> +
> +static inline bool nvmet_blkcg_begin(struct nvmet_ns *ns)
> +{
> +	if (!ns->blkcg_css || !in_task() || !(current->flags & PF_KTHREAD))
> +		return false;
> +
> +	kthread_associate_blkcg(ns->blkcg_css);
> +	return true;
> +}
> +
> +static inline void nvmet_blkcg_end(bool associated)
> +{
> +	if (associated)
> +		kthread_associate_blkcg(NULL);
> +}
> +#else
> +static inline void nvmet_blkcg_set_bio(struct nvmet_ns *ns, struct bio *=
bio)
> +{
> +}
> +
> +static inline bool nvmet_blkcg_begin(struct nvmet_ns *ns)
> +{
> +	return false;
> +}
> +
> +static inline void nvmet_blkcg_end(bool associated)
> +{
> +}
> +#endif /* CONFIG_BLK_CGROUP */
> +
>  static inline u32 nvmet_rw_data_len(struct nvmet_req *req)
>  {
>  	return ((u32)le16_to_cpu(req->cmd->rw.length) + 1) <<
> diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
> index 23a17c02abee..1de1f0e1ef1c 100644
> --- a/drivers/nvme/target/zns.c
> +++ b/drivers/nvme/target/zns.c
> @@ -580,6 +580,7 @@ void nvmet_bdev_execute_zone_append(struct nvmet_req =
*req)
>  		bio =3D bio_alloc(req->ns->bdev, req->sg_cnt, opf, GFP_KERNEL);
>  	}
> =20
> +	nvmet_blkcg_set_bio(req->ns, bio);
>  	bio->bi_end_io =3D nvmet_bdev_zone_append_bio_done;
>  	bio->bi_iter.bi_sector =3D sect;
>  	bio->bi_private =3D req;

