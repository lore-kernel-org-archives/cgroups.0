Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794810800;
	b=D+hhes3clWbIo9f4rCqUFgySx2hi6Kx4I0FeMKfsaPATOjRonOaWQ0bPwYTlBuCX6Zp3
	 /5eyxtcdjFTDzrUuslG68aMbOfqbd/RMKZXsUlCt44RaANQK2zFfWTy4XFodUQ5eaW/yt
	 fnCBtq9E6LAPfcSMoOurktIm0XVdvbyPjztwb38QnkelLRKeBLMcDKEAhM9EyGUe5+hlX
	 QfUh7wwxu53IQpsLSajSy7b6r2hZbPJT7Y398/lPZaWUGGmOdkl50eVyxCTuft7JEvww6
	 V9RVLTdvQcJGUsrYzQxFGQjWBGSpAGbfgEDt8G8cZ+6fQTbeKk8PXQaCJkOiUzyRkLg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794810800;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ggt4XEbzaHLvs1xJGaZAIsxFE3XBdGn1PW0gI0oUcwE=;
	b=QGL5fYXafogGp4FhHwVDwCuVmOFmV39b9dS7jBCfVDKrl/C1BoZliZ2aR0mnUXbv1DjT
	 Uqc9T7o5YHBoUGxpHw+hxe35J5ift1tgExq4ZWNsotmysP1ZzoBjOtDMM7wsYv8QQTJ5y
	 44A4c/jlNPIb/2LK1wN/5aoCg20I54JsUJLq9VRJHUPrHNg1V25zn1kbv1OxmAwgbvCZJ
	 uj2n+1h3B61hS9lR/43Igu9Avdb/0CQgcilZSWHz8fH6XKe5ACyUYcPLot3cFyG4zPou/
	 WksybODU4Rib/aptdDqZAFY9do1CyeR2fnlH0tTPxmPoFgnV1oUxG74FJYDAX+b1Pxw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e7HX9zoh;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.53
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57ECE606A329
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 06:33:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57ECE606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e7HX9zoh
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-4a77dcc4ca0so3005649fac.2
        for <cgroups@vger.kernel.org>; Sun, 15 Nov 2026 22:33:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794810798; cv=none;
        d=google.com; s=arc-20260327;
        b=ker0lqAMckYuVGwnYcM6mObg+8NZPRJvJ1/p8zUOrr+IoRqBQTj+JLr1ze8Xmt1Yex
         RyKR3Oec/5I5N0/dCU2JrcFm/RUYGEFjgza8hqScii8/CPc3+ep/Z4uLRAAaH2eLyzeH
         sPqpKcwkr8egET8+tikInYz4U/R4A6ehSAGwaxSMxYqtdNUX71b0L8U3pR7MNnlmrYON
         Y8vTP0N6zGZW6I9XfEGcfMU+vONwJgaNaYodd8Lcqmb3QSqGhjWOSEH6+kK+xN4wvXCs
         86wsg77qFzCzlqdNEkSZUTdDRpoW9u1/EtC7dTP1hwI/dbYwOzBoUBwmnqLU2PpkEHui
         aGKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ggt4XEbzaHLvs1xJGaZAIsxFE3XBdGn1PW0gI0oUcwE=;
        fh=O9xWffJxnOyLnDuyEzLh2hxriXy85Bd31KMgSrzsTdI=;
        b=sILeluDAKsVOzoAAd2uOgdX534zgDLxwsRyhQQrvOPdv698yuruyBAEmoadH7SAsGB
         1Tol32jpUNhyClP8mUJCA1vlcKoCTP3JPSj9asDImyE4zpr9Rg31yMxxxKBBZ05DL+dt
         jr5AitrEqb7xPMedmX7C81MEus5k2+bxc+oDiyqmFEMN7FpHXoRW8UvHZvMU9JCX+Rne
         XfcASsAwzhaThkPmptTtPxsgQ3ZRA1lYOCkhGcUzciHXUlylzBXFyf5Ic58jCqpBdIQv
         tmkZmxes/M60B53hEyIcLp4BHnI9RX/UpeUtk/GqoevTg/D7sx4jDnVanfa1C6FreNa9
         vnwg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794810798; x=1795415598; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ggt4XEbzaHLvs1xJGaZAIsxFE3XBdGn1PW0gI0oUcwE=;
        b=e7HX9zoho2K8jUE/kV1XZhpsYRkNLYwiXRSuDJL91/adm7vISQO5nJGkXQbhqJnony
         3f6WrLHZjKbS02I2msGkh2Zb+9mfZ19bdA+53of3NZ+tHJ3waPM/elq3oBFJXGU+UVOc
         lbzmswPfHaQkMWNkwTzCHwjkJi4qr73AUCza73e7xKZfvKpo7P2bBWlIOCpWxPBsfvcj
         zzS02oIPZdWIUFeMa1l4VoczbL5bk86frhdmdib/1oD1opqD8ZQQyDK2ugdtkZHMXC+Y
         yXaXPKW5vOf8rfXbXA9DkHWlTuNLDKY/y6xvtAWRDAsBYKgHEZQi0Xphe8cEIHTTR5si
         NpMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794810798; x=1795415598;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ggt4XEbzaHLvs1xJGaZAIsxFE3XBdGn1PW0gI0oUcwE=;
        b=wKtjnTOJ+0K1QC8EvzuMdR1NMXUJNOYvvZSYd97zaNrFNvX20/8XrWQ5yGTv9Otkxv
         agzEx0S50qoMcg8ehUwfzxTcykYwa+HYO9IJjFIo46me5A2wS5iECfdxqPnAsXv+VM21
         rkwrn6yV3q+1gc7uHyNnZ0BpciH0MsD2rHwC8gITESGNtQmz9frOF7xVH8NiHHV50iyX
         JXYpJIgg7uZhn02tv84/kJap1ZNcIaqEVEI1mK1NE/7scyP+WVPtQZkWfw3vyt8zyiOt
         zmGDE/AVqmyPmklbUx0TsAfjcHzmpSemHanzD16InDM0vJCmIIPoLa3Kruz8zg6EUUTU
         /d+g==
X-Forwarded-Encrypted: i=1; AL+hErF2wsNCdQKv1pz0YFcxmY91uIvjEbqrTwM/Ro03n+UUsyzskcqxKSDZdNMZtB3k25WBGTiWWHc3@vger.kernel.org
X-Gm-Message-State: APuU4Z9kRgdhzznDIHBcvy+8ZQ4ptAvBK93+4/P634nT3yk8TJavZaoN
	zGCYMCQKvbEuzbsILXzJdTFwEKZyh9vK/vezzt4+gGwNneqDA3QuQtLoEE5tl06e8g44LxZZKR4
	tl3sQXxc1yeIdxUIYjwqQsK7GLEHfbdA=
X-Gm-Gg: AYBFou24Xzk5eLamxq5c+IRL91dP/LbMp6fDpyGdIRaYtBW30PIWKoLRSRtlVYUtj7I
	DK8RIN8rzPFiqvM6qP+UgaBoeeF8V7pzgD8DbD0FDAErkpHdXv4/Xods4sudvCJR06dx3DJi5/7
	he+UWoYCtThkCVgX2s9EIkGxjk6t5eRkgrX4+HWQM+RXArBZMRpslmogwsGb1ST8Th6DCFbvyFd
	ijEPiEc2OMUgQZFEssuPnQNWS4XPOiD91s9GKcHkZKH/oOg8gps05wI1VohJWxM97e1wNgz7eY9
	DsLm3dpKu3yAOVZWmoq9/TiohFjnWmkFFTh9XFstZIWWBqFhCbepEvWdhnTg+qpvW+P+VfvN9e4
	z9Y0pi454Ec6dAuTGvqVZvzRJ257mVkRmISdZBUcGcouGAfARVhBWt5Mo0S5xb7jGXWxI5KFARX
	yP7tQwj5aNTK99VnITls8LCk/4USJ0
X-Received: by 2002:a05:6808:2383:b0:4f7:8bdd:b74 with SMTP id
 5614622812f47-56e64f07813mr7362776b6e.51.1794810797985; Sun, 15 Nov 2026
 22:33:17 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106163123.208454-1-yupeng0921@gmail.com>
In-Reply-To: <20261106163123.208454-1-yupeng0921@gmail.com>
From: peng yu <yupeng0921@gmail.com>
Date: Sun, 15 Nov 2026 22:33:06 -0800
X-Gm-Features: AclHuK8Ey-D1J4zBl2f0fI1lLG2haCzaZjnWU4D6k-akiRvq9vj4Nja4mUoyrU8
Message-ID: <CAG3TDc1bDm7Dg7OcwOzBbEsyjgYOwt9RMF96OhQE0e65qsnnUQ@mail.gmail.com>
Subject: Re: [PATCH v13] nvmet: add cgroup_id to charge namespace I/O to a cgroup
To: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>
Cc: Keith Busch <kbusch@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, 
	Maurizio Lombardi <mlombard@arkamax.eu>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Keith and Christoph, any opinion about this patch?

On Fri, Nov 6, 2026 at 8:31=E2=80=AFAM Peng Yu <yupeng0921@gmail.com> wrote=
:
>
> The nvmet issues namespace IOs from kernel threads. So the io.max and
> other cgroup controllers can't apply limits to the namespaces.
> Consider this scenario: LVM creates multiple logical volumes on the
> same physical disk, and the logical volumes are assigned to different
> nvmet subsystems/namespaces. We want to stop a remote noisy user from
> using all the disk iops via nvmet. So add a per namespace cgroup_id to
> associate the namespace with a cgroup. Each namespace can then be
> throttled separately.
>
> The per namespace cgroup is good enough for the io.max, but is not good
> enough for the io.cost and io.latency. The io.cost and io.latency may
> put a thread to sleep. If the thread is shared by different namespaces,
> all of them will be impacted together. Submit the IOs via a workqueue to
> avoid this impact.
>
> With cgroup_id set, every I/O command except Reservation commands runs
> from its own work item on a per namespace WQ_HIGHPRI workqueue. Zone
> management and the file backend's Flush, DSM and Write Zeroes run
> directly in that work item. Each work item runs under memalloc_noio and
> looks up the cgroup's effective io css. A command whose queue is being
> deleted is aborted. buffered_io is not supported.
>
> Performance test:
> On a 4 core VM and 4G ramdisk, export tcp-nvmeof targets to 127.0.0.1,
> run fio with below parameters:
> fio --bs=3D4k --rw=3Drandwrite --iodepth=3D32 --numjobs=3D4 --ioengine=3D=
libaio --direct=3D1
>
> file backend result:
> |                            | IOPS   | Mean Latency | p99 latency |
> |without this patch          | 204.4k | 625.8 =C2=B5s     | 668 =C2=B5s  =
    |
> |this patch, cgroup_id unset | 204.4k | 625.7 =C2=B5s     | 668 =C2=B5s  =
    |
> |this patch, cgroup_id set   | 155.9k | 820.6 =C2=B5s     | 1139 =C2=B5s =
    |
>
> block device backend result:
> |                            | IOPS   | Mean Latency | p99 latency |
> |without this patch          | 216.0k | 592.2 =C2=B5s     | 627 =C2=B5s  =
    |
> |this patch, cgroup_id unset | 216.0k | 592.1 =C2=B5s     | 627 =C2=B5s  =
    |
> |this patch, cgroup_id set   | 160.0k | 799.6 =C2=B5s     | 1090 =C2=B5s =
    |
>
> With this patch and no cgroup_id set, the performance is almost the same.
> When we set the cgroup_id, with no io controller limit, we can see a
> performance decrease but it is still very fast.
>
> Signed-off-by: Peng Yu <yupeng0921@gmail.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> Assisted-by: Claude:claude-fable-5 [Claude Code]
> Assisted-by: Claude:claude-opus-5-5 [Claude Code]
> ---
> Changes since v12 (Tejun's review of v12):
> * Comment at nvmet_req_run_work() that the file backend's Flush, DSM and
>   Write Zeroes and the zone management commands hold one of the
>   namespace workqueue's max_active slots for their whole duration.
> * Added Tejun's Acked-by from v12. The comment is the only other change.
>
> Tejun's v12 review: https://lore.kernel.org/all/95403f5dce741c515718b2fc7=
f5dcc64@kernel.org/
> v12: https://lore.kernel.org/all/20261104071600.470430-1-yupeng0921@gmail=
.com/
> Tejun's v11 review: https://lore.kernel.org/all/17d94c41da65e31e1579a7211=
ebb7aa1@kernel.org/
> v11: https://lore.kernel.org/all/20261029153103.13689-1-yupeng0921@gmail.=
com/
> Sashiko's v10 review: https://lore.kernel.org/all/sashiko-outbox-185466@k=
ernel.org/
> v10: https://lore.kernel.org/all/20261026153020.47791-1-yupeng0921@gmail.=
com/
> Tejun's v9 comment: https://lore.kernel.org/all/aee729fd53ef9c7c084a44321=
6cfeb39@kernel.org/
> v9: https://lore.kernel.org/all/20261023043423.176002-1-yupeng0921@gmail.=
com/
> v8: https://lore.kernel.org/all/20261002152821.410591-1-yupeng0921@gmail.=
com/
> v7 (with test steps): https://lore.kernel.org/all/20260929232411.101087-1=
-yupeng0921@gmail.com/
>
>  Documentation/ABI/stable/configfs-nvmet |  21 ++++
>  drivers/nvme/target/configfs.c          |  47 ++++++++
>  drivers/nvme/target/core.c              | 153 ++++++++++++++++++++++++
>  drivers/nvme/target/io-cmd-file.c       |  10 +-
>  drivers/nvme/target/nvmet.h             |  46 +++++++
>  drivers/nvme/target/zns.c               |   8 +-
>  6 files changed, 275 insertions(+), 10 deletions(-)
>
> diff --git a/Documentation/ABI/stable/configfs-nvmet b/Documentation/ABI/=
stable/configfs-nvmet
> index 36b587404ee7..c0b0b7ff100e 100644
> --- a/Documentation/ABI/stable/configfs-nvmet
> +++ b/Documentation/ABI/stable/configfs-nvmet
> @@ -314,6 +314,27 @@ Description:
>                 attr_subsys_vendor_id: Shows or sets the PCI subsystem
>                 vendor ID. Displayed in "0x%x" format.
>
> +What:          /config/nvmet/subsystems/NAME/namespaces/NSID/cgroup_id
> +Date:          November 2026
> +KernelVersion: 7.5
> +Contact:       Peng Yu <yupeng0921@gmail.com>
> +Description:
> +               Shows or sets the cgroup2 ID of the cgroup to charge this
> +               namespace's I/O to. Writing 0 clears it. The I/O is
> +               charged to the cgroup's effective io css: the cgroup
> +               itself or its nearest ancestor with the io controller
> +               enabled. The namespace must be disabled before
> +               modification. Enabling the namespace fails if the cgroup
> +               can't be found in the cgroup namespace of the enabling
> +               task, or if buffered_io is set. If the cgroup is removed
> +               while the namespace is enabled, the I/O goes to the
> +               effective io css of its nearest remaining ancestor; a
> +               cgroup that is removed and created again gets a new ID.
> +               Reservation commands and the flush of a Set Features
> +               Write Protect are not charged.
> +
> +               Only available when CONFIG_BLK_CGROUP is enabled.
> +
>  What:          /config/nvmet/hosts/HOSTNQN/dhchap_key
>  What:          /config/nvmet/hosts/HOSTNQN/dhchap_ctrl_key
>  What:          /config/nvmet/hosts/HOSTNQN/dhchap_hash
> diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configf=
s.c
> index b3a5242d06f9..622559022f07 100644
> --- a/drivers/nvme/target/configfs.c
> +++ b/drivers/nvme/target/configfs.c
> @@ -572,6 +572,50 @@ static ssize_t nvmet_ns_device_path_store(struct con=
fig_item *item,
>
>  CONFIGFS_ATTR(nvmet_ns_, device_path);
>
> +#ifdef CONFIG_BLK_CGROUP
> +static ssize_t nvmet_ns_cgroup_id_show(struct config_item *item, char *p=
age)
> +{
> +       struct nvmet_ns *ns =3D to_nvmet_ns(item);
> +       struct nvmet_subsys *subsys =3D ns->subsys;
> +       ssize_t ret;
> +
> +       mutex_lock(&subsys->lock);
> +       ret =3D snprintf(page, PAGE_SIZE, "%llu\n", ns->cgroup_id);
> +       mutex_unlock(&subsys->lock);
> +       return ret;
> +}
> +
> +static ssize_t nvmet_ns_cgroup_id_store(struct config_item *item,
> +               const char *page, size_t count)
> +{
> +       struct nvmet_ns *ns =3D to_nvmet_ns(item);
> +       struct nvmet_subsys *subsys =3D ns->subsys;
> +       u64 cgroup_id;
> +       int ret;
> +
> +       ret =3D kstrtou64(page, 0, &cgroup_id);
> +       if (ret)
> +               return ret;
> +
> +       mutex_lock(&subsys->lock);
> +
> +       if (ns->enabled) {
> +               ret =3D -EBUSY;
> +               goto out_unlock;
> +       }
> +
> +       /* Writing 0 clears the association. */
> +       ns->cgroup_id =3D cgroup_id;
> +       ret =3D count;
> +
> +out_unlock:
> +       mutex_unlock(&subsys->lock);
> +       return ret;
> +}
> +
> +CONFIGFS_ATTR(nvmet_ns_, cgroup_id);
> +#endif /* CONFIG_BLK_CGROUP */
> +
>  #ifdef CONFIG_PCI_P2PDMA
>  static ssize_t nvmet_ns_p2pmem_show(struct config_item *item, char *page=
)
>  {
> @@ -844,6 +888,9 @@ static struct configfs_attribute *nvmet_ns_attrs[] =
=3D {
>         &nvmet_ns_attr_buffered_io,
>         &nvmet_ns_attr_revalidate_size,
>         &nvmet_ns_attr_resv_enable,
> +#ifdef CONFIG_BLK_CGROUP
> +       &nvmet_ns_attr_cgroup_id,
> +#endif
>  #ifdef CONFIG_PCI_P2PDMA
>         &nvmet_ns_attr_p2pmem,
>  #endif
> diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
> index 1dede04c204a..67aeb704b015 100644
> --- a/drivers/nvme/target/core.c
> +++ b/drivers/nvme/target/core.c
> @@ -4,12 +4,15 @@
>   * Copyright (c) 2015-2016 HGST, a Western Digital Company.
>   */
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +#include <linux/cgroup.h>
>  #include <linux/hex.h>
> +#include <linux/kthread.h>
>  #include <linux/module.h>
>  #include <linux/random.h>
>  #include <linux/rculist.h>
>  #include <linux/pci-p2pdma.h>
>  #include <linux/scatterlist.h>
> +#include <linux/sched/mm.h>
>
>  #include <generated/utsrelease.h>
>
> @@ -483,8 +486,152 @@ void nvmet_put_namespace(struct nvmet_ns *ns)
>         percpu_ref_put(&ns->ref);
>  }
>
> +#ifdef CONFIG_BLK_CGROUP
> +static int nvmet_blkcg_ns_enable(struct nvmet_ns *ns)
> +{
> +       struct cgroup *cgrp;
> +
> +       if (!ns->cgroup_id)
> +               return 0;
> +
> +       /*
> +        * Writeback of buffered writes is charged through the page cache=
's
> +        * memcg, not to this cgroup, so we don't support buffered io.
> +        */
> +       if (ns->buffered_io) {
> +               pr_err("cgroup_id is not supported with buffered_io: %s\n=
",
> +                      ns->device_path);
> +               return -EINVAL;
> +       }
> +
> +       cgrp =3D cgroup_get_from_id(ns->cgroup_id);
> +       if (IS_ERR(cgrp)) {
> +               pr_err("failed to resolve cgroup id %llu: %ld\n",
> +                      ns->cgroup_id, PTR_ERR(cgrp));
> +               return PTR_ERR(cgrp);
> +       }
> +
> +       /*
> +        * WQ_HIGHPRI: the tcp and rdma transports execute the commands f=
rom
> +        * WQ_HIGHPRI workqueues; keep that priority on this one.
> +        */
> +       ns->blkcg_wq =3D alloc_workqueue("nvmet-blkcg-%u",
> +                       WQ_MEM_RECLAIM | WQ_UNBOUND | WQ_HIGHPRI,
> +                       min_t(int, num_online_cpus(), WQ_MAX_ACTIVE),
> +                       ns->nsid);
> +       if (!ns->blkcg_wq) {
> +               cgroup_put(cgrp);
> +               return -ENOMEM;
> +       }
> +
> +       ns->cgrp =3D cgrp;
> +       return 0;
> +}
> +
> +static void nvmet_blkcg_ns_disable(struct nvmet_ns *ns)
> +{
> +       if (ns->cgrp) {
> +               /*
> +                * No command is left, but the work item of a command tha=
t
> +                * completed from inside ->blkcg_execute() may still be
> +                * returning: destroy_workqueue() waits for it.
> +                */
> +               destroy_workqueue(ns->blkcg_wq);
> +               ns->blkcg_wq =3D NULL;
> +               cgroup_put(ns->cgrp);
> +               ns->cgrp =3D NULL;
> +       }
> +}
> +
> +/*
> + * Charge the I/O that the current work item submits for @req to the
> + * effective io css of the namespace's cgroup, looked up for each comman=
d.
> + */
> +static bool nvmet_blkcg_begin(struct nvmet_req *req)
> +{
> +       struct nvmet_ns *ns =3D req->ns;
> +       struct cgroup_subsys_state *css;
> +
> +       /*
> +        * A disable waits for the command: don't throttle it any more. T=
his
> +        * catches only commands that haven't started; io.max holds the b=
ios
> +        * already submitted and releases them at its rate.
> +        */
> +       if (!test_bit(NVMET_NS_IO_LIVE, &ns->flags))
> +               return false;
> +
> +       css =3D cgroup_get_e_css(ns->cgrp, &io_cgrp_subsys);
> +       kthread_associate_blkcg(css);
> +       css_put(css);
> +       return true;
> +}
> +
> +static void nvmet_blkcg_end(bool associated)
> +{
> +       if (associated)
> +               kthread_associate_blkcg(NULL);
> +}
> +
> +/*
> + * The io.cost and io.latency enforce their limits by putting the thread=
 to
> + * sleep. A transport thread may be shared by multiple namespaces. In th=
e
> + * tcp-nvmeof case, all namespaces in the same subsystem may share a
> + * thread. So we submit the IOs via the workqueue, thus the current thre=
ad
> + * won't be blocked.
> + */
> +static void nvmet_blkcg_work(struct work_struct *work)
> +{
> +       struct nvmet_req *req =3D
> +               container_of(work, struct nvmet_req, blkcg_work);
> +       unsigned int noio_flag;
> +       bool associated;
> +
> +       /* its queue is being deleted: abort it rather than throttle it *=
/
> +       if (unlikely(percpu_ref_is_dying(&req->sq->ref))) {
> +               nvmet_req_complete(req, NVME_SC_ABORT_QUEUE);
> +               return;
> +       }
> +
> +       /* reclaim must not wait for I/O queued on this workqueue */
> +       noio_flag =3D memalloc_noio_save();
> +       associated =3D nvmet_blkcg_begin(req);
> +       req->blkcg_execute(req);
> +       nvmet_blkcg_end(associated);
> +       memalloc_noio_restore(noio_flag);
> +}
> +
> +static void nvmet_blkcg_queue_req(struct nvmet_req *req)
> +{
> +       INIT_WORK(&req->blkcg_work, nvmet_blkcg_work);
> +       queue_work(req->ns->blkcg_wq, &req->blkcg_work);
> +}
> +
> +static void nvmet_blkcg_init_req(struct nvmet_req *req)
> +{
> +       if (!req->ns->blkcg_wq)
> +               return;
> +
> +       req->blkcg_execute =3D req->execute;
> +       req->execute =3D nvmet_blkcg_queue_req;
> +}
> +#else
> +static inline int nvmet_blkcg_ns_enable(struct nvmet_ns *ns)
> +{
> +       return 0;
> +}
> +
> +static inline void nvmet_blkcg_ns_disable(struct nvmet_ns *ns)
> +{
> +}
> +
> +static inline void nvmet_blkcg_init_req(struct nvmet_req *req)
> +{
> +}
> +#endif /* CONFIG_BLK_CGROUP */
> +
>  static void nvmet_ns_dev_disable(struct nvmet_ns *ns)
>  {
> +       nvmet_blkcg_ns_disable(ns);
>         nvmet_bdev_ns_disable(ns);
>         nvmet_file_ns_disable(ns);
>  }
> @@ -611,6 +758,10 @@ int nvmet_ns_enable(struct nvmet_ns *ns)
>         if (ret)
>                 goto out_unlock;
>
> +       ret =3D nvmet_blkcg_ns_enable(ns);
> +       if (ret)
> +               goto out_dev_disable;
> +
>         ret =3D nvmet_p2pmem_ns_enable(ns);
>         if (ret)
>                 goto out_dev_disable;
> @@ -1170,6 +1321,8 @@ static u16 nvmet_parse_io_cmd(struct nvmet_req *req=
)
>         if (ret)
>                 return ret;
>
> +       nvmet_blkcg_init_req(req);
> +
>         if (req->ns->pr.enable) {
>                 ret =3D nvmet_pr_check_cmd_access(req);
>                 if (ret)
> diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-c=
md-file.c
> index 695963dd932e..b9d221eeef57 100644
> --- a/drivers/nvme/target/io-cmd-file.c
> +++ b/drivers/nvme/target/io-cmd-file.c
> @@ -265,8 +265,7 @@ static void nvmet_file_execute_flush(struct nvmet_req=
 *req)
>  {
>         if (!nvmet_check_transfer_len(req, 0))
>                 return;
> -       INIT_WORK(&req->f.work, nvmet_file_flush_work);
> -       queue_work(nvmet_wq, &req->f.work);
> +       nvmet_req_run_work(req, nvmet_wq, &req->f.work, nvmet_file_flush_=
work);
>  }
>
>  static void nvmet_file_execute_discard(struct nvmet_req *req)
> @@ -325,8 +324,7 @@ static void nvmet_file_execute_dsm(struct nvmet_req *=
req)
>  {
>         if (!nvmet_check_data_len_lte(req, nvmet_dsm_len(req)))
>                 return;
> -       INIT_WORK(&req->f.work, nvmet_file_dsm_work);
> -       queue_work(nvmet_wq, &req->f.work);
> +       nvmet_req_run_work(req, nvmet_wq, &req->f.work, nvmet_file_dsm_wo=
rk);
>  }
>
>  static void nvmet_file_write_zeroes_work(struct work_struct *w)
> @@ -355,8 +353,8 @@ static void nvmet_file_execute_write_zeroes(struct nv=
met_req *req)
>  {
>         if (!nvmet_check_transfer_len(req, 0))
>                 return;
> -       INIT_WORK(&req->f.work, nvmet_file_write_zeroes_work);
> -       queue_work(nvmet_wq, &req->f.work);
> +       nvmet_req_run_work(req, nvmet_wq, &req->f.work,
> +                       nvmet_file_write_zeroes_work);
>  }
>
>  u16 nvmet_file_parse_io_cmd(struct nvmet_req *req)
> diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
> index 3cd58e813aa7..96306f5c09ae 100644
> --- a/drivers/nvme/target/nvmet.h
> +++ b/drivers/nvme/target/nvmet.h
> @@ -118,6 +118,22 @@ struct nvmet_ns {
>         struct nvmet_subsys     *subsys;
>         const char              *device_path;
>
> +#ifdef CONFIG_BLK_CGROUP
> +       u64                     cgroup_id;
> +       /*
> +        * Resolved from ->cgroup_id when the namespace is enabled and
> +        * released when it is disabled, so it has the same lifetime and
> +        * visibility rules as ->bdev and ->file.
> +        */
> +       struct cgroup           *cgrp;
> +       /*
> +        * The I/O commands of a namespace with a cgroup, except Reservat=
ion
> +        * commands, are executed from their own work items on ->blkcg_wq=
, so
> +        * the cgroup's throttling doesn't put a transport context to sle=
ep.
> +        */
> +       struct workqueue_struct *blkcg_wq;
> +#endif
> +
>         struct config_group     device_group;
>         struct config_group     group;
>
> @@ -510,6 +526,11 @@ struct nvmet_req {
>
>         void (*execute)(struct nvmet_req *req);
>         const struct nvmet_fabrics_ops *ops;
> +#ifdef CONFIG_BLK_CGROUP
> +       /* the backend's ->execute, called from ->blkcg_work */
> +       void (*blkcg_execute)(struct nvmet_req *req);
> +       struct work_struct      blkcg_work;
> +#endif
>
>         struct pci_dev          *p2p_dev;
>         struct device           *p2p_client;
> @@ -756,6 +777,31 @@ void nvmet_bdev_execute_zone_mgmt_recv(struct nvmet_=
req *req);
>  void nvmet_bdev_execute_zone_mgmt_send(struct nvmet_req *req);
>  void nvmet_bdev_execute_zone_append(struct nvmet_req *req);
>
> +/*
> + * A command of a namespace with a cgroup already runs from its own work
> + * item on the namespace's workqueue (see nvmet_blkcg_work()), so run th=
e
> + * backend's work function right there; otherwise queue it on @wq.
> + *
> + * So with a cgroup, the file backend's Flush, DSM and Write Zeroes and
> + * the zone management commands hold one of blkcg_wq's max_active slots
> + * for the whole vfs_fsync(), vfs_fallocate() or zone operation. That ca=
n
> + * only delay other commands of the same namespace, which are charged to
> + * the same cgroup.
> + */
> +static inline void nvmet_req_run_work(struct nvmet_req *req,
> +               struct workqueue_struct *wq, struct work_struct *work,
> +               work_func_t func)
> +{
> +#ifdef CONFIG_BLK_CGROUP
> +       if (req->ns->blkcg_wq) {
> +               func(work);
> +               return;
> +       }
> +#endif
> +       INIT_WORK(work, func);
> +       queue_work(wq, work);
> +}
> +
>  static inline u32 nvmet_rw_data_len(struct nvmet_req *req)
>  {
>         return ((u32)le16_to_cpu(req->cmd->rw.length) + 1) <<
> diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
> index 92f5c1435582..38455481da24 100644
> --- a/drivers/nvme/target/zns.c
> +++ b/drivers/nvme/target/zns.c
> @@ -335,8 +335,8 @@ void nvmet_bdev_execute_zone_mgmt_recv(struct nvmet_r=
eq *req)
>         if (!nvmet_check_transfer_len(req, (numd + 1) << 2))
>                 return;
>
> -       INIT_WORK(&req->z.zmgmt_work, nvmet_bdev_zone_zmgmt_recv_work);
> -       queue_work(zbd_wq, &req->z.zmgmt_work);
> +       nvmet_req_run_work(req, zbd_wq, &req->z.zmgmt_work,
> +                          nvmet_bdev_zone_zmgmt_recv_work);
>  }
>
>  static inline enum req_op zsa_req_op(u8 zsa)
> @@ -534,8 +534,8 @@ static void nvmet_bdev_zmgmt_send_work(struct work_st=
ruct *w)
>
>  void nvmet_bdev_execute_zone_mgmt_send(struct nvmet_req *req)
>  {
> -       INIT_WORK(&req->z.zmgmt_work, nvmet_bdev_zmgmt_send_work);
> -       queue_work(zbd_wq, &req->z.zmgmt_work);
> +       nvmet_req_run_work(req, zbd_wq, &req->z.zmgmt_work,
> +                          nvmet_bdev_zmgmt_send_work);
>  }
>
>  static void nvmet_bdev_zone_append_bio_done(struct bio *bio)
>
> base-commit: ca7e6a9a693240f059a0b47726f64a3f0573011a
> --
> 2.53.0
>
